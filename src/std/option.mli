(** Optional elements of a certain type.

*)



type 'a t = 'a option
(** ['a t] Type of an optional object of type ['a] *)


val return: 'a -> 'a t
(** [return a] Equivalent to [Some a]. *)

val fail: 'a t
(** Equivalent to [None]. *)


val (let* ): 'a t -> ('a -> 'b t) -> 'b t
(** Chaining of operations which return optional elements.

    Example:
    {[
        let* a = op1 ... in (* 'op1 ... ' returns an optional element *)
        let* b = op2 ... in
        let* c = op3 ... in
        ...
        return (f a b c ...)
    ]}
*)


val (>>=)  : 'a t -> ('a -> 'b t) -> 'b t
(** [opt >>= f] Equivalent to [let* v = opt in f v]. *)


val map: ('a -> 'b) -> 'a t -> 'b t
(** [map f m] Map the element of [m] by [f], if exists. *)



val to_list: 'a t -> 'a list
(** [to_list a] Returns a one element list or an empty list. *)
