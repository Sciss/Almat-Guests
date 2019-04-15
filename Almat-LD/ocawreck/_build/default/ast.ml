type binop = Add | Subtr | Mult | Div

type expr =
  | Var of string
  | Float of float
  | Let of string * expr * expr
  | App of expr * expr
  | Binop of binop * expr * expr
  | FunDef of string * string list * expr

(* | ProcDef of string * expr list * expr * string * expr list *)

(* | If of expr * expr * expr *)
