module Tests exposing (..)

import Duration
import Expect exposing (FloatingPointTolerance(..))
import Length
import Pace exposing (..)
import Pace.DistanceParser as DistanceParser
import Pace.TimeParser as TimeParser
import Speed
import Test exposing (..)


suite : Test
suite =
    describe "Pace"
        [ describe "Converter"
            [ describe "Output"
                [ test "should accurately output seconds per meter" <|
                    \_ ->
                        Pace.secondsPerMeter 1
                            |> Pace.inSecondsPerMeter
                            |> Expect.within (Absolute 0.00001) 1.0
                , test "should accurately output seconds per foot" <|
                    \_ ->
                        Pace.secondsPerMeter 1
                            |> Pace.inSecondsPerFoot
                            |> Expect.within (Absolute 0.0001) 0.3048
                , test "should accurately output minutes per kilometer" <|
                    \_ ->
                        Pace.secondsPerMeter 1
                            |> Pace.inMinutesPerKilometer
                            |> Expect.within (Absolute 0.0001) 16.6667
                , test "should accurately output minutes per mile" <|
                    \_ ->
                        Pace.secondsPerMeter 1
                            |> Pace.inMinutesPerMile
                            |> Expect.within (Absolute 0.0001) 26.8224
                ]
            , describe "Input"
                [ test "should accurately take minutes per kilometer" <|
                    \_ ->
                        Pace.minutesPerKilometer 1
                            |> Pace.inSecondsPerMeter
                            |> Expect.within (Absolute 0.0001) 0.06
                , test "should accurately take secondsPerFoot input" <|
                    \_ ->
                        Pace.secondsPerFoot 1
                            |> Pace.inSecondsPerMeter
                            |> Expect.within (Absolute 0.0001) 3.2808
                , test "should convert 6 MPH to 10 minutes per mile" <|
                    \_ ->
                        Speed.milesPerHour 6.0
                            |> Pace.speed
                            |> Pace.inMinutesPerMile
                            |> Expect.within (Absolute 0.1) 10.0
                , test "should convert Speed to Pace" <|
                    \_ ->
                        Speed.milesPerHour 7.0
                            |> Pace.speed
                            |> Pace.inMinutesPerMile
                            |> Expect.within (Absolute 0.1) 8.57
                , test "should convert arbitrary time and distance to Pace" <|
                    \_ ->
                        Length.meters 5000.0
                            |> Pace.timeAndDistance (Duration.minutes 19.0)
                            |> Pace.inMinutesPerMile
                            |> Expect.within (Absolute 0.1) 6.1
                ]
            , describe "TimeParser"
                [ test "should parse single-digit integer" <|
                    \_ ->
                        TimeParser.parse "0:1"
                            |> Expect.equal (Ok <| Duration.seconds 1.0)
                , test "should parse leading-zero integer" <|
                    \_ ->
                        TimeParser.parse "0:01"
                            |> Expect.equal (Ok <| Duration.seconds 1.0)
                , test "should parse double-digit integer" <|
                    \_ ->
                        TimeParser.parse "0:10"
                            |> Expect.equal (Ok <| Duration.seconds 10.0)
                , test "should parse minutes and seconds" <|
                    \_ ->
                        TimeParser.parse "1:01"
                            |> Expect.equal (Ok <| Duration.seconds 61.0)
                ]
            , describe "DistanceParser"
                [ test "should parse meters" <|
                    \_ ->
                        DistanceParser.parse "100m"
                            |> Expect.equal (Ok <| Length.meters 100)
                , test "should parse meters with a space" <|
                    \_ ->
                        DistanceParser.parse "100 m"
                            |> Expect.equal (Ok <| Length.meters 100)
                , test "should parse kilometers" <|
                    \_ ->
                        DistanceParser.parse "1km"
                            |> Expect.equal (Ok <| Length.meters 1000)
                , test "should parse kilometers with a space" <|
                    \_ ->
                        DistanceParser.parse "1 km"
                            |> Expect.equal (Ok <| Length.meters 1000)
                , test "should parse miles" <|
                    \_ ->
                        DistanceParser.parse "1mi"
                            |> Expect.equal (Ok <| Length.miles 1)
                , test "should parse miles with a space" <|
                    \_ ->
                        DistanceParser.parse "1 mi"
                            |> Expect.equal (Ok <| Length.miles 1)
                ]
            , describe "Pace parser"
                [ test "should parse distance and time with spaces (metric)" <|
                    \_ ->
                        Pace.parse "5000m @ 25:00"
                            |> Expect.equal (Ok <| Pace.minutesPerKilometer 5)
                , test "should parse distance and time without spaces (metric)" <|
                    \_ ->
                        Pace.parse "5000m@25:00"
                            |> Expect.equal (Ok <| Pace.minutesPerKilometer 5)
                , test "should parse distance and time (imperial)" <|
                    \_ ->
                        Pace.parse "5mi@25:00"
                            |> Expect.equal (Ok <| Pace.minutesPerMile 5)
                ]
            ]
        ]
