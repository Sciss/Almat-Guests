
(* The type of tokens. *)

type token = 
  | TIMES
  | SUBTRACT
  | RPAREN
  | PLUS
  | LPAREN
  | LET
  | IN
  | ID of (string)
  | FLOAT of (float)
  | EQUALS
  | EOF
  | DIVIDE
  | APP

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val prog: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.expr)
