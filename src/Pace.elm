module Pace exposing (parseTime)
import Parser exposing ((|.), (|=), Parser)
import Duration exposing (Duration)

parseTime : String -> Result (List Parser.DeadEnd) Float
parseTime  = 
  Parser.succeed makeFloat
  |. Parser.spaces 
  |= Parser.int
  |. Parser.symbol ":"
  |= Parser.int
  |> Parser.run


makeFloat minutes seconds = 
  toFloat minutes + toFloat seconds 
