module Pace.DistanceParser exposing (parse, parser)

import Length exposing (Length)
import Parser exposing (..)


parse : String -> Result (List DeadEnd) Length
parse input =
    run parser input


parser : Parser Length
parser =
    succeed toLength
        |= float
        |. spaces
        |= oneOf
            [ map (\_ -> Length.kilometers) (token "km")
            , map (\_ -> Length.miles) (token "mi")
            , map (\_ -> Length.meters) (token "m")
            ]


toLength num fun =
    fun num
