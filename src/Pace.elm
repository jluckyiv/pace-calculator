module Pace exposing
    ( Pace, SecondsPerMeter
    , secondsPerMeter, inSecondsPerMeter, minutesPerKilometer, inMinutesPerKilometer
    , secondsPerFoot, inSecondsPerFoot, minutesPerMile, inMinutesPerMile
    , distanceAndTime, parse, speed, timeAndDistance
    )

{-| A `Pace` value represents a speed in minutes per kilometer, minutes per hour etc.
It is stored as a number of seconds per meter.

Note that since `SecondsPerMeter` is defined as `Rate Seconds Meters` (unit time
per length), you can construct a `Pace` value using `Quantity.per`:

    pace =
        duration |> Quantity.per length

You can also do rate-related calculations with `Pace` values to compute
`Length` or `Duration`:

    length =
        pace |> Quantity.for duration

    alsoLength =
        duration |> Quantity.at pace

    duration =
        length |> Quantity.at_ pace

@docs Pace, SecondsPerMeter


## Metric

@docs secondsPerMeter, inSecondsPerMeter, minutesPerKilometer, inMinutesPerKilometer


## Imperial

@docs secondsPerFoot, inSecondsPerFoot, minutesPerMile, inMinutesPerMile

-}

import Duration exposing (Duration, Seconds)
import Length exposing (Length, Meters)
import Pace.DistanceParser as DistanceParser
import Pace.TimeParser as TimeParser
import Parser exposing ((|.), (|=), Parser)
import Quantity exposing (Quantity(..), Rate)
import Speed exposing (Speed)



-- CONSTANTS
-- Metric


meter : Float
meter =
    1.0


kilometer : Float
kilometer =
    1000 * meter



-- Imperial


inch : Float
inch =
    0.0254 * meter


foot : Float
foot =
    12 * inch


mile : Float
mile =
    5280 * foot



-- Time


second : Float
second =
    1.0


minute : Float
minute =
    60 * second


{-| -}
type alias SecondsPerMeter =
    Rate Seconds Meters


{-| -}
type alias Pace =
    Quantity Float SecondsPerMeter


{-| Construct a pace from a speed
-}
speed : Speed -> Pace
speed speed_ =
    speed_
        |> Speed.inMetersPerSecond
        |> (/) 1
        |> secondsPerMeter


{-| Construct a pace from a number of seconds per meter.
-}
secondsPerMeter : Float -> Pace
secondsPerMeter numSecondsPerMeter =
    Quantity numSecondsPerMeter


{-| Convert a pace to a number of seconds per meter.
-}
inSecondsPerMeter : Pace -> Float
inSecondsPerMeter (Quantity numSecondsPerMeter) =
    numSecondsPerMeter


{-| Construct a pace from a number of seconds per foot.
-}
secondsPerFoot : Float -> Pace
secondsPerFoot numSecondsPerFoot =
    secondsPerMeter (numSecondsPerFoot / foot)


{-| Convert a pace to a number of seconds per foot.
-}
inSecondsPerFoot : Pace -> Float
inSecondsPerFoot pace =
    inSecondsPerMeter pace * foot


{-| Construct a pace from a number of minutes per kilometer.
-}
minutesPerKilometer : Float -> Pace
minutesPerKilometer numMinutesPerKilometer =
    secondsPerMeter (numMinutesPerKilometer * minute / kilometer)


{-| Convert a pace to a number of minutes per kilometer.
-}
inMinutesPerKilometer : Pace -> Float
inMinutesPerKilometer pace =
    (kilometer / minute) * inSecondsPerMeter pace


{-| Construct a pace from a number of minutes per mile.
-}
minutesPerMile : Float -> Pace
minutesPerMile numMinutesPerMile =
    secondsPerMeter (numMinutesPerMile * minute / mile)


{-| Convert a speed to a number of minutes per mile.
-}
inMinutesPerMile : Pace -> Float
inMinutesPerMile pace =
    (mile / minute) * inSecondsPerMeter pace


timeAndDistance : Duration -> Length -> Pace
timeAndDistance duration length =
    secondsPerMeter (Duration.inSeconds duration / Length.inMeters length)


distanceAndTime : Length -> Duration -> Pace
distanceAndTime length duration =
    timeAndDistance duration length



-- JACK


parse : String -> Result (List Parser.DeadEnd) Pace
parse input =
    Parser.run parser input


parser : Parser Pace
parser =
    Parser.oneOf
        [ Parser.succeed distanceAndTime
            |= DistanceParser.parser
            |. Parser.spaces
            |. Parser.symbol "@"
            |. Parser.spaces
            |= TimeParser.parser
        ]
