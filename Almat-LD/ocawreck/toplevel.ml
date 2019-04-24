open Llvm
open Llvm_scalar_opts
open Wreckparse
open Jack

let _ = Thread.create Jack_callback.open_stream ()

external get_raw_fptr :
  string -> Llvm_executionengine.llexecutionengine -> nativeint
  = "llvm_ee_get_function_address"

let anonymous_func_count = ref 0

let module_count = ref 0

let parse (s : string) : Ast.expr =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.prog Lexer.read lexbuf in
  ast

let rec check_for_stop () =
  match input_char stdin with
  | '\027' ->
      print_endline "Stopping playback" ;
      Jack_callback.set_init_callback () ;
      ()
  | _ ->
      check_for_stop ()

let rec readtop cur_string =
  match input_char stdin with
  | ';' ->
      cur_string
  (* | '\n' ->
   *     readtop cur_string *)
  | ch ->
      readtop (cur_string ^ String.make 1 ch)

(* let make_module_and_fpm () =
 *   module_count := !module_count + 1 ;
 *   let llvm_mod =
 *     create_module Codegen.context (Printf.sprintf "wreck_%d" !module_count)
 *   in
 *   let fpm = PassManager.create_function llvm_mod in
 *   (\* Set up the optimizer pipeline.  Start with registering info about how the
 *    * target lays out data structures. *\)
 *   (\* DataLayout.add (Llvm_executionengine.target_data execution_engine) fpm ; *\)
 *   (\* Promote allocas to registers. *\)
 *   add_memory_to_register_promotion fpm ;
 *   (\* Do simple "peephole" optimizations and bit-twiddling optzn. *\)
 *   add_instruction_combination fpm ;
 *   (\* reassociate expressions. *\)
 *   add_reassociation fpm ;
 *   (\* Eliminate Common SubExpressions. *\)
 *   add_gvn fpm ;
 *   (\* Simplify the control flow graph (deleting unreachable blocks, etc). *\)
 *   add_cfg_simplification fpm ;
 *   ignore (PassManager.initialize fpm) ;
 *   (\* Run the main "interpreter loop" now. *\)
 *   (llvm_mod, fpm) *)

let set_jack_func ee fpm llvm_mod cb_func =
  let _ = Llvm_executionengine.add_module llvm_mod ee in
  anonymous_func_count := !anonymous_func_count + 1 ;
  let tmp_name = Printf.sprintf "__jack_cb%d" !anonymous_func_count in
  let func =
    declare_function tmp_name (function_type Codegen.double_type [||]) llvm_mod
  in
  let bb = append_block Codegen.context "entry" func in
  position_at_end bb Codegen.builder ;
  (* deal with sample_counter *)
  let ret_val =
    build_call cb_func
      [|const_int Codegen.int64_type 0|]
      "calltmp" Codegen.builder
  in
  let _ = build_ret ret_val Codegen.builder in
  (* dump_module llvm_mod ; *)
  Llvm_analysis.assert_valid_function func ;
  let _ = PassManager.run_function func fpm in
  let fptr = get_raw_fptr tmp_name ee in
  Jack_callback.set_callback fptr ;
  print_endline "Starting playback..." ;
  func

(* delete_function func ;
   * let _ = Llvm_executionengine.remove_module llvm_mod execution_engine in *)

