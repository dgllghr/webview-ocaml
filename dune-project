(lang dune 2.4)
(name webview-ocaml)
(implicit_transitive_deps false)

(generate_opam_files true)
(maintainers "Dan Gallagher <dgllghr@fastmail.com>")
(authors "Dan Gallagher <dgllghr@fastmail.com>")

(package
 (name webview-ocaml)
 (synopsis "Webview (https://github.com/zserge/webview) bindings for OCaml")
 (description "\
Webview (https://github.com/zserge/webview) bindings for OCaml
")
 (depends alcotest fmt logs ctypes dune-configurator))
