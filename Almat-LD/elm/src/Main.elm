module Main exposing (main)

import Browser
import Color
import Css exposing (marginBottom, marginLeft, marginRight, padding, paddingBottom, px)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href, id, size, src, value)
import Html.Styled.Events exposing (onClick, onInput)
import List
import Random
import Svg.Styled exposing (..)
import Svg.Styled.Attributes exposing (fill, height, stroke, strokeWidth, viewBox, width, x, y)


main =
    Browser.element
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view >> Html.Styled.toUnstyled
        }



-- MODEL


type alias FloatInput =
    { fl : Float, str : String }


inputFromFloat : Float -> FloatInput
inputFromFloat fl =
    FloatInput fl (String.fromFloat fl)


updateFromString : FloatInput -> String -> FloatInput
updateFromString input str =
    case String.toFloat str of
        Nothing ->
            FloatInput input.fl str

        Just fl ->
            FloatInput fl str


type alias Model =
    { initOscs : List Oscillator
    , iteratedOscs : List (List Oscillator)
    , nIterations : Int
    , nOscs : Int
    , phaseMin : FloatInput
    , phaseMax : FloatInput
    , couplingMin : FloatInput
    , couplingMax : FloatInput
    , incrMin : FloatInput
    , incrMax : FloatInput
    , seed : Random.Seed
    , screenWidth : Int
    , pixels : List (Svg Msg)
    , nDisplayOscs : Int
    , nDisplayIterations : Int
    , diffFun : List Float -> List Float
    }


