port module Main exposing (main)

import Json.Decode as Decode exposing (Decoder)
import Pace
import Parser
import Platform exposing (Program)
import Result exposing (andThen, map, mapError)


type alias InputType =
    String


inputDecoder : Decoder InputType
inputDecoder =
    Decode.string


type alias OutputType =
    String


port get : (Decode.Value -> msg) -> Sub msg


port put : OutputType -> Cmd msg


main : Program Flags Model Msg
main =
    Platform.worker
        { init = init
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    ()


type Msg
    = Input Decode.Value


type alias Flags =
    ()


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( (), Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input input ->
            ( model, put (transform input) )


subscriptions : Model -> Sub Msg
subscriptions _ =
    get Input



{- Below is the input-to-output transformation.
   It could be anything.  Here we have something
   simple for demonstration purposes.
-}


transform : Decode.Value -> OutputType
transform input =
    case decodeAndParse input of
        Ok value ->
            value

        Err error ->
            error


decodeAndParse : Decode.Value -> Result String String
decodeAndParse value =
    value
        |> Decode.decodeValue inputDecoder
        |> mapError Decode.errorToString
        |> andThen (Pace.parse >> mapError Parser.deadEndsToString)
        |> map Pace.inMinutesPerMile
        |> map Pace.toString
