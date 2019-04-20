
module MenhirBasics = struct
  
  exception Error
  
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
    | LT
    | LPAREN
    | LET
    | LE
    | LBRACE
    | IN
    | IF
    | ID of (
# 7 "parser.mly"
       (string)
# 27 "parser.ml"
  )
    | GT
    | GE
    | FUN
    | FLOAT of (
# 6 "parser.mly"
       (float)
# 35 "parser.ml"
  )
    | EQUALS
    | EQ
    | EOF
    | ELSE
    | DIVIDE
    | COMMA
    | APP
  
end

include MenhirBasics

let _eRR =
  MenhirBasics.Error

type _menhir_env = {
  _menhir_lexer: Lexing.lexbuf -> token;
  _menhir_lexbuf: Lexing.lexbuf;
  _menhir_token: token;
  mutable _menhir_error: bool
}

and _menhir_state = 
  | MenhirState62
  | MenhirState59
  | MenhirState58
  | MenhirState56
  | MenhirState54
  | MenhirState53
  | MenhirState48
  | MenhirState47
  | MenhirState46
  | MenhirState45
  | MenhirState43
  | MenhirState42
  | MenhirState41
  | MenhirState40
  | MenhirState39
  | MenhirState38
  | MenhirState37
  | MenhirState36
  | MenhirState35
  | MenhirState34
  | MenhirState33
  | MenhirState32
  | MenhirState31
  | MenhirState30
  | MenhirState29
  | MenhirState28
  | MenhirState27
  | MenhirState26
  | MenhirState25
  | MenhirState24
  | MenhirState23
  | MenhirState22
  | MenhirState21
  | MenhirState20
  | MenhirState19
  | MenhirState18
  | MenhirState17
  | MenhirState16
  | MenhirState15
  | MenhirState14
  | MenhirState11
  | MenhirState10
  | MenhirState7
  | MenhirState6
  | MenhirState3
  | MenhirState2
  | MenhirState0

# 1 "parser.mly"
  
    open Ast

# 112 "parser.ml"

let rec _menhir_fail : unit -> 'a =
  fun () ->
    Printf.fprintf stderr "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

and _menhir_goto_toplevel_expr : _menhir_env -> 'ttv_tail -> _menhir_state -> (Ast.expr) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _menhir_stack = Obj.magic _menhir_stack in
    assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | EOF ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, (e : (Ast.expr))) = _menhir_stack in
        let _2 = () in
        let _v : (
# 46 "parser.mly"
       (Ast.expr)
# 134 "parser.ml"
        ) = 
# 66 "parser.mly"
                          ( e )
# 138 "parser.ml"
         in
        let _menhir_stack = Obj.magic _menhir_stack in
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_1 : (
# 46 "parser.mly"
       (Ast.expr)
# 145 "parser.ml"
        )) = _v in
        Obj.magic _1
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s

and _menhir_goto_separated_nonempty_list_COMMA_simple_expr_ : _menhir_env -> 'ttv_tail -> _menhir_state -> (Ast.expr list) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState48 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let _menhir_stack = Obj.magic _menhir_stack in
        let (xs : (Ast.expr list)) = _v in
        let ((_menhir_stack, _menhir_s, (x : (Ast.expr))), _) = _menhir_stack in
        let _2 = () in
        let _v : (Ast.expr list) = 
# 243 "/home/luc/.opam/4.06.1/lib/menhir/standard.mly"
    ( x :: xs )
# 167 "parser.ml"
         in
        _menhir_goto_separated_nonempty_list_COMMA_simple_expr_ _menhir_env _menhir_stack _menhir_s _v
    | MenhirState46 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let _menhir_stack = Obj.magic _menhir_stack in
        let (x : (Ast.expr list)) = _v in
        let _v : (Ast.expr list) = 
# 144 "/home/luc/.opam/4.06.1/lib/menhir/standard.mly"
    ( x )
# 177 "parser.ml"
         in
        _menhir_goto_loption_separated_nonempty_list_COMMA_simple_expr__ _menhir_env _menhir_stack _menhir_s _v
    | _ ->
        _menhir_fail ()

and _menhir_goto_loption_separated_nonempty_list_COMMA_simple_expr__ : _menhir_env -> 'ttv_tail -> _menhir_state -> (Ast.expr list) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _menhir_stack = Obj.magic _menhir_stack in
    assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | RBRACE ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let _menhir_env = _menhir_discard _menhir_env in
        let _menhir_stack = Obj.magic _menhir_stack in
        let ((((((_menhir_stack, _menhir_s), (func : (
# 7 "parser.mly"
       (string)
# 197 "parser.ml"
        ))), _, (fargs : (string list))), _, (body : (Ast.expr))), _), _, (xs : (Ast.expr list))) = _menhir_stack in
        let _8 = () in
        let _6 = () in
        let _4 = () in
        let _1 = () in
        let _v : (Ast.expr) = let updates = 
# 232 "/home/luc/.opam/4.06.1/lib/menhir/standard.mly"
    ( xs )
# 206 "parser.ml"
         in
        
# 72 "parser.mly"
                                                                                                                                     ( ProcDef (func, fargs, body, updates) )
# 211 "parser.ml"
         in
        _menhir_goto_toplevel_expr _menhir_env _menhir_stack _menhir_s _v
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s

