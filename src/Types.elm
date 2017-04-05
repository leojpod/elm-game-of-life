module Types exposing (Model, Msg(..))

import Material


-- local imports

import Setup.Types exposing (Setup, SetupMsg(..))
import Board.Types exposing (Board, BoardMsg)


-- MODEL


type alias Model =
    { board : Board, setup : Setup, mdl : Material.Model }



-- MESSAGE


type Msg
    = BoardMsg BoardMsg
    | SetupMsg SetupMsg
    | Mdl (Material.Msg Msg)
