{

  open Parser

  exception Error of string

(* NOTE: More keywords here https://github.com/correctcomputation/checkedc/blob/master/include/stdchecked.h *)

                   (* :count as a token
itype(.* ) as a token
itype(.* ) bounds( * ) as a token
                    *)
                   
(* NOTE: Parser should look for a #include of stdchecked.h, enabling a few more keywords below *)
}

let id = ['a'-'z' 'A'-'Z' '_'] ['a'-'z' 'A'-'Z' '0'-'9' '_']*
let bounds = "bounds" | "count" | "byte_count"
let pid = "malloc" | "calloc" | "free" | "realloc"                                    

rule keyword = parse
| ['/']['*']  { let b = Buffer.create 17 in Buffer.add_string b "/*"; comment b lexbuf }
| [' ' '\t']     { keyword lexbuf }
| ['#']"pragma" { let start_p = Lexing.lexeme_start lexbuf in
                        let _ = pragma lexbuf in
                        let end_p = Lexing.lexeme_end lexbuf in
                        Lexing.new_line lexbuf;
                        PRAGMA(start_p,end_p)  }
| "_Itype_for_any" | "_For_any" { FORANY }
| "_Ptr" | "_Array_ptr" | "_Nt_array_ptr" { PTR } 
| "_Checked" | "_Unchecked" | "_Nt_checked" { CHECKED }
| "_Dynamic_check" { DYNCHECK }
| "_Assume_bounds_cast" { ASSUME_CAST }
| "ptr" | "array_ptr" | "nt_array_ptr" { PTR (* enable this and those next if stdchecked.h included *) }
| "checked" | "unchecked" { CHECKED }
| "dynamic_check" { DYNCHECK }
| pid { PID(Lexing.lexeme lexbuf) }
| id { ID(Lexing.lexeme lexbuf) }
| "," { COMMA }
| "<" { LANGLE }
| ">" { RANGLE }
| "(" { LPAREN }
| ")" { RPAREN }
| ":" { let start_p = Lexing.lexeme_start lexbuf in
        let c = colon lexbuf in
        let end_p = Lexing.lexeme_end lexbuf in
        if c = 1 then COLONITYPE(start_p,end_p)
        else if c = 2 then COLONBOUNDS(start_p,end_p)
        else COLON }
| "\n" { Lexing.new_line lexbuf; keyword lexbuf; }
| eof { EOF }
| _ as c { ANY(String.make 1 c) }

and colon =
  parse
  | "itype" {1 } 
  | bounds { 2 }
  | "\n" { Lexing.new_line lexbuf; colon lexbuf; }
  | [' ' '\t'] { colon lexbuf }
  | _ { 3 } (* FIX: eats up a character *)

and pragma =
  parse
 | "\n" { COLON }
 | _ { pragma lexbuf }
  
and comment buf =
  parse
| ['*']['/']       { Buffer.add_string buf "*/"; ANY (Buffer.contents buf) }
 | "\n" { Lexing.new_line lexbuf; Buffer.add_char buf '\n'; comment buf lexbuf; }
  | _ as c { Buffer.add_char buf c; comment buf lexbuf }
