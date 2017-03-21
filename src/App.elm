module App exposing (..)

import Html exposing (Html, h1, table, td, tr, div, text, program)
import List exposing (repeat)


-- MODEL


type Cell
    = Empty
    | Alive


type alias Board =
    List (List Cell)


type alias Model =
    { board : Board }


model : Model
model =
    Model (repeat 10 (repeat 10 Empty))


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )



-- MESSAGE


type Msg
    = NoOps



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Elm's game of life" ]
        , div [] [ boardView model.board ]
        ]


boardView : Board -> Html Msg
boardView board =
    table [] (List.map rowView board)


rowView : List Cell -> Html Msg
rowView row =
    tr [] (List.map cellView row)


cellView : Cell -> Html Msg
cellView cell =
    case cell of
        Empty ->
            td [] [ text " " ]

        Alive ->
            td [] [ text "X" ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOps ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
