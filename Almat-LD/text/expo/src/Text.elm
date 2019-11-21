module Text exposing (contentGraph, entries, lorem, subGraphs)

import Content exposing (..)
import Dict exposing (Dict)
import Graph exposing (Graph)
import Html exposing (div, text)
import Set


addOtherConnections : Entry msg -> List (Entry msg) -> Entry msg
addOtherConnections entry l =
    let
        connectedTitles =
            List.map .title <| List.filter (\e -> List.member entry.title e.neighbors) l

        allNeighbors =
            Set.toList <| Set.fromList (entry.neighbors ++ connectedTitles)
    in
    { entry | neighbors = allNeighbors }


completeNeighbors : List (Entry msg) -> List (Entry msg)
completeNeighbors lst =
    List.map (\e -> addOtherConnections e lst) lst


entries : List (Entry msg)
entries =
    [ { title = "Synchronization"
      , neighbors = [ "Computation", "Contingency", "Information" ]
      , keywords = []
      , content = div [] [ text "Example text" ]
      }
    , { title = "Information"
      , neighbors = [ "Computation", "System", "Synchronization", "Affect" ]
      , keywords = []
      , content = div [] [ text "Example text" ]
      }
    , { title = "Contingency"
      , neighbors = []
      , keywords = []
      , content = div [] [ text "Example text" ]
      }
    , { title = "Computation"
      , neighbors = []
      , keywords = []
      , content = div [] [ text "Example text" ]
      }

    -- , { title = "Format"
    --   , neighbors = [ "Computation" ]
    --   , keywords = []
    --   , content = div [] [ text "Example text" ]
    --   }
    , { title = "System"
      , neighbors = [ "Computation", "Text" ]
      , keywords = []
      , content = div [] [ text "Example text" ]
      }

    -- , { title = "Agency"
    --   , neighbors = [ "Computation" ]
    --   , keywords = []
    --   , content = div [] [ text "Example text" ]
    --   }
    , { title = "Entanglement"
      , neighbors = [ "Body", "Experimentation" ]
      , keywords = []
      , content = div [] [ text "Example text" ]
      }
    , { title = "Experimentation"
      , neighbors = [ "Text", "Contingency" ]
      , keywords = []
      , content = div [] [ text "Example text" ]
      }
    , { title = "Recursivity"
      , neighbors = [ "Computation", "Contingency", "System" ]
      , keywords = []
      , content = div [] [ text "Example text" ]
      }
    , { title = "Apparatus"
      , neighbors = [ "Computation", "Body", "System" ]
      , keywords = []
      , content = div [] [ text "Example text" ]
      }
    , { title = "Body"
      , neighbors = [ "Entanglement", "Affect" ]
      , keywords = []
      , content = div [] [ text "Example text" ]
      }
    , { title = "Affect"
      , neighbors = [ "Synchronization", "Contingency", "Body" ]
      , keywords = []
      , content = div [] [ text "Example text" ]
      }
    , { title = "Text"
      , neighbors = [ "System" ]
      , keywords = []
      , content = div [] [ text "Example text" ]
      }
    ]
        |> completeNeighbors


contentGraph : Graph (Entry msg) ()
contentGraph =
    makeGraph entries


subGraphs : Dict String (Graph (GraphElement {}) ())
subGraphs =
    Dict.fromList <| List.map (\e -> ( e.title, makeSubGraph e )) entries



-- , "Entanglement"
-- , "Site"
-- , "Aesthetic experience"
-- , "Computation"
-- , "Iterativity"
-- , "Formats"
-- , "Speculation"