and _menhir_run15 : _menhir_env -> 'ttv_tail * _menhir_state * (Ast.expr) -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | FLOAT _v ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState15 _v
    | ID _v ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState15 _v
    | IF ->
        _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState15
    | LET ->
        _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState15
    | LPAREN ->
        _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState15
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState15

and _menhir_run17 : _menhir_env -> 'ttv_tail * _menhir_state * (Ast.expr) -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | FLOAT _v ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState17 _v
    | ID _v ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState17 _v
    | IF ->
        _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState17
    | LET ->
        _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState17
    | LPAREN ->
        _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState17
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState17

and _menhir_run20 : _menhir_env -> 'ttv_tail * _menhir_state * (Ast.expr) -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | FLOAT _v ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState20 _v
    | ID _v ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState20 _v
    | IF ->
        _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState20
    | LET ->
        _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState20
    | LPAREN ->
        _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState20
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState20

and _menhir_run24 : _menhir_env -> 'ttv_tail * _menhir_state * (Ast.expr) -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | FLOAT _v ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState24 _v
    | ID _v ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState24 _v
    | IF ->
        _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState24
    | LET ->
        _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState24
    | LPAREN ->
        _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState24
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState24

and _menhir_run28 : _menhir_env -> 'ttv_tail * _menhir_state * (Ast.expr) -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | FLOAT _v ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState28 _v
    | ID _v ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState28 _v
    | IF ->
        _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState28
    | LET ->
        _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState28
    | LPAREN ->
        _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState28
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState28

and _menhir_run30 : _menhir_env -> 'ttv_tail * _menhir_state * (Ast.expr) -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | FLOAT _v ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState30 _v
    | ID _v ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState30 _v
    | IF ->
        _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState30
    | LET ->
        _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState30
    | LPAREN ->
        _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState30
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState30

and _menhir_run32 : _menhir_env -> 'ttv_tail * _menhir_state * (Ast.expr) -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | FLOAT _v ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState32 _v
    | ID _v ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState32 _v
    | IF ->
        _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState32
    | LET ->
        _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState32
    | LPAREN ->
        _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState32
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState32

and _menhir_run34 : _menhir_env -> 'ttv_tail * _menhir_state * (Ast.expr) -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | FLOAT _v ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState34 _v
    | ID _v ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState34 _v
    | IF ->
        _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState34
    | LET ->
        _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState34
    | LPAREN ->
        _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState34
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState34

and _menhir_run36 : _menhir_env -> 'ttv_tail * _menhir_state * (Ast.expr) -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | FLOAT _v ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState36 _v
    | ID _v ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState36 _v
    | IF ->
        _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState36
    | LET ->
        _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState36
    | LPAREN ->
        _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState36
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState36

and _menhir_run22 : _menhir_env -> 'ttv_tail * _menhir_state * (Ast.expr) -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | FLOAT _v ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState22 _v
    | ID _v ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState22 _v
    | IF ->
        _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState22
    | LET ->
        _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState22
    | LPAREN ->
        _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState22
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState22

and _menhir_goto_list_ID_ : _menhir_env -> 'ttv_tail -> _menhir_state -> (string list) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState3 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let _menhir_stack = Obj.magic _menhir_stack in
        let ((_menhir_stack, _menhir_s, (x : (
# 7 "parser.mly"
       (string)
# 441 "parser.ml"
        ))), _, (xs : (string list))) = _menhir_stack in
        let _v : (string list) = 
# 213 "/home/luc/.opam/4.06.1/lib/menhir/standard.mly"
    ( x :: xs )
# 446 "parser.ml"
         in
        _menhir_goto_list_ID_ _menhir_env _menhir_stack _menhir_s _v
    | MenhirState2 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | EQUALS ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            (match _tok with
            | FLOAT _v ->
                _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState6 _v
            | ID _v ->
                _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState6 _v
            | IF ->
                _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState6
            | LET ->
                _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState6
            | LPAREN ->
                _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState6
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState6)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let _menhir_stack = Obj.magic _menhir_stack in
            let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s)
    | MenhirState56 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | EQUALS ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            (match _tok with
            | FLOAT _v ->
                _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState58 _v
            | ID _v ->
                _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState58 _v
            | IF ->
                _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState58
            | LET ->
                _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState58
            | LPAREN ->
                _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState58
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState58)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let _menhir_stack = Obj.magic _menhir_stack in
            let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s)
    | _ ->
        _menhir_fail ()

