let make_url n =
  String.concat "" [
    "data:text/html,";
    "%3Chtml%3E%0A%3Chead%3E%3C%2Fhead%3E%0A%3Cbody%3E%0A%20%20%3Cscript
    %3E%0A%20%20%20%20window.external.invoke(%22";
    string_of_int n;
    "%22)%3B%0A%20%20%3C%2Fscript%3E%0Arunning test%3C%2Fbody%3E%0A%3C%2Fhtml%3E"
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
  let url = make_url input in
  let wv = Webview.create
    ~handler:test_handler "webview-ocaml integration test" url 800 600
  in
  match Webview.run_blocking wv with
  | Ok () ->
    assert (Some input = !output);
    Logs.debug (fun f -> f "test passed")
  | Error _ -> failwith "error running webview"

