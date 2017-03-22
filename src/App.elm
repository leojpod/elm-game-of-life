module App exposing (..)

import Html exposing (program)


-- local imports

import Types exposing (Cell(..), Board, Model, Msg(..))
import State exposing (init, update, subscriptions)
import View exposing (view)


-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
