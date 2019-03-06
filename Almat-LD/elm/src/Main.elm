module Main exposing (main)

--import Html.Attributes
--import Random
--import Time exposing (Posix)

import Browser
import Browser.Events exposing (onAnimationFrameDelta, onClick)
import Color
import Html
import List
import TypedSvg exposing (rect, svg)
import TypedSvg.Attributes exposing (fill, stroke, viewBox)
import TypedSvg.Attributes.InPx exposing (..)
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (Fill(..))


main =
    Browser.element
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }



-- MODEL


type alias Model =
    Int


init : Int -> ( Model, Cmd Msg )
init floatSeed =
    ( floatSeed
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    onAnimationFrameDelta AnimationFrame



-- Calculation


type alias Oscillator =
    { phase : Float
    , incr : Float
    , coupling : Float
    }


unwrapPhase : Float -> Float
unwrapPhase ph =
    if ph < 0 then
        unwrapPhase (ph + 2 * pi)

    else if ph > 2 * pi then
        unwrapPhase (ph - 2 * pi)

    else
        ph


calcDiffs : List Float -> List Float
calcDiffs phases =
    List.map (\phK -> List.foldl (\phJ sum -> sum + sin (phJ - phK)) 0.0 phases) phases


updateOsc : Oscillator -> Float -> Oscillator
updateOsc osc diff =
    let
        nextPhase =
            unwrapPhase (osc.phase + osc.incr + diff * osc.coupling)
    in
    { osc | phase = nextPhase }


updateOscs : List Oscillator -> List Oscillator
updateOscs oscs =
    let
        diffs =
            calcDiffs (List.map (\o -> o.phase) oscs)
    in
    List.map2 updateOsc oscs diffs



-- UPDATE


type Msg
    = Increment
    | Decrement
    | AnimationFrame Float


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( model + 1, Cmd.none )

        Decrement ->
            ( model - 1, Cmd.none )

        AnimationFrame fl ->
            ( model + round fl, Cmd.none )



-- VIEW


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ svg
            [ viewBox 0 0 800 1600
            ]
            [ pixel ( 10, 20 ) 1.1
            , pixel ( 10, 520 ) pi
            , pixel ( 10, 1020 ) 0
            ]
        ]


pixel : ( Float, Float ) -> Float -> Svg msg
pixel ( xCoord, yCoord ) phase =
    rect
        [ x xCoord
        , y yCoord
        , width 400
        , height 400
        , fill (Fill (Color.rgba 0.0 0.0 0.0 (1 - sin (phase / 2))))
        ]
        []