and _menhir_goto_simple_expr : _menhir_env -> 'ttv_tail -> _menhir_state -> (Ast.expr) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState11 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | DIVIDE ->
            _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState14
        | EQ ->
            _menhir_run36 _menhir_env (Obj.magic _menhir_stack) MenhirState14
        | FLOAT _v ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState14 _v
        | GE ->
            _menhir_run34 _menhir_env (Obj.magic _menhir_stack) MenhirState14
        | GT ->
            _menhir_run32 _menhir_env (Obj.magic _menhir_stack) MenhirState14
        | ID _v ->
            _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState14 _v
        | IF ->
            _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState14
        | LE ->
            _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState14
        | LET ->
            _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState14
        | LPAREN ->
            _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState14
        | LT ->
            _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState14
        | PLUS ->
            _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState14
        | SUBTRACT ->
            _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState14
        | THEN ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let _menhir_s = MenhirState14 in
            let _menhir_stack = (_menhir_stack, _menhir_s) in
            let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            (match _tok with
            | FLOAT _v ->
                _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState26 _v
            | ID _v ->
                _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState26 _v
            | IF ->
                _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState26
            | LET ->
                _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState26
            | LPAREN ->
                _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState26
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState26)
        | TIMES ->
            _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState14
        | UNEQ ->
            _menhir_run15 _menhir_env (Obj.magic _menhir_stack) MenhirState14
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState14)
    | MenhirState15 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | DIVIDE ->
            _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState16
        | FLOAT _v ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState16 _v
        | ID _v ->
            _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState16 _v
        | PLUS ->
            _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState16
        | SUBTRACT ->
            _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState16
        | TIMES ->
            _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState16
        | COMMA | ELSE | EOF | IF | IN | LBRACE | LET | LPAREN | RBRACE | RPAREN | THEN ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let (((_menhir_stack, _menhir_s, (e1 : (Ast.expr))), _), _, (e2 : (Ast.expr))) = _menhir_stack in
            let _2 = () in
            let _v : (Ast.expr) = 
# 88 "parser.mly"
                                                   ( Binop (Uneq, e1, e2) )
# 600 "parser.ml"
             in
            _menhir_goto_simple_expr _menhir_env _menhir_stack _menhir_s _v
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState16)
    | MenhirState17 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | FLOAT _v ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState18 _v
        | ID _v ->
            _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState18 _v
        | COMMA | DIVIDE | ELSE | EOF | EQ | GE | GT | IF | IN | LBRACE | LE | LET | LPAREN | LT | PLUS | RBRACE | RPAREN | SUBTRACT | THEN | TIMES | UNEQ ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let (((_menhir_stack, _menhir_s, (e1 : (Ast.expr))), _), _, (e2 : (Ast.expr))) = _menhir_stack in
            let _2 = () in
            let _v : (Ast.expr) = 
# 81 "parser.mly"
                                             ( Binop (Mult, e1, e2) )
# 623 "parser.ml"
             in
            _menhir_goto_simple_expr _menhir_env _menhir_stack _menhir_s _v
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState18)
    | MenhirState62 | MenhirState59 | MenhirState54 | MenhirState45 | MenhirState47 | MenhirState43 | MenhirState40 | MenhirState42 | MenhirState14 | MenhirState27 | MenhirState39 | MenhirState37 | MenhirState35 | MenhirState33 | MenhirState31 | MenhirState29 | MenhirState16 | MenhirState25 | MenhirState21 | MenhirState23 | MenhirState19 | MenhirState18 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | FLOAT _v ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState19 _v
        | ID _v ->
            _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState19 _v
        | COMMA | DIVIDE | ELSE | EOF | EQ | GE | GT | IF | IN | LBRACE | LE | LET | LPAREN | LT | PLUS | RBRACE | RPAREN | SUBTRACT | THEN | TIMES | UNEQ ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let ((_menhir_stack, _menhir_s, (func : (Ast.expr))), _, (arg : (Ast.expr))) = _menhir_stack in
            let _v : (Ast.expr) = 
# 91 "parser.mly"
                                                           ( App (func, arg) )
# 645 "parser.ml"
             in
            _menhir_goto_simple_expr _menhir_env _menhir_stack _menhir_s _v
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState19)
    | MenhirState20 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | DIVIDE ->
            _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState21
        | FLOAT _v ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState21 _v
        | ID _v ->
            _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState21 _v
        | TIMES ->
            _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState21
        | COMMA | ELSE | EOF | EQ | GE | GT | IF | IN | LBRACE | LE | LET | LPAREN | LT | PLUS | RBRACE | RPAREN | SUBTRACT | THEN | UNEQ ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let (((_menhir_stack, _menhir_s, (e1 : (Ast.expr))), _), _, (e2 : (Ast.expr))) = _menhir_stack in
            let _2 = () in
            let _v : (Ast.expr) = 
# 79 "parser.mly"
                                                       ( Binop (Subtr, e1, e2) )
# 672 "parser.ml"
             in
            _menhir_goto_simple_expr _menhir_env _menhir_stack _menhir_s _v
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState21)
    | MenhirState22 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | FLOAT _v ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState23 _v
        | ID _v ->
            _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState23 _v
        | TIMES ->
            _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState23
        | COMMA | DIVIDE | ELSE | EOF | EQ | GE | GT | IF | IN | LBRACE | LE | LET | LPAREN | LT | PLUS | RBRACE | RPAREN | SUBTRACT | THEN | UNEQ ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let (((_menhir_stack, _menhir_s, (e1 : (Ast.expr))), _), _, (e2 : (Ast.expr))) = _menhir_stack in
            let _2 = () in
            let _v : (Ast.expr) = 
# 80 "parser.mly"
                                              ( Binop (Div, e1, e2) )