lorem =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis vestibulum commodo ipsum. Mauris vitae mollis diam. Nulla pulvinar quis neque accumsan eleifend. Nullam sollicitudin vel nibh nec rhoncus. In hac habitasse platea dictumst. Etiam tristique elementum est non feugiat. Sed vitae porta tortor. Nulla in gravida nisi, eget suscipit lacus. Nunc iaculis semper rutrum. Morbi facilisis tristique interdum. Aenean elementum, nulla id pulvinar feugiat, nunc nunc pulvinar ante, tristique tristique lorem lacus ac ante.\n\nFusce ac nibh ac magna iaculis elementum eu id tellus. Nulla luctus at magna quis suscipit. Donec vel volutpat dolor, ac convallis arcu. Duis bibendum arcu leo, id efficitur urna bibendum sed. Integer id consectetur metus. Nam accumsan libero nec leo vestibulum imperdiet. Donec tincidunt vitae ex id dignissim.\n\nQuisque sed enim eros. Quisque nulla sapien, semper eget odio ut, auctor maximus ligula. In vitae porttitor nibh. Proin nec arcu vitae nulla pellentesque lacinia quis sit amet nulla. Phasellus varius leo sed fringilla sagittis. Duis luctus, lorem in congue dictum, lectus arcu vulputate erat, quis efficitur sem neque ac odio. Sed luctus viverra purus quis accumsan. Integer a quam facilisis, ullamcorper turpis eu, pharetra dui. Nulla facilisi. Integer vehicula sed est vitae tempus. Vivamus vel tellus id risus sollicitudin rutrum. Suspendisse potenti.\n\nPhasellus ut elementum felis, sed fermentum tortor. Quisque sollicitudin est lacinia, vehicula velit maximus, feugiat neque. Duis finibus condimentum ipsum sed elementum. Quisque ac imperdiet lectus. Morbi a luctus leo. Fusce at sapien tincidunt, volutpat lacus vitae, pharetra mauris. Sed eu blandit arcu, ac luctus diam. Proin nec porta tellus.\n\nQuisque ultricies porta elit sit amet fermentum. Donec luctus, elit consequat cursus semper, elit dui blandit sem, id interdum turpis arcu ornare mi. Proin fermentum enim sed nisi imperdiet blandit. Vivamus iaculis, ipsum ac vulputate rutrum, purus metus mattis justo, ut molestie est eros sit amet tellus. Nulla non eros fringilla, pulvinar lorem et, consequat felis. Vivamus vulputate placerat consequat. Phasellus ut quam justo. Nunc vestibulum eros lacus, et blandit enim tincidunt in. Sed dignissim orci nisi, vitae ullamcorper ex fermentum eget. Aenean volutpat egestas dolor, in vulputate nisi cursus gravida. Vestibulum eget scelerisque nisi. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis vestibulum commodo ipsum. Mauris vitae mollis diam. Nulla pulvinar quis neque accumsan eleifend. Nullam sollicitudin vel nibh nec rhoncus. In hac habitasse platea dictumst. Etiam tristique elementum est non feugiat. Sed vitae porta tortor. Nulla in gravida nisi, eget suscipit lacus. Nunc iaculis semper rutrum. Morbi facilisis tristique interdum. Aenean elementum, nulla id pulvinar feugiat, nunc nunc pulvinar ante, tristique tristique lorem lacus ac ante.\n\nFusce ac nibh ac magna iaculis elementum eu id tellus. Nulla luctus at magna quis suscipit. Donec vel volutpat dolor, ac convallis arcu. Duis bibendum arcu leo, id efficitur urna bibendum sed. Integer id consectetur metus. Nam accumsan libero nec leo vestibulum imperdiet. Donec tincidunt vitae ex id dignissim.\n\nQuisque sed enim eros. Quisque nulla sapien, semper eget odio ut, auctor maximus ligula. In vitae porttitor nibh. Proin nec arcu vitae nulla pellentesque lacinia quis sit amet nulla. Phasellus varius leo sed fringilla sagittis. Duis luctus, lorem in congue dictum, lectus arcu vulputate erat, quis efficitur sem neque ac odio. Sed luctus viverra purus quis accumsan. Integer a quam facilisis, ullamcorper turpis eu, pharetra dui. Nulla facilisi. Integer vehicula sed est vitae tempus. Vivamus vel tellus id risus sollicitudin rutrum. Suspendisse potenti.\n\nPhasellus ut elementum felis, sed fermentum tortor. Quisque sollicitudin est lacinia, vehicula velit maximus, feugiat neque. Duis finibus condimentum ipsum sed elementum. Quisque ac imperdiet lectus. Morbi a luctus leo. Fusce at sapien tincidunt, volutpat lacus vitae, pharetra mauris. Sed eu blandit arcu, ac luctus diam. Proin nec porta tellus.\n\nQuisque ultricies porta elit sit amet fermentum. Donec luctus, elit consequat cursus semper, elit dui blandit sem, id interdum turpis arcu ornare mi. Proin fermentum enim sed nisi imperdiet blandit. Vivamus iaculis, ipsum ac vulputate rutrum, purus metus mattis justo, ut molestie est eros sit amet tellus. Nulla non eros fringilla, pulvinar lorem et, consequat felis. Vivamus vulputate placerat consequat. Phasellus ut quam justo. Nunc vestibulum eros lacus, et blandit enim tincidunt in. Sed dignissim orci nisi, vitae ullamcorper ex fermentum eget. Aenean volutpat egestas dolor, in vulputate nisi cursus gravida. Vestibulum eget scelerisque nisi."
