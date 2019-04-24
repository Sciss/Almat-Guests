type binop = Add | Subtr | Mult | Div | Lt | Gt | Le | Ge | Eq | Uneq | Mod

let string_of_binop = function
  | Add ->
      "Add"
  | Subtr ->
      "Subtr"
  | Mult ->
      "Mult"
  | Div ->
      "Div"
  | Lt ->
      "Lt"
  | Gt ->
      "Gt"
  | Le ->
      "Le"
  | Ge ->
      "Ge"
  | Eq ->
      "Eq"
  | Uneq ->
      "Uneq"
  | Mod ->
      "Mod"

type expr =
  | Var of string
  | Float of float
  | Let of string * expr * expr
  | If of expr * expr * expr
  | Play of expr
  (* | GlobalLet of string * expr *)
  (* | App of expr * expr *)
  | App of expr * expr list
  | Binop of binop * expr * expr
  | FunDef of string * string list * expr
  | ProcDef of string * string list * expr * expr list

(* | ProcDef of string * string list * expr * expr *)

(* | If of expr * expr * expr *)

let rec string_of_expr = function
  | Var str ->
      "(var " ^ str ^ ")"
  | Float fl ->
      "(" ^ string_of_float fl ^ ")"
  | Let (n, expr1, expr2) ->
      "(let " ^ n ^ " = " ^ string_of_expr expr1 ^ " in "
      ^ string_of_expr expr2 ^ ")"
  | If (cond, expr1, expr2) ->
      Printf.sprintf "(if %s then %s else %s)" (string_of_expr cond)
        (string_of_expr expr1) (string_of_expr expr2)
  | Play expr ->
      Printf.sprintf "(play %s)" (string_of_expr expr)
  | App (func, args) ->
      Printf.sprintf "(app %s %s)" (string_of_expr func)
        (String.concat "," (List.map string_of_expr args))
  | Binop (op, e1, e2) ->
      Printf.sprintf "(binop %s %s %s)" (string_of_binop op)
        (string_of_expr e1) (string_of_expr e2)
  | FunDef (name, args, body) ->
      Printf.sprintf "(fundef %s, args: %s, body: %s)" name
        (String.concat "" args) (string_of_expr body)
  | ProcDef (name, args, body, update) ->
      Printf.sprintf "(procdef %s, args: %s, body: %s, update: %s)" name
        (String.concat "" args) (string_of_expr body)
        (String.concat "," (List.map string_of_expr update))
