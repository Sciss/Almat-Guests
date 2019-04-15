(* open Llvm
 * 
 * let _ =
 *   let llctx = global_context () in
 *   let llm = create_module llctx "mymodule" in
 *   let i32_t = i32_type llctx in
 *   let fty = function_type i32_t [|i32_t|] in
 *   let _ = define_global "myInt" (const_int i32_t 11) llm in
 *   (\* let struct_elts = [| const_float double_type 1.0; const_float double_type 2.0 |] *\)
 *   (\* let _ = define_global "tmpStruct1" (const_struct i32_t 11) llm in *\)
 *   let test_fun = define_function "test" fty llm in
 *   let llbuilder = builder_at_end llctx (entry_block test_fun) in
 *   (\* let ci = const_int i32_t 9 in *\)
 *   let _ =
 *     match lookup_global "myInt" llm with
 *     | Some v ->
 *         let p1 = param test_fun 0 in
 *         let loaded = build_load v "tmpName1" llbuilder in
 *         let adder = build_add p1 loaded "addtmp" llbuilder in
 *         let _ = build_ret adder llbuilder in
 *         ()
 *     | None ->
 *         ()
 *   in
 *   let _ = Llvm_analysis.assert_valid_function test_fun in
 *   let _ = Llvm_executionengine.initialize () in
 *   let execution_engine = Llvm_executionengine.create llm in
 *   let _ = Llvm_executionengine.add_module llm execution_engine in
 *   let fp =
 *     Llvm_executionengine.get_function_address "test"
 *       (Foreign.funptr Ctypes.(int @-> returning int))
 *       execution_engine
 *   in
 *   let _ = Printf.printf "Evaluated to %d\n" (fp 19) in
 *   dump_module llm *)

(* (executable
 *  (libraries
 *    ctypes.foreign
 *    llvm
 *    llvm.analysis
 *    llvm.executionengine
 *    llvm.target
 *    llvm.scalar_opts)
 *  (name wreck)) *)
