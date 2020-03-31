(lang dune 2.4)
(name webview)
(implicit_transitive_deps false)

(generate_opam_files true)
(maintainers "Dan Gallagher <dgllghr@fastmail.com>")
(authors "Dan Gallagher <dgllghr@fastmail.com>")
(source (github dgllghr/webview-ocaml))

(package
 (name webview)
 (synopsis "webview (https://github.com/zserge/webview) bindings for OCaml")
 (description "webview (https://github.com/zserge/webview) bindings for OCaml")
 (depends
    (fmt (>= 0.8))
    (logs (>= 0.7))
    (ppx_cstubs (>= 0.3))
    (ctypes (>= 0.17))
    (ctypes-foreign (>= 0.4))
    (dune-configurator (>= 2.4))))
