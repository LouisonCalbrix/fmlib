(** Character Parser: An indentation sensitive parser which parses streams of
    characters i.e. the token type is [char].
*)

open Fmlib_std.Interfaces

module Make (State: ANY) (Final: ANY) (Semantic: ANY):
sig

    (**
    - [State]: User state.
    - [Final]: Final result type of the parser.
    - [Semantic]: Semantic error message (triggered by [fail error])
    *)

    (** {1 Final Parser} *)

    module Parser:
    sig
        include Interfaces.PARSER
        type t
        val needs_more: t -> bool
        val has_ended:  t -> bool

        val has_succeeded:       t -> bool
        val has_failed_syntax:   t -> bool
        val has_failed_semantic: t -> bool

        val position: t -> Position.t
        val line:   t -> int
        val column: t -> int

        val state:      t -> State.t
        val lookaheads: t -> char array * bool

        val final: t -> Final.t
        val failed_expectations: t -> (string * Indent.violation option) list
        val failed_semantic:     t -> Semantic.t

        val put: char -> t -> t
        val put_end: t -> t

        val run_on_string: string -> t -> t
    end



    (** {1 Generic Combinators} *)

    include Interfaces.COMBINATOR
        with
            type state = State.t
            and type expect = string
            and type semantic = Semantic.t



    (** {1 Location Combinator} *)

    val located: 'a t -> 'a Located.t t
    (** [located p] Parse [p] and return its result with its start and end
        position.

        Note: If [p] parses strips whitespace at the end, the returned end
        position is at the end of the whitespace. This is not what you usually
        want. Therefore first parse the essential part located and then strip
        the whitespace.
    *)



    (** {1 Indentation Combinators} *)


    val indent: int -> 'a t -> 'a t
    (** [indent i p] Indent [p] by [i] columns relative to its parent.

        Precondition: [0 <= i]
    *)


    val align: 'a t -> 'a t
    (** [align p]

        Set the indentation set of [p] to [{col}] where [col] is the column
        position of its first character. Fail, if [col] is not in the
        indentation set.
    *)


    val left_align: 'a t -> 'a t
    (** [left_align p]

        Set the indentation set of [p] to [{col}] where [col] is the column
        position of its first character. Fail, if [col] is not the lower bound
        of the indentation set. I.e. [p] is left aligned in its indentation set.
    *)


    val detach: 'a t -> 'a t
    (** [detach p] Parse [p] without any indentation and alignment restrictions.
    *)


    val zero_or_more_aligned: 'r -> ('a -> 'r -> 'r) -> 'a t -> 'r t
    (** [zero_or_more_aligned start next p]

        Parse an indented block of zero or more aligned constructs [p].

        Equivalent to
        {[
            zero_or_more start next (align p) |> align |> indent 1
        ]}
    *)



    val one_or_more_aligned: ('a -> 'r) -> ('a -> 'r -> 'r) -> 'a t -> 'r t
    (** [zero_or_more_aligned first next p]

        Parse an indented block of one or more aligned constructs [p].

        Equivalent to
        {[
            one_or_more first next (align p) |> align |> indent 1
        ]}
    *)



    (** {1 Make the Final Parser} *)

    val make: State.t -> Final.t t -> Parser.t

    val make_parser: Position.t -> State.t -> Final.t t -> Parser.t





    (** {1 Character Combinators} *)


    val charp: (char -> bool) -> string -> char t

    val char: char -> char t

    val one_of_chars: string -> expect -> char t

    val string: string -> string t

    val uppercase_letter: char t
    val lowercase_letter: char t
    val letter: char t

    val digit: int t
end
