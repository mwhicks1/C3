
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
| p = pointer m = main { ($startpos.pos_cnum , $endpos(p).pos_cnum, p)::m }
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
| LPAREN e = expr RPAREN { "(" ^ e ^ ")" }
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
    
instvar:
| LANGLE insideitype RANGLE  { ($startpos.pos_cnum, $endpos.pos_cnum, "") }
                        
annot:
/* add INCLUDE here; remove _checked, drop stdchecked.h (and note it in lexer) */
| CHECKED { ($startpos.pos_cnum, $endpos.pos_cnum, "") }
| p = PRAGMA { let (s,e) = p in (s, e, "") }
| DYNCHECK LPAREN insidebounds* RPAREN { ($startpos.pos_cnum, $endpos.pos_cnum, "") }
| FORANY LPAREN ID RPAREN { ($startpos.pos_cnum, $endpos.pos_cnum, "") }
| p = bounds { let (s,_) = p in (s, $endpos.pos_cnum, "") }
| p = itype fakebounds* { let (s,_) = p in (s, $endpos.pos_cnum, "") }

bounds:
| p = COLONBOUNDS LPAREN insidebounds* RPAREN { p }

fakebounds: /* I am assuming ID will be count, bounds, or byte_count */
| ID LPAREN insidebounds+ RPAREN { None }

insidebounds:
| LPAREN insidebounds+ RPAREN { None }
| pointer { None }
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
| c = pointer { c }
| c = ID { c }
| c = ANY { c }

pointer:
| PTR LANGLE p = pointer RANGLE { String.concat "" [p; " *"] }
| PTR LANGLE s = insideptr RANGLE { String.concat "" [s; " *"]}
(* TODO: correct replacement *)
| PTR LANGLE fp = fpointer RANGLE name = ID 
  { let (ret,params) = fp in String.concat "" [ret; "(*"; name; ")"; params] }

fpointer:
| ret = rettype LPAREN lst = option(paramlist) RPAREN 
  { (ret, match lst with | None -> "" | Some s -> s ) }

rettype: 
| c = ID { c } 
| c = pointer { c }

paramlist:
| lst = separated_list(COMMA, param)
  { String.concat "" ["("; String.concat "," lst; ")"] }

(* This could use the `list` production, but that causes a reduce reduce 
 * error. However, I beleive there are only 4 valid type qualifiers
 * (see https://en.wikipedia.org/wiki/C_data_types#Type_qualifiers) 
 * plus `unsigned`, so this should cover every case *)
param:
| c1 = ID c2 = ID? c3 = ID? c4 = ID? c5 = ID?
  { String.concat " " (List.fold_right (fun x y -> match (x,y) with 
    | (None, b) -> b
    | (Some a, b) -> a :: b)
  [Some c1; c2; c3; c4; c5] []) }

| c = pointer { c }

insideptr:
| c = ANY s = insideptr { String.concat "" [c; s]}
/* This is not properly capturing whitespace: it assumes there's a space between tokens, but that's not necessarily so. Need to fix lexer.  */
| c = ID s = insideptr { String.concat " " [c; s]}
| c = ANY { c }
| c = ID { c }

