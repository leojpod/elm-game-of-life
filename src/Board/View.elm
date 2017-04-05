module Board.View exposing (boardView)

import Material
import Material.Grid as Grid exposing (grid, cell, size, Device(..))
import Material.Card as Card
import Material.Elevation as Elevation
import Html exposing (Html, table, tr, td, text)


-- local imports

import Board.Types exposing (Cell(..), Board, BoardMsg(..))


boardView : Board -> Material.Model -> Html BoardMsg
boardView board mdlModel =
    Card.view
        [ Elevation.e24
        , Elevation.transition 1000
        , size All 12
        ]
        [ Card.text []
            [ boardDisplay board
            ]
        ]


boardDisplay : Board -> Html BoardMsg
boardDisplay board =
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


rowView : Int -> List Cell -> Html BoardMsg
rowView idx row =
    tr [] ((td [] [ text (toString idx) ]) :: (List.map cellView row))


cellView : Cell -> Html BoardMsg
cellView cell =
    case cell of
        Empty ->
            td [] [ text "." ]

        Dead ->
            td [] [ text "-" ]

        Alive ->
            td [] [ text "X" ]
