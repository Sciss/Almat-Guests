module Main where

import           Control.Monad
import           Control.Monad.Trans.Writer
import           Crawler
import           Data.List                  (intercalate)
import qualified Data.Text.IO               as TIO
import           Data.Time.Clock            (getCurrentTime)
import           ExpositionParser
import           System.Environment         (getArgs)

mkImportOptions :: String -> String -> ImportOptions
mkImportOptions expoId weaveId =
  ImportOptions
    { markdown = False
    , writeMarkdown = False
    , epub = False
    , expId = expoId
    , download = Nothing
    , pageId = Just weaveId
    }

parseArgs :: [String] -> ImportOptions
parseArgs [eId, wId] = mkImportOptions eId wId
parseArgs _          = error "exposition-id and page-id are missing."

usage :: IO ()
usage = putStrLn "Usage: parse-exposition exposition-id page-id"

main :: IO ()
main = do
  args <- getArgs
  let options = parseArgs args
  expo <- crawlExposition options
  let (weaves, log) = runWriter $ mapM weaveWithMetaData (expositionWeaves expo)
  t <- getCurrentTime
  writeFile ("tmp_" ++ (show t) ++ ".log") (intercalate "\n" log)
  TIO.putStrLn $ encodeTxt $ weaves
