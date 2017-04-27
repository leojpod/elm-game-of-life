module Setup.Types exposing (SetupMsg(..), PlayState(..), Setup, Speed(..), speedToInt, speedToInterval, intToSpeed)

import Time


-- MODEL


type PlayState
    = Play
    | Pause


type Speed
    = Slow
    | Normal
    | Fast
    | SuperFast


type alias Setup =
    { state : PlayState, speed : Speed, size : Int }



-- UTILS


intToSpeed : number -> Speed
intToSpeed speed =
    if speed == 0 then
        Slow
    else if speed == 1 then
        Normal
    else if speed == 2 then
        Fast
    else if speed == 3 then
        SuperFast
    else
        Normal


speedToInt : Speed -> number
speedToInt speed =
    case speed of
        Slow ->
            0

        Normal ->
            1

        Fast ->
            2

        SuperFast ->
            3


speedToInterval : Speed -> Float
speedToInterval speed =
    case speed of
        Slow ->
            3 * Time.second

        Normal ->
            1 * Time.second

        Fast ->
            500 * Time.millisecond

        SuperFast ->
            250 * Time.millisecond



-- MESSAGE


type SetupMsg
    = StateChange PlayState
    | SpeedChange Speed
    | SizeChange Int
    | NoOps
