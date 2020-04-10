let page n = String.concat "" ["<html>
    <head>
    </head>
    <body>
      <script>window.external.invoke('";
      string_of_int n;
      "')</script>
    </body>
  </html>"
]

module WvHandle = Webview.Handle

let () =
  Logs.set_level (Some Logs.Debug);
  Logs.set_reporter (Logs_fmt.reporter ());

  let output: (int option) ref = ref None in
  let test_handler (h: WvHandle.t) msg =
    Logs.debug (fun f -> f "Received message from the browser: %s" msg);
    match WvHandle.eval h "1 + 1" with
    | Ok () ->
      Logs.debug (fun f -> f "Evaluated javascript");
      output := Some (int_of_string msg);
      WvHandle.terminate h;
    | Error _ -> Logs.err (fun f -> f "Error running javascript");
    ()
  in

  let input = 17 in
  let url = "data:text/html," ^ (Uri.pct_encode (page input)) in
  let wv = Webview.create ~handler:test_handler ~debug:true
    "webview-ocaml integration test" url 800 600
  in
  match Webview.run_blocking wv with
  | Ok () ->
    assert (Some input = !output);
    Logs.debug (fun f -> f "test passed")
  | Error _ -> failwith "error running webview"

