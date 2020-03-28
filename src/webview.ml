module Wvs = Webview_sys

type t = (Wvs.webview, [ `Struct ]) Ctypes_static.structured

type error =
  | InitError

let make title url width height resizable =
  Ctypes.(
    let wv = make Wvs.webview in
    setf wv Wvs.title title;
    setf wv Wvs.url url;
    setf wv Wvs.width width;
    setf wv Wvs.height height;
    let resizable = if resizable then 1 else 0 in 
    setf wv Wvs.resizable resizable;
    match Wvs.init (addr wv) with
    | 0 -> Result.Ok wv
    | _ -> Result.Error InitError
  )

let main () =
  let () = Logs.debug (fun m -> m "Program has started") in
  let res = make "Test" "https://www.example.com" 800 600 false in
  Printf.printf "%B" (Result.is_ok res);
  ()
