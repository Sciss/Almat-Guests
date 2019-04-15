{
open Parser
}

let white = [' ' '\t']+
let digit = ['0'-'9']
let frac = '.' digit*
let exp = ['e' 'E'] ['-' '+']? digit+
let float = digit* frac? exp?
let letter = ['a'-'z' 'A'-'Z']
let id = letter+

rule read = 
  parse
  | white { read lexbuf }
  | "=" { EQUALS }
  | "," { EQUALS }
  | "*" { TIMES }
  | "+" { PLUS }
  | "+" { SUBTRACT }
  | "+" { DIVIDE }
  | "(" { LPAREN }
  | ")" { RPAREN }
  | "let" { LET }
  | "in" { IN }
  | id { ID (Lexing.lexeme lexbuf) }
  | float { FLOAT (float_of_string (Lexing.lexeme lexbuf)) }
  | eof { EOF }