# 697 "parser.ml"
             in
            _menhir_goto_simple_expr _menhir_env _menhir_stack _menhir_s _v
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState23)
    | MenhirState24 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | DIVIDE ->
            _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState25
        | FLOAT _v ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState25 _v
        | ID _v ->
            _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState25 _v
        | SUBTRACT ->
            _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState25
        | TIMES ->
            _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState25
        | COMMA | ELSE | EOF | EQ | GE | GT | IF | IN | LBRACE | LE | LET | LPAREN | LT | PLUS | RBRACE | RPAREN | THEN | UNEQ ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let (((_menhir_stack, _menhir_s, (e1 : (Ast.expr))), _), _, (e2 : (Ast.expr))) = _menhir_stack in
            let _2 = () in
            let _v : (Ast.expr) = 
# 82 "parser.mly"
                                            ( Binop (Add, e1, e2) )
# 726 "parser.ml"
             in
            _menhir_goto_simple_expr _menhir_env _menhir_stack _menhir_s _v
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState25)
    | MenhirState26 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | DIVIDE ->
            _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState27
        | ELSE ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let _menhir_s = MenhirState27 in
            let _menhir_stack = (_menhir_stack, _menhir_s) in
            let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            (match _tok with
            | FLOAT _v ->
                _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState38 _v
            | ID _v ->
                _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState38 _v
            | IF ->
                _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState38
            | LET ->
                _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState38
            | LPAREN ->
                _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState38
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState38)
        | EQ ->
            _menhir_run36 _menhir_env (Obj.magic _menhir_stack) MenhirState27
        | FLOAT _v ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState27 _v
        | GE ->
            _menhir_run34 _menhir_env (Obj.magic _menhir_stack) MenhirState27
        | GT ->
            _menhir_run32 _menhir_env (Obj.magic _menhir_stack) MenhirState27
        | ID _v ->
            _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState27 _v
        | IF ->
            _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState27
        | LE ->
            _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState27
        | LET ->
            _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState27
        | LPAREN ->
            _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState27
        | LT ->
            _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState27
        | PLUS ->
            _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState27
        | SUBTRACT ->
            _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState27
        | TIMES ->
            _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState27
        | UNEQ ->
            _menhir_run15 _menhir_env (Obj.magic _menhir_stack) MenhirState27
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState27)
    | MenhirState28 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | DIVIDE ->
            _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState29
        | FLOAT _v ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState29 _v
        | ID _v ->
            _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState29 _v
        | PLUS ->
            _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState29
        | SUBTRACT ->
            _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState29
        | TIMES ->
            _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState29
        | COMMA | ELSE | EOF | IF | IN | LBRACE | LET | LPAREN | RBRACE | RPAREN | THEN ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let (((_menhir_stack, _menhir_s, (e1 : (Ast.expr))), _), _, (e2 : (Ast.expr))) = _menhir_stack in
            let _2 = () in
            let _v : (Ast.expr) = 
# 83 "parser.mly"
                                                 ( Binop (Lt, e1, e2) )
# 817 "parser.ml"
             in
            _menhir_goto_simple_expr _menhir_env _menhir_stack _menhir_s _v
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState29)
    | MenhirState30 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | DIVIDE ->
            _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState31
        | FLOAT _v ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState31 _v
        | ID _v ->
            _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState31 _v
        | PLUS ->
            _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState31
        | SUBTRACT ->
            _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState31
        | TIMES ->
            _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState31
        | COMMA | ELSE | EOF | IF | IN | LBRACE | LET | LPAREN | RBRACE | RPAREN | THEN ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let (((_menhir_stack, _menhir_s, (e1 : (Ast.expr))), _), _, (e2 : (Ast.expr))) = _menhir_stack in
            let _2 = () in
            let _v : (Ast.expr) = 
# 86 "parser.mly"
                                                 ( Binop (Le, e1, e2) )
# 848 "parser.ml"
             in
            _menhir_goto_simple_expr _menhir_env _menhir_stack _menhir_s _v
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState31)
    | MenhirState32 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | DIVIDE ->
            _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState33
        | FLOAT _v ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState33 _v
        | ID _v ->
            _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState33 _v
        | PLUS ->
            _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState33
        | SUBTRACT ->
            _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState33
        | TIMES ->
            _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState33
        | COMMA | ELSE | EOF | IF | IN | LBRACE | LET | LPAREN | RBRACE | RPAREN | THEN ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let (((_menhir_stack, _menhir_s, (e1 : (Ast.expr))), _), _, (e2 : (Ast.expr))) = _menhir_stack in
            let _2 = () in
            let _v : (Ast.expr) = 
# 84 "parser.mly"
                                                 ( Binop (Gt, e1, e2) )
# 879 "parser.ml"
             in
            _menhir_goto_simple_expr _menhir_env _menhir_stack _menhir_s _v
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState33)
    | MenhirState34 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | DIVIDE ->
            _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState35
        | FLOAT _v ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState35 _v
        | ID _v ->
            _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState35 _v
        | PLUS ->
            _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState35
        | SUBTRACT ->
            _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState35
        | TIMES ->
            _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState35
        | COMMA | ELSE | EOF | IF | IN | LBRACE | LET | LPAREN | RBRACE | RPAREN | THEN ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let (((_menhir_stack, _menhir_s, (e1 : (Ast.expr))), _), _, (e2 : (Ast.expr))) = _menhir_stack in
            let _2 = () in
            let _v : (Ast.expr) = 
# 85 "parser.mly"
                                                 ( Binop (Ge, e1, e2) )
