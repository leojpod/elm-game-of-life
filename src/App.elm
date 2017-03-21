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
    | Dead
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
    | Tick
    | NoOps



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Elm's game of life" ]
        , button [ onClick Tick ] [ text "tick!" ]
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



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOps ->
            ( model, Cmd.none )

        BoardUpdate board ->
            ( { model | board = board }, Cmd.none )

        Tick ->
            let
                nextBoard =
                    compute model.board
            in
                ( { model | board = nextBoard }, Cmd.none )


neighbourCount : Int -> Int -> Array (Array Cell) -> Int
neighbourCount x y arrayBoard =
    let
        aboveRow =
            get (x - 1) arrayBoard

        belowRow =
            get (x + 1) arrayBoard

        currentRow =
            get x arrayBoard
    in
        [ aboveRow |> andThen (get (y - 1))
        , aboveRow |> andThen (get y)
        , aboveRow |> andThen (get (y + 1))
        , currentRow |> andThen (get (y - 1))
        , currentRow |> andThen (get (y + 1))
        , belowRow |> andThen (get (y - 1))
        , belowRow |> andThen (get y)
        , belowRow |> andThen (get (y + 1))
        ]
            |> List.map
                (\just ->
                    case just of
                        Just cell ->
                            cell

                        Nothing ->
                            Empty
                )
            |> List.filter
                (\cell ->
                    case cell of
                        Alive ->
                            True

                        _ ->
                            False
                )
            |> List.length


compute : Board -> Board
compute board =
    let
        arrayBoard =
            fromList (List.map fromList board)
    in
        Array.indexedMap
            (\x row ->
                Array.indexedMap
                    (\y cell ->
                        let
                            neighbours =
                                neighbourCount x y arrayBoard
                        in
                            case cell of
                                Alive ->
                                    if (neighbours == 3 || neighbours == 2) then
                                        Alive
                                    else
                                        Dead

                                _ ->
                                    if (neighbours == 3) then
                                        Alive
                                    else
                                        Empty
                    )
                    row
            )
            arrayBoard
            |> \newArray -> (toList (Array.map toList newArray))



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