init : ( Int, Int ) -> ( Model, Cmd Msg )
init ( intSeed, width ) =
    -- get screen width
    ( Model []
        []
        200
        100
        (inputFromFloat 0.0)
        (inputFromFloat 2.0)
        (inputFromFloat 0.01)
        (inputFromFloat 0.01)
        (inputFromFloat 0.03)
        (inputFromFloat 0.03)
        (Random.initialSeed intSeed)
        width
        []
        200
        300
        calcDiffsNeighbors
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- Calculation


type alias Oscillator =
    { phase : Float
    , incr : Float
    , coupling : Float
    }


rndOsc : ( Float, Float ) -> ( Float, Float ) -> ( Float, Float ) -> Random.Generator Oscillator
rndOsc ( phMin, phMax ) ( incrMin, incrMax ) ( couplingMin, couplingMax ) =
    Random.map3 Oscillator (Random.float phMin phMax) (Random.float incrMin incrMax) (Random.float couplingMin couplingMax)


genLst : Random.Seed -> Int -> Random.Generator a -> ( List a, Random.Seed )
genLst seed n gen =
    let
        genLstAcc seedAcc nAcc genAcc lstAcc =
            if nAcc <= 0 then
                ( lstAcc, seedAcc )

            else
                let
                    ( element, newSeed ) =
                        Random.step genAcc seedAcc
                in
                genLstAcc newSeed (nAcc - 1) genAcc (List.append lstAcc [ element ])
    in
    genLstAcc seed n gen []


unwrapPhase : Float -> Float
unwrapPhase ph =
    if ph < 0 then
        unwrapPhase (ph + 2 * pi)

    else if ph > 2 * pi then
        unwrapPhase (ph - 2 * pi)

    else
        ph


calcDiffsAll : List Float -> List Float
calcDiffsAll phases =
    let
        n =
            toFloat (List.length phases)
    in
    List.map (\phK -> List.foldl (\phJ sum -> sum + sin (phJ - phK)) 0.0 phases / n) phases


calcDiffsNeighbors : List Float -> List Float
calcDiffsNeighbors phases =
    let
        calcNeighbors lst prev last =
            case lst of
                this :: next :: rest ->
                    ((sin (prev - this) * -1) + sin (next - this)) / 2 :: calcNeighbors (next :: rest) this last

                [ this ] ->
                    [ ((sin (prev - this) * -1) + sin (last - this)) / 2 ]

                [] ->
                    []
    in
    case phases of
        [] ->
            []

        head :: _ ->
            case List.reverse phases of
                headRev :: _ ->
                    calcNeighbors phases head headRev

                [] ->
                    []


updateOsc : Oscillator -> Float -> Oscillator
updateOsc osc diff =
    let
        nextPhase =
            unwrapPhase (osc.phase + osc.incr + diff * osc.coupling)
    in
    { osc | phase = nextPhase }


updateOscs : (List Float -> List Float) -> List Oscillator -> List Oscillator
updateOscs diffFun oscs =
    let
        diffs =
            diffFun (List.map (\o -> o.phase) oscs)
    in
    List.map2 updateOsc oscs diffs


collectOscs : (List Float -> List Float) -> Int -> List Oscillator -> List (List Oscillator)
collectOscs diffFun n initOscs =
    if n <= 0 then
        []

    else
        let
            newOscs =
                updateOscs diffFun initOscs
        in
        newOscs :: collectOscs diffFun (n - 1) newOscs



-- UPDATE


type Msg
    = Render
    | SetNOscs String
    | SetNIterations String
    | SetNPhaseMin String
    | SetNPhaseMax String
    | SetNIncrMin String
    | SetNIncrMax String
    | SetNCouplingMin String
    | SetNCouplingMax String
    | SetDiffFun String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Render ->
            let
                oscGenerator =
                    rndOsc ( model.phaseMin.fl, model.phaseMax.fl ) ( model.incrMin.fl, model.incrMax.fl ) ( model.couplingMin.fl, model.couplingMax.fl )

                ( startOscs, newSeed ) =
                    genLst model.seed model.nOscs oscGenerator

                iterations =
                    collectOscs model.diffFun model.nIterations startOscs

                pixelSize =
                    toFloat model.screenWidth / toFloat model.nOscs

                newPixels =
                    List.concat (List.indexedMap (\idx oscs -> oscsIterToPixels pixelSize (pixelSize * toFloat idx) oscs) iterations)
            in
            ( { model
                | seed = newSeed
                , initOscs = startOscs
                , iteratedOscs = iterations
                , pixels = newPixels
                , nDisplayOscs = model.nOscs
                , nDisplayIterations = model.nIterations
              }
            , Cmd.none
            )

        SetNOscs n ->
            case String.toInt n of
                Nothing ->
                    ( model, Cmd.none )

                Just newN ->
                    ( { model | nOscs = newN }, Cmd.none )

        SetNIterations n ->
            case String.toInt n of
                Nothing ->
                    ( model, Cmd.none )

                Just newN ->
                    ( { model | nIterations = newN }, Cmd.none )

        SetNPhaseMin n ->
            ( { model | phaseMin = updateFromString model.phaseMin n }, Cmd.none )

        SetNPhaseMax n ->
            ( { model | phaseMax = updateFromString model.phaseMax n }, Cmd.none )

        SetNIncrMin n ->
            ( { model | incrMin = updateFromString model.incrMin n }, Cmd.none )

        SetNIncrMax n ->
            ( { model | incrMax = updateFromString model.incrMax n }, Cmd.none )

        SetNCouplingMin n ->
            ( { model | couplingMin = updateFromString model.couplingMin n }, Cmd.none )

        SetNCouplingMax n ->
            ( { model | couplingMax = updateFromString model.couplingMax n }, Cmd.none )

        SetDiffFun n ->
            case String.toInt n of
                Nothing ->
                    ( model, Cmd.none )

                Just i ->
                    case i of
                        1 ->
                            ( { model | diffFun = calcDiffsNeighbors }, Cmd.none )

                        2 ->
                            ( { model | diffFun = calcDiffsAll }, Cmd.none )

                        _ ->
                            ( model, Cmd.none )



-- VIEW


diffFunMenu : Html Msg
diffFunMenu =
    select [ onInput SetDiffFun, css [ marginRight (px 10) ] ] [ option [ value "1" ] [ Html.Styled.text "Neighbor diffs" ], option [ value "2" ] [ Html.Styled.text "All diffs" ] ]


viewInput : String -> String -> String -> (String -> msg) -> List (Html msg)
viewInput idStr labelStr val toMsg =
    [ label [ Html.Styled.Attributes.for idStr ] [ Html.Styled.text labelStr ]
    , input [ value val, onInput toMsg, id idStr, size 6, css [ marginRight (px 10), marginLeft (px 3) ] ] []
    ]


oscsIterToPixels : Float -> Float -> List Oscillator -> List (Svg msg)
oscsIterToPixels xStepSize y iteration =
    List.indexedMap (\idx osc -> pixel ( toFloat idx * xStepSize, y ) osc.phase xStepSize) iteration


view : Model -> Html Msg
view model =
    let
        pixelSize =
            toFloat model.screenWidth / toFloat model.nDisplayOscs

        formElements =
            viewInput "nOscInput" "N Oscs:" (String.fromInt model.nOscs) SetNOscs
                ++ viewInput "nIterInput" "N Iterations:" (String.fromInt model.nIterations) SetNIterations
                ++ viewInput "nPhMin" "Phase Offset Min:" model.phaseMin.str SetNPhaseMin
                ++ viewInput "nPhMax" "Phase Offset Max:" model.phaseMax.str SetNPhaseMax
                ++ viewInput "nIncrMin" "Ph.Incr. Min:" model.incrMin.str SetNIncrMin
                ++ viewInput "nIncrMax" "Ph.Incr. Max:" model.incrMax.str SetNIncrMax
                ++ viewInput "nCoupMin" "Coupling Min:" model.couplingMin.str SetNCouplingMin
                ++ viewInput "nCoupMax" "Coupling Max:" model.couplingMax.str SetNCouplingMax
                ++ [ diffFunMenu ]
                ++ [ button [ css [ padding (px 4) ], onClick Render ] [ Html.Styled.text "Render" ] ]
    in
    div []
        [ div [ css [ paddingBottom (px 5) ] ] formElements
        , div []
            [ svg
                [ viewBox <| "0 0 " ++ String.fromInt model.screenWidth ++ " " ++ String.fromInt (round ((toFloat model.nDisplayIterations * pixelSize) + 1))
                ]
                model.pixels
            ]
        ]


pixel : ( Float, Float ) -> Float -> Float -> Svg msg
pixel ( xCoord, yCoord ) phase pixelSize =
    let
        colorValue =
            String.fromInt (round (sin (phase / 2.0) * 255.0))

        color =
            "rgb(" ++ colorValue ++ "," ++ colorValue ++ "," ++ colorValue ++ ")"
    in
    rect
        [ x (String.fromFloat xCoord)
        , y (String.fromFloat yCoord)
        , width (String.fromFloat pixelSize)
        , height (String.fromFloat pixelSize)
        , fill color
        , stroke color
        ]
        []



-- TODO
-- scale to vertical screen size (y pixel size)
-- störung, input?
-- different integration function
