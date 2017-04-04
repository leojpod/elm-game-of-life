module Setup.Types exposing (SetupMsg(..), PlayState(..), Setup, Speed(..))

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



-- MESSAGE


type SetupMsg
    = StateChange PlayState
    | SpeedChange Speed
    | SizeChange Int
    | NoOps
