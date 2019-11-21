module SampleData exposing (CrimeRate, Gender(..), Population, crimeRates, miserablesGraph, norwegianCarSales, norwegianCarSalesMiddlePlayers, populationMinnesota1850, timeSeries)

import Dict exposing (Dict)
import Graph
import Time


timeSeries : List ( Time.Posix, Float )
timeSeries =
    [ ( Time.millisToPosix 1448928000000, 2.5 )
    , ( Time.millisToPosix 1451606400000, 2 )
    , ( Time.millisToPosix 1452211200000, 3.5 )
    , ( Time.millisToPosix 1452816000000, 2 )
    , ( Time.millisToPosix 1453420800000, 3 )
    , ( Time.millisToPosix 1454284800000, 1 )
    , ( Time.millisToPosix 1456790400000, 1.2 )
    ]


type alias CrimeRate =
    { year : Int
    , population : Int
    , murder : Int
    , rape : Int
    , robbery : Int
    , assault : Int
    , burglary : Int
    , larceny : Int
    , motorTheft : Int
    }


crimeRates : List CrimeRate
crimeRates =
    [ CrimeRate 1994 260327021 23326 102216 618949 1113179 2712774 7879812 1539287
    , CrimeRate 1995 262803276 21606 97470 580509 1099207 2593784 7997710 1472441
    , CrimeRate 1996 265228572 19645 96252 535594 1037049 2506400 7904685 1394238
    , CrimeRate 1997 267783607 18208 96153 498534 1023201 2460526 7743760 1354189
    , CrimeRate 1998 270248003 16974 93144 447186 976583 2332735 7376311 1242781
    , CrimeRate 1999 272690813 15522 89411 409371 911740 2100739 6955520 1152075
    , CrimeRate 2000 281421906 15586 90178 408016 911706 2050992 6971590 1160002
    , CrimeRate 2001 285317559 16037 90863 423557 909023 2116531 7092267 1228391
    , CrimeRate 2002 287973924 16229 95235 420806 891407 2151252 7057379 1246646
    , CrimeRate 2003 290788976 16528 93883 414235 859030 2154834 7026802 1261226
    , CrimeRate 2004 293656842 16148 95089 401470 847381 2144446 6937089 1237851
    , CrimeRate 2005 296507061 16740 94347 417438 862220 2155448 6783447 1235859
    , CrimeRate 2006 299398484 17309 94472 449246 874096 2194993 6626363 1198245
    , CrimeRate 2007 301621157 17128 92160 447324 866358 2190198 6591542 1100472
    , CrimeRate 2008 304059724 16465 90750 443563 843683 2228887 6586206 959059
    , CrimeRate 2009 307006550 15399 89241 408742 812514 2203313 6338095 795652
    , CrimeRate 2010 309330219 14722 85593 369089 781844 2168459 6204601 739565
    , CrimeRate 2011 311587816 14661 84175 354746 752423 2185140 6151095 716508
    , CrimeRate 2012 313873685 14856 85141 355051 762009 2109932 6168874 723186
    , CrimeRate 2013 316128839 14196 79770 345031 724149 1928465 6004453 699594
    ]


type Gender
    = M
    | F


type alias Population =
    { year : Int, age : Int, gender : Gender, people : Int }


populationMinnesota1850 : List Population
populationMinnesota1850 =
    [ Population 1850 0 M 1483789
    , Population 1850 0 F 1450376
    , Population 1850 5 M 1411067
    , Population 1850 5 F 1359668
    , Population 1850 10 M 1260099
    , Population 1850 10 F 1216114
    , Population 1850 15 M 1077133
    , Population 1850 15 F 1110619
    , Population 1850 20 M 1017281
    , Population 1850 20 F 1003841
    , Population 1850 25 M 862547
    , Population 1850 25 F 799482
    , Population 1850 30 M 730638
    , Population 1850 30 F 639636
    , Population 1850 35 M 588487
    , Population 1850 35 F 505012
    , Population 1850 40 M 475911
    , Population 1850 40 F 428185
    , Population 1850 45 M 384211
    , Population 1850 45 F 341254
    , Population 1850 50 M 321343
    , Population 1850 50 F 286580
    , Population 1850 55 M 194080
    , Population 1850 55 F 187208
    , Population 1850 60 M 174976
    , Population 1850 60 F 162236
    , Population 1850 65 M 106827
    , Population 1850 65 F 105534
    , Population 1850 70 M 73677
    , Population 1850 70 F 71762
    , Population 1850 75 M 40834
    , Population 1850 75 F 40229
    , Population 1850 80 M 23449
    , Population 1850 80 F 22949
    , Population 1850 85 M 8186
    , Population 1850 85 F 10511
    , Population 1850 90 M 5259
    , Population 1850 90 F 6569
    ]


