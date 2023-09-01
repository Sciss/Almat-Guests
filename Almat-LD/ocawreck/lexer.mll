{
open Parser
}

let white = [' ' '\t' '\n']+
let digit = ['0'-'9']
let frac = '.' digit*
let comment_line = "//"([^ '\n' ]+)
let exp = ['e' 'E'] ['-' '+']? digit+
let float = ['-']? digit* frac? exp?
let letter = ['a'-'z' 'A'-'Z']
let id = ['a'-'z' '_'] ['a'-'z' '_' '0'-'9']*

rule read = 
  parse
  | white { read lexbuf }
  | "//" { line_comment lexbuf; read lexbuf } 
  | "=" { EQUALS }
  | "*" { TIMES }
  | "+" { PLUS }
  | "-" { SUBTRACT }
  | "%" { MOD }
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
  | "fn" { FUN }
  | "," { COMMA }
  | "let" { LET }
  | "in" { IN }
  | "if" { IF }
  | "then" { THEN }
  | "else" { ELSE }
  | id { ID (Lexing.lexeme lexbuf) }
  | float { FLOAT (float_of_string (Lexing.lexeme lexbuf)) }
  | eof { EOF }
  
and line_comment = parse
  | ('\n' | eof) { () }
  | _ { line_comment lexbuf }
