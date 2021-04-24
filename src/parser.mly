
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
| p = annot m = main { p::m }
| LPAREN m = main { m }
| RPAREN m = main { m }
| LANGLE m = main { m }
| RANGLE m = main { m }
| COLON m = main { m }
| PID popt = instvar? m = main { match popt with Some p -> p::m | None -> m }
| ID m = main { m }
| ps = cast m = main { ps @ m }
| COMMA m = main { m }
| ANY m = main { m }
| EOF { [] }

cast: (* Might want to change the insideitype* part into a normal C cast; not currently supported *)
  | ASSUME_CAST LANGLE insideitype* RANGLE LPAREN x = expr COMMA insidebounds* RPAREN { let (s,e) = x in ($startpos.pos_cnum, s, "")::(e, $endpos.pos_cnum, "")::[] }
  | ASSUME_CAST LANGLE insideitype* RANGLE LPAREN x = expr RPAREN { let (s,e) = x in ($startpos.pos_cnum, s, "")::(e, $endpos.pos_cnum, "")::[] }

expr: expr_comp+ { ($startpos.pos_cnum, $endpos.pos_cnum) }
                                              
expr_comp:
| LPAREN expr_comp* RPAREN { None }
| pointer { None }
| LANGLE { None }
| RANGLE { None }
| COLON { None }
| ID { None }
| ANY { None }
    
instvar:
| LANGLE insideitype* RANGLE  { ($startpos.pos_cnum, $endpos.pos_cnum, "") }
                        
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
| ID LPAREN insidebounds* RPAREN { None }

insidebounds:
| LPAREN insidebounds* RPAREN { None }
| pointer { None }
| LANGLE { None }
| RANGLE { None }
| COLON { None }
| COMMA { None }
| ID { None }
| ANY { None }

itype:
| p = COLONITYPE LPAREN insideitype* RPAREN { p }

insideitype:
| pointer { None }
| ID { None }
| ANY { None }

pointer:
| PTR LANGLE p = pointer RANGLE { String.concat "" [p; " *"] }
| PTR LANGLE s = insideptr RANGLE { String.concat "" [s; " *"]}
(* TODO: correct replacement *)
| PTR LANGLE fp = fpointer RANGLE name = ID 
  { let (ret,params) = fp in String.concat "" [ret; "(*"; name; ")"; params] }

fpointer:
| ret = rettype LPAREN lst = option(paramlist) RPAREN 
  { (ret, String.concat "" (Option.to_list lst)) }

rettype: 
| c = ID { c } 
| c = pointer { c }

paramlist:
| lst = separated_list(COMMA, param)
  { String.concat "" ["("; String.concat "," lst; ")"] }

param:
| c = ID { c }
| c = pointer { c }

insideptr:
| c = ANY s = insideptr { String.concat "" [c; s]}
/* This is not properly capturing whitespace: it assumes there's a space between tokens, but that's not necessarily so. Need to fix lexer.  */
| c = ID s = insideptr { String.concat " " [c; s]}
| c = ANY { c }
| c = ID { c }