miserablesGraph =
    Graph.fromNodeLabelsAndEdgePairs
        [ "Myriel"
        , "Napoleon"
        , "Mlle.Baptistine"
        , "Mme.Magloire"
        , "CountessdeLo"
        , "Geborand"
        , "Champtercier"
        , "Cravatte"
        , "Count"
        , "OldMan"
        , "Labarre"
        , "Valjean"
        , "Marguerite"
        , "Mme.deR"
        , "Isabeau"
        , "Gervais"
        , "Tholomyes"
        , "Listolier"
        , "Fameuil"
        , "Blacheville"
        , "Favourite"
        , "Dahlia"
        , "Zephine"
        , "Fantine"
        , "Mme.Thenardier"
        , "Thenardier"
        , "Cosette"
        , "Javert"
        , "Fauchelevent"
        , "Bamatabois"
        , "Perpetue"
        , "Simplice"
        , "Scaufflaire"
        , "Woman1"
        , "Judge"
        , "Champmathieu"
        , "Brevet"
        , "Chenildieu"
        , "Cochepaille"
        , "Pontmercy"
        , "Boulatruelle"
        , "Eponine"
        , "Anzelma"
        , "Woman2"
        , "MotherInnocent"
        , "Gribier"
        , "Jondrette"
        , "Mme.Burgon"
        , "Gavroche"
        , "Gillenormand"
        , "Magnon"
        , "Mlle.Gillenormand"
        , "Mme.Pontmercy"
        , "Mlle.Vaubois"
        , "Lt.Gillenormand"
        , "Marius"
        , "BaronessT"
        , "Mabeuf"
        , "Enjolras"
        , "Combeferre"
        , "Prouvaire"
        , "Feuilly"
        , "Courfeyrac"
        , "Bahorel"
        , "Bossuet"
        , "Joly"
        , "Grantaire"
        , "MotherPlutarch"
        , "Gueulemer"
        , "Babet"
        , "Claquesous"
        , "Montparnasse"
        , "Toussaint"
        , "Child1"
        , "Child2"
        , "Brujon"
        , "Mme.Hucheloup"
        ]
        [ ( 1, 0 )
        , ( 2, 0 )
        , ( 3, 0 )
        , ( 3, 2 )
        , ( 4, 0 )
        , ( 5, 0 )
        , ( 6, 0 )
        , ( 7, 0 )
        , ( 8, 0 )
        , ( 9, 0 )
        , ( 11, 10 )
        , ( 11, 3 )
        , ( 11, 2 )
        , ( 11, 0 )
        , ( 12, 11 )
        , ( 13, 11 )
        , ( 14, 11 )
        , ( 15, 11 )
        , ( 17, 16 )
        , ( 18, 16 )
        , ( 18, 17 )
        , ( 19, 16 )
        , ( 19, 17 )
        , ( 19, 18 )
        , ( 20, 16 )
        , ( 20, 17 )
        , ( 20, 18 )
        , ( 20, 19 )
        , ( 21, 16 )
        , ( 21, 17 )
        , ( 21, 18 )
        , ( 21, 19 )
        , ( 21, 20 )
        , ( 22, 16 )
        , ( 22, 17 )
        , ( 22, 18 )
        , ( 22, 19 )
        , ( 22, 20 )
        , ( 22, 21 )
        , ( 23, 16 )
        , ( 23, 17 )
        , ( 23, 18 )
        , ( 23, 19 )
        , ( 23, 20 )
        , ( 23, 21 )
        , ( 23, 22 )
        , ( 23, 12 )
        , ( 23, 11 )
        , ( 24, 23 )
        , ( 24, 11 )
        , ( 25, 24 )
        , ( 25, 23 )
        , ( 25, 11 )
        , ( 26, 24 )
        , ( 26, 11 )
        , ( 26, 16 )
        , ( 26, 25 )
        , ( 27, 11 )
        , ( 27, 23 )
        , ( 27, 25 )
        , ( 27, 24 )
        , ( 27, 26 )
        , ( 28, 11 )
        , ( 28, 27 )
        , ( 29, 23 )
        , ( 29, 27 )
        , ( 29, 11 )
        , ( 30, 23 )
        , ( 31, 30 )
        , ( 31, 11 )
        , ( 31, 23 )
        , ( 31, 27 )
        , ( 32, 11 )
        , ( 33, 11 )
        , ( 33, 27 )
        , ( 34, 11 )
        , ( 34, 29 )
        , ( 35, 11 )
        , ( 35, 34 )
        , ( 35, 29 )
        , ( 36, 34 )
        , ( 36, 35 )
        , ( 36, 11 )
        , ( 36, 29 )
        , ( 37, 34 )
        , ( 37, 35 )
        , ( 37, 36 )
        , ( 37, 11 )
        , ( 37, 29 )
        , ( 38, 34 )
        , ( 38, 35 )
        , ( 38, 36 )
        , ( 38, 37 )
        , ( 38, 11 )
        , ( 38, 29 )
        , ( 39, 25 )
        , ( 40, 25 )
        , ( 41, 24 )
        , ( 41, 25 )
        , ( 42, 41 )
        , ( 42, 25 )
        , ( 42, 24 )
        , ( 43, 11 )
        , ( 43, 26 )
        , ( 43, 27 )
        , ( 44, 28 )
        , ( 44, 11 )
        , ( 45, 28 )
        , ( 47, 46 )
        , ( 48, 47 )
        , ( 48, 25 )
        , ( 48, 27 )
        , ( 48, 11 )
        , ( 49, 26 )
        , ( 49, 11 )
        , ( 50, 49 )
        , ( 50, 24 )
        , ( 51, 49 )
        , ( 51, 26 )
        , ( 51, 11 )
        , ( 52, 51 )
        , ( 52, 39 )
        , ( 53, 51 )
        , ( 54, 51 )
        , ( 54, 49 )
        , ( 54, 26 )
        , ( 55, 51 )
        , ( 55, 49 )
        , ( 55, 39 )
        , ( 55, 54 )
        , ( 55, 26 )
        , ( 55, 11 )
        , ( 55, 16 )
        , ( 55, 25 )
        , ( 55, 41 )
        , ( 55, 48 )
        , ( 56, 49 )
        , ( 56, 55 )
        , ( 57, 55 )
        , ( 57, 41 )
        , ( 57, 48 )
        , ( 58, 55 )
        , ( 58, 48 )
        , ( 58, 27 )
        , ( 58, 57 )
        , ( 58, 11 )
        , ( 59, 58 )
        , ( 59, 55 )
        , ( 59, 48 )
        , ( 59, 57 )
        , ( 60, 48 )
        , ( 60, 58 )
        , ( 60, 59 )
        , ( 61, 48 )
        , ( 61, 58 )
        , ( 61, 60 )
        , ( 61, 59 )
        , ( 61, 57 )
        , ( 61, 55 )
        , ( 62, 55 )
        , ( 62, 58 )
        , ( 62, 59 )
        , ( 62, 48 )
        , ( 62, 57 )
        , ( 62, 41 )
        , ( 62, 61 )
        , ( 62, 60 )
        , ( 63, 59 )
        , ( 63, 48 )
        , ( 63, 62 )
        , ( 63, 57 )
        , ( 63, 58 )
        , ( 63, 61 )
        , ( 63, 60 )
        , ( 63, 55 )
        , ( 64, 55 )
        , ( 64, 62 )
        , ( 64, 48 )
        , ( 64, 63 )
        , ( 64, 58 )
        , ( 64, 61 )
        , ( 64, 60 )
        , ( 64, 59 )
        , ( 64, 57 )
        , ( 64, 11 )
        , ( 65, 63 )
        , ( 65, 64 )
        , ( 65, 48 )
        , ( 65, 62 )
        , ( 65, 58 )
        , ( 65, 61 )
        , ( 65, 60 )
        , ( 65, 59 )
        , ( 65, 57 )
        , ( 65, 55 )
        , ( 66, 64 )
        , ( 66, 58 )
        , ( 66, 59 )
        , ( 66, 62 )
        , ( 66, 65 )
        , ( 66, 48 )
        , ( 66, 63 )
        , ( 66, 61 )
        , ( 66, 60 )
        , ( 67, 57 )
        , ( 68, 25 )
        , ( 68, 11 )
        , ( 68, 24 )
        , ( 68, 27 )
        , ( 68, 48 )
        , ( 68, 41 )
        , ( 69, 25 )
        , ( 69, 68 )
        , ( 69, 11 )
        , ( 69, 24 )
        , ( 69, 27 )
        , ( 69, 48 )
        , ( 69, 41 )
        , ( 70, 25 )
        , ( 70, 69 )
        , ( 70, 68 )
        , ( 70, 11 )
        , ( 70, 24 )
        , ( 70, 27 )
        , ( 70, 41 )
        , ( 70, 58 )
        , ( 71, 27 )
        , ( 71, 69 )
        , ( 71, 68 )
        , ( 71, 70 )
        , ( 71, 11 )
        , ( 71, 48 )
        , ( 71, 41 )
        , ( 71, 25 )
        , ( 72, 26 )
        , ( 72, 27 )
        , ( 72, 11 )
        , ( 73, 48 )
        , ( 74, 48 )
        , ( 74, 73 )
        , ( 75, 69 )
        , ( 75, 68 )
        , ( 75, 25 )
        , ( 75, 48 )
        , ( 75, 41 )
        , ( 75, 70 )
        , ( 75, 71 )
        , ( 76, 64 )
        , ( 76, 65 )
        , ( 76, 66 )
        , ( 76, 63 )
        , ( 76, 62 )
        , ( 76, 48 )
        , ( 76, 58 )
        ]


norwegianCarSalesMiddlePlayers : List ( String, List Float )
norwegianCarSalesMiddlePlayers =
    let
        emptyYear : List Float
        emptyYear =
            List.repeat 12 0

        yearValues : unused -> Dict Int (Dict Int Float) -> List Float
        yearValues make years =
            List.range 2007 2016
                |> List.map (yearValue (Dict.map monthValues years))
                |> List.concat

        yearValue : Dict comparable (List Float) -> comparable -> List Float
        yearValue year index =
            Dict.get index year
                |> Maybe.withDefault emptyYear

        monthValues : unused -> Dict Int Float -> List Float
        monthValues year months =
            List.range 1 12
                |> List.map (monthValue months)

        monthValue : Dict Int Float -> Int -> Float
        monthValue months index =
            Dict.get index months
                |> Maybe.withDefault 0
    in
    -- first, for every make convert the nested dict into a rectangular matrix (size: length data x 12), padding with 0s when data is missing
    -- then, sort and select the middle brands:
    -- they have more variation, which makes for a more interesting graph.
    norwegianCarSales
        |> Dict.map yearValues
        |> Dict.toList
        |> List.sortBy (Tuple.second >> List.sum >> negate)
        |> List.drop 4
        |> List.take 8


