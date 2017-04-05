module Board.State exposing (init, update)

import Random
import Array exposing (Array, fromList, toList, get)
import Maybe exposing (andThen)


-- local import

import Board.Types exposing (Board, Cell(..), BoardMsg(..))


-- INIT


init : ( Board, Cmd BoardMsg )
init =
    ( (List.repeat 10 (List.repeat 10 Empty)), initialRandomGeneration 10 10 )


initialRandomGeneration : Int -> Int -> Cmd BoardMsg
initialRandomGeneration xSize ySize =
    Random.generate Update (Random.list xSize (Random.list ySize randCell))


randCell : Random.Generator Cell
randCell =
    Random.map
        (\b ->
            if b then
                Alive
            else
                Empty
        )
        Random.bool



-- UPDATE


update : BoardMsg -> Board -> ( Board, Cmd BoardMsg )
update msg board =
    case msg of
        Update newBoard ->
            ( newBoard, Cmd.none )

        Tick ->
            ( compute board, Cmd.none )


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
            -- |> Debug.log
            -- ("("
            -- ++ (toString x)
            -- ++ ","
            -- ++ (toString y)
            -- ++ ") before filterMap"
            -- )
            |>
                List.filterMap
                    (\just ->
                        case just of
                            Just cell ->
                                case cell of
                                    Alive ->
                                        Just Alive

                                    _ ->
                                        Nothing

                            Nothing ->
                                Nothing
                    )
            -- |> Debug.log "after filterMap"
            |>
                List.length



-- SUBSCRIPTIONS
