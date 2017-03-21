module App exposing (..)

import Html exposing (Html, button, h1, table, td, tr, div, text, program)
import Html.Events exposing (onClick)
import List exposing (repeat)
import Random exposing (Generator, bool, list)
import Array exposing (Array, fromList, toList, get)
import Maybe exposing (Maybe, andThen)


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


randCell : Generator Cell
randCell =
    Random.map
        (\b ->
            if b then
                Alive
            else
                Empty
        )
        bool


init : ( Model, Cmd Msg )
init =
    ( model, Random.generate BoardUpdate (list 10 (list 10 randCell)) )



-- MESSAGE


type Msg
    = BoardUpdate Board
    | NoOps



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

        BoardUpdate board ->
            ( { model | board = board }, Cmd.none )



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
