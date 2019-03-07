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
    { oscs : List Oscillator
    , nIterations : Int
    }


init : Int -> ( Model, Cmd Msg )
init floatSeed =
    -- get screen width
    ( Model (List.concat (List.repeat 200 [ Oscillator 0.0 0.002 0.05, Oscillator 1.9 0.005 0.09 ])) 200
    , Cmd.none
    )



-- should be float


xStep : Int
xStep =
    2



-- should be float


yStep : Int
yStep =
    2


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



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
    let
        n =
            toFloat (List.length phases)
    in
    List.map (\phK -> List.foldl (\phJ sum -> sum + sin (phJ - phK)) 0.0 phases / n) phases


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


collectOscs : Int -> List Oscillator -> List (List Oscillator)
collectOscs n initOscs =
    if n <= 0 then
        []

    else
        let
            newOscs =
                updateOscs initOscs
        in
        newOscs :: collectOscs (n - 1) newOscs



-- UPDATE


type Msg
    = Calc


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Calc ->
            ( model, Cmd.none )



-- VIEW


oscsIterToPixels : Float -> Float -> List Oscillator -> List (Svg msg)
oscsIterToPixels xStepSize y iteration =
    List.indexedMap (\idx osc -> pixel ( toFloat idx * xStepSize, y ) osc.phase) iteration


view : Model -> Html.Html Msg
view model =
    let
        iterations =
            collectOscs model.nIterations model.oscs
    in
    let
        pixels =
            List.concat (List.indexedMap (\idx oscs -> oscsIterToPixels (toFloat xStep) (toFloat yStep * toFloat idx) oscs) iterations)
    in
    Html.div []
        [ svg
            [ viewBox 0 0 800 1600
            ]
            pixels
        ]


pixel : ( Float, Float ) -> Float -> Svg msg
pixel ( xCoord, yCoord ) phase =
    let
        color =
            Color.rgba 0.0 0.0 0.0 (1 - sin (phase / 2))
    in
    rect
        [ x xCoord
        , y yCoord
        , width (toFloat xStep)
        , height (toFloat yStep)
        , fill (Fill color)
        , stroke color
        ]
        []
