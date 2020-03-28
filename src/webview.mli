type t

type error =
  | InitError

val make : string -> string -> int -> int -> bool -> (t, error) result

val main : unit -> unit
