module Setup.State exposing (init, update)

-- local import

import Setup.Types exposing (Setup, Speed(..), PlayState(..), SetupMsg(..))


-- INIT


init : Setup
init =
    Setup Pause Normal 10



-- UPDATE


update : SetupMsg -> Setup -> ( Setup, Cmd SetupMsg )
update msg setup =
    case msg of
        StateChange newState ->
            ( { setup | state = newState }, Cmd.none )

        SpeedChange newSpeed ->
            ( { setup | speed = newSpeed }, Cmd.none )

        SizeChange newSize ->
            ( { setup | size = newSize }, Cmd.none )

        NoOps ->
            ( setup, Cmd.none )
