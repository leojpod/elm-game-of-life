module Setup.View exposing (..)

import Html exposing (Html, div, text)
import Material
import Material.Button as Button
import Material.Icon as Icon
import Material.Card as Card
import Material.Options as Options
import Material.Slider as Slider
import Material.Elevation as Elevation
import Material.Grid as Grid exposing (grid, cell, size, Device(..))


-- local imports

import Setup.Types exposing (Setup, PlayState(..), Speed(..), SetupMsg(..))
import Types exposing (Msg(..))


startStop : PlayState -> Material.Model -> Html Types.Msg
startStop playState mdlModel =
    (Button.render Mdl
        [ 0, 1, 2, 3 ]
        mdlModel
        [ Button.raised
        , Button.colored
        , Button.ripple
        , Button.icon
        , Options.onClick
            (case playState of
                Play ->
                    SetupMsg (Setup.Types.StateChange Pause)

                Pause ->
                    SetupMsg (Setup.Types.StateChange Play)
            )
        ]
        [ (case playState of
            Play ->
                -- (text "pause")
                (Icon.i "pause")

            Pause ->
                -- (text "play")
                (Icon.i "play_arrow")
          )
        ]
    )


speedChangeView : Speed -> Html Types.Msg
speedChangeView currentSpeed =
    Slider.view
        [ Slider.onChange
            (\float ->
                let
                    speed =
                        Setup.Types.intToSpeed float
                in
                    SetupMsg (SpeedChange speed)
            )
        , Slider.value (Setup.Types.speedToInt currentSpeed)
        , Slider.min 0
        , Slider.max 3
        ]


setupView : Setup -> Material.Model -> Html Types.Msg
setupView setup mdlModel =
    Card.view
        [ Elevation.e24
        , Elevation.transition 500
        , size All 12
        ]
        [ Card.title []
            [ Card.head [] [ text "Setup" ]
            , Card.subhead [] [ text "setup your game and it will reset accordingly" ]
            ]
        , Card.text []
            [ text <| "select the speed: " ++ (toString setup.speed)
            , speedChangeView setup.speed
            ]
        , Card.actions
            [ Card.border ]
            [ startStop setup.state mdlModel ]
        ]