# 910 "parser.ml"
             in
            _menhir_goto_simple_expr _menhir_env _menhir_stack _menhir_s _v
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState35)
    | MenhirState36 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | DIVIDE ->
            _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState37
        | FLOAT _v ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState37 _v
        | ID _v ->
            _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState37 _v
        | PLUS ->
            _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState37
        | SUBTRACT ->
            _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState37
        | TIMES ->
            _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState37
        | COMMA | ELSE | EOF | IF | IN | LBRACE | LET | LPAREN | RBRACE | RPAREN | THEN ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let (((_menhir_stack, _menhir_s, (e1 : (Ast.expr))), _), _, (e2 : (Ast.expr))) = _menhir_stack in
            let _2 = () in
            let _v : (Ast.expr) = 
# 87 "parser.mly"
                                                 ( Binop (Eq, e1, e2) )
# 941 "parser.ml"
             in
            _menhir_goto_simple_expr _menhir_env _menhir_stack _menhir_s _v
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState37)
    | MenhirState38 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | DIVIDE ->
            _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState39
        | EQ ->
            _menhir_run36 _menhir_env (Obj.magic _menhir_stack) MenhirState39
        | FLOAT _v ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState39 _v
        | GE ->
            _menhir_run34 _menhir_env (Obj.magic _menhir_stack) MenhirState39
        | GT ->
            _menhir_run32 _menhir_env (Obj.magic _menhir_stack) MenhirState39
        | ID _v ->
            _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState39 _v
        | LE ->
            _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState39
        | LET ->
            _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState39
        | LPAREN ->
            _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState39
        | LT ->
            _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState39
        | PLUS ->
            _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState39
        | SUBTRACT ->
            _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState39
        | TIMES ->
            _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState39
        | UNEQ ->
            _menhir_run15 _menhir_env (Obj.magic _menhir_stack) MenhirState39
        | COMMA | ELSE | EOF | IN | LBRACE | RBRACE | RPAREN | THEN ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let ((((((_menhir_stack, _menhir_s), _, (cond : (Ast.expr))), _), _, (then_ : (Ast.expr))), _), _, (else_ : (Ast.expr))) = _menhir_stack in
            let _5 = () in
            let _3 = () in
            let _1 = () in
            let _v : (Ast.expr) = 
# 89 "parser.mly"
                                                                                       ( If (cond, then_, else_) )
# 990 "parser.ml"
             in
            _menhir_goto_simple_expr _menhir_env _menhir_stack _menhir_s _v
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState39)
    | MenhirState10 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | DIVIDE ->
            _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState40
        | EQ ->
            _menhir_run36 _menhir_env (Obj.magic _menhir_stack) MenhirState40
        | FLOAT _v ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState40 _v
        | GE ->
            _menhir_run34 _menhir_env (Obj.magic _menhir_stack) MenhirState40
        | GT ->
            _menhir_run32 _menhir_env (Obj.magic _menhir_stack) MenhirState40
        | ID _v ->
            _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState40 _v
        | IF ->
            _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState40
        | IN ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let _menhir_s = MenhirState40 in
            let _menhir_stack = (_menhir_stack, _menhir_s) in
            let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            (match _tok with
            | FLOAT _v ->
                _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState41 _v
            | ID _v ->
                _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState41 _v
            | IF ->
                _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState41
            | LET ->
                _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState41
            | LPAREN ->
                _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState41
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState41)
        | LE ->
            _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState40
        | LET ->
            _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState40
        | LPAREN ->
            _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState40
        | LT ->
            _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState40
        | PLUS ->
            _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState40
        | SUBTRACT ->
            _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState40
        | TIMES ->
            _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState40
        | UNEQ ->
            _menhir_run15 _menhir_env (Obj.magic _menhir_stack) MenhirState40
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState40)
    | MenhirState41 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | DIVIDE ->
            _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState42
        | EQ ->
            _menhir_run36 _menhir_env (Obj.magic _menhir_stack) MenhirState42
        | FLOAT _v ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState42 _v
        | GE ->
            _menhir_run34 _menhir_env (Obj.magic _menhir_stack) MenhirState42
        | GT ->
            _menhir_run32 _menhir_env (Obj.magic _menhir_stack) MenhirState42
        | ID _v ->
            _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState42 _v
        | IF ->
            _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState42
        | LE ->
            _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState42
        | LET ->
            _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState42
        | LPAREN ->
            _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState42
        | LT ->
            _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState42
        | PLUS ->
            _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState42
        | SUBTRACT ->
            _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState42
        | TIMES ->
            _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState42
        | UNEQ ->
            _menhir_run15 _menhir_env (Obj.magic _menhir_stack) MenhirState42
        | COMMA | ELSE | EOF | IN | LBRACE | RBRACE | RPAREN | THEN ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let (((((_menhir_stack, _menhir_s), (x : (
# 7 "parser.mly"
       (string)
# 1097 "parser.ml"
            ))), _, (e1 : (Ast.expr))), _), _, (e2 : (Ast.expr))) = _menhir_stack in
            let _5 = () in
            let _3 = () in
            let _1 = () in
            let _v : (Ast.expr) = 
# 90 "parser.mly"
                                                               ( Let (x, e1, e2) )
