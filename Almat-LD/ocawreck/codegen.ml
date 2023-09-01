open Llvm
open Wreckparse

exception Error of string

let context = global_context ()

let llvm_init_module = create_module context "wreck"

let builder = builder context

let named_values : (string, llvalue) Hashtbl.t = Hashtbl.create 10

let print_named_values () =
  Hashtbl.iter
    (fun k v -> print_endline ("hashtbl: " ^ k ^ ", " ^ string_of_llvalue v))
    named_values

let intrinsics : (string, llvalue) Hashtbl.t = Hashtbl.create 10

let process_defs :
    (string, string * string list * Ast.expr * Ast.expr list) Hashtbl.t =
  Hashtbl.create 10

let process_count = ref 0

let process_funcs : llvalue list ref = ref []

let double_type = double_type context

let int_type = i32_type context

let int64_type = i64_type context

let _ =
  Hashtbl.add intrinsics "sin"
    (declare_function "llvm.sin.f64"
       (function_type double_type [|double_type|])
       llvm_init_module) ;
  Hashtbl.add intrinsics "cos"
    (declare_function "llvm.cos.f64"
       (function_type double_type [|double_type|])
       llvm_init_module) ;
  Hashtbl.add intrinsics "exp"
    (declare_function "llvm.exp.f64"
       (function_type double_type [|double_type|])
       llvm_init_module) ;
  Hashtbl.add intrinsics "exp2"
    (declare_function "llvm.exp2.f64"
       (function_type double_type [|double_type|])
       llvm_init_module) ;
  Hashtbl.add intrinsics "log"
    (declare_function "llvm.log.f64"
       (function_type double_type [|double_type|])
       llvm_init_module) ;
  Hashtbl.add intrinsics "log10"
    (declare_function "llvm.log10.f64"
       (function_type double_type [|double_type|])
       llvm_init_module) ;
  Hashtbl.add intrinsics "log2"
    (declare_function "llvm.log2.f64"
       (function_type double_type [|double_type|])
       llvm_init_module) ;
  Hashtbl.add intrinsics "abs"
    (declare_function "llvm.fabs.f64"
       (function_type double_type [|double_type|])
       llvm_init_module) ;
  Hashtbl.add intrinsics "sqrt"
    (declare_function "llvm.sqrt.f64"
       (function_type double_type [|double_type|])
       llvm_init_module) ;
  Hashtbl.add intrinsics "pow"
    (declare_function "llvm.pow.f64"
       (function_type double_type [|double_type; double_type|])
       llvm_init_module) ;
  Hashtbl.add intrinsics "min"
    (declare_function "llvm.minnum.f64"
       (function_type double_type [|double_type; double_type|])
       llvm_init_module) ;
  Hashtbl.add intrinsics "max"
    (declare_function "llvm.maxnum.f64"
       (function_type double_type [|double_type; double_type|])
       llvm_init_module) ;
  Hashtbl.add intrinsics "floor"
    (declare_function "llvm.floor.f64"
       (function_type double_type [|double_type|])
       llvm_init_module) ;
  Hashtbl.add intrinsics "ceil"
    (declare_function "llvm.ceil.f64"
       (function_type double_type [|double_type|])
       llvm_init_module) ;
  Hashtbl.add intrinsics "round"
    (declare_function "llvm.round.f64"
       (function_type double_type [|double_type|])
       llvm_init_module)

let lookup_function_or_intrinsic func_name llvm_mod =
  match lookup_function func_name llvm_mod with
  | Some f ->
      Some f
  | None ->
      Hashtbl.find_opt intrinsics func_name

let is_process name =
  match Hashtbl.find_opt process_defs name with
  | Some _ ->
      true
  | None ->
      false

(* let string_of_typekind = function
 *   | Llvm.TypeKind.Void ->
 *       "Void"
 *   | Llvm.TypeKind.Half ->
 *       "Half"
 *   | Llvm.TypeKind.Float ->
 *       "Float"
 *   | Llvm.TypeKind.Double ->
 *       "Double"
 *   | Llvm.TypeKind.X86fp80 ->
 *       "X86fp80"
 *   | Llvm.TypeKind.Fp128 ->
 *       "Fp128"
 *   | Llvm.TypeKind.Ppc_fp128 ->
 *       "fp128"
 *   | Llvm.TypeKind.Label ->
 *       "Label"
 *   | Llvm.TypeKind.Integer ->
 *       "Integer"
 *   | Llvm.TypeKind.Function ->
 *       "Function"
 *   | Llvm.TypeKind.Struct ->
 *       "Struct"
 *   | Llvm.TypeKind.Array ->
 *       "Array"
 *   | Llvm.TypeKind.Pointer ->
 *       "Pointer"
 *   | Llvm.TypeKind.Vector ->
 *       "Vector"
 *   | Llvm.TypeKind.Metadata ->
 *       "Metadata"
 *   | Llvm.TypeKind.X86_mmx ->
 *       "mmx"
 *   | Llvm.TypeKind.Token ->
 *       "Token" *)

