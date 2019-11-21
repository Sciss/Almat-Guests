module Content exposing (Entry, GraphElement, makeGraph, makeSubGraph)

import Graph exposing (Graph, fromNodeLabelsAndEdgePairs)
import Html exposing (Html)


type alias GraphElement a =
    { a
        | title : String
    }


stringAsGraphElement : String -> GraphElement {}
stringAsGraphElement str =
    { title = str }


type alias Entry msg =
    GraphElement
        { neighbors : List String
        , keywords : List String
        , content : Html msg
        }


findIdx : a -> List a -> Maybe Int
findIdx el lst =
    case lst of
        [] ->
            Nothing

        fst :: rest ->
            if fst == el then
                Just 0

            else
                Maybe.map (\a -> a + 1) (findIdx el rest)


catMaybes : List (Maybe a) -> List a
catMaybes lst =
    case lst of
        [] ->
            []

        (Just a) :: rest ->
            a :: catMaybes rest

        Nothing :: rest ->
            catMaybes rest


makeGraph : List (Entry msg) -> Graph (Entry msg) ()
makeGraph entries =
    let
        titles =
            List.map .title entries

        collectNeighbors idx entryLst =
            case entryLst of
                [] ->
                    []

                thisEntry :: otherEntries ->
                    let
                        neighbors =
                            catMaybes <|
                                List.map (\neighbor -> findIdx neighbor titles)
                                    thisEntry.neighbors
                    in
                    List.map (\n -> ( idx, n )) neighbors
                        ++ collectNeighbors (idx + 1)
                            otherEntries
    in
    fromNodeLabelsAndEdgePairs entries (collectNeighbors 0 entries)


makeSubGraph : Entry msg -> Graph (GraphElement {}) ()
makeSubGraph entry =
    if List.isEmpty entry.neighbors then
        fromNodeLabelsAndEdgePairs [ stringAsGraphElement entry.title ] []

    else
        let
            pairs =
                List.map (\n -> ( 0, n )) <| List.range 1 (List.length entry.neighbors)
        in
        fromNodeLabelsAndEdgePairs
            (List.map stringAsGraphElement (entry.title :: entry.neighbors))
            pairs
