{
open Parser
}

let white = [' ' '\t']+
let digit = ['0'-'9']
let frac = '.' digit*
let exp = ['e' 'E'] ['-' '+']? digit+
let float = digit* frac? exp?
let letter = ['a'-'z' 'A'-'Z']
let id = ['a'-'z' '_'] ['a'-'z' '_' '0'-'9']*

rule read = 
  parse
  | white { read lexbuf }
  | "=" { EQUALS }
  | "*" { TIMES }
  | "+" { PLUS }
  | "-" { SUBTRACT }
  | "/" { DIVIDE }
  | "(" { LPAREN }
  | ")" { RPAREN }
  | "{" { LBRACE }
  | "}" { RBRACE }
  | "<" { LT }
  | "<=" { LE }
  | ">" { GT }
  | ">=" { GE }
  | "==" { EQ }
  | "!=" { UNEQ }
  | "play" { PLAY }
  | "proc" { PROC }
  | "fun" { FUN }
  | "," { COMMA }
  | "let" { LET }
  | "in" { IN }
  | "if" { IF }
  | "then" { THEN }
  | "else" { ELSE }
  | id { ID (Lexing.lexeme lexbuf) }
  | float { FLOAT (float_of_string (Lexing.lexeme lexbuf)) }
  | eof { EOF }
