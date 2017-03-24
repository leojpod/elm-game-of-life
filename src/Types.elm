module Types exposing (Cell(..), Board, PlayState(..), Model, Msg(..))

import Material


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
    { board : Board, playState : PlayState, mdl : Material.Model }



-- MESSAGE


type Msg
    = BoardUpdate Board
    | Tick
    | TogglePlayState
    | Mdl (Material.Msg Msg)
