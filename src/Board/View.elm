module Board.View exposing (boardView)

import Material
import Material.Grid as Grid exposing (grid, cell, size, Device(..))
import Material.Card as Card
import Material.Elevation as Elevation
import Html exposing (Html, table, tr, td, text)
import Svg exposing (Svg, svg, rect, circle)
import Svg.Attributes exposing (x, cx, y, cy, r, fill, width, height, viewBox)


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
    svg
        [ viewBox "0 0 100 100"
        ]
        (rect [ fill "#FFFFFF", x "0", y "0", width "100", height "100" ] []
            :: List.concat (List.indexedMap rowView board)
        )



-- table []
--     ((tr []
--         ((td [] [])
--             :: ((List.range 0 9)
--                     |> List.map (\col -> td [] [ text (toString col) ])
--                )
--         )
--      )
--         :: (List.indexedMap rowView board)
--     )


rowView : Int -> List Cell -> List (Svg BoardMsg)
rowView idx row =
    List.concat (List.indexedMap (cellView idx) row)


cellView : Int -> Int -> Cell -> List (Svg BoardMsg)
cellView rowIdx colIdx cell =
    rect [ x (toString (colIdx * 10)), y (toString (rowIdx * 10)), width "10", height "10", fill "#FFFFFF" ] []
        :: (case cell of
                Empty ->
                    []

                Dead ->
                    [ circle [ cx (toString (colIdx * 10 + 5)), cy (toString (rowIdx * 10 + 5)), r "5", fill "rgb(0, 121, 107)" ] [] ]

                Alive ->
                    [ circle [ cx (toString (colIdx * 10 + 5)), cy (toString (rowIdx * 10 + 5)), r "5", fill "rgb(0, 150, 136)" ] [] ]
           )