(* Create an alloca instruction in the entry block of the function. This
 * is used for mutable variables etc. *)
let create_entry_block_alloca func var_name =
  let builder = builder_at context (instr_begin (entry_block func)) in
  build_alloca double_type var_name builder

(* let struct_elts = [|const_float f64 1.0; const_float f64 2.0|] in
 * let _ = define_global "tmpStruct1" (const_struct llctx struct_elts) llm in *)

(* let rec construct_func_arg_lst = function
 *   | Ast.App (func, arg) -> (
 *     match func with
 *     | Ast.App _ ->
 *         List.append (construct_func_arg_lst func) (construct_func_arg_lst arg)
 *     | expr ->
 *         expr :: construct_func_arg_lst arg )
 *   | exp ->
 *       [exp] *)

(* let rec construct_func_arg_lst = function
 *   | Ast.App (func, arg) -> (
 *     match func with
 *     | Ast.App _ ->
 *         func :: construct_func_arg_lst arg
 *     | expr ->
 *         expr :: construct_func_arg_lst arg )
 *   | exp ->
 *       [exp] *)

let var_name = function
  | Ast.Var s ->
      s
  | _ ->
      raise (Error "expression is no variable")

let codegen_proto name args llvm_mod =
  (* Make the function type: double(double,double) etc. *)
  let doubles = Array.make (Array.length args) double_type in
  let ft = function_type double_type doubles in
  let f =
    match lookup_function_or_intrinsic name llvm_mod with
    | None ->
        declare_function name ft llvm_mod
    (* If 'f' conflicted, there was already something named 'name'. If it
     * has a body, don't allow redefinition or reextern. *)
    | Some f ->
        delete_function f ;
        declare_function name ft llvm_mod
    (* (\* If 'f' already has a body, reject this. *\)
         * if block_begin f <> At_end f then
         *   raise (Error "redefinition of function") ;
         * (\* If 'f' took a different number of arguments, reject. *\)
         * if element_type (type_of f) <> ft then
         *   raise (Error "redefinition of function with different # args") ; *)
    (* f *)
  in
  (* Set names for all arguments. *)
  Array.iteri
    (fun i a ->
      let n = args.(i) in
      set_value_name n a ;
      Hashtbl.add named_values n a )
    (params f) ;
  f

(* Create an alloca for each argument and register the argument in the symbol
 * table so that references to it will succeed. *)
let create_argument_allocas func args =
  Array.iteri
    (fun i ai ->
      let var_name = List.nth args i in
      (* Create an alloca for this variable. *)
      let alloca = create_entry_block_alloca func var_name in
      (* Store the initial value into the alloca. *)
      Llvm.build_store ai alloca builder |> ignore ;
      (* Add arguments to variable symbol table. *)
      Hashtbl.add named_values var_name alloca )
    (Llvm.params func)

(*
   define struct
   define update function
   function (pointer) store in struct

0   is output
1   is evaluation state n
2   field  is n variables
3-- fields are variables

return pointer to function
  *)

(* let make_id_fun fpm name =
 *   let func =
 *     declare_function name (function_type double_type [||]) llvm_module
 *   in
 *   let bb = append_block context "entry" func in
 *   position_at_end bb builder ;
 *   let ret_val = const_float double_type 13.0 in
 *   let _ = build_ret ret_val builder in
 *   Llvm_analysis.assert_valid_function func ;
 *   print_endline (string_of_llvalue func) ;
 *   let _ = PassManager.run_function func fpm in
 *   name *)

(* check if evaluated arg if it is function pointer
 * put values/pointers into struct
 * need function to check type of value
 * call funcs with sample_counter (int)
 *)

let rec codegen_expr fpm exp llvm_mod =
  let make_process fpm (name, args) proc_def =
    let _, arg_names, body, updates = proc_def in
    process_count := !process_count + 1 ;
    let base_name = Printf.sprintf "__%s%d" name !process_count in
    let func_name = base_name ^ "_func" in
    let struct_name = base_name ^ "_struct" in
    (* print_endline "codegen args" ;
     * flush stdout ; *)
    let args_exp =
      Array.map (fun exp -> codegen_expr fpm exp llvm_mod) (Array.of_list args)
    in
    let output = const_float double_type 0.0 in
    let eval_state = const_int int64_type (-1) in
    let n = const_int int_type (Array.length args_exp) in
    let struct_elts = Array.append [|output; eval_state; n|] args_exp in
    let proc_struct = const_struct context struct_elts in
    let _ = define_global struct_name proc_struct llvm_mod in
    let func =
      declare_function func_name
        (function_type double_type [|int64_type|])
        llvm_mod
    in
    (* let func = codegen_proto func_name [||] in *)
    (* Create a new basic block to start insertion into. *)
    let bb = append_block context "entry" func in
    position_at_end bb builder ;
    let cur_n = param func 0 in
    match lookup_global struct_name llvm_mod with
    | Some v ->
        let old_bindings = ref [] in
        let function_bindings = ref [] in
        let struct_types = Array.map type_of struct_elts in
        let _ =
          Array.iteri
            (fun i var_name ->
              let field_i =
                build_struct_gep v (3 + i)
                  ("__field" ^ string_of_int i)
                  builder
              in
              let field_loaded =
                build_load field_i ("__tmp" ^ string_of_int i) builder
              in
              let alloca = create_entry_block_alloca func var_name in
              ( match classify_type struct_types.(3 + i) with
              (* if loaded value is another process func, call it *)
              | Pointer ->
                  let result =
                    build_call field_loaded [|cur_n|]
                      ("__call_result" ^ string_of_int i)
                      builder
                  in
                  (* remember fptr *)
                  function_bindings :=
                    (var_name, field_i) :: !function_bindings ;
                  ignore (build_store result alloca builder)
              | _ ->
                  ignore (build_store field_loaded alloca builder) ) ;
              ( try
                  let old_value = Hashtbl.find named_values var_name in
                  old_bindings := (var_name, old_value) :: !old_bindings
                with Not_found -> () ) ;
              (* Remember this binding. *)
              Hashtbl.replace named_values var_name alloca )
            (Array.of_list arg_names)
        in
        let ret_val = codegen_expr fpm body llvm_mod in
        (* bind var again to fptr *)
        List.iter
          (fun (var_name, fun_ptr) -> Hashtbl.add named_values var_name fun_ptr)
          !function_bindings ;
        (* store current value in first struct field *)
        let output_value_field =
          build_struct_gep v 0 "__tmp_output_field" builder
        in
        ignore (build_store ret_val output_value_field builder) ;
        (* store current eval n in second struct field *)
        let eval_n_field = build_struct_gep v 1 "__tmp_eval_n_field" builder in
        ignore (build_store cur_n eval_n_field builder) ;
        let _ =
          List.iteri
            (fun i update ->
              let cur_field =
                build_struct_gep v (3 + i)
                  ("__field" ^ string_of_int i)
                  builder
              in
              let update_res = codegen_expr fpm update llvm_mod in
              ignore (build_store update_res cur_field builder) )
            updates
        in
        (* Pop all our variables from scope. *)
        List.iter
          (fun var_name -> Hashtbl.remove named_values var_name)
          arg_names ;
        List.iter
          (fun (var_name, old_value) ->
            Hashtbl.add named_values var_name old_value )
          !old_bindings ;
        List.iter
          (fun (var_name, _) -> Hashtbl.remove named_values var_name)
          !function_bindings ;
        let _ = build_ret ret_val builder in
        (* Validate the generated code, checking for consistency. *)
        (* print_endline (string_of_llvalue func) ; *)
        Llvm_analysis.assert_valid_function func ;
        (* Optimize the function. *)
        let _ = PassManager.run_function func fpm in
        (* we clear the entire local variables table at the end!! *)
        Hashtbl.clear named_values ; func
    | None ->
        raise (Error "cannot find process struct")
  in
  match exp with
  | Ast.Float f ->
      const_float double_type f
  | Ast.Var name -> (
    match Hashtbl.find_opt named_values name with
    | None ->
        raise (Error ("unkown variable name " ^ name))
    (* Load the value *)
    | Some v ->
        Llvm.build_load v name builder )
  | Ast.Binop (op, lhs, rhs) -> (
      let lhs_val = codegen_expr fpm lhs llvm_mod in
      let rhs_val = codegen_expr fpm rhs llvm_mod in
      match op with
      | Ast.Add ->
          build_fadd lhs_val rhs_val "addtmp" builder
      | Ast.Subtr ->
          build_fsub lhs_val rhs_val "subtmp" builder
      | Ast.Mult ->
          build_fmul lhs_val rhs_val "multmp" builder
      | Ast.Div ->
          build_fdiv lhs_val rhs_val "divtmp" builder
      | Ast.Mod ->
          build_frem lhs_val rhs_val "remtmp" builder
      | _ as compare ->
          let comp =
            match compare with
            | Ast.Lt ->
                Fcmp.Ult
            | Ast.Gt ->
                Fcmp.Ugt
            | Ast.Le ->
                Fcmp.Ule
            | Ast.Ge ->
                Fcmp.Uge
            | Ast.Eq ->
                Fcmp.Ueq
            | Ast.Uneq ->
                Fcmp.Une
            | _ ->
                raise (Error "wrong type of comparison")
          in
          (* Convert bool 0/1 to double 0.0 or 1.0 *)
          let i = build_fcmp comp lhs_val rhs_val "cmptmp" builder in
          build_uitofp i double_type "booltmp" builder )
  | Ast.Let (var_name, var_value, body) ->
      let old_bindings = ref [] in
      let func = block_parent (insertion_block builder) in
      let value_expr = codegen_expr fpm var_value llvm_mod in
      let alloca = create_entry_block_alloca func var_name in
      ignore (build_store value_expr alloca builder) ;
      ( try
          let old_value = Hashtbl.find named_values var_name in
          old_bindings := (var_name, old_value) :: !old_bindings
        with Not_found -> () ) ;
      (* Remember this binding. *)
      Hashtbl.add named_values var_name alloca ;
      let body_val = codegen_expr fpm body llvm_mod in
      (* Pop all our variables from scope. *)
      (* Hashtbl.remove named_values var_name ; *)
      List.iter
        (fun (var_name, old_value) ->
          Hashtbl.add named_values var_name old_value )
        !old_bindings ;
      (* Return the body computation. *)
      body_val
  | Ast.Play (Ast.App (func, argslst)) -> (
    (* let fun_and_args = construct_func_arg_lst app in
       * let func = var_name (List.hd fun_and_args) in
       * let argslst = List.tl fun_and_args in *)
    match Hashtbl.find_opt process_defs (var_name func) with
    | Some proc_def ->
        make_process fpm (var_name func, argslst) proc_def
    | None ->
        raise (Error "unknown process referenced") )
  | Ast.App (func, args) as app ->
      (* let fun_and_args = construct_func_arg_lst app in
       * let func = var_name (List.hd fun_and_args) in *)
      (* let args = Array.of_list (List.tl fun_and_args) in *)
      (* Look up the name in the module table. *)
      let args = Array.of_list args in
      if is_process (var_name func) then
        codegen_expr fpm (Ast.Play app) llvm_mod
      else
        let callee =
          match lookup_function_or_intrinsic (var_name func) llvm_mod with
          | Some func ->
              func
          | None ->
              raise (Error "unknown function referenced")
        in
        let params = params callee in
        (* If argument mismatch error. *)
        if Array.length params == Array.length args then ()
        else
          raise
            (Error
               (Printf.sprintf
                  "incorrect # arguments passed. Got %d, expected %d."
                  (Array.length args) (Array.length params))) ;
        let args = Array.map (fun exp -> codegen_expr fpm exp llvm_mod) args in
        build_call callee args "calltmp" builder
  | Ast.If (cond, then_, else_) ->
      let cond = codegen_expr fpm cond llvm_mod in
      (* Convert condition to a bool by comparing equal to 0.0 *)
      let zero = const_float double_type 0.0 in
      let cond_val = build_fcmp Fcmp.One cond zero "ifcond" builder in
      (* Grab the first block so that we might later add the conditional branch
      * to it at the end of the function. *)
      let start_bb = insertion_block builder in
      let the_function = block_parent start_bb in
      let then_bb = append_block context "then" the_function in
      (* Emit 'then' value. *)
      position_at_end then_bb builder ;
      let then_val = codegen_expr fpm then_ llvm_mod in
      (* Codegen of 'then' can change the current block, update then_bb for the
      * phi. We create a new name because one is used for the phi node, and the
      * other is used for the conditional branch. *)
      let new_then_bb = insertion_block builder in
      (* Emit 'else' value. *)
      let else_bb = append_block context "else" the_function in
      position_at_end else_bb builder ;
      let else_val = codegen_expr fpm else_ llvm_mod in
      (* Codegen of 'else' can change the current block, update else_bb for the
      * phi. *)
      let new_else_bb = insertion_block builder in
      (* Emit merge block. *)
      let merge_bb = append_block context "ifcont" the_function in
      position_at_end merge_bb builder ;
      let incoming = [(then_val, new_then_bb); (else_val, new_else_bb)] in
      let phi = build_phi incoming "iftmp" builder in
      (* Return to the start block to add the conditional branch. *)
      position_at_end start_bb builder ;
      ignore (build_cond_br cond_val then_bb else_bb builder) ;
      (* Set a unconditional branch at the end of the 'then' block and the
      * 'else' block to the 'merge' block. *)
      position_at_end new_then_bb builder ;
      ignore (build_br merge_bb builder) ;
      position_at_end new_else_bb builder ;
      ignore (build_br merge_bb builder) ;
      (* Finally, set the builder to the end of the merge block. *)
      position_at_end merge_bb builder ;
      phi
  | Ast.FunDef (name, args, body) -> (
      Hashtbl.clear named_values ;
      let func = codegen_proto name (Array.of_list args) llvm_mod in
      (* Create a new basic block to start insertion into. *)
      let bb = append_block context "entry" func in
      position_at_end bb builder ;
      try
        create_argument_allocas func args ;
        let ret_val = codegen_expr fpm body llvm_mod in
        (* Finish off the function. *)
        let _ = build_ret ret_val builder in
        (* Validate the generated code, checking for consistency. *)
        Llvm_analysis.assert_valid_function func ;
        (* Optimize the function. *)
        let _ = PassManager.run_function func fpm in
        func
      with e -> delete_function func ; raise e )
  | Ast.ProcDef (name, args, body, cont) ->
      if is_process name then
        Hashtbl.replace process_defs name (name, args, body, cont)
      else Hashtbl.add process_defs name (name, args, body, cont) ;
      (* dummy *)
      const_null double_type
  | _ ->
      raise (Error "cannot parse")

(* let _ =
 *   let llctx = global_context () in
 *   let llm = create_module llctx "mymodule" in
 *   let f64 = double_type llctx in
 *   let struct_elts = [|const_float f64 1.0; const_float f64 2.0|] in
 *   let _ = define_global "tmpStruct1" (const_struct llctx struct_elts) llm in
 *   let fty = function_type f64 [|f64|] in
 *   (\* inc fun *\)
 *   let inc_fun = define_function "incFun" fty llm in
 *   let llbuilder_inc = builder_at_end llctx (entry_block inc_fun) in
 *   let _ =
 *     match lookup_global "tmpStruct1" llm with
 *     | Some v ->
 *         let p1 = param inc_fun 0 in
 *         let field1 = build_struct_gep v 0 "field1" llbuilder_inc in
 *         let fieldLoaded = build_load field1 "tmpF1" llbuilder_inc in
 *         let adder = build_fadd p1 fieldLoaded "addtmp" llbuilder_inc in
 *         let _ = build_store adder field1 llbuilder_inc in
 *         let _ = build_ret adder llbuilder_inc in
 *         ()
 *     | None ->
 *         ()
 *   in
 *   let fty_test = function_type f64 [||] in
 *   let test_fun = define_function "test" fty_test llm in
 *   let llbuilder = builder_at_end llctx (entry_block test_fun) in
 *   (\* let ci = const_int i32_t 9 in *\)
 *   let _ =
 *     match lookup_global "tmpStruct1" llm with
 *     | Some v ->
 *         let field1 = build_struct_gep v 0 "field1" llbuilder in
 *         let fieldLoaded = build_load field1 "tmpF1" llbuilder in
 *         let _ = build_ret fieldLoaded llbuilder in
 *         ()
 *     | None ->
 *         ()
 *   in
 *   let _ = Llvm_analysis.assert_valid_function test_fun in
 *   let _ = Llvm_executionengine.initialize () in
 *   let execution_engine = Llvm_executionengine.create llm in
 *   let _ = Llvm_executionengine.add_module llm execution_engine in
 *   let fp_inc =
 *     Llvm_executionengine.get_function_address "incFun"
 *       (Foreign.funptr Ctypes.(double @-> returning double))
 *       execution_engine
 *   in
 *   let fp_test =
 *     Llvm_executionengine.get_function_address "test"
 *       (Foreign.funptr Ctypes.(void @-> returning double))
 *       execution_engine
 *   in
 *   let _ = Printf.printf "Currently %f\n" (fp_test ()) in
 *   let _ = Printf.printf "Inc %f\n" (fp_inc 3.5) in
 *   let _ = Printf.printf "Currently %f\n" (fp_test ()) in
 *   let _ = Printf.printf "Inc %f\n" (fp_inc 3.5) in
 *   let _ = Printf.printf "Currently %f\n" (fp_test ()) in
 *   dump_module llm *)
