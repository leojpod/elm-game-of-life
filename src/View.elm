module View exposing (view)

import Html exposing (Html, h1, div, button, text, table, tr, td)
import Material.Layout as Layout
import Material.Grid as Grid exposing (grid, cell, size, Device(..))


-- local import

import Types exposing (Model, Msg(..))
import Setup.View exposing (setupView)
import Board.View exposing (boardView)


-- VIEW


view : Model -> Html Msg
view model =
    Layout.render Mdl
        model.mdl
        [ Layout.fixedHeader
        ]
        { header = [ h1 [] [ text "Elm's game of life" ] ]
        , drawer = []
        , tabs = ( [], [] )
        , main = [ viewBody model ]
        }


viewBody : Model -> Html Msg
viewBody model =
    grid []
        [ cell [ size All 4 ] [ setupView model.setup model.mdl ]
        , cell [ size All 8 ] [ boardView model.board model.mdl |> Html.map (\a -> BoardMsg a) ]
        ]
