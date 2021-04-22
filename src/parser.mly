
%token PTR
%token BOUNDS
%token ITYPE
%token <string> ANY
%token <string> ID
%token EOF
%token LANGLE
%token RANGLE
%token LPAREN
%token RPAREN
%token FORANY
%token COLON
%token CHECKED
%token DYNCHECK

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
| ID m = main { m }
| ANY m = main { m }
| EOF { [] }

annot:
/* add INCLUDE here; remove _checked, drop stdchecked.h (and note it in lexer) */
| CHECKED { ($startpos.pos_cnum, $endpos.pos_cnum, "") }
| DYNCHECK { ($startpos.pos_cnum, $endpos.pos_cnum, "assert") (* idea: replace with a macro with will neuter the check; pick something other than assert *) }
| FORANY LPAREN ID RPAREN { ($startpos.pos_cnum, $endpos.pos_cnum, "") }
| COLON bounds
    { ($startpos.pos_cnum, $endpos.pos_cnum, "") }
| COLON itype bounds*
    { ($startpos.pos_cnum, $endpos.pos_cnum, "") }

bounds:
| BOUNDS LPAREN insidebounds* RPAREN { None }

insidebounds:
| LPAREN insidebounds* RPAREN { None }
| pointer { None }
| LANGLE { None }
| RANGLE { None }
| COLON { None }
| ID { None }
| ANY { None }

itype:
| ITYPE LPAREN insideitype* RPAREN { None }

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
| lst = separated_list(ANY, param)
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