{-| Subset of a kaggle dataset

<https://www.kaggle.com/dmi3kno/newcarsalesnorway>

which in turn is based on (I assume scraped from)

<http://www.ofvas.no/bilsalget/category404.html>

-}
norwegianCarSales : Dict String (Dict Int (Dict Int Float))
norwegianCarSales =
    Dict.fromList
        [ ( "Audi"
          , Dict.fromList
                [ ( 2007, Dict.fromList [ ( 1, 471 ), ( 2, 356 ), ( 3, 423 ), ( 4, 390 ), ( 5, 437 ), ( 6, 345 ), ( 7, 424 ), ( 8, 379 ), ( 9, 280 ), ( 10, 374 ), ( 11, 118 ), ( 12, 139 ) ] )
                , ( 2008, Dict.fromList [ ( 1, 157 ), ( 2, 200 ), ( 3, 235 ), ( 4, 504 ), ( 5, 467 ), ( 6, 555 ), ( 7, 504 ), ( 8, 491 ), ( 9, 435 ), ( 10, 457 ), ( 11, 341 ), ( 12, 388 ) ] )
                , ( 2009, Dict.fromList [ ( 1, 89 ), ( 2, 138 ), ( 3, 160 ), ( 4, 148 ), ( 5, 151 ), ( 6, 186 ), ( 7, 246 ), ( 8, 224 ), ( 9, 133 ), ( 10, 217 ), ( 11, 226 ), ( 12, 257 ) ] )
                , ( 2010, Dict.fromList [ ( 1, 176 ), ( 2, 143 ), ( 3, 207 ), ( 4, 494 ), ( 5, 388 ), ( 6, 343 ), ( 7, 248 ), ( 8, 237 ), ( 9, 144 ), ( 10, 178 ), ( 11, 205 ), ( 12, 161 ) ] )
                , ( 2011, Dict.fromList [ ( 4, 175 ), ( 5, 242 ), ( 6, 203 ), ( 7, 192 ), ( 8, 193 ), ( 9, 205 ), ( 10, 184 ), ( 11, 178 ), ( 12, 185 ) ] )
                , ( 2012, Dict.fromList [ ( 1, 159 ), ( 6, 143 ), ( 8, 185 ), ( 9, 119 ), ( 10, 160 ), ( 11, 216 ), ( 12, 140 ) ] )
                , ( 2013, Dict.fromList [ ( 1, 179 ), ( 2, 169 ), ( 3, 139 ), ( 4, 247 ), ( 5, 408 ), ( 6, 159 ), ( 7, 407 ), ( 8, 348 ), ( 9, 344 ), ( 10, 372 ), ( 11, 269 ), ( 12, 332 ) ] )
                , ( 2014, Dict.fromList [ ( 1, 151 ), ( 3, 201 ), ( 4, 240 ), ( 5, 219 ), ( 6, 196 ), ( 7, 222 ), ( 8, 200 ), ( 9, 146 ), ( 10, 221 ), ( 11, 157 ), ( 12, 205 ) ] )
                , ( 2015, Dict.fromList [ ( 1, 119 ), ( 2, 207 ), ( 3, 281 ), ( 4, 327 ), ( 5, 303 ), ( 6, 292 ), ( 7, 321 ), ( 8, 198 ), ( 9, 148 ), ( 10, 192 ), ( 11, 209 ), ( 12, 179 ) ] )
                , ( 2016, Dict.fromList [ ( 1, 427 ), ( 2, 416 ), ( 3, 266 ), ( 4, 275 ), ( 5, 266 ), ( 6, 241 ), ( 7, 419 ), ( 8, 164 ), ( 9, 186 ), ( 10, 203 ), ( 11, 270 ), ( 12, 403 ) ] )
                ]
          )
        , ( "BMW"
          , Dict.fromList
                [ ( 2007, Dict.fromList [ ( 1, 183 ), ( 2, 149 ) ] )
                , ( 2008, Dict.fromList [ ( 1, 158 ), ( 2, 184 ), ( 4, 208 ), ( 5, 174 ), ( 6, 207 ), ( 7, 140 ), ( 8, 86 ), ( 9, 219 ), ( 10, 196 ), ( 11, 124 ), ( 12, 189 ) ] )
                , ( 2009, Dict.fromList [ ( 2, 135 ), ( 3, 132 ), ( 4, 133 ), ( 5, 168 ), ( 6, 188 ), ( 7, 169 ), ( 8, 194 ), ( 9, 198 ), ( 10, 175 ), ( 11, 130 ), ( 12, 130 ) ] )
                , ( 2011, Dict.fromList [ ( 1, 168 ), ( 10, 145 ) ] )
                , ( 2012, Dict.fromList [ ( 1, 237 ), ( 2, 132 ), ( 3, 186 ), ( 4, 199 ), ( 5, 223 ), ( 6, 357 ), ( 7, 165 ), ( 8, 139 ), ( 9, 176 ), ( 10, 170 ), ( 11, 298 ), ( 12, 221 ) ] )
                , ( 2013, Dict.fromList [ ( 1, 387 ), ( 5, 449 ), ( 7, 264 ), ( 9, 482 ), ( 10, 114 ), ( 11, 141 ), ( 12, 328 ) ] )
                , ( 2014, Dict.fromList [ ( 1, 421 ), ( 2, 329 ), ( 3, 556 ), ( 4, 452 ), ( 5, 296 ), ( 6, 269 ), ( 7, 265 ), ( 8, 341 ), ( 9, 257 ), ( 10, 130 ), ( 11, 156 ) ] )
                , ( 2015, Dict.fromList [ ( 3, 499 ), ( 4, 453 ), ( 9, 266 ), ( 10, 326 ), ( 11, 293 ), ( 12, 415 ) ] )
                , ( 2016, Dict.fromList [ ( 1, 846 ), ( 2, 676 ), ( 3, 904 ), ( 4, 910 ), ( 5, 306 ), ( 6, 267 ), ( 7, 229 ), ( 8, 293 ), ( 9, 520 ), ( 10, 503 ), ( 11, 1264 ), ( 12, 523 ) ] )
                , ( 2017, Dict.fromList [ ( 1, 1050 ) ] )
                ]
          )
        , ( "Citroen"
          , Dict.fromList
                [ ( 2012, Dict.fromList [ ( 11, 129 ) ] )
                ]
          )
        , ( "Ford"
          , Dict.fromList
                [ ( 2007, Dict.fromList [ ( 1, 631 ), ( 2, 447 ), ( 3, 530 ), ( 4, 264 ), ( 5, 274 ), ( 6, 289 ), ( 7, 773 ), ( 8, 631 ), ( 9, 558 ), ( 10, 558 ), ( 11, 407 ), ( 12, 614 ) ] )
                , ( 2008, Dict.fromList [ ( 1, 761 ), ( 2, 859 ), ( 3, 597 ), ( 4, 696 ), ( 5, 719 ), ( 6, 692 ), ( 7, 758 ), ( 8, 466 ), ( 9, 578 ), ( 10, 514 ), ( 11, 445 ), ( 12, 537 ) ] )
                , ( 2009, Dict.fromList [ ( 1, 422 ), ( 2, 315 ), ( 3, 416 ), ( 4, 333 ), ( 5, 414 ), ( 6, 558 ), ( 7, 534 ), ( 8, 338 ), ( 9, 627 ), ( 10, 673 ), ( 11, 550 ), ( 12, 698 ) ] )
                , ( 2010, Dict.fromList [ ( 1, 700 ), ( 2, 312 ), ( 3, 770 ), ( 4, 420 ), ( 5, 689 ), ( 6, 912 ), ( 7, 708 ), ( 8, 827 ), ( 9, 844 ), ( 10, 620 ), ( 11, 806 ), ( 12, 805 ) ] )
                , ( 2011, Dict.fromList [ ( 1, 451 ), ( 2, 504 ), ( 3, 601 ), ( 4, 468 ), ( 5, 645 ), ( 6, 635 ), ( 7, 560 ), ( 8, 750 ), ( 9, 679 ), ( 10, 736 ), ( 11, 769 ), ( 12, 846 ) ] )
                , ( 2012, Dict.fromList [ ( 1, 433 ), ( 2, 484 ), ( 3, 773 ), ( 4, 424 ), ( 5, 645 ), ( 6, 882 ), ( 7, 587 ), ( 8, 568 ), ( 9, 601 ), ( 10, 581 ), ( 11, 434 ), ( 12, 548 ) ] )
                , ( 2013, Dict.fromList [ ( 1, 317 ), ( 2, 253 ), ( 3, 264 ), ( 4, 325 ), ( 5, 805 ), ( 6, 295 ), ( 7, 551 ), ( 8, 258 ), ( 9, 384 ), ( 10, 257 ), ( 11, 203 ), ( 12, 682 ) ] )
                , ( 2014, Dict.fromList [ ( 1, 152 ), ( 4, 266 ), ( 5, 159 ), ( 6, 239 ), ( 7, 150 ), ( 8, 144 ), ( 9, 161 ), ( 10, 139 ), ( 11, 219 ), ( 12, 190 ) ] )
                , ( 2015, Dict.fromList [ ( 1, 414 ), ( 2, 452 ), ( 3, 769 ), ( 4, 607 ), ( 5, 474 ), ( 6, 395 ), ( 7, 350 ), ( 8, 486 ), ( 9, 353 ), ( 10, 306 ), ( 11, 385 ), ( 12, 348 ) ] )
                , ( 2016, Dict.fromList [ ( 1, 702 ), ( 2, 703 ), ( 3, 645 ), ( 4, 645 ), ( 5, 269 ), ( 6, 319 ), ( 7, 111 ), ( 8, 124 ) ] )
                ]
          )
        , ( "Honda"
          , Dict.fromList
                [ ( 2007, Dict.fromList [ ( 1, 172 ), ( 2, 225 ), ( 3, 266 ), ( 4, 215 ), ( 5, 349 ), ( 6, 468 ), ( 7, 233 ), ( 8, 146 ), ( 9, 190 ), ( 10, 262 ), ( 11, 314 ), ( 12, 335 ) ] )
                , ( 2008, Dict.fromList [ ( 1, 397 ), ( 2, 219 ), ( 3, 151 ), ( 4, 248 ), ( 5, 191 ), ( 6, 136 ), ( 7, 145 ), ( 8, 121 ), ( 9, 122 ), ( 10, 91 ), ( 11, 102 ), ( 12, 198 ) ] )
                , ( 2009, Dict.fromList [ ( 2, 131 ), ( 3, 214 ), ( 4, 125 ), ( 5, 123 ), ( 6, 109 ), ( 7, 173 ), ( 8, 99 ), ( 9, 72 ), ( 10, 71 ) ] )
                , ( 2012, Dict.fromList [ ( 11, 138 ), ( 12, 125 ) ] )
                , ( 2013, Dict.fromList [ ( 1, 204 ), ( 2, 227 ), ( 3, 214 ), ( 4, 205 ), ( 5, 164 ), ( 6, 132 ), ( 7, 76 ), ( 8, 121 ), ( 12, 178 ) ] )
                ]
          )
        , ( "Hyundai"
          , Dict.fromList
                [ ( 2009, Dict.fromList [ ( 3, 141 ), ( 6, 147 ), ( 7, 165 ), ( 8, 165 ), ( 9, 123 ), ( 10, 125 ) ] )
                , ( 2012, Dict.fromList [ ( 6, 257 ), ( 12, 116 ) ] )
                , ( 2013, Dict.fromList [ ( 7, 133 ), ( 9, 112 ), ( 12, 70 ) ] )
                , ( 2015, Dict.fromList [ ( 1, 217 ), ( 2, 76 ), ( 3, 106 ) ] )
                , ( 2016, Dict.fromList [ ( 1, 95 ), ( 2, 54 ), ( 7, 152 ) ] )
                ]
          )
        , ( "Kia"
          , Dict.fromList
                [ ( 2012, Dict.fromList [ ( 2, 154 ), ( 6, 164 ), ( 8, 174 ), ( 9, 118 ), ( 11, 369 ), ( 12, 113 ) ] )
                , ( 2013, Dict.fromList [ ( 2, 175 ), ( 7, 136 ), ( 9, 196 ), ( 12, 213 ) ] )
                , ( 2015, Dict.fromList [ ( 3, 141 ), ( 4, 137 ) ] )
                , ( 2016, Dict.fromList [ ( 1, 103 ), ( 2, 293 ), ( 3, 141 ), ( 4, 149 ), ( 7, 106 ) ] )
                , ( 2017, Dict.fromList [ ( 1, 214 ) ] )
                ]
          )
        , ( "Mazda"
          , Dict.fromList
                [ ( 2008, Dict.fromList [ ( 6, 189 ), ( 7, 228 ), ( 8, 195 ), ( 9, 202 ), ( 10, 153 ), ( 11, 109 ), ( 12, 87 ) ] )
                , ( 2009, Dict.fromList [ ( 1, 97 ), ( 2, 127 ), ( 3, 248 ), ( 4, 103 ), ( 5, 54 ), ( 6, 123 ), ( 7, 89 ), ( 8, 90 ), ( 9, 164 ), ( 10, 68 ) ] )
                , ( 2012, Dict.fromList [ ( 6, 204 ), ( 11, 137 ), ( 12, 226 ) ] )
                , ( 2013, Dict.fromList [ ( 1, 490 ), ( 2, 497 ), ( 3, 489 ), ( 4, 243 ), ( 5, 167 ), ( 6, 336 ), ( 7, 502 ), ( 8, 506 ), ( 9, 421 ), ( 10, 299 ), ( 11, 250 ), ( 12, 187 ) ] )
                , ( 2014, Dict.fromList [ ( 1, 406 ), ( 2, 214 ), ( 3, 389 ), ( 4, 229 ), ( 5, 366 ), ( 6, 283 ), ( 7, 323 ), ( 8, 360 ), ( 9, 361 ), ( 10, 331 ), ( 11, 368 ), ( 12, 216 ) ] )
                , ( 2015, Dict.fromList [ ( 1, 252 ), ( 2, 180 ), ( 3, 180 ), ( 4, 355 ), ( 5, 286 ), ( 6, 358 ), ( 7, 248 ), ( 8, 225 ), ( 9, 256 ), ( 10, 281 ), ( 11, 262 ), ( 12, 285 ) ] )
                , ( 2016, Dict.fromList [ ( 1, 492 ), ( 2, 500 ), ( 3, 369 ), ( 4, 398 ), ( 5, 399 ), ( 6, 465 ), ( 7, 354 ), ( 8, 395 ), ( 9, 428 ), ( 10, 422 ), ( 11, 326 ), ( 12, 393 ) ] )
                ]
          )
        , ( "Mercedes-Benz"
          , Dict.fromList
                [ ( 2012, Dict.fromList [ ( 11, 149 ), ( 12, 436 ) ] )
                , ( 2013, Dict.fromList [ ( 2, 281 ), ( 3, 221 ), ( 4, 260 ), ( 5, 368 ), ( 6, 81 ), ( 7, 112 ), ( 8, 148 ), ( 9, 107 ), ( 10, 121 ), ( 11, 151 ), ( 12, 595 ) ] )
                , ( 2015, Dict.fromList [ ( 1, 178 ), ( 2, 172 ), ( 3, 224 ), ( 4, 392 ), ( 5, 144 ), ( 6, 142 ), ( 7, 263 ), ( 8, 346 ), ( 9, 153 ), ( 10, 108 ), ( 11, 141 ), ( 12, 159 ) ] )
                , ( 2016, Dict.fromList [ ( 1, 386 ), ( 2, 342 ), ( 3, 461 ), ( 4, 380 ), ( 5, 365 ), ( 6, 359 ), ( 7, 251 ), ( 8, 300 ), ( 9, 466 ), ( 10, 326 ), ( 11, 232 ), ( 12, 200 ) ] )
                , ( 2017, Dict.fromList [ ( 1, 285 ) ] )
                ]
          )
        , ( "Mitsubishi"
          , Dict.fromList
                [ ( 2007, Dict.fromList [ ( 8, 524 ), ( 9, 410 ), ( 10, 236 ), ( 11, 118 ), ( 12, 226 ) ] )
                , ( 2008, Dict.fromList [ ( 1, 232 ), ( 2, 257 ), ( 3, 430 ), ( 4, 474 ), ( 5, 205 ), ( 6, 180 ), ( 7, 194 ), ( 8, 135 ), ( 9, 182 ), ( 10, 125 ), ( 11, 110 ), ( 12, 149 ) ] )
                , ( 2009, Dict.fromList [ ( 3, 150 ), ( 4, 100 ) ] )
                , ( 2010, Dict.fromList [ ( 2, 233 ), ( 3, 198 ), ( 4, 265 ), ( 5, 236 ), ( 6, 217 ), ( 7, 199 ), ( 8, 141 ), ( 9, 122 ), ( 10, 123 ), ( 11, 283 ), ( 12, 252 ) ] )
                , ( 2011, Dict.fromList [ ( 1, 202 ), ( 2, 222 ), ( 3, 336 ), ( 4, 642 ), ( 5, 577 ), ( 6, 363 ), ( 7, 477 ), ( 8, 338 ), ( 9, 107 ), ( 10, 133 ), ( 11, 382 ), ( 12, 415 ) ] )
                , ( 2012, Dict.fromList [ ( 1, 238 ), ( 2, 171 ), ( 3, 186 ), ( 4, 200 ), ( 5, 240 ), ( 6, 176 ), ( 7, 182 ), ( 8, 185 ), ( 9, 159 ), ( 10, 133 ), ( 11, 312 ), ( 12, 262 ) ] )
                , ( 2013, Dict.fromList [ ( 1, 392 ), ( 2, 267 ), ( 3, 234 ), ( 4, 387 ), ( 5, 396 ), ( 6, 260 ), ( 7, 228 ), ( 8, 188 ), ( 9, 165 ), ( 10, 177 ), ( 11, 145 ), ( 12, 305 ) ] )
                , ( 2014, Dict.fromList [ ( 1, 174 ), ( 2, 238 ), ( 3, 341 ), ( 4, 311 ), ( 5, 248 ), ( 6, 211 ), ( 7, 217 ), ( 8, 280 ), ( 9, 346 ), ( 10, 229 ), ( 11, 230 ), ( 12, 163 ) ] )
                , ( 2015, Dict.fromList [ ( 1, 326 ), ( 2, 157 ), ( 3, 204 ), ( 4, 280 ), ( 5, 399 ), ( 6, 487 ), ( 7, 126 ), ( 8, 88 ), ( 9, 222 ), ( 10, 527 ), ( 11, 578 ), ( 12, 561 ) ] )
                , ( 2016, Dict.fromList [ ( 1, 145 ), ( 2, 553 ), ( 3, 739 ), ( 4, 569 ), ( 5, 553 ), ( 6, 590 ), ( 7, 552 ), ( 8, 405 ), ( 9, 455 ), ( 10, 365 ), ( 11, 406 ), ( 12, 355 ) ] )
                ]
          )
        , ( "Nissan"
          , Dict.fromList
                [ ( 2007, Dict.fromList [ ( 11, 333 ) ] )
                , ( 2008, Dict.fromList [ ( 1, 424 ), ( 2, 543 ), ( 3, 402 ), ( 4, 385 ), ( 5, 428 ), ( 6, 447 ), ( 7, 268 ), ( 8, 193 ), ( 9, 209 ), ( 10, 246 ), ( 11, 204 ), ( 12, 200 ) ] )
                , ( 2009, Dict.fromList [ ( 1, 130 ), ( 2, 142 ), ( 3, 182 ), ( 4, 166 ), ( 5, 162 ), ( 6, 202 ), ( 7, 325 ), ( 8, 323 ), ( 9, 302 ), ( 10, 307 ), ( 11, 291 ), ( 12, 231 ) ] )
                , ( 2010, Dict.fromList [ ( 1, 279 ), ( 2, 257 ), ( 3, 381 ), ( 4, 386 ), ( 5, 381 ), ( 6, 424 ), ( 7, 312 ), ( 8, 280 ), ( 9, 367 ), ( 10, 315 ), ( 11, 306 ), ( 12, 182 ) ] )
                , ( 2011, Dict.fromList [ ( 1, 303 ), ( 2, 272 ), ( 3, 282 ), ( 4, 258 ), ( 5, 349 ), ( 6, 307 ), ( 7, 305 ), ( 8, 262 ), ( 9, 430 ), ( 10, 325 ), ( 11, 271 ), ( 12, 206 ) ] )
                , ( 2012, Dict.fromList [ ( 1, 541 ), ( 2, 439 ), ( 3, 472 ), ( 4, 310 ), ( 5, 439 ), ( 6, 365 ), ( 7, 449 ), ( 8, 445 ), ( 9, 481 ), ( 10, 516 ), ( 11, 478 ), ( 12, 260 ) ] )
                , ( 2013, Dict.fromList [ ( 1, 542 ), ( 2, 482 ), ( 3, 556 ), ( 4, 721 ), ( 5, 591 ), ( 6, 570 ), ( 7, 557 ), ( 8, 648 ), ( 9, 532 ), ( 10, 956 ), ( 11, 643 ), ( 12, 433 ) ] )
                , ( 2014, Dict.fromList [ ( 1, 650 ), ( 2, 776 ), ( 3, 828 ), ( 4, 785 ), ( 5, 700 ), ( 6, 521 ), ( 7, 572 ), ( 8, 599 ), ( 9, 556 ), ( 10, 668 ), ( 11, 502 ), ( 12, 499 ) ] )
                , ( 2015, Dict.fromList [ ( 1, 740 ), ( 2, 657 ), ( 3, 798 ), ( 4, 314 ), ( 5, 364 ), ( 6, 493 ), ( 7, 624 ), ( 8, 536 ), ( 9, 738 ), ( 10, 577 ), ( 11, 297 ), ( 12, 138 ) ] )
                , ( 2016, Dict.fromList [ ( 1, 571 ), ( 2, 752 ), ( 3, 867 ), ( 4, 667 ), ( 5, 452 ), ( 6, 472 ), ( 7, 420 ), ( 8, 449 ), ( 9, 345 ), ( 10, 526 ), ( 11, 456 ), ( 12, 409 ) ] )
                , ( 2017, Dict.fromList [ ( 1, 352 ) ] )
                ]
          )
        , ( "Opel"
          , Dict.fromList
                [ ( 2007, Dict.fromList [ ( 1, 396 ), ( 2, 221 ), ( 3, 211 ), ( 4, 152 ), ( 5, 187 ), ( 6, 214 ), ( 7, 205 ), ( 8, 146 ), ( 9, 150 ), ( 10, 164 ), ( 11, 154 ), ( 12, 130 ) ] )
                , ( 2009, Dict.fromList [ ( 1, 117 ), ( 2, 86 ), ( 3, 156 ), ( 4, 197 ), ( 5, 237 ), ( 6, 281 ), ( 7, 236 ), ( 8, 116 ), ( 9, 132 ), ( 10, 167 ), ( 11, 143 ), ( 12, 147 ) ] )
                , ( 2010, Dict.fromList [ ( 3, 202 ), ( 4, 211 ), ( 5, 164 ), ( 6, 213 ), ( 7, 134 ), ( 8, 144 ), ( 9, 90 ) ] )
                , ( 2011, Dict.fromList [ ( 1, 168 ), ( 2, 136 ), ( 3, 213 ), ( 4, 172 ), ( 5, 191 ), ( 6, 168 ), ( 7, 176 ), ( 8, 147 ), ( 9, 111 ), ( 11, 114 ), ( 12, 81 ) ] )
                , ( 2013, Dict.fromList [ ( 5, 238 ), ( 6, 110 ), ( 12, 233 ) ] )
                , ( 2015, Dict.fromList [ ( 3, 31 ), ( 4, 30 ) ] )
                , ( 2016, Dict.fromList [ ( 1, 133 ), ( 2, 177 ), ( 3, 83 ), ( 4, 170 ), ( 5, 188 ), ( 6, 225 ), ( 7, 192 ) ] )
                ]
          )
        , ( "Peugeot"
          , Dict.fromList
                [ ( 2007, Dict.fromList [ ( 1, 801 ), ( 2, 493 ), ( 3, 600 ), ( 4, 409 ), ( 5, 556 ), ( 6, 421 ), ( 7, 570 ), ( 8, 372 ), ( 9, 291 ), ( 10, 491 ), ( 11, 327 ), ( 12, 112 ) ] )
                , ( 2008, Dict.fromList [ ( 1, 337 ), ( 2, 144 ), ( 3, 130 ), ( 4, 213 ), ( 5, 379 ), ( 6, 138 ), ( 7, 405 ), ( 8, 350 ), ( 9, 243 ), ( 10, 328 ), ( 11, 260 ), ( 12, 73 ) ] )
                , ( 2009, Dict.fromList [ ( 1, 209 ), ( 2, 204 ), ( 3, 278 ), ( 4, 402 ), ( 5, 256 ), ( 6, 114 ), ( 7, 138 ), ( 8, 99 ), ( 9, 62 ), ( 10, 69 ), ( 11, 85 ), ( 12, 39 ) ] )
                , ( 2010, Dict.fromList [ ( 1, 718 ), ( 2, 291 ), ( 3, 308 ), ( 4, 220 ), ( 5, 199 ), ( 6, 193 ), ( 7, 201 ), ( 8, 203 ), ( 9, 160 ), ( 10, 183 ), ( 11, 165 ), ( 12, 115 ) ] )
                , ( 2011, Dict.fromList [ ( 1, 167 ), ( 2, 192 ), ( 3, 177 ), ( 4, 222 ), ( 5, 149 ), ( 6, 309 ), ( 7, 365 ), ( 8, 315 ), ( 9, 353 ), ( 11, 312 ), ( 12, 231 ) ] )
                , ( 2012, Dict.fromList [ ( 1, 186 ), ( 2, 169 ), ( 3, 133 ), ( 4, 128 ), ( 5, 198 ), ( 6, 289 ), ( 11, 195 ) ] )
                , ( 2013, Dict.fromList [ ( 1, 374 ), ( 2, 187 ), ( 3, 148 ), ( 5, 331 ), ( 9, 143 ), ( 12, 72 ) ] )
                , ( 2014, Dict.fromList [ ( 1, 343 ), ( 2, 184 ), ( 10, 260 ), ( 12, 206 ) ] )
                , ( 2015, Dict.fromList [ ( 3, 168 ), ( 4, 181 ), ( 5, 196 ), ( 6, 203 ), ( 7, 174 ), ( 8, 145 ), ( 9, 112 ), ( 10, 170 ), ( 11, 136 ) ] )
                , ( 2016, Dict.fromList [ ( 1, 236 ), ( 2, 212 ), ( 3, 142 ), ( 4, 170 ), ( 5, 152 ), ( 6, 153 ), ( 7, 114 ) ] )
                , ( 2017, Dict.fromList [ ( 1, 216 ) ] )
                ]
          )
        , ( "Renault"
          , Dict.fromList
                [ ( 2015, Dict.fromList [ ( 3, 228 ), ( 4, 154 ), ( 6, 431 ), ( 7, 24 ) ] )
                , ( 2016, Dict.fromList [ ( 1, 197 ), ( 2, 50 ), ( 3, 291 ), ( 4, 230 ), ( 5, 64 ), ( 6, 398 ), ( 7, 79 ), ( 8, 15 ), ( 9, 158 ), ( 10, 161 ), ( 11, 100 ) ] )
                , ( 2017, Dict.fromList [ ( 1, 240 ) ] )
                ]
          )
        , ( "Saab"
          , Dict.fromList
                [ ( 2007, Dict.fromList [ ( 3, 214 ), ( 4, 167 ), ( 5, 224 ), ( 6, 161 ), ( 12, 259 ) ] )
                ]
          )
        , ( "Skoda"
          , Dict.fromList
                [ ( 2007, Dict.fromList [ ( 1, 481 ), ( 2, 334 ), ( 3, 295 ), ( 4, 253 ), ( 5, 279 ), ( 6, 295 ), ( 7, 290 ), ( 8, 258 ), ( 9, 192 ), ( 10, 256 ), ( 11, 258 ), ( 12, 308 ) ] )
                , ( 2008, Dict.fromList [ ( 1, 216 ), ( 2, 225 ), ( 3, 415 ), ( 4, 268 ), ( 5, 268 ), ( 6, 220 ), ( 7, 167 ), ( 8, 139 ), ( 9, 152 ), ( 10, 117 ), ( 11, 117 ), ( 12, 181 ) ] )
                , ( 2009, Dict.fromList [ ( 1, 92 ), ( 2, 197 ), ( 3, 236 ), ( 4, 286 ), ( 5, 232 ), ( 6, 182 ), ( 7, 195 ), ( 8, 169 ), ( 9, 194 ), ( 10, 318 ), ( 11, 220 ), ( 12, 211 ) ] )
                , ( 2010, Dict.fromList [ ( 1, 197 ), ( 2, 272 ), ( 3, 278 ), ( 4, 272 ), ( 5, 178 ), ( 6, 263 ), ( 7, 282 ), ( 8, 177 ), ( 9, 258 ), ( 10, 258 ), ( 11, 323 ), ( 12, 256 ) ] )
                , ( 2011, Dict.fromList [ ( 1, 257 ), ( 2, 278 ), ( 3, 209 ), ( 4, 238 ), ( 5, 241 ), ( 6, 245 ), ( 7, 283 ), ( 8, 274 ), ( 9, 331 ), ( 10, 357 ), ( 11, 257 ), ( 12, 321 ) ] )
                , ( 2012, Dict.fromList [ ( 2, 219 ), ( 3, 210 ), ( 4, 297 ), ( 5, 220 ), ( 6, 401 ), ( 7, 356 ), ( 8, 217 ), ( 9, 179 ), ( 10, 255 ), ( 11, 190 ), ( 12, 383 ) ] )
                , ( 2013, Dict.fromList [ ( 3, 243 ), ( 4, 252 ), ( 5, 187 ), ( 6, 184 ), ( 7, 348 ), ( 8, 324 ), ( 9, 444 ), ( 10, 540 ), ( 11, 524 ), ( 12, 702 ) ] )
                , ( 2014, Dict.fromList [ ( 1, 378 ), ( 2, 308 ), ( 3, 301 ), ( 4, 398 ), ( 5, 412 ), ( 6, 381 ), ( 7, 336 ), ( 8, 354 ), ( 9, 323 ), ( 10, 483 ), ( 11, 361 ), ( 12, 392 ) ] )
                , ( 2015, Dict.fromList [ ( 1, 289 ), ( 2, 362 ), ( 3, 466 ), ( 4, 521 ), ( 5, 329 ), ( 6, 358 ), ( 7, 343 ), ( 8, 372 ), ( 9, 311 ), ( 10, 386 ), ( 11, 310 ), ( 12, 349 ) ] )
                , ( 2016, Dict.fromList [ ( 1, 462 ), ( 2, 688 ), ( 3, 473 ), ( 4, 569 ), ( 5, 561 ), ( 6, 496 ), ( 7, 449 ), ( 8, 392 ), ( 9, 482 ), ( 10, 489 ), ( 11, 496 ), ( 12, 384 ) ] )
                , ( 2017, Dict.fromList [ ( 1, 563 ) ] )
                ]
          )
        , ( "Subaru"
          , Dict.fromList
                [ ( 2009, Dict.fromList [ ( 1, 83 ) ] )
                , ( 2012, Dict.fromList [ ( 6, 182 ), ( 7, 263 ), ( 8, 272 ), ( 9, 319 ), ( 10, 212 ), ( 11, 168 ), ( 12, 80 ) ] )
                , ( 2013, Dict.fromList [ ( 12, 134 ) ] )
                ]
          )
        , ( "Suzuki"
          , Dict.fromList
                [ ( 2010, Dict.fromList [ ( 2, 164 ) ] )
                , ( 2011, Dict.fromList [ ( 1, 370 ), ( 2, 124 ), ( 3, 212 ), ( 4, 128 ), ( 5, 101 ) ] )
                , ( 2012, Dict.fromList [ ( 1, 158 ) ] )
                , ( 2013, Dict.fromList [ ( 9, 132 ), ( 12, 211 ) ] )
                , ( 2014, Dict.fromList [ ( 1, 314 ), ( 2, 209 ), ( 3, 168 ), ( 4, 165 ), ( 5, 163 ), ( 6, 135 ), ( 7, 174 ), ( 8, 142 ), ( 9, 196 ), ( 10, 208 ), ( 11, 150 ), ( 12, 121 ) ] )
                , ( 2015, Dict.fromList [ ( 1, 170 ), ( 2, 185 ), ( 3, 247 ), ( 4, 58 ) ] )
                , ( 2016, Dict.fromList [ ( 1, 219 ), ( 2, 156 ), ( 3, 181 ), ( 4, 154 ), ( 5, 93 ), ( 6, 95 ), ( 7, 128 ) ] )
                ]
          )
        , ( "Tesla"
          , Dict.fromList
                [ ( 2013, Dict.fromList [ ( 9, 616 ), ( 12, 553 ) ] )
                , ( 2014, Dict.fromList [ ( 2, 431 ), ( 3, 1493 ), ( 4, 171 ), ( 5, 371 ), ( 6, 536 ), ( 7, 114 ), ( 8, 183 ), ( 9, 104 ), ( 10, 36 ), ( 11, 202 ), ( 12, 267 ) ] )
                , ( 2015, Dict.fromList [ ( 2, 321 ), ( 3, 1140 ), ( 4, 230 ), ( 5, 346 ), ( 6, 566 ), ( 7, 222 ), ( 8, 220 ), ( 9, 127 ), ( 10, 198 ), ( 11, 225 ), ( 12, 373 ) ] )
                , ( 2016, Dict.fromList [ ( 1, 105 ), ( 2, 113 ), ( 3, 487 ), ( 4, 96 ), ( 5, 156 ), ( 6, 284 ), ( 7, 43 ), ( 8, 170 ), ( 9, 247 ), ( 10, 39 ), ( 11, 48 ), ( 12, 263 ) ] )
                , ( 2017, Dict.fromList [ ( 1, 238 ) ] )
                ]
          )
        , ( "Toyota"
          , Dict.fromList
                [ ( 2007, Dict.fromList [ ( 1, 2699 ), ( 2, 1744 ), ( 3, 1413 ), ( 4, 908 ), ( 5, 1714 ), ( 6, 1485 ), ( 7, 1781 ), ( 8, 1616 ), ( 9, 1164 ), ( 10, 1500 ), ( 11, 1447 ), ( 12, 966 ) ] )
                , ( 2008, Dict.fromList [ ( 1, 1618 ), ( 2, 1436 ), ( 3, 1252 ), ( 4, 1346 ), ( 5, 991 ), ( 6, 861 ), ( 7, 994 ), ( 8, 711 ), ( 9, 940 ), ( 10, 979 ), ( 11, 610 ), ( 12, 765 ) ] )
                , ( 2009, Dict.fromList [ ( 1, 748 ), ( 2, 641 ), ( 3, 759 ), ( 4, 696 ), ( 5, 756 ), ( 6, 548 ), ( 7, 844 ), ( 8, 736 ), ( 9, 1124 ), ( 10, 955 ), ( 11, 1229 ), ( 12, 948 ) ] )
                , ( 2010, Dict.fromList [ ( 1, 1610 ), ( 2, 1117 ), ( 3, 1132 ), ( 4, 830 ), ( 5, 808 ), ( 6, 941 ), ( 7, 1021 ), ( 8, 1121 ), ( 9, 1156 ), ( 10, 1182 ), ( 11, 1323 ), ( 12, 517 ) ] )
                , ( 2011, Dict.fromList [ ( 1, 1190 ), ( 2, 940 ), ( 3, 1041 ), ( 4, 680 ), ( 5, 712 ), ( 6, 504 ), ( 7, 871 ), ( 8, 662 ), ( 9, 704 ), ( 10, 764 ), ( 11, 764 ), ( 12, 542 ) ] )
                , ( 2012, Dict.fromList [ ( 1, 965 ), ( 2, 1124 ), ( 3, 1359 ), ( 4, 970 ), ( 5, 1080 ), ( 6, 1023 ), ( 7, 959 ), ( 8, 904 ), ( 9, 1059 ), ( 10, 1321 ), ( 11, 1031 ), ( 12, 622 ) ] )
                , ( 2013, Dict.fromList [ ( 1, 854 ), ( 2, 1193 ), ( 3, 1018 ), ( 4, 1497 ), ( 5, 1395 ), ( 6, 1232 ), ( 7, 1485 ), ( 8, 1410 ), ( 9, 1426 ), ( 10, 1601 ), ( 11, 1269 ), ( 12, 765 ) ] )
                , ( 2014, Dict.fromList [ ( 1, 1196 ), ( 2, 1109 ), ( 3, 1145 ), ( 4, 960 ), ( 5, 1134 ), ( 6, 1038 ), ( 7, 1064 ), ( 8, 966 ), ( 9, 1170 ), ( 10, 1199 ), ( 11, 1036 ), ( 12, 873 ) ] )
                , ( 2015, Dict.fromList [ ( 1, 1176 ), ( 2, 1153 ), ( 3, 1447 ), ( 4, 1238 ), ( 5, 1019 ), ( 6, 1075 ), ( 7, 1078 ), ( 8, 1064 ), ( 9, 1213 ), ( 10, 1185 ), ( 11, 886 ), ( 12, 619 ) ] )
                , ( 2016, Dict.fromList [ ( 1, 1083 ), ( 2, 1358 ), ( 3, 1519 ), ( 4, 1421 ), ( 5, 1665 ), ( 6, 1582 ), ( 7, 1119 ), ( 8, 1689 ), ( 9, 1711 ), ( 10, 1243 ), ( 11, 1287 ), ( 12, 976 ) ] )
                , ( 2017, Dict.fromList [ ( 1, 1342 ) ] )
                ]
          )
        , ( "Volkswagen"
          , Dict.fromList
                [ ( 2007, Dict.fromList [ ( 1, 2440 ), ( 2, 1395 ), ( 3, 1314 ), ( 4, 1113 ), ( 5, 1796 ), ( 6, 1437 ), ( 7, 1690 ), ( 8, 1539 ), ( 9, 1258 ), ( 10, 1798 ), ( 11, 1368 ), ( 12, 1014 ) ] )
                , ( 2008, Dict.fromList [ ( 1, 790 ), ( 2, 1379 ), ( 3, 1116 ), ( 4, 1297 ), ( 5, 1006 ), ( 6, 840 ), ( 7, 841 ), ( 8, 1017 ), ( 9, 952 ), ( 10, 1057 ), ( 11, 942 ), ( 12, 979 ) ] )
                , ( 2009, Dict.fromList [ ( 1, 559 ), ( 2, 727 ), ( 3, 691 ), ( 4, 854 ), ( 5, 874 ), ( 6, 786 ), ( 7, 1135 ), ( 8, 941 ), ( 9, 964 ), ( 10, 1079 ), ( 11, 1203 ), ( 12, 1238 ) ] )
                , ( 2010, Dict.fromList [ ( 1, 1348 ), ( 2, 1096 ), ( 3, 1118 ), ( 4, 1709 ), ( 5, 1359 ), ( 6, 1238 ), ( 7, 1733 ), ( 8, 1302 ), ( 9, 1350 ), ( 10, 1415 ), ( 11, 1473 ), ( 12, 977 ) ] )
                , ( 2011, Dict.fromList [ ( 1, 1551 ), ( 2, 1393 ), ( 3, 1739 ), ( 4, 1724 ), ( 5, 1570 ), ( 6, 998 ), ( 7, 1316 ), ( 8, 1601 ), ( 9, 1395 ), ( 10, 1622 ), ( 11, 1583 ), ( 12, 1731 ) ] )
                , ( 2012, Dict.fromList [ ( 1, 1287 ), ( 2, 1152 ), ( 3, 1444 ), ( 4, 1753 ), ( 5, 1404 ), ( 6, 1147 ), ( 7, 1582 ), ( 8, 1369 ), ( 9, 1128 ), ( 10, 1384 ), ( 11, 1826 ), ( 12, 1084 ) ] )
                , ( 2013, Dict.fromList [ ( 1, 1252 ), ( 2, 1185 ), ( 3, 1051 ), ( 4, 1543 ), ( 5, 979 ), ( 6, 1047 ), ( 7, 1357 ), ( 8, 1012 ), ( 9, 1244 ), ( 10, 1108 ), ( 11, 1090 ), ( 12, 1342 ) ] )
                , ( 2014, Dict.fromList [ ( 1, 1121 ), ( 2, 1158 ), ( 3, 1451 ), ( 4, 1682 ), ( 5, 1424 ), ( 6, 1307 ), ( 7, 1880 ), ( 8, 1775 ), ( 9, 1470 ), ( 10, 1760 ), ( 11, 1532 ), ( 12, 1725 ) ] )
                , ( 2015, Dict.fromList [ ( 1, 3078 ), ( 2, 398 ), ( 3, 2006 ), ( 4, 2342 ), ( 5, 1689 ), ( 6, 2114 ), ( 7, 2012 ), ( 8, 1844 ), ( 9, 1466 ), ( 10, 1791 ), ( 11, 1940 ), ( 12, 1394 ) ] )
                , ( 2016, Dict.fromList [ ( 1, 1608 ), ( 2, 1871 ), ( 3, 2028 ), ( 4, 2777 ), ( 5, 1878 ), ( 6, 1817 ), ( 7, 1866 ), ( 8, 1903 ), ( 9, 1726 ), ( 10, 1764 ), ( 11, 1627 ), ( 12, 1670 ) ] )
                , ( 2017, Dict.fromList [ ( 1, 1253 ) ] )
                ]
          )
        , ( "Volvo"
          , Dict.fromList
                [ ( 2007, Dict.fromList [ ( 1, 346 ), ( 2, 407 ), ( 3, 433 ), ( 4, 359 ), ( 5, 514 ), ( 6, 439 ), ( 7, 819 ), ( 8, 278 ), ( 9, 384 ), ( 10, 615 ), ( 11, 409 ), ( 12, 384 ) ] )
                , ( 2008, Dict.fromList [ ( 1, 315 ), ( 2, 392 ), ( 3, 281 ), ( 4, 405 ), ( 5, 447 ), ( 6, 311 ), ( 7, 267 ), ( 8, 120 ), ( 9, 233 ), ( 10, 185 ), ( 11, 139 ), ( 12, 343 ) ] )
                , ( 2009, Dict.fromList [ ( 1, 262 ), ( 2, 199 ), ( 3, 88 ), ( 4, 243 ), ( 5, 217 ), ( 6, 516 ), ( 7, 836 ), ( 8, 296 ), ( 9, 590 ), ( 10, 508 ), ( 11, 901 ), ( 12, 1133 ) ] )
                , ( 2010, Dict.fromList [ ( 1, 483 ), ( 2, 645 ), ( 3, 846 ), ( 4, 665 ), ( 5, 557 ), ( 6, 570 ), ( 7, 900 ), ( 8, 358 ), ( 9, 612 ), ( 10, 584 ), ( 11, 639 ), ( 12, 1069 ) ] )
                , ( 2011, Dict.fromList [ ( 1, 361 ), ( 2, 751 ), ( 3, 901 ), ( 4, 647 ), ( 5, 968 ), ( 6, 770 ), ( 7, 1033 ), ( 8, 633 ), ( 9, 1088 ), ( 10, 813 ), ( 11, 1099 ), ( 12, 1175 ) ] )
                , ( 2012, Dict.fromList [ ( 1, 761 ), ( 2, 588 ), ( 3, 1043 ), ( 4, 881 ), ( 5, 1036 ), ( 6, 824 ), ( 7, 860 ), ( 8, 418 ), ( 9, 623 ), ( 10, 748 ), ( 11, 1052 ), ( 12, 1227 ) ] )
                , ( 2013, Dict.fromList [ ( 1, 723 ), ( 2, 646 ), ( 3, 679 ), ( 4, 876 ), ( 5, 920 ), ( 6, 572 ), ( 7, 881 ), ( 8, 467 ), ( 9, 1059 ), ( 10, 831 ), ( 11, 786 ), ( 12, 1850 ) ] )
                , ( 2014, Dict.fromList [ ( 1, 340 ), ( 2, 566 ), ( 3, 723 ), ( 4, 478 ), ( 5, 519 ), ( 6, 468 ), ( 7, 556 ), ( 8, 373 ), ( 9, 538 ), ( 10, 680 ), ( 11, 785 ), ( 12, 1621 ) ] )
                , ( 2015, Dict.fromList [ ( 3, 546 ), ( 4, 712 ), ( 5, 635 ), ( 6, 454 ), ( 7, 368 ), ( 8, 257 ), ( 9, 407 ), ( 10, 480 ), ( 11, 537 ), ( 12, 1052 ) ] )
                , ( 2016, Dict.fromList [ ( 1, 631 ), ( 2, 706 ), ( 3, 615 ), ( 4, 651 ), ( 5, 270 ), ( 6, 282 ), ( 7, 493 ), ( 12, 602 ) ] )
                , ( 2017, Dict.fromList [ ( 1, 1081 ) ] )
                ]
          )
        ]
