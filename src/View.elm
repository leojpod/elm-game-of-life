module View exposing (view)

import Html exposing (Html, h1, div, button, text, table, tr, td)
import Html.Events exposing (onClick)
import Material.Layout as Layout


-- local import

import Types exposing (Board, Cell(..), PlayState(..), Model, Msg(..))


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
    div []
        [ button [ onClick TogglePlayState ]
            [ case model.playState of
                Play ->
                    text "pause"

                Pause ->
                    text "resume"
            ]
        , div [] [ boardView model.board ]
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
