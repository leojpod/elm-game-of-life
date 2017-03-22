module State exposing (init, update, subscriptions)

import List exposing (repeat)
import Random exposing (Generator, bool, list)
import Array exposing (Array, fromList, toList, get)
import Maybe exposing (Maybe, andThen)
import Time exposing (every)


-- local imports

import Types exposing (Board, Cell(..), Model, Msg(..))


-- INIT


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
    every 2000 (\_ -> Tick)
