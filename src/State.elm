module State exposing (init, update, subscriptions)

import Time exposing (every, second)
import Material
import Material.Layout as Layout


-- local imports

import Types exposing (Model, Msg(..))
import Setup.State
import Setup.Types exposing (SetupMsg(..))
import Board.State
import Board.Types exposing (BoardMsg(..))


-- INIT


model : Model
model =
    let
        ( startBoard, _ ) =
            Board.State.init
    in
        Model startBoard Setup.State.init Material.model


init : ( Model, Cmd Msg )
init =
    let
        ( _, initialRandomCmd ) =
            Board.State.init
    in
        ( model
        , Cmd.batch
            [ initialRandomCmd
                |> Cmd.map (\a -> BoardMsg a)
            , Layout.sub0 Mdl
            ]
        )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        BoardMsg boardMsg ->
            Board.State.update boardMsg model.board
                |> (\( newBoard, _ ) -> ( { model | board = newBoard }, Cmd.none ))

        SetupMsg setupMsg ->
            Setup.State.update setupMsg model.setup
                |> (\( newSetup, cmd ) -> ( { model | setup = newSetup }, Cmd.none ))

        Mdl mdlMsg ->
            Material.update Mdl mdlMsg model



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Material.subscriptions Mdl model
        , case model.setup.state of
            Setup.Types.Play ->
                every (Setup.Types.speedToInterval model.setup.speed) (\_ -> BoardMsg Tick)

            Setup.Types.Pause ->
                Sub.none
        ]
