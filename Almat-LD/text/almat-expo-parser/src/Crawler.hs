{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedStrings     #-}

module Crawler
  ( ImportOptions(..)
  , crawlExposition
  , Exposition(..)
  , Weave(..)
  , Popover(..)
  , Position(..)
  , Size(..)
  , Tool(..)
  , ToolContent(..)
  , ExpositionMetaData(..)
  , encodeTxt
  ) where

import           Control.Monad

import           Data.Aeson                    (ToJSON)
import           Data.Aeson.Encode.Pretty      (encodePretty)
import qualified Data.Map.Strict               as Map

import           Control.Monad.Reader          (ReaderT, ask, liftIO, runReaderT)
import qualified Data.ByteString.Lazy          as ByteString
import           Data.Char                     (isSpace)
import           Data.Conduit                  (runConduitRes, (.|))
import qualified Data.Conduit.Binary           as CB
import qualified Data.List                     as L
import qualified Data.Map.Strict               as M
import qualified Data.Text                     as T

-- import qualified Data.Text.IO                  as TIO
import           Data.Text.Lazy                (toStrict)
import           Data.Text.Lazy.Encoding       (decodeUtf8)
import           Data.Text.Read                (decimal)

import           GHC.Generics
import           Network.HTTP.Simple           (getResponseBody, httpSink, httpSource, parseRequest)
import           System.Directory              (createDirectory, doesDirectoryExist)

-- import           System.Environment
-- import           System.Exit
import           System.FilePath               (takeExtension, (</>))
import           Text.Blaze.Html               (toHtml)
import           Text.Blaze.Html.Renderer.Text (renderHtml)
import           Text.HTML.DOM                 (sinkDoc)
import qualified Text.Pandoc                   as Pan
import qualified Text.Pandoc.Options           as PanOptions
import           Text.XML                      (Element (..), Node (..))
import           Text.XML.Cursor               (attribute, attributeIs, check, content, element, fromDocument, parent,
                                                ($//), (&/), (&//), (&|), (>=>))
import           Text.XML.Cursor.Generic       (Cursor (..), node)

data Exposition =
  Exposition
    { expositionToc      :: [(T.Text, T.Text)]
    , expositionId       :: T.Text
    , expositionMetaData :: ExpositionMetaData
    , expositionWeaves   :: [Weave]
    }
  deriving (Generic, Show)

instance ToJSON Exposition

data Weave =
  Weave
    { weaveTitle    :: T.Text
    , weaveUrl      :: T.Text
    , weaveTools    :: [Tool]
    , weavePopovers :: [Popover]
    }
  deriving (Generic, Show)

instance ToJSON Weave

data Popover =
  Popover
    { popoverId      :: T.Text
  -- , popoverPosition :: Position
  -- , popoverSize     :: Size
    , popoverContent :: Weave
    }
  deriving (Generic, Show)

instance ToJSON Popover

data Position =
  Position
    { left :: Maybe Int
    , top  :: Maybe Int
    }
  deriving (Generic, Show, Eq)

instance ToJSON Position

data Size =
  Size
    { width  :: Maybe Int
    , height :: Maybe Int
    }
  deriving (Generic, Show, Eq)

instance ToJSON Size

data Tool =
  Tool
    { toolMediaFile :: Maybe String
    , toolId        :: T.Text
    , position      :: Position
    , size          :: Size
    , toolContent   :: ToolContent
    , hoverText     :: Maybe T.Text
    }
  deriving (Generic, Show, Eq)

instance ToJSON Tool

instance Ord Tool where
  compare tool1 tool2 =
    let p1 = position tool1
        p2 = position tool2
     in case (left p1, top p1, left p2, top p2) of
          (Just l1, Just t1, Just l2, Just t2)
            | l1 == l2 -> compare t1 t2
          (Nothing, Nothing, Nothing, Nothing) -> EQ
          (Nothing, Nothing, _, _) -> GT
          (_, _, Nothing, Nothing) -> LT
          (Nothing, Just t1, Nothing, Just t2) -> compare t1 t2
          (Just l1, _, Just l2, _) -> compare l1 l2
          _ -> EQ

-- | Content types to be extended
data ToolContent
  = TextContent
      { textToolContent :: T.Text
      }
  | ImageContent
      { imageUrl :: T.Text
      }
  | VideoContent
      { videoUrl :: T.Text
      }
  | AudioContent
      { audioUrl :: T.Text
      }
  deriving (Generic, Show, Eq)

instance ToJSON ToolContent

data ImportOptions =
  ImportOptions
    { markdown      :: Bool -- convert content of text tools
    , writeMarkdown :: Bool -- for output
    , epub          :: Bool
    , expId         :: String
    , download      :: Maybe String
    , pageId        :: Maybe String
    }

type ToolTypeName = T.Text

type ToolSpec = (ToolTypeName, Cursor Node -> ToolContent)

data ExpositionMetaData =
  ExpoMetaData
    { metaTitle      :: T.Text
    , metaDate       :: T.Text
    , metaAuthors    :: [T.Text]
    , metaKeywords   :: [T.Text]
    , metaExpMainUrl :: T.Text
    }
  deriving (Generic, Show)

instance ToJSON ExpositionMetaData

-- | Encodes an object as strict json text
encodeTxt :: ToJSON a => a -> T.Text
encodeTxt a = toStrict . decodeUtf8 $ encodePretty a

-- | Checks if class attribute string contains a certain class
checkClass :: T.Text -> Cursor Node -> Bool
checkClass cls cursor =
  case node cursor of
    (NodeElement (Element _ attr _)) ->
      case M.lookup "class" attr of
        Just classes -> T.isInfixOf cls classes
        _            -> False
    _ -> False

-- | Get style property from a list of lists
styleProperty :: T.Text -> [[T.Text]] -> Maybe Int
styleProperty prop propLst =
  case L.find (\propPair -> head propPair == prop) propLst of
    Just val ->
      case decimal $ second val of
        Right (num, _) -> Just num
        _              -> Nothing
    _ -> Nothing
  where
    second = head . tail

-- | Extract size and position from a list of style strings
extractSizePos :: [T.Text] -> ([Position], [Size])
extractSizePos styles = (positions, sizes)
  where
    assocStyles = map (map (T.splitOn ":") . T.splitOn ";") styles
    lefts = map (styleProperty "left") assocStyles
    tops = map (styleProperty "top") assocStyles
    positions = zipWith Position lefts tops
    widths = map (styleProperty "width") assocStyles
    heights = map (styleProperty "height") assocStyles
    sizes = zipWith Size widths heights

--------------------
--- Specification of tool functions
--------------------
textContent :: Cursor Node -> ToolContent
textContent cursor =
  TextContent $ (toStrict . renderHtml . toHtml . node) cursor

imageContent :: Cursor Node -> ToolContent
imageContent cursor = ImageContent img
  where
    img = T.concat $ cursor $// element "img" >=> attribute "src"

videoContent :: Cursor Node -> ToolContent
videoContent cursor = VideoContent video
  where
    video = T.concat $ cursor $// attribute "data-file"

audioContent :: Cursor Node -> ToolContent
audioContent cursor = AudioContent audio
  where
    audio = T.concat $ cursor $// attribute "data-file"
    -- lstinfo = T.pack $ show $cursor
    -- audio = T.concat $ cursor $// element "video" >=> attribute "src"

toolSpecs :: [ToolSpec]
toolSpecs =
  [ ("text", textContent)
  , ("simpletext", textContent)
  , ("picture", imageContent)
  , ("video", videoContent)
  , ("audio", audioContent)
  ]

-- | Get tools of a certain type
getTools :: ToolSpec -> Cursor Node -> [Tool]
getTools (toolTypeName, contentFun) cursor =
  L.zipWith5 (Tool Nothing) ids positions sizes toolsContent hoverTexts
  where
    tools = cursor $// attributeIs "data-tool" toolTypeName
    ids = map (T.concat . attribute "data-id") tools
    styles = map (T.concat . attribute "style") tools
    hoverTexts =
      map
        ((\s ->
            if T.null s
              then Nothing
              else Just s) .
         T.concat . attribute "data-plaintext")
        tools
    (positions, sizes) = extractSizePos styles
    tContent =
      cursor $// attributeIs "data-tool" toolTypeName &/
      check (checkClass "tool-content")
    toolsContent = map contentFun tContent

--------------------
--- File download
--------------------
downloadFile :: String -> String -> IO ()
downloadFile url fname = do
  req <- parseRequest url
  runConduitRes $ httpSource req getResponseBody .| CB.sinkFile fname

toolUrl :: Tool -> Maybe String
toolUrl tool =
  case toolContent tool of
    ImageContent url -> Just (T.unpack url)
    VideoContent url -> Just (T.unpack url)
    AudioContent url -> Just (T.unpack url)
    _                -> Nothing

toolFileExtension :: Tool -> Maybe String
toolFileExtension tool =
  let fname url = Just $ takeWhile (/= '?') (takeExtension url)
   in fname =<< toolUrl tool

toolFileName :: Tool -> String -> Maybe String
toolFileName tool dir =
  (\ending -> dir </> T.unpack (toolId tool) ++ ending) <$>
  toolFileExtension tool

downloadTool :: String -> Tool -> IO ()
downloadTool dir tool =
  let fileName = toolFileName tool dir
      url = toolUrl tool
   in case (fileName, url) of
        (Just fnameStr, Just urlStr) -> downloadFile urlStr fnameStr
        _                            -> return ()

downloadTools :: ImportOptions -> Exposition -> IO ()
downloadTools options exposition =
  let tools = concatMap weaveTools (expositionWeaves exposition)
   in case download options of
        Nothing -> return ()
        Just dir -> do
          exists <- doesDirectoryExist dir
          unless exists $ createDirectory dir
          mapM_ (downloadTool dir) tools

--------------------
--- Popovers
--------------------
popoverUrl :: String -> String -> String
popoverUrl expoId popId = "/view/popover/" ++ expoId ++ "/" ++ popId

getPopovers :: String -> Cursor Node -> IO [Popover]
getPopovers expoId cursor = L.zipWith Popover ids <$> contents
  where
    ids = cursor $// element "a" >=> attribute "data-popover"
    contents =
      traverse
        (\u ->
           getWeave expoId ("popover", T.pack (popoverUrl expoId (T.unpack u))))
        ids

--------------------
--- Markdown conversion
--------------------
toolToMarkdown :: Pan.PandocMonad m => Tool -> m Tool
toolToMarkdown tool =
  case toolContent tool of
    TextContent txt -> do
      pantxt <- Pan.readHtml PanOptions.def txt
      mdtxt <- Pan.writeMarkdown PanOptions.def pantxt
      return tool {toolContent = TextContent mdtxt}
    _ -> return tool

textToolsToMarkdown :: Pan.PandocMonad m => Exposition -> m Exposition
textToolsToMarkdown expo = do
  mdTools <- mapM (mapM toolToMarkdown) (map weaveTools (expositionWeaves expo))
  return $
    expo
      { expositionWeaves =
          zipWith (\w t -> w {weaveTools = t}) (expositionWeaves expo) mdTools
      }

--------------------
--- Adding Metadata
--------------------
addMetaString :: Pan.Pandoc -> String -> String -> Pan.Pandoc
addMetaString (Pan.Pandoc (Pan.Meta meta) blocks) key value =
  Pan.Pandoc newMeta blocks
  where
    newMeta = Pan.Meta $ Map.insert key (Pan.MetaString value) meta

addMetaStringList :: Pan.Pandoc -> String -> [String] -> Pan.Pandoc
addMetaStringList (Pan.Pandoc (Pan.Meta meta) blocks) key values =
  Pan.Pandoc newMeta blocks
  where
    newMeta =
      Pan.Meta $ Map.insert key (Pan.MetaList $ map Pan.MetaString values) meta

--------------------
--- EPub3 conversion
--------------------
mdReaderOptions =
  (PanOptions.def
     { PanOptions.readerExtensions =
         PanOptions.extensionsFromList [PanOptions.Ext_multiline_tables]
     })

mdWriterOptions =
  (PanOptions.def
     { PanOptions.writerExtensions =
         PanOptions.extensionsFromList [PanOptions.Ext_multiline_tables]
     })

toolToMd :: Pan.PandocMonad m => ToolContent -> m Pan.Pandoc
toolToMd (TextContent txt) = Pan.readHtml mdReaderOptions txt
toolToMd (ImageContent img) =
  Pan.readMarkdown PanOptions.def ("\n![](" <> img <> ")\n")
toolToMd (AudioContent url) =
  Pan.readMarkdown PanOptions.def ("\n![" <> url <> "](" <> url <> ")\n")
toolToMd (VideoContent url) =
  Pan.readMarkdown PanOptions.def ("\n![" <> url <> "](" <> url <> ")\n")

lastN :: Int -> [a] -> [a]
lastN n xs = drop (length xs - n) xs

expToEPub ::
     Pan.PandocMonad m
  => Exposition
  -> ExpositionMetaData
  -> m ByteString.ByteString
expToEPub expo meta = do
  let sortedTools =
        map toolContent $
        concatMap (L.sort . weaveTools) (expositionWeaves expo)
  pan <- fmap mconcat $ traverse toolToMd sortedTools
  template <- Pan.getDefaultTemplate "epub"
  let year = lastN 4 (T.unpack $ metaDate meta)
  Pan.writeEPUB3
    (PanOptions.def
       { Pan.writerVariables = [("coverpage", "true"), ("titlepage", "true")]
       , Pan.writerTemplate = Just template
       })
    (addMetaString
       (addMetaStringList
          (addMetaString pan "title" (T.unpack $ metaTitle meta))
          "creator"
          (map T.unpack $ metaAuthors meta))
       "date"
       year)

--------------------
--- Markdown conversion
--------------------
mkYamlHeader :: ExpositionMetaData -> T.Text
mkYamlHeader meta =
  T.unlines $
  [ "---"
  , "title:"
  , "- type: main"
  , "  text: \"" <> metaTitle meta <> "\""
  , "creator:"
  ] ++
  authors ++ ["..."]
  where
    authors =
      mconcat $
      map
        (\author -> ["- role: author", "  text: \"" <> author <> "\""])
        (metaAuthors meta)

expToMarkdown ::
     Pan.PandocMonad m => Exposition -> ExpositionMetaData -> m T.Text
expToMarkdown expo meta = do
  let sortedTools =
        map toolContent $
        concatMap (L.sort . weaveTools) (expositionWeaves expo)
  pan <- fmap mconcat $ traverse toolToMd sortedTools
  _template <- Pan.getDefaultTemplate "markdown"
  let year = lastN 4 (T.unpack $ metaDate meta)
  Pan.writeMarkdown
    mdWriterOptions
    (addMetaString
       (addMetaStringList
          (addMetaString pan "title" (T.unpack $ metaTitle meta))
          "creator"
          (map T.unpack $ metaAuthors meta))
       "date"
       year)

--------------------
--- Main functions
--------------------
insertFileNames :: ImportOptions -> Exposition -> Exposition
insertFileNames options expo =
  case download options of
    Nothing -> expo
    Just dir ->
      let toolsFname =
            map
              (map (\tool -> tool {toolMediaFile = toolFileName tool dir}) .
               weaveTools)
              (expositionWeaves expo)
       in expo
            { expositionWeaves =
                zipWith
                  (\w t -> w {weaveTools = t})
                  (expositionWeaves expo)
                  toolsFname
            }

getWeave :: String -> (T.Text, T.Text) -> IO Weave
getWeave wId (title, url) = do
  req <- parseRequest $ "https://www.researchcatalogue.net" <> T.unpack url
  doc <- httpSink req $ const sinkDoc
  let cursor = fromDocument doc
  let tools = concatMap (`getTools` cursor) toolSpecs
  popovers <- getPopovers wId cursor
  return $
    Weave
      { weaveTitle = title
      , weaveUrl = url
      , weaveTools = tools
      , weavePopovers = popovers
      }

parseExposition ::
     String
  -> Maybe String
  -> ExpositionMetaData
  -> Cursor Node
  -> IO Exposition
parseExposition expoId pageIdM metadata cursor =
  let expToc = toc cursor
      selectedToc =
        case pageIdM of
          Just pid ->
            L.filter (\(_, url) -> T.isInfixOf (T.pack pid) url) expToc
          Nothing -> expToc
   in do weaves <- mapM (getWeave expoId) selectedToc
         return $ Exposition expToc (T.pack expoId) metadata weaves

toc :: Cursor Node -> [(T.Text, T.Text)]
toc cursor =
  let tocTitles =
        cursor $// attributeIs "class" "mainmenu" &/
        check (checkClass "menu-home") &//
        element "a" &/
        content
      tocUrls =
        cursor $// attributeIs "class" "mainmenu" &/
        check (checkClass "menu-home") &//
        element "a" >=>
        attribute "href"
   in L.filter (\(_title, url) -> T.isInfixOf "view" url) $
      zip tocTitles tocUrls

getExposition :: ImportOptions -> ExpositionMetaData -> IO Exposition
getExposition options metadata = do
  req <- parseRequest $ T.unpack (metaExpMainUrl metadata)
  doc <- httpSink req $ const sinkDoc
  exposition <-
    parseExposition (expId options) (pageId options) metadata (fromDocument doc)
  return $ insertFileNames options exposition

detailsUrl :: String -> String
detailsUrl exposition =
  "https://www.researchcatalogue.net/profile/show-exposition?exposition=" <>
  exposition

trim :: T.Text -> T.Text
trim = T.dropWhileEnd isSpace . T.dropWhile isSpace

unwrapTxt :: Maybe T.Text -> T.Text
unwrapTxt Nothing    = ""
unwrapTxt (Just txt) = txt

parseDetailsPage :: Cursor Node -> ExpositionMetaData
parseDetailsPage cursor =
  let title =
        T.concat $
        cursor $// element "h2" >=>
        attributeIs "class" "meta-headline" &/ content
      authors =
        cursor $// element "h2" >=>
        attributeIs "class" "meta-headline" &| parent &// element "a" &/ content
      mainUrl =
        T.concat $
        cursor $// attributeIs "class" "meta-left-col" &/
        attributeIs "class" "button" >=>
        attribute "href"
      ths =
        cursor $// attributeIs "class" "meta-table" &// element "th" &/ content
      tds =
        cursor $// attributeIs "class" "meta-table" &// element "td" &/ content
      metadata = zip ths tds
   in ExpoMetaData
        { metaTitle = trim title
        , metaDate = unwrapTxt $ lookup "date" metadata
        , metaKeywords = T.splitOn "," $ unwrapTxt $ lookup "keywords" metadata
        , metaAuthors = L.concat authors
        , metaExpMainUrl = mainUrl
        }

getDetailsPageData :: ReaderT ImportOptions IO ExpositionMetaData
getDetailsPageData = do
  options <- ask
  req <- liftIO $ parseRequest $ detailsUrl (expId options)
  doc <- liftIO $ httpSink req $ const sinkDoc
  return $ parseDetailsPage (fromDocument doc)

-- parseArgs :: [String] -> ImportOptions
-- parseArgs args =
--   makeOptions args (ImportOptions False False False "" Nothing Nothing)
--   where
--     makeOptions :: [String] -> ImportOptions -> ImportOptions
--     makeOptions ("-epub":t) options = makeOptions t (options {epub = True})
--     makeOptions ("-pageid":wId:t) options =
--       makeOptions t (options {pageId = Just wId})
--     makeOptions ("-md":t) options =
--       makeOptions t (options {writeMarkdown = True})
--     makeOptions ("-textmd":t) options =
--       makeOptions t (options {markdown = True})
--     makeOptions ("-d":t) options =
--       makeOptions t (options {download = Just "media"})
--     makeOptions (wId:t) options = makeOptions t (options {expId = wId})
--     makeOptions [] options = options
-- usage =
--   putStrLn
--     "Usage: parse-exposition [-pageid] [-epub] [-textmd] [-md] [-d] exposition-id"
-- exit = exitSuccess
-- expToTxt :: Pan.PandocMonad m => m Exposition -> m T.Text
-- expToTxt exp = encodeTxt <$> exp
-- encodeMdTxt :: Exposition -> IO T.Text
-- encodeMdTxt exp = Pan.runIOorExplode $ expToTxt (textToolsToMarkdown exp)
-- main :: IO ()
-- main = do
--   args <- getArgs
--   let options = parseArgs args
--   details <- runReaderT getDetailsPageData options
--   expo <- getExposition options details
--   downloadTools options expo
--   if markdown options
--     then TIO.putStrLn =<< encodeMdTxt expo
--     else TIO.putStrLn $ encodeTxt expo
--   when (epub options) $ do
--     epubBs <- Pan.runIOorExplode $ expToEPub expo details
--     ByteString.writeFile "export.epub" epubBs
--   when (writeMarkdown options) $ do
--     md <- Pan.runIOorExplode $ expToMarkdown expo details
--     TIO.writeFile "export.md" $ mkYamlHeader details <> md
crawlExposition :: ImportOptions -> IO Exposition
crawlExposition options = do
  details <- runReaderT getDetailsPageData options
  getExposition options details