(* top ::= definition | external | expression | ';' *)
let rec main_loop execution_engine fpm llvm_mod =
  (* let llvm_mod, fpm = make_module_and_fpm () in *)
  try
    let expr = parse (readtop "") in
    match expr with
    | Ast.FunDef (name, _, _) ->
        print_newline () ;
        print_endline (name ^ ": function definition") ;
        ignore (Codegen.codegen_expr fpm expr llvm_mod) ;
        print_string "wreck> " ;
        flush stdout ;
        main_loop execution_engine fpm llvm_mod
    | Ast.ProcDef (name, _, _, _) ->
        print_newline () ;
        print_endline (name ^ ": process definition") ;
        ignore (Codegen.codegen_expr fpm expr llvm_mod) ;
        print_string "wreck> " ;
        flush stdout ;
        main_loop execution_engine fpm llvm_mod
    | Ast.Play _ ->
        print_newline () ;
        flush stdout ;
        let play_func = Codegen.codegen_expr fpm expr llvm_mod in
        (* dump_value play_func ; *)
        let set_func = set_jack_func execution_engine fpm llvm_mod play_func in
        print_newline () ;
        check_for_stop () ;
        delete_function set_func ;
        let _ = Llvm_executionengine.remove_module llvm_mod execution_engine in
        print_string "wreck> " ;
        flush stdout ;
        main_loop execution_engine fpm llvm_mod
    | _ ->
        (* Evaluate a top-level expression into an anonymous function. *)
        (* print_endline "parsed a top-level expr" ; *)
        (* dump_module Codegen.llvm_module ; *)
        let _ = Llvm_executionengine.add_module llvm_mod execution_engine in
        anonymous_func_count := !anonymous_func_count + 1 ;
        let tmp_name = Printf.sprintf "__toplevel%d" !anonymous_func_count in
        let func =
          declare_function tmp_name
            (function_type Codegen.double_type [||])
            llvm_mod
        in
        (* let func = Codegen.codegen_proto "wreck_main" [||] in *)
        (* Create a new basic block to start insertion into. *)
        let bb = append_block Codegen.context "entry" func in
        position_at_end bb Codegen.builder ;
        let ret_val = Codegen.codegen_expr fpm expr llvm_mod in
        let _ = build_ret ret_val Codegen.builder in
        (* dump_value func ; *)
        (* dump_module llvm_mod ; *)
        (* Validate the generated code, checking for consistency. *)
        Llvm_analysis.assert_valid_function func ;
        (* Optimize the function. *)
        let _ = PassManager.run_function func fpm in
        (* JIT the function, returning a function pointer. *)
        let fp =
          Llvm_executionengine.get_function_address tmp_name
            (Foreign.funptr Ctypes.(void @-> returning double))
            execution_engine
        in
        let result = fp () in
        delete_function func ;
        let _ = Llvm_executionengine.remove_module llvm_mod execution_engine in
        (* print_string "Evaluated to: " ; *)
        print_newline () ;
        print_float result ;
        print_newline () ;
        print_string "wreck> " ;
        flush stdout ;
        main_loop execution_engine fpm llvm_mod
  with ex ->
    let msg = Printexc.to_string ex and stack = Printexc.get_backtrace () in
    Printf.printf "Error: %s%s\n" msg stack ;
    print_string "wreck> " ;
    flush stdout ;
    main_loop execution_engine fpm llvm_mod

let main () =
  (* ignore (initialize_native_target ()) ; *)
  print_string "wreck> " ;
  flush stdout ;
  (* Create the JIT. *)
  let _ = Llvm_executionengine.initialize () in
  let execution_engine =
    Llvm_executionengine.create Codegen.llvm_init_module
  in
  (* let _ =
   *   Llvm_executionengine.add_module Codegen.llvm_module execution_engine
   * in *)
  let fpm = PassManager.create_function Codegen.llvm_init_module in
  (* Set up the optimizer pipeline.  Start with registering info about how the
   * target lays out data structures. *)
  (* DataLayout.add (Llvm_executionengine.target_data execution_engine) fpm ; *)
  (* Promote allocas to registers. *)
  add_memory_to_register_promotion fpm ;
  (* Do simple "peephole" optimizations and bit-twiddling optzn. *)
  add_instruction_combination fpm ;
  (* reassociate expressions. *)
  add_reassociation fpm ;
  (* Eliminate Common SubExpressions. *)
  add_gvn fpm ;
  (* Simplify the control flow graph (deleting unreachable blocks, etc). *)
  add_cfg_simplification fpm ;
  ignore (PassManager.initialize fpm) ;
  (* Run the main "interpreter loop" now. *)
  main_loop execution_engine fpm Codegen.llvm_init_module

let _ = main ()
