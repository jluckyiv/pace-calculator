module Tests exposing (..)

import Test exposing (..)
import Pace
import Expect


suite : Test
suite =
    describe "Parser"
        [ test "should parse seconds" <|
            \_ ->
                Pace.parseTime "0:1"
                    |> Expect.equal (Ok 1.0)
        ]
