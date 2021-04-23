{

  open Parser

  exception Error of string

(* NOTE: More keywords here https://github.com/correctcomputation/checkedc/blob/master/include/stdchecked.h *)

(* NOTE: Parser should look for a #include of stdchecked.h, enabling a few more keywords below *)
}

let id = ['a'-'z' 'A'-'Z' '_'] ['a'-'z' 'A'-'Z' '0'-'9' '_']*


rule keyword = parse
| ['/']['*']  { let b = Buffer.create 17 in Buffer.add_string b "/*"; comment b lexbuf }
| [' ' '\t']     { keyword lexbuf }
| ['#']"pragma" { let start_p = Lexing.lexeme_start lexbuf in
                        let _ = pragma lexbuf in
                        let end_p = Lexing.lexeme_end lexbuf in
                        Lexing.new_line lexbuf;
                        (* Printf.printf "%d -- %d\n" start_p end_p; *)
                        PRAGMA(start_p,end_p)  }
| "bounds" | "count" | "byte_count" { BOUNDS }
| "itype" { ITYPE }
| "_Itype_for_any" | "_For_any" { FORANY }
| "_Ptr" | "_Array_ptr" | "_Nt_array_ptr" { PTR } 
| "_Checked" | "_Unchecked" | "_Nt_checked" { CHECKED }
| "_Dynamic_check" { DYNCHECK }
| "ptr" | "array_ptr" | "nt_array_ptr" { PTR (* enable this and those next if stdchecked.h included *) }
| "checked" | "unchecked" { CHECKED }
| "dynamic_check" { DYNCHECK }
| id { ID(Lexing.lexeme lexbuf) }
| "<" { LANGLE }
| ">" { RANGLE }
| "(" { LPAREN }
| ")" { RPAREN }
| ":" { COLON }
| "\n" { Lexing.new_line lexbuf; keyword lexbuf; }
| eof { EOF }
| _ as c { ANY(String.make 1 c) }

and pragma =
  parse
 | "\n" { COLON }
 | _ { pragma lexbuf }
  
and comment buf =
  parse
| ['*']['/']       { Buffer.add_string buf "*/"; ANY (Buffer.contents buf) }
 | "\n" { Lexing.new_line lexbuf; Buffer.add_char buf '\n'; comment buf lexbuf; }
  | _ as c { Buffer.add_char buf c; comment buf lexbuf }
