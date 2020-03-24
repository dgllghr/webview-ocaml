let () =
  Logs.set_level (Some Logs.Debug);
  Logs.set_reporter (Logs_fmt.reporter ());
  let _ = Webview_ocaml.main () in
  ()