# 1105 "parser.ml"
             in
            _menhir_goto_simple_expr _menhir_env _menhir_stack _menhir_s _v
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState42)
    | MenhirState7 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | DIVIDE ->
            _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState43
        | EQ ->
            _menhir_run36 _menhir_env (Obj.magic _menhir_stack) MenhirState43
        | FLOAT _v ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState43 _v
        | GE ->
            _menhir_run34 _menhir_env (Obj.magic _menhir_stack) MenhirState43
        | GT ->
            _menhir_run32 _menhir_env (Obj.magic _menhir_stack) MenhirState43
        | ID _v ->
            _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState43 _v
        | IF ->
            _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState43
        | LE ->
            _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState43
        | LET ->
            _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState43
        | LPAREN ->
            _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState43
        | LT ->
            _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState43
        | PLUS ->
            _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState43
        | RPAREN ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let _menhir_s = MenhirState43 in
            let _menhir_env = _menhir_discard _menhir_env in
            let _menhir_stack = Obj.magic _menhir_stack in
            let ((_menhir_stack, _menhir_s), _, (e : (Ast.expr))) = _menhir_stack in
            let _3 = () in
            let _1 = () in
            let _v : (Ast.expr) = 
# 94 "parser.mly"
                                 ( e )
# 1152 "parser.ml"
             in
            _menhir_goto_simple_expr _menhir_env _menhir_stack _menhir_s _v
        | SUBTRACT ->
            _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState43
        | TIMES ->
            _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState43
        | UNEQ ->
            _menhir_run15 _menhir_env (Obj.magic _menhir_stack) MenhirState43
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState43)
    | MenhirState6 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | DIVIDE ->
            _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState45
        | EQ ->
            _menhir_run36 _menhir_env (Obj.magic _menhir_stack) MenhirState45
        | FLOAT _v ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState45 _v
        | GE ->
            _menhir_run34 _menhir_env (Obj.magic _menhir_stack) MenhirState45
        | GT ->
            _menhir_run32 _menhir_env (Obj.magic _menhir_stack) MenhirState45
        | ID _v ->
            _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState45 _v
        | IF ->
            _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState45
        | LBRACE ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let _menhir_s = MenhirState45 in
            let _menhir_stack = (_menhir_stack, _menhir_s) in
            let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            (match _tok with
            | FLOAT _v ->
                _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState46 _v
            | ID _v ->
                _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState46 _v
            | IF ->
                _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState46
            | LET ->
                _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState46
            | LPAREN ->
                _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState46
            | RBRACE ->
                let _menhir_stack = Obj.magic _menhir_stack in
                let _menhir_s = MenhirState46 in
                let _v : (Ast.expr list) = 
# 142 "/home/luc/.opam/4.06.1/lib/menhir/standard.mly"
    ( [] )
# 1207 "parser.ml"
                 in
                _menhir_goto_loption_separated_nonempty_list_COMMA_simple_expr__ _menhir_env _menhir_stack _menhir_s _v
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState46)
        | LE ->
            _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState45
        | LET ->
            _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState45
        | LPAREN ->
            _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState45
        | LT ->
            _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState45
        | PLUS ->
            _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState45
        | SUBTRACT ->
            _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState45
        | TIMES ->
            _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState45
        | UNEQ ->
            _menhir_run15 _menhir_env (Obj.magic _menhir_stack) MenhirState45
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState45)
    | MenhirState48 | MenhirState46 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | COMMA ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let _menhir_s = MenhirState47 in
            let _menhir_stack = (_menhir_stack, _menhir_s) in
            let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            (match _tok with
            | FLOAT _v ->
                _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState48 _v
            | ID _v ->
                _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState48 _v
            | IF ->
                _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState48
            | LET ->
                _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState48
            | LPAREN ->
                _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState48
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState48)
        | DIVIDE ->
            _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState47
        | EQ ->
            _menhir_run36 _menhir_env (Obj.magic _menhir_stack) MenhirState47
        | FLOAT _v ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState47 _v
        | GE ->
            _menhir_run34 _menhir_env (Obj.magic _menhir_stack) MenhirState47
        | GT ->
            _menhir_run32 _menhir_env (Obj.magic _menhir_stack) MenhirState47
        | ID _v ->
            _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState47 _v
        | IF ->
            _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState47
        | LE ->
            _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState47
        | LET ->
            _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState47
        | LPAREN ->
            _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState47
        | LT ->
            _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState47
        | PLUS ->
            _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState47
        | SUBTRACT ->
            _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState47
        | TIMES ->
            _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState47
        | UNEQ ->
            _menhir_run15 _menhir_env (Obj.magic _menhir_stack) MenhirState47
        | RBRACE ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let (_menhir_stack, _menhir_s, (x : (Ast.expr))) = _menhir_stack in
            let _v : (Ast.expr list) = 
# 241 "/home/luc/.opam/4.06.1/lib/menhir/standard.mly"
    ( [ x ] )
