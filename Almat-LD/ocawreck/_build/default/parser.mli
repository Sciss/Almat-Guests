
(* The type of tokens. *)

type token = 
  | UNEQ
  | TIMES
  | THEN
  | SUBTRACT
  | RPAREN
  | RBRACE
  | PROC
  | PLUS
  | PLAY
  | MOD
  | LT
  | LPAREN
  | LET
  | LE
  | LBRACE
  | IN
  | IF
  | ID of (string)
  | GT
  | GE
  | FUN
  | FLOAT of (float)
  | EQUALS
  | EQ
  | EOF
  | ELSE
  | DIVIDE
  | COMMA
  | APP

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val prog: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.expr)
