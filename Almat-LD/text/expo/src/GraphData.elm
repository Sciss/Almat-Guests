module GraphData exposing (cloud)

import Graph


cloud =
    Graph.fromNodeLabelsAndEdgePairs
        [ "Synchronization"
        , "Epistemic object"
        , "Contingency"
        , "Entanglement"
        , "Site"
        , "Aesthetic experience"
        , "Computation"
        , "Iterativity"
        , "Formats"
        , "Speculation"
        ]
        [ ( 0, 1 )
        , ( 0, 2 )
        , ( 0, 6 )
        , ( 1, 3 )
        , ( 2, 4 )
        , ( 2, 5 )
        , ( 2, 5 )
        , ( 3, 4 )
        , ( 3, 5 )
        , ( 6, 2 )
        , ( 7, 8 )
        , ( 7, 6 )
        , ( 8, 1 )
        , ( 8, 4 )
        , ( 8, 2 )
        , ( 9, 6 )
        , ( 9, 2 )
        ]
