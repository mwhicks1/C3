%{

  open Hack
    
%}
%token PTR
%token <int * int> COLONBOUNDS
%token <int * int> COLONITYPE
%token <string> ANY
%token <int * int> PRAGMA
%token <string> ID
%token <string> PID
%token EOF
%token LANGLE
%token RANGLE
%token LPAREN
%token RPAREN
%token FORANY
%token COLON
%token COMMA
%token CHECKED
%token DYNCHECK
%token ASSUME_CAST

%start <(int*int*string) list> main

%%

main:
| p = checkedptr m = main { ($startpos.pos_cnum , $endpos(p).pos_cnum, p)::m }
| p = cast m = main { ($startpos.pos_cnum , $endpos(p).pos_cnum, p)::m }
| p = annot m = main { p::m }
| LPAREN m = main { m }
| RPAREN m = main { m }
| LANGLE m = main { m }
| RANGLE m = main { m }
| COLON m = main { m }
| PID popt = instvar? m = main { match popt with Some p -> p::m | None -> m }
| ID m = main { m }
| COMMA m = main { m }
| ANY m = main { m }
| EOF { [] }

cast: 
  | ASSUME_CAST LANGLE  i = insideitype RANGLE LPAREN e = expr COMMA insidebounds* RPAREN { "("^i^")"^e } 
  | ASSUME_CAST LANGLE  i = insideitype RANGLE LPAREN e = expr RPAREN {  "("^i^")"^e }

expr:
| LPAREN e = exprcomma* RPAREN {  (String.concat "" ("("::e))^")" }
| c = ANY s = expr { String.concat "" [c; s]}
| LANGLE s = expr { String.concat "" ["<"; s]}
| RANGLE s = expr { String.concat "" [">"; s]}
| COLON s = expr { String.concat "" [":"; s]}
/* This is not properly capturing whitespace: it assumes there's a space between tokens, but that's not necessarily so. Need to fix lexer.  */
| c = ID s = expr { String.concat " " [c; s]}
| LANGLE { "<" }
| RANGLE { ">" }
| COLON { ":" }
| c = ANY { c }
| c = ID { c }

exprcomma:
| LPAREN e = exprcomma* RPAREN { (String.concat "" ("("::e))^")" }
| c = ANY s = exprcomma { String.concat "" [c; s]}
| LANGLE s = exprcomma { String.concat "" ["<"; s]}
| RANGLE s = exprcomma { String.concat "" [">"; s]}
| COMMA s = exprcomma { String.concat "" [","; s]}
| COLON s = exprcomma { String.concat "" [":"; s]}
/* This is not properly capturing whitespace: it assumes there's a space between tokens, but that's not necessarily so. Need to fix lexer.  */
| c = ID s = exprcomma { String.concat " " [c; s]}
| LANGLE { "<" }
| RANGLE { ">" }
| COLON { ":" }
| COMMA { "," }
| c = ANY { c }
| c = ID { c }
        
instvar:
| LANGLE insideitype RANGLE  { ($startpos.pos_cnum, $endpos.pos_cnum, "") }
                        
annot:
/* add INCLUDE here; remove _checked, drop stdchecked.h (and note it in lexer) */
| CHECKED { ($startpos.pos_cnum, $endpos.pos_cnum, "") }
| p = PRAGMA { let (s,e) = p in (s, e, "") }
| DYNCHECK LPAREN insidebounds* RPAREN { ($startpos.pos_cnum, $endpos.pos_cnum, "") }
| FORANY LPAREN t = ID RPAREN { note_tyvar t; ($startpos.pos_cnum, $endpos.pos_cnum, "") }
| p = bounds { let (s,_) = p in (s, $endpos.pos_cnum, "") }
| p = itype fakebounds* { let (s,_) = p in (s, $endpos.pos_cnum, "") }

bounds:
| p = COLONBOUNDS LPAREN insidebounds* RPAREN { p }

fakebounds: /* I am assuming ID will be count, bounds, or byte_count */
| ID LPAREN insidebounds+ RPAREN { None }

insidebounds:
| LPAREN insidebounds+ RPAREN { None }
| checkedptr { None }
| LANGLE { None }
| RANGLE { None }
| COLON { None }
| COMMA { None }
| ID { None }
| ANY { None }

itype:
| p = COLONITYPE LPAREN insideitype RPAREN { p }

insideitype:
| c = ANY s = insideitype { String.concat "" [c; s]}
/* This is not properly capturing whitespace: it assumes there's a space between tokens, but that's not necessarily so. Need to fix lexer.  */
| c = ID s = insideitype { String.concat " " [c; s]}
| c = checkedptr { c }
| c = ID { c }
| c = ANY { c }

checkedptr:
| PTR LANGLE p = checkedptr RANGLE { String.concat "" [p; " *"] }
| PTR LANGLE s = insideptr RANGLE { String.concat "" [s; " *"]}
| PTR LANGLE fp = fpointer RANGLE name = id_or_pid 
  { let (ret,params) = fp in String.concat "" [ret; "(*"; name; ")"; params] }
(* "anonymous" function pointers *)
| PTR LANGLE fp = fpointer RANGLE 
  { let (ret,params) = fp in String.concat "" [ret; "(*"; ")"; params] }

fpointer:
| ret = param LPAREN lst = option(paramlist) RPAREN 
  { (ret, tostring lst) }
(* Can this be factored out? I don't know what I'm doing. ~ Matt *)
| ret = param LPAREN lst = option(paramlist) RPAREN annot
  { (ret, tostring lst ) }


paramlist:
| lst = separated_list(COMMA, param)
  { String.concat "" ["("; String.concat "," lst; ")"] }


param:
| p = checkedptr name = option(ID) b = option(bounds) { let _ = b in String.concat " " [p; tostring name] } 
| p = insideptr { p }

(* This could use the `list` production, but that causes a reduce reduce 
 * error. However, I beleive there are only 4 valid type qualifiers
 * (see https://en.wikipedia.org/wiki/C_data_types#Type_qualifiers) 
 * plus `unsigned`, so this should cover every case *)
(* TODO currently unused *)
qualed_type:
| c1 = ID c2 = ID? c3 = ID? c4 = ID? c5 = ID?
  { String.concat " " (List.fold_right (fun x y -> match (x,y) with 
    | (None, b) -> b
    | (Some a, b) -> a :: b)
  [Some c1; c2; c3; c4; c5] []) }

| c = checkedptr { c }

insideptr:
| c = ANY s = insideptr { String.concat "" [c; s]}
(* This is not properly capturing whitespace: it assumes there's a space between tokens, but that's not necessarily so. Need to fix lexer.  *)
| c = ID s = insideptr { let t = if is_tyvar c then "void" else c in String.concat " " [t; s] }
| c = ANY annot { c }
| c = ID annot { let t = if is_tyvar c then "void" else c in t }
| c = ANY { c }
| c = ID { let t = if is_tyvar c then "void" else c in t }

id_or_pid:
| c = ID { c }
| c = PID { c }
