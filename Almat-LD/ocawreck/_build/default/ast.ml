type binop = Add | Subtr | Mult | Div | Lt | Gt | Le | Ge | Eq | Uneq

type expr =
  | Var of string
  | Float of float
  | Let of string * expr * expr
  | If of expr * expr * expr
  | Play of expr
  (* | GlobalLet of string * expr *)
  | App of expr * expr
  | Binop of binop * expr * expr
  | FunDef of string * string list * expr
  | ProcDef of string * string list * expr * expr list

(* | ProcDef of string * string list * expr * expr *)

(* | If of expr * expr * expr *)