# 1296 "parser.ml"
             in
            _menhir_goto_separated_nonempty_list_COMMA_simple_expr_ _menhir_env _menhir_stack _menhir_s _v
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState47)
    | MenhirState53 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | DIVIDE ->
            _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState54
        | EQ ->
            _menhir_run36 _menhir_env (Obj.magic _menhir_stack) MenhirState54
        | FLOAT _v ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState54 _v
        | GE ->
            _menhir_run34 _menhir_env (Obj.magic _menhir_stack) MenhirState54
        | GT ->
            _menhir_run32 _menhir_env (Obj.magic _menhir_stack) MenhirState54
        | ID _v ->
            _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState54 _v
        | IF ->
            _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState54
        | LE ->
            _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState54
        | LET ->
            _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState54
        | LPAREN ->
            _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState54
        | LT ->
            _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState54
        | PLUS ->
            _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState54
        | SUBTRACT ->
            _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState54
        | TIMES ->
            _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState54
        | UNEQ ->
            _menhir_run15 _menhir_env (Obj.magic _menhir_stack) MenhirState54
        | EOF ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let ((_menhir_stack, _menhir_s), _, (e : (Ast.expr))) = _menhir_stack in
            let _1 = () in
            let _v : (Ast.expr) = 
# 73 "parser.mly"
                                ( Play e )
# 1345 "parser.ml"
             in
            _menhir_goto_toplevel_expr _menhir_env _menhir_stack _menhir_s _v
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState54)
    | MenhirState58 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | DIVIDE ->
            _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState59
        | EQ ->
            _menhir_run36 _menhir_env (Obj.magic _menhir_stack) MenhirState59
        | FLOAT _v ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState59 _v
        | GE ->
            _menhir_run34 _menhir_env (Obj.magic _menhir_stack) MenhirState59
        | GT ->
            _menhir_run32 _menhir_env (Obj.magic _menhir_stack) MenhirState59
        | ID _v ->
            _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState59 _v
        | IF ->
            _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState59
        | LE ->
            _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState59
        | LET ->
            _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState59
        | LPAREN ->
            _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState59
        | LT ->
            _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState59
        | PLUS ->
            _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState59
        | SUBTRACT ->
            _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState59
        | TIMES ->
            _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState59
        | UNEQ ->
            _menhir_run15 _menhir_env (Obj.magic _menhir_stack) MenhirState59
        | EOF ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let ((((_menhir_stack, _menhir_s), (func : (
# 7 "parser.mly"
       (string)
# 1392 "parser.ml"
            ))), _, (fargs : (string list))), _, (body : (Ast.expr))) = _menhir_stack in
            let _4 = () in
            let _1 = () in
            let _v : (Ast.expr) = 
# 71 "parser.mly"
                                                                       ( FunDef (func, fargs, body) )
# 1399 "parser.ml"
             in
            _menhir_goto_toplevel_expr _menhir_env _menhir_stack _menhir_s _v
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState59)
    | MenhirState0 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | DIVIDE ->
            _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState62
        | EQ ->
            _menhir_run36 _menhir_env (Obj.magic _menhir_stack) MenhirState62
        | FLOAT _v ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState62 _v
        | GE ->
            _menhir_run34 _menhir_env (Obj.magic _menhir_stack) MenhirState62
        | GT ->
            _menhir_run32 _menhir_env (Obj.magic _menhir_stack) MenhirState62
        | ID _v ->
            _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState62 _v
        | IF ->
            _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState62
        | LE ->
            _menhir_run30 _menhir_env (Obj.magic _menhir_stack) MenhirState62
        | LET ->
            _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState62
        | LPAREN ->
            _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState62
        | LT ->
            _menhir_run28 _menhir_env (Obj.magic _menhir_stack) MenhirState62
        | PLUS ->
            _menhir_run24 _menhir_env (Obj.magic _menhir_stack) MenhirState62
        | SUBTRACT ->
            _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState62
        | TIMES ->
            _menhir_run17 _menhir_env (Obj.magic _menhir_stack) MenhirState62
        | UNEQ ->
            _menhir_run15 _menhir_env (Obj.magic _menhir_stack) MenhirState62
        | EOF ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let (_menhir_stack, _menhir_s, (e1 : (Ast.expr))) = _menhir_stack in
            let _v : (Ast.expr) = 
# 70 "parser.mly"
                           ( e1 )
# 1447 "parser.ml"
             in
            _menhir_goto_toplevel_expr _menhir_env _menhir_stack _menhir_s _v
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState62)
    | _ ->
        _menhir_fail ()

and _menhir_run7 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | FLOAT _v ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState7 _v
    | ID _v ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState7 _v
    | IF ->
        _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState7
    | LET ->
        _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState7
    | LPAREN ->
        _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState7
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState7

and _menhir_run8 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | ID _v ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let _menhir_stack = (_menhir_stack, _v) in
        let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | EQUALS ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            (match _tok with
            | FLOAT _v ->
                _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState10 _v
            | ID _v ->
                _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState10 _v
            | IF ->
                _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState10
            | LET ->
                _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState10
            | LPAREN ->
                _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState10
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState10)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let _menhir_stack = Obj.magic _menhir_stack in
            let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s

and _menhir_run11 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | FLOAT _v ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState11 _v
    | ID _v ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState11 _v
    | IF ->
        _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState11
    | LET ->
        _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState11
    | LPAREN ->
        _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState11
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState11

and _menhir_run12 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 7 "parser.mly"
       (string)
# 1546 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_env = _menhir_discard _menhir_env in
    let _menhir_stack = Obj.magic _menhir_stack in
    let (x : (
# 7 "parser.mly"
       (string)
# 1554 "parser.ml"
    )) = _v in
    let _v : (Ast.expr) = 
