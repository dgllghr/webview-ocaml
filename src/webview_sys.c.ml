let%c () = header "#include \"./webview.h\""

module ExternalCb = [%cb ptr void @-> string @-> returning void]

module DispatchFn = [%cb ptr void @-> ptr void @-> returning void]

let handlers = Hashtbl.create 8

let register_handler (ptr: unit Ctypes.ptr) (handler: string -> unit) =
  let addr = Ctypes.raw_address_of_ptr ptr in
  Hashtbl.replace handlers addr handler

let deregister_handler (ptr: unit Ctypes.ptr) =
  let addr = Ctypes.raw_address_of_ptr ptr in
  Hashtbl.remove handlers addr

let%cb handler_cb (ptr: unit Ctypes.ptr) (msg: string) : ExternalCb.t =
  let handler = Ctypes.raw_address_of_ptr ptr |> Hashtbl.find handlers in
  handler msg [@@ acquire_runtime_lock] [@@ thread_registration]

let dispatch_fns = Hashtbl.create 8

let dispatch_fn_registered = Hashtbl.mem dispatch_fns

let register_dispatch_fn n f =
  Hashtbl.replace dispatch_fns n f;
  Nativeint.of_int n |> Ctypes.ptr_of_raw_address

let deregister_dispatch_fn = Hashtbl.remove dispatch_fns

let%cb dispatch_fn (_: unit Ctypes.ptr) (arg: unit Ctypes.ptr) : DispatchFn.t =
  let fn = Ctypes.raw_address_of_ptr arg
    |> Nativeint.to_int
    |> Hashtbl.find dispatch_fns
  in
  fn () [@@ acquire_runtime_lock] [@@ thread_registration]

let%c priv = opaque "struct webview_priv"

type%c webview = {
  url: string;
  title: string;
  width: int;
  height: int;
  resizable: int;
  debug: int;
  external_invoke_cb: ExternalCb.t;
  priv: priv;
  userdata: void ptr;
}

external%c run: webview:(webview ptr) -> void = {|
  while (webview_loop($webview, 1) == 0) {
  }
  return 0;
|} [@@ release_runtime_lock]

external init: webview ptr -> int =
  "webview_init" [@@ release_runtime_lock]

external eval: webview ptr -> string -> int =
  "webview_eval" [@@ release_runtime_lock]

external inject_css: webview ptr -> string -> int =
  "webview_inject_css" [@@ release_runtime_lock]

external set_title: webview ptr -> string -> void =
  "webview_set_title" [@@ release_runtime_lock]

external set_fullscreen: webview ptr -> int -> void =
  "webview_set_fullscreen" [@@ release_runtime_lock] [@@ noalloc]

external dispatch: webview ptr -> DispatchFn.t -> void ptr -> void =
  "webview_dispatch" [@@ release_runtime_lock]

external terminate: webview ptr -> void =
  "webview_terminate" [@@ release_runtime_lock] [@@ noalloc]