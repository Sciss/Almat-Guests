{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE TypeFamilies #-}

module Lib
  ( dia
  ) where

import Diagrams.Backend.SVG.CmdLine
import Diagrams.Prelude

data Oscillator = Osc
  { phase :: Double
  , incr :: Double
  , coupling :: Double
  } deriving (Eq, Show)

unwrapPhase ph
  | ph < 0 = unwrapPhase $ ph + 2 * pi
  | ph > 2 * pi = unwrapPhase $ ph - 2 * pi
  | otherwise = ph

calcDiffs :: [Double] -> [Double]
calcDiffs phases =
  map (\phK -> foldl (\sum phJ -> sum + (sin $ phJ - phK)) 0.0 phases) phases

updateOsc :: Oscillator -> Double -> Oscillator
updateOsc osc diff = osc {phase = nextPhase}
  where
    nextPhase = unwrapPhase $ phase osc + incr osc + diff * coupling osc

updateOscs :: [Oscillator] -> [Oscillator]
updateOscs oscs = zipWith updateOsc oscs diffs
  where
    phases = map phase oscs
    diffs = calcDiffs phases

unzipLst ((h1:t1):rest) =
  [h1 : (map head rest)] ++ unzipLst (t1 : (map tail rest))
unzipLst _ = []

-- infinite list of oscs
collectOscs :: [Oscillator] -> [[Oscillator]]
collectOscs oscs = updatedOscs : collectOscs updatedOscs
  where
    updatedOscs = updateOscs oscs

---[xI,xI+1],[xI+1,xI+2]
-- collectPhasePoints :: Int -> [Oscillator] -> [[(Double, Double)]]
-- collectPhasePoints n init = map (\l -> zip l (tail l)) phases
--   where
--     phases = map (map phase) $ unzipLst $ take n $ collectOscs init
collectWithT :: Int -> Double -> [Oscillator] -> [[(Double, Double)]]
collectWithT n step init = map (zip ts) phases
  where
    phases = map (map phase) $ unzipLst $ take n $ collectOscs init
    ts = take n [0.0,step ..]

-- testing
-- phLines :: Trail' Line V2 Double
-- phLines = fromVertices $ map p2 osc1Phases
--   where
--     osc1Phases =
--       head
--         (collectPhasePoints
--            5000
--            [Osc 0.0 0.01 0.005, Osc 0.4 0.01 0.005, Osc 0.83 0.01 0.005])
-- dia :: Diagram B
-- dia = pad 1.1 . center $ phLines # strokeLine
createPoints :: Double -> Double -> [(Double, Double)] -> [Point V2 Double]
createPoints _ _ [] = []
createPoints y lastPhase ((thisX, thisPhase):rest)
  | lastPhase > thisPhase = p2 (thisX, y) : createPoints y thisPhase rest
  | otherwise = createPoints y thisPhase rest

--map (\ps -> position $ zip ps (repeat spot)) points
createDia :: Int -> Double -> [Oscillator] -> Diagram B
createDia n xstep init = atPoints (mconcat points) (repeat spot)
  where
    ys = take (length init) [0.0,20.0 ..]
    points = zipWith3 createPoints ys (repeat 0.0) (collectWithT n xstep init)
    spot = circle 2 # fc black -- dia :: Diagram B

dia =
  pad 2 . center $ createDia 2000 0.3 [Osc 0.0 0.04 0.001, Osc 3.4 0.04 0.001]
