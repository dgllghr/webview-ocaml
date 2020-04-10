module C = Configurator.V1

let base_flags = ["-DWEBVIEW_IMPLEMENTATION"; "-DWEBVIEW_STATIC"; "-Wno-return-type"]

let sysname =
  let uname = ExtUnixAll.uname () in
  uname.sysname

let platform_flags =
  match sysname with
  | "Darwin" -> ["-DWEBVIEW_COCOA"; "-x objective-c"]
  | _ -> ["-DWEBVIEW_GTK"]

let platform_linker_flags =
  match sysname with
  | "Darwin" -> ["-framework Cocoa"; "-framework WebKit"]
  | _ -> []

let platform_packages =
  match sysname with
  | "Darwin" -> ""
  | _ -> "gtk+-3.0 webkit2gtk-4.0"

let () =
  C.main ~name:"webview-ocaml" (fun c ->
    let default: C.Pkg_config.package_conf =
      {
        libs = [];
        cflags = [];
      }
    in
    let conf =
      if platform_packages != "" then
	      (match C.Pkg_config.get c with
	      | None -> default
	      | Some pkg_config ->
	        Option.value (C.Pkg_config.query pkg_config ~package:platform_packages)
	        	~default)
	     else default
    in
    let cflags = List.append conf.cflags base_flags
      |> List.append platform_flags
    in
    let libs = List.append conf.libs platform_linker_flags in
    C.Flags.write_sexp "c_flags.sexp" cflags;
    C.Flags.write_sexp "c_library_flags.sexp" libs;
    C.Flags.write_lines "c_flags.lines" cflags;
    ()
  )