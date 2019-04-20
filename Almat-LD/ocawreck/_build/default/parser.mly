%{
    open Ast
%}


%token <float> FLOAT
%token <string> ID
%token TIMES  
%token PLUS
%token DIVIDE
%token LT
%token LE
%token GT
%token GE
%token EQ
%token UNEQ
%token IF
%token THEN
%token ELSE
%token SUBTRACT
%token LPAREN
%token RPAREN
%token LBRACE
%token RBRACE
%token PLAY
%token PROC
%token COMMA
%token FUN
%token LET
%token IN
%token EQUALS
%token APP
%token EOF


%nonassoc IF THEN ELSE COMMA 
%nonassoc LET LPAREN PROC FUN PLAY
%nonassoc LT LE GT GE EQ UNEQ
%left PLUS
%left SUBTRACT
%left DIVIDE
%left TIMES
%nonassoc APP
%nonassoc ID FLOAT

%start <Ast.expr> prog


%%

reversed_nonempty_llist(X):
    x = X
    { [ x ] }
   | xs = reversed_nonempty_llist(X) x = X
    { x :: xs }

(* [nonempty_llist(X)] recognizes a nonempty list of [X]s, and produces an OCaml
   list in direct order -- that is, the first element in the input text appears
   first in this list. *)

%inline nonempty_llist(X):
  xs = rev(reversed_nonempty_llist(X))
    { xs }
                    
prog:
	| e = toplevel_expr; EOF { e }
	  ;

toplevel_expr:
        | e1 = simple_expr { e1 }
        | FUN; func = ID; fargs = list(ID); EQUALS; body = simple_expr { FunDef (func, fargs, body) }
        | PROC; func = ID; fargs = list(ID); EQUALS; body = simple_expr; LBRACE; updates = separated_list(COMMA, simple_expr) RBRACE { ProcDef (func, fargs, body, updates) }
        | PLAY; e = simple_expr { Play e }
        ;
          
simple_expr:
	| i = FLOAT { Float i }
	| x = ID { Var x }
        | e1 = simple_expr; SUBTRACT; e2 = simple_expr { Binop (Subtr, e1, e2) }
	| e1 = simple_expr; DIVIDE; e2 = simple_expr { Binop (Div, e1, e2) }
	| e1 = simple_expr; TIMES; e2 = simple_expr { Binop (Mult, e1, e2) } 
	| e1 = simple_expr; PLUS; e2 = simple_expr { Binop (Add, e1, e2) }
        | e1 = simple_expr; LT; e2 = simple_expr { Binop (Lt, e1, e2) }
        | e1 = simple_expr; GT; e2 = simple_expr { Binop (Gt, e1, e2) }
        | e1 = simple_expr; GE; e2 = simple_expr { Binop (Ge, e1, e2) }
        | e1 = simple_expr; LE; e2 = simple_expr { Binop (Le, e1, e2) }
        | e1 = simple_expr; EQ; e2 = simple_expr { Binop (Eq, e1, e2) }
        | e1 = simple_expr; UNEQ; e2 = simple_expr { Binop (Uneq, e1, e2) }
        | IF; cond = simple_expr; THEN; then_ = simple_expr; ELSE; else_ = simple_expr { If (cond, then_, else_) }
	| LET; x = ID; EQUALS; e1 = simple_expr; IN; e2 = simple_expr { Let (x, e1, e2) }
        | func = simple_expr; arg = simple_expr  %prec APP { App (func, arg) }
        (* | func = ID; args = nonempty_list(simple_expr)  %prec APP { App (func, args) } *)
          
	| LPAREN; e=simple_expr; RPAREN { e } 
	;
