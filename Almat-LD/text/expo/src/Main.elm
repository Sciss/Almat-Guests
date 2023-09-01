module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Browser.Navigation as Nav
import Content exposing (Entry)
import Dict
import DrawGraph
import Graph exposing (Graph, Node)
import Html exposing (Html, a, div, text)
import Html.Attributes exposing (class, href, id)
import Html.Events exposing (onClick)
import Text
import Url



-- MAIN
-- main =
--     Browser.sandbox { init = init, update = update, view = view }


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type Node
    = Overview
    | Introduction
    | Bibliography
    | Subgraph String


type alias Model =
    { selectedNode : Node
    , key : Nav.Key
    , url : Url.Url
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { selectedNode = nodeFromUrl url
      , key = key
      , url = url
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


nodeFromUrl : Url.Url -> Node
nodeFromUrl s =
    case s.fragment of
        Nothing ->
            Overview

        Just "Overview" ->
            Overview

        Just "Introduction" ->
            Introduction

        Just "Bibliography" ->
            Bibliography

        Just str ->
            -- check if exists and deal with non-existence here
            Subgraph str


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url, selectedNode = nodeFromUrl url }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


pagetitle : String -> Html msg
pagetitle t =
    div [ id "pagetitle" ] [ text t ]


subgraphName : Node -> Maybe String
subgraphName n =
    case n of
        Subgraph s ->
            Just s

        _ ->
            Nothing


title =
    "Almat: Affective Apparatuses"


viewOverview : Html msg
viewOverview =
    let
        graph =
            DrawGraph.view Text.contentGraph "Overview" ( 1200, 700 ) ( 1600, 900 ) 220
    in
    div [ class "overview" ]
        [ div [ class "head" ]
            [ div [ id "title" ] [ text title ]
            , pagetitle "Overview"
            ]
        , div [ class "nav-list-overview" ]
            [ div [] [ a [ href "#Overview" ] [ text "Overview" ] ]
            , div [] [ a [ href "#Introduction" ] [ text "Introduction" ] ]
            , div [] [ a [ href "#Bibliography" ] [ text "Bibliography" ] ]
            ]
        , div [ class "overview-graph" ] [ graph ]
        ]


viewSubgraph : String -> Html msg
viewSubgraph subName =
    let
        subgraph =
            Maybe.withDefault (div [] []) <|
                Maybe.map
                    (\g ->
                        DrawGraph.view g subName ( 540, 400 ) ( 600, 500 ) 150
                    )
                    (Dict.get subName Text.subGraphs)
    in
    div [ class "wrapper" ]
        [ div [ class "head" ]
            [ div [ id "title" ] [ text title ]
            , pagetitle subName
            ]
        , div
            [ class "metadata" ]
            [ div [ class "small-nav" ]
                [ div [ class "nav-list" ]
                    [ div [] [ a [ href "#Overview" ] [ text "Overview" ] ]
                    , div [] [ a [ href "#Introduction" ] [ text "Introduction" ] ]
                    , div [] [ a [ href "#Bibliography" ] [ text "Bibliography" ] ]
                    ]
                , div [ class "subgraph" ] [ subgraph ]
                ]

            --                , div [ class "keywords" ] [ text "keywords" ]
            , div [ class "references" ] [ text "References" ]
            ]
        , div [ class "content" ] [ text Text.lorem ]
        ]


view : Model -> Browser.Document Msg
view model =
    { title = "Test" -- TODO fix
    , body =
        [ case model.selectedNode of
            Subgraph s ->
                viewSubgraph s

            _ ->
                viewOverview
        ]
    }



-- Background.viewGraph ( 450, 450 ) NodeSelected
