module Pace.TimeParser exposing (parse, parser)

import Duration exposing (Duration)
import Parser exposing (..)


parse : String -> Result (List DeadEnd) Duration
parse input =
    run parser input


parser : Parser Duration
parser =
    succeed toDuration
        |= float
        |. symbol ":"
        |= digitsParser


toDuration : Float -> Float -> Duration.Duration
toDuration minutes seconds =
    Duration.seconds <| minutes * 60.0 + seconds


digitsParser : Parser Float
digitsParser =
    Parser.oneOf
        [ leadingZeroParser
        , Parser.float
        ]


leadingZeroParser : Parser Float
leadingZeroParser =
    Parser.succeed identity
        |. Parser.symbol "0"
        |= Parser.float