# 78 "parser.mly"
          ( Var x )
# 1559 "parser.ml"
     in
    _menhir_goto_simple_expr _menhir_env _menhir_stack _menhir_s _v

and _menhir_errorcase : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    match _menhir_s with
    | MenhirState62 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState59 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState58 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState56 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState54 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState53 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState48 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState47 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState46 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState45 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState43 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState42 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState41 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState40 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState39 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState38 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState37 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState36 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState35 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState34 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState33 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState32 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState31 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState30 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState29 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState28 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState27 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState26 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState25 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState24 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState23 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState22 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState21 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState20 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState19 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState18 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState17 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState16 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState15 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState14 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState11 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState10 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState7 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState6 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState3 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState2 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s
    | MenhirState0 ->
        let _menhir_stack = Obj.magic _menhir_stack in
        raise _eRR

and _menhir_reduce1 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : (string list) = 
# 211 "/home/luc/.opam/4.06.1/lib/menhir/standard.mly"
    ( [] )
# 1759 "parser.ml"
     in
    _menhir_goto_list_ID_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run3 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 7 "parser.mly"
       (string)
# 1766 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | ID _v ->
        _menhir_run3 _menhir_env (Obj.magic _menhir_stack) MenhirState3 _v
    | EQUALS ->
        _menhir_reduce1 _menhir_env (Obj.magic _menhir_stack) MenhirState3
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState3

and _menhir_run13 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 6 "parser.mly"
       (float)
# 1785 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_env = _menhir_discard _menhir_env in
    let _menhir_stack = Obj.magic _menhir_stack in
    let (i : (
# 6 "parser.mly"
       (float)
# 1793 "parser.ml"
    )) = _v in
    let _v : (Ast.expr) = 
# 77 "parser.mly"
             ( Float i )
# 1798 "parser.ml"
     in
    _menhir_goto_simple_expr _menhir_env _menhir_stack _menhir_s _v

and _menhir_discard : _menhir_env -> _menhir_env =
  fun _menhir_env ->
    let lexer = _menhir_env._menhir_lexer in
    let lexbuf = _menhir_env._menhir_lexbuf in
    let _tok = lexer lexbuf in
    {
      _menhir_lexer = lexer;
      _menhir_lexbuf = lexbuf;
      _menhir_token = _tok;
      _menhir_error = false;
    }

and prog : (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (
# 46 "parser.mly"
       (Ast.expr)
# 1817 "parser.ml"
) =
  fun lexer lexbuf ->
    let _menhir_env = let _tok = Obj.magic () in
    {
      _menhir_lexer = lexer;
      _menhir_lexbuf = lexbuf;
      _menhir_token = _tok;
      _menhir_error = false;
    } in
    Obj.magic (let _menhir_stack = ((), _menhir_env._menhir_lexbuf.Lexing.lex_curr_p) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | FLOAT _v ->
        _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState0 _v
    | FUN ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let _menhir_s = MenhirState0 in
        let _menhir_stack = (_menhir_stack, _menhir_s) in
        let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | ID _v ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let _menhir_stack = (_menhir_stack, _v) in
            let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            (match _tok with
            | ID _v ->
                _menhir_run3 _menhir_env (Obj.magic _menhir_stack) MenhirState56 _v
            | EQUALS ->
                _menhir_reduce1 _menhir_env (Obj.magic _menhir_stack) MenhirState56
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState56)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let _menhir_stack = Obj.magic _menhir_stack in
            let (_menhir_stack, _menhir_s) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s)
    | ID _v ->
        _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState0 _v
    | IF ->
        _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | LET ->
        _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | LPAREN ->
        _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | PLAY ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let _menhir_s = MenhirState0 in
        let _menhir_stack = (_menhir_stack, _menhir_s) in
        let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | FLOAT _v ->
            _menhir_run13 _menhir_env (Obj.magic _menhir_stack) MenhirState53 _v
        | ID _v ->
            _menhir_run12 _menhir_env (Obj.magic _menhir_stack) MenhirState53 _v
        | IF ->
            _menhir_run11 _menhir_env (Obj.magic _menhir_stack) MenhirState53
        | LET ->
            _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState53
        | LPAREN ->
            _menhir_run7 _menhir_env (Obj.magic _menhir_stack) MenhirState53
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState53)
    | PROC ->
        let _menhir_stack = Obj.magic _menhir_stack in
        let _menhir_s = MenhirState0 in
        let _menhir_stack = (_menhir_stack, _menhir_s) in
        let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        (match _tok with
        | ID _v ->
            let _menhir_stack = Obj.magic _menhir_stack in
            let _menhir_stack = (_menhir_stack, _v) in
            let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            (match _tok with
            | ID _v ->
                _menhir_run3 _menhir_env (Obj.magic _menhir_stack) MenhirState2 _v
            | EQUALS ->
                _menhir_reduce1 _menhir_env (Obj.magic _menhir_stack) MenhirState2
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState2)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let _menhir_stack = Obj.magic _menhir_stack in
            let (_menhir_stack, _menhir_s) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState0)

# 269 "/home/luc/.opam/4.06.1/lib/menhir/standard.mly"
  

# 1924 "parser.ml"
