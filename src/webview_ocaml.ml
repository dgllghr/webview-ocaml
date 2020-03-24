open Ctypes
open Foreign

let webview = foreign "webview" (string @-> string @-> int @-> int @-> bool @-> returning int)

let main () =
  let () = Logs.debug (fun m -> m "Program has started") in
  let _ = webview "Test" "https://www.datasembly.com" 800 600 true in
  ()
