module Wvs = Webview_sys

type t = ((Wvs.webview, [ `Struct ]) Ctypes_static.structured) Ctypes.ptr

type error = int

let ( >>= ) o f = Result.bind o f

let res_of_code success = function
  | 0 -> Ok success
  | code -> Error code

module Handle = struct
  type t = ((Wvs.webview, [ `Struct ]) Ctypes_static.structured) Ctypes.ptr

  let set_fullscreen h fullscreen =
    let fullscreen = if fullscreen then 1 else 0 in
    Wvs.set_fullscreen h fullscreen

  let eval h script =
    Wvs.eval h script |> res_of_code ()

  let exit = Wvs.exit

  let terminate = Wvs.terminate
end

type handler = Handle.t -> string -> unit

let default_cb (_: Handle.t) (_: string) = ()

let create ?(resizable = true) ?(debug = false) ?(handler = default_cb)
          title url width height =
  Ctypes.(
    let wv = make
      ~finalise:(fun wv -> Wvs.deregister_handler (addr wv |> to_voidp))
      Wvs.webview
    in
    let wvp = addr wv in
    setf wv Wvs.title title;
    setf wv Wvs.url url;
    setf wv Wvs.width width;
    setf wv Wvs.height height;
    Wvs.register_handler (to_voidp wvp) (handler wvp);
    setf wv Wvs.external_invoke_cb Wvs.handler_cb;
    let resizable = if resizable then 1 else 0 in 
    setf wv Wvs.resizable resizable;
    let debug = if debug then 1 else 0 in
    setf wv Wvs.debug debug;
    wvp
  )

let run_blocking webview =
  Wvs.init webview |> res_of_code () >>= fun () ->
  Wvs.run ~webview:webview |> res_of_code ()

