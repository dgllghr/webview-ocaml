type t

type error = int

module Handle : sig
  type t

  val set_fullscreen: t -> bool -> unit

  val eval: t -> string -> (unit, error) result


  val terminate: t -> unit
end

type handler = Handle.t -> string -> unit

val create: ?resizable:bool -> ?debug:bool -> ?handler:handler -> string ->
  string -> int -> int -> t

val run_blocking: t -> (unit, error) result
