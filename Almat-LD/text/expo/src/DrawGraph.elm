module DrawGraph exposing (view)

import Color exposing (Color)
import Content exposing (Entry, GraphElement)
import Force exposing (State)
import Graph exposing (Edge, Graph, Node, NodeId)
import Html exposing (Html)
import IntDict
import List exposing (range)
import Scale exposing (SequentialScale)
import Scale.Color
import TypedSvg exposing (a, circle, ellipse, g, line, polygon, svg, text_, title)
import TypedSvg.Attributes exposing (class, fill, fontFamily, fontSize, fontWeight, height, points, stroke, textAnchor, viewBox, width, xlinkHref)
import TypedSvg.Attributes.InPx exposing (cx, cy, r, rx, ry, strokeWidth, x, x1, x2, y, y1, y2)
import TypedSvg.Core exposing (Svg, text)
import TypedSvg.Events exposing (onClick)
import TypedSvg.Types exposing (AnchorAlignment(..), Fill(..), FontWeight(..), Length(..))


type alias CustomNode =
    { rank : Int, name : String }


type alias Entity =
    Force.Entity NodeId { value : CustomNode }


init : Graph (GraphElement a) () -> Float -> ( Float, Float ) -> Graph Entity ()
init contentGraph dist ( w, h ) =
    let
        graph =
            Graph.mapContexts
                (\({ node, incoming, outgoing } as ctx) ->
                    { incoming = incoming
                    , outgoing = outgoing
                    , node =
                        { label =
                            Force.entity node.id
                                (CustomNode
                                    (IntDict.size incoming + IntDict.size outgoing)
                                    node.label.title
                                )
                        , id = node.id
                        }
                    }
                )
                contentGraph

        links =
            graph
                |> Graph.edges
                |> List.map
                    (\{ from, to } ->
                        { source = from
                        , target = to
                        , distance = dist
                        , strength = Nothing
                        }
                    )

        link { from, to } =
            ( from, to )

        forces =
            [ Force.customLinks 1 links

            --              Force.links <| List.map link <| Graph.edges graph
            , Force.manyBodyStrength -2600 <| List.map .id <| Graph.nodes graph
            , Force.center (w / 2) (h / 2)
            ]
    in
    Graph.nodes graph
        |> List.map .label
        |> Force.computeSimulation (Force.simulation forces)
        |> updateGraphWithList graph


updateGraphWithList : Graph Entity () -> List Entity -> Graph Entity ()
updateGraphWithList =
    let
        graphUpdater value =
            Maybe.map (\ctx -> updateContextWithValue ctx value)
    in
    List.foldr (\node graph -> Graph.update node.id (graphUpdater node) graph)


updateContextWithValue nodeCtx value =
    let
        node =
            nodeCtx.node
    in
    { nodeCtx | node = { node | label = value } }


linkElement : Graph Entity () -> Edge () -> Svg msg
linkElement graph edge =
    let
        retrieveEntity =
            Maybe.withDefault (Force.entity 0 (CustomNode 0 "")) << Maybe.map (.node >> .label)

        source =
            retrieveEntity <| Graph.get edge.from graph

        target =
            retrieveEntity <| Graph.get edge.to graph
    in
    line
        [ strokeWidth 1
        , stroke Color.black --<| Scale.convert colorScale source.x
        , x1 source.x
        , y1 source.y
        , x2 target.x
        , y2 target.y
        ]
        []


hexagon ( x, y ) size attrs =
    let
        angle =
            2 * pi / 6

        p =
            range 0 6
                |> List.map toFloat
                |> List.map (\a -> ( x + cos (a * angle) * size, y + sin (a * angle) * size ))
                |> points
    in
    polygon
        (p :: attrs)


nodeSize size node =
    hexagon ( node.x, node.y )
        size
        [ fill <| Fill Color.black --<| Scale.convert colorScale node.x
        ]
        [ title [] [ text node.value.name ] ]


nodeElement selectedString node =
    let
        thisNode =
            node.label.value.name

        weight =
            if selectedString == thisNode then
                FontWeightBolder

            else
                FontWeightNormal
    in
    g []
        [ ellipse
            [ rx 110
            , ry 22
            , cx node.label.x
            , cy node.label.y
            , fill (Fill Color.white)
            , stroke Color.black
            ]
            []
        , text_ [ textAnchor AnchorMiddle, x node.label.x, y (node.label.y + 5) ]
            [ a
                [ xlinkHref ("#" ++ thisNode)
                , fontSize (Em 1.2)
                , fontFamily [ "Inconsolata" ]
                , fontWeight weight
                ]
                [ text thisNode ]
            ]
        ]


viewGraph : ( Float, Float ) -> String -> ( Float, Float ) -> Graph Entity () -> Html msg
viewGraph ( w, h ) selectedString ( boxWidth, boxHeight ) model =
    svg [ width (Px w), height (Px h), viewBox 0 0 boxWidth boxHeight ]
        [ g [ class [ "links" ] ] <| List.map (linkElement model) <| Graph.edges model
        , g [ class [ "nodes" ] ] <| List.map (nodeElement selectedString) <| Graph.nodes model
        ]


view : Graph (GraphElement a) () -> String -> ( Float, Float ) -> ( Float, Float ) -> Float -> Html msg
view graph selectedString ( width, height ) ( boxWidth, boxHeight ) dist =
    viewGraph ( width, height ) selectedString ( boxWidth, boxHeight ) (init graph dist ( boxWidth, boxHeight ))
