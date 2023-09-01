let rec reader cur_string =
  let cur_char = input_char stdin in
  if cur_char == ';' then cur_string
  else reader (cur_string ^ String.make 1 cur_char)

let rec mainloop () =
  let str = reader "" in
  print_endline ("you wrote: " ^ str) ;
  mainloop ()

let _ = mainloop ()
