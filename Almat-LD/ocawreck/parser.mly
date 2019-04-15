%{
    open Ast
%}


%token <float> FLOAT
%token <string> ID
%token TIMES  
%token PLUS
%token DIVIDE
%token SUBTRACT
%token LPAREN
%token RPAREN
%token LET
%token IN
%token EQUALS
%token APP
%token EOF


%nonassoc LET LPAREN ID FLOAT
%left PLUS
%left SUBTRACT
%left DIVIDE
%left TIMES
%nonassoc APP

%start <Ast.expr> prog


%%
                    
prog:
	| e = toplevel_expr; EOF { e }
	  ;

toplevel_expr:
        | e1 = simple_expr { e1 }
        | LET; func = ID; fargs = list(ID); EQUALS; body = simple_expr { FunDef (func, fargs, body) }
        ;
                                                        
simple_expr:
	| i = FLOAT { Float i }
	| x = ID { Var x }
        | e1 = simple_expr; SUBTRACT; e2 = simple_expr { Binop (Subtr, e1, e2) }
	| e1 = simple_expr; DIVIDE; e2 = simple_expr { Binop (Div, e1, e2) }
	| e1 = simple_expr; TIMES; e2 = simple_expr { Binop (Mult, e1, e2) } 
	| e1 = simple_expr; PLUS; e2 = simple_expr { Binop (Add, e1, e2) }
	| LET; x = ID; EQUALS; e1 = simple_expr; IN; e2 = simple_expr { Let (x, e1, e2) }
        | func = simple_expr; arg = simple_expr  %prec APP { App (func, arg) }
	| LPAREN; e=simple_expr; RPAREN { e } 
	;
