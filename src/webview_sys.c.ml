let%c () = header "#include \"./webview.h\""

module ExternalCb = [%cb ptr void @-> string @-> returning void]

type%c webview = {
  url: string;
  title: string;
  width: int;
  height: int;
  resizable: int;
  debug: int;
  external_invoke_cb: ExternalCb.t;
  userdata: void ptr;
}

external run: string -> string -> int -> int -> bool -> int = "webview"

external init: webview ptr -> int = "webview_init"

external loop: webview ptr -> int -> int = "webview_loop"

external eval: webview ptr -> string -> int = "webview_eval"

external inject_css: webview ptr -> string -> int = "webview_inject_css"

external set_title: webview ptr -> string -> void = "webview_set_title"