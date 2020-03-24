module C = Configurator.V1

let packages = "gtk+-3.0 webkit2gtk-4.0"

let () =
  C.main ~name:"webview-ocaml" (fun c ->
    let default: C.Pkg_config.package_conf =
      {
        libs = [];
        cflags = [];
      }
    in
    let conf =
      match C.Pkg_config.get c with
      | None -> default
      | Some pkg_config ->
        Option.value (C.Pkg_config.query pkg_config ~package:packages) ~default
    in
    C.Flags.write_sexp "c_flags.sexp" conf.cflags;
    C.Flags.write_sexp "c_library_flags.sexp" conf.libs;
    ()
  )