type ('a,'e) t = ('a,'e) result


let return (a: 'a): ('a,'e) t =
    Ok a


let (>>=) (m: ('a,'e) t) (f: 'a -> ('b,'e) t): ('b,'e) t =
    match m with
    | Ok a ->
        f a
    | Error e ->
        Error e

let ( let* ) = (>>=)



module Monad (E: Interfaces.ANY) =
struct
    type 'a t = ('a, E.t) result

    let return = return

    let (>>=)  = (>>=)

    let ( let* ) = (>>=)
end



(* Unit tests *)
(*****************************************)

type 'a r = ('a, string) result

let add (a: int r) (b: int r): int r =
    let* x = a in
    let* y = b in
    Ok (x + y)

let divide (a: int r) (b: int r): int r =
    let* x = a in
    let* y = b in
    if y = 0 then
        Error "Division by Zero"
    else
        Ok (x / y)

let%test _ =
    add (Ok 1) (divide (Ok 2) (Ok 0))
    =
    Error "Division by Zero"

let%test _ =
    add (Ok 1) (divide (Ok 10) (Ok 2))
    =
    Ok 6
