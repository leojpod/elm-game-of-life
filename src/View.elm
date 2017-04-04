module View exposing (view)

import Html exposing (Html, h1, div, button, text, table, tr, td)
import Material.Layout as Layout
import Material.Grid as Grid exposing (grid, cell, size, Device(..))


-- local import

import Types exposing (Board, Cell(..), Model, Msg(..))
import Setup.View exposing (setupView)


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
        , cell [ size All 8 ] [ boardView model.board ]
        ]


boardView : Board -> Html Msg
boardView board =
    table []
        ((tr []
            ((td [] [])
                :: ((List.range 0 9)
                        |> List.map (\col -> td [] [ text (toString col) ])
                   )
            )
         )
            :: (List.indexedMap rowView board)
        )


rowView : Int -> List Cell -> Html Msg
rowView idx row =
    tr [] ((td [] [ text (toString idx) ]) :: (List.map cellView row))


cellView : Cell -> Html Msg
cellView cell =
    case cell of
        Empty ->
            td [] [ text "." ]

        Dead ->
            td [] [ text "-" ]

        Alive ->
            td [] [ text "X" ]
