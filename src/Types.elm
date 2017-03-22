module Types exposing (Cell(..), Board, PlayState(..), Model, Msg(..))

-- MODEL


type Cell
    = Empty
    | Dead
    | Alive


type alias Board =
    List (List Cell)


type PlayState
    = Play
    | Pause


type alias Model =
    { board : Board, playState : PlayState }



-- MESSAGE


type Msg
    = BoardUpdate Board
    | Tick
    | TogglePlayState
    | NoOps
