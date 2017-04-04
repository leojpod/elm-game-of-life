module Types exposing (Cell(..), Board, Model, Msg(..))

import Material


-- local imports

import Setup.Types exposing (Setup, SetupMsg(..))


-- MODEL


type Cell
    = Empty
    | Dead
    | Alive


type alias Board =
    List (List Cell)


type alias Model =
    { board : Board, setup : Setup, mdl : Material.Model }



-- MESSAGE


type Msg
    = BoardUpdate Board
    | Tick
    | SetupMsg SetupMsg
    | Mdl (Material.Msg Msg)
