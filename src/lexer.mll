{

  open Parser
  open Hack
     
  exception Error of string

(* NOTE: More keywords here https://github.com/correctcomputation/checkedc/blob/master/include/stdchecked.h *)

  let stdchecked = ref false;;
(*
#define ptr _Ptr
#define array_ptr _Array_ptr
#define nt_array_ptr _Nt_array_ptr
#define checked _Checked
#define nt_checked _Nt_checked
#define unchecked _Unchecked
#define bounds_only _Bounds_only
#define where _Where
#define dynamic_check _Dynamic_check
#define dynamic_bounds_cast _Dynamic_bounds_cast
#define assume_bounds_cast _Assume_bounds_cast
#define return_value _Return_value
 *)

  let brace_depth = ref None
}

let id = ['a'-'z' 'A'-'Z' '_'] ['a'-'z' 'A'-'Z' '0'-'9' '_']*
let bounds = "bounds" | "count" | "byte_count"
let pid = "malloc" | "calloc" | "free" | "realloc" | "memcpy"

rule keyword = parse
| ['/']['*']  { let b = Buffer.create 17 in Buffer.add_string b "/*"; comment b lexbuf }
| ['/']['/']   { let b = Buffer.create 17 in Buffer.add_string b "//"; line_comment b lexbuf }
| [' ' '\t']     { keyword lexbuf }
| ['#']"pragma" { let start_p = Lexing.lexeme_start lexbuf in
                        let _ = pragma lexbuf in
                        let end_p = Lexing.lexeme_end lexbuf in
                        Lexing.new_line lexbuf;
                        PRAGMA(start_p,end_p)  }
| ['#']"include"[' ' '\t']*"<stdchecked.h>" { stdchecked := true; CHECKED }
| '"' { let b = Buffer.create 17 in Buffer.add_char b '"'; read_string b lexbuf }
| '\'' { let b = Buffer.create 17 in Buffer.add_char b '\''; read_char b lexbuf }
| "_Itype_for_any" | "_For_any" { brace_depth := Some(0); FORANY }
| "_Ptr" | "_Array_ptr" | "_Nt_array_ptr" { PTR } 
| "_Checked" | "_Unchecked" | "_Nt_checked" { CHECKED }
| "_Dynamic_check" { DYNCHECK }
| "_Assume_bounds_cast" | "_Dynamic_bounds_cast" { ASSUME_CAST }
(* Shorthands -- could limit only if !stdchecked, but won't work if not directly included *)
| "ptr" | "array_ptr" | "nt_array_ptr" { if !stdchecked then PTR else ID(Lexing.lexeme lexbuf) }
| "checked" | "unchecked" | "nt_checked" {if !stdchecked then CHECKED else ID(Lexing.lexeme lexbuf) }
| "dynamic_check" { if !stdchecked then DYNCHECK else ID(Lexing.lexeme lexbuf) }
| "assume_bounds_cast" | "dynamic_bounds_cast" { if !stdchecked then ASSUME_CAST else ID(Lexing.lexeme lexbuf) }
| pid { PID(Lexing.lexeme lexbuf) }
| id { ID(Lexing.lexeme lexbuf) }
| "," { COMMA }
| ";" { (match !brace_depth with
          Some 0 -> brace_depth := None; clear_tyvars() (* forall applied to a prototype; stop looking *)
        | _ -> ()); ANY(Lexing.lexeme lexbuf) }
| "<" { LANGLE }
| ">" { RANGLE }
| "(" { LPAREN }
| ")" { RPAREN }
| "{" { (match !brace_depth with
          Some n -> brace_depth := Some(n+1)
        | None -> ()); ANY(Lexing.lexeme lexbuf) }
| "}" { (match !brace_depth with
          Some n -> if n = 1 then (brace_depth := None; clear_tyvars()) else brace_depth := Some(n-1)
        | None -> ()); ANY(Lexing.lexeme lexbuf) }
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

and line_comment buf =
  parse
 | [^ '\n'] as c { Buffer.add_char buf c; line_comment buf lexbuf }
 | "\n" { Lexing.new_line lexbuf; Buffer.add_char buf '\n';  ANY (Buffer.contents buf) }

and read_string buf =
  parse
  | '"'       { Buffer.add_char buf '"'; ANY (Buffer.contents buf) }
  | '\\' '\n' { Lexing.new_line lexbuf;  Buffer.add_char buf '\\'; Buffer.add_char buf '\n'; read_string buf lexbuf; }
  | '\\' '\\'  { Buffer.add_char buf '\\'; Buffer.add_char buf '\\'; read_string buf lexbuf }
  | '\\' '"'  { Buffer.add_char buf '\\'; Buffer.add_char buf '"'; read_string buf lexbuf }
  | _ as c { Buffer.add_char buf c; read_string buf lexbuf }

and read_char buf =
  parse
  | '\''       { Buffer.add_char buf '\''; ANY (Buffer.contents buf) }
  | '\\' '\''  { Buffer.add_char buf '\\'; Buffer.add_char buf '\''; read_char buf lexbuf }
  | '\\' '\\'  { Buffer.add_char buf '\\'; Buffer.add_char buf '\\'; read_char buf lexbuf }
  | _ as c { Buffer.add_char buf c; read_char buf lexbuf }
