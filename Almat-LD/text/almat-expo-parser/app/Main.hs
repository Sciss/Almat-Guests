module Main where

import           Crawler
import qualified Data.Text.IO       as TIO
import           ExpositionParser
import           System.Environment (getArgs)

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
  TIO.putStrLn $ encodeTxt $ fmap weaveWithMetaData (expositionWeaves expo)
