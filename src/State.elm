module State exposing (init, update, subscriptions)

import List exposing (repeat)
import Random exposing (Generator, bool, list)
import Array exposing (Array, fromList, toList, get)
import Maybe exposing (Maybe, andThen)
import Time exposing (every, second)
import Material
import Material.Layout as Layout


-- local imports

import Types exposing (Board, Cell(..), PlayState(..), Model, Msg(..))


-- INIT


model : Model
model =
    Model (repeat 10 (repeat 10 Empty)) Play Material.model


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
    ( model
    , Cmd.batch
        [ Random.generate BoardUpdate (list 10 (list 10 randCell))
        , Layout.sub0 Mdl
        ]
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        BoardUpdate board ->
            ( { model | board = board }, Cmd.none )

        Tick ->
            let
                nextBoard =
                    compute model.board
            in
                ( { model | board = nextBoard }, Cmd.none )

        TogglePlayState ->
            case model.playState of
                Play ->
                    ( { model | playState = Pause }, Cmd.none )

                Pause ->
                    ( { model | playState = Play }, Cmd.none )

        Mdl mdlMsg ->
            Material.update Mdl mdlMsg model


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
    Sub.batch
        [ Material.subscriptions Mdl model
        , case model.playState of
            Play ->
                every second (\_ -> Tick)

            Pause ->
                Sub.none
        ]
