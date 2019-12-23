{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE DuplicateRecordFields #-}

module ExpositionParser
  ( MediaWithMetaData
  , weaveWithMetaData
  ) where

import           Crawler
import           Data.Aeson   (ToJSON)
import qualified Data.List    as L
import           Data.Maybe   (maybe)
import qualified Data.Text    as T
import           GHC.Generics
import           MetaData
import           TextContent

data TextType
  = TextLink Link
  | TextMeta
  | TextText
      { html  :: T.Text
      , links :: [Link]
      }
  deriving (Generic, Show, Eq)

instance ToJSON TextType

data MediaContentType
  = ImageTool T.Text
  | VideoTool T.Text
  | AudioTool T.Text
  | TextTool TextType
  deriving (Generic, Show, Eq)

instance ToJSON MediaContentType

data MediaWithMetaData =
  MediaWithMetaData
    { mediaFile     :: Maybe String
    , mediaId       :: T.Text
    , mediaPosition :: Position
    , mediaSize     :: Size
    , mediaMeta     :: ParsedMetaData
    , mediaContent  :: MediaContentType
    }
  deriving (Generic, Show, Eq)

instance ToJSON MediaWithMetaData

-- |Get all the pure metadata blocks that refer to the entire page
filterMetaBlocks :: [MediaWithMetaData] -> [MediaWithMetaData]
filterMetaBlocks =
  L.filter
    (\t ->
       case mediaContent t of
         TextTool TextMeta -> True
         _                 -> False)

-- |Concat the tool metadata blocks with the general page
-- blocks. Overwriting etc. is done automatically due to Monoid
-- implementation.
applyMetaBlocks :: [MediaWithMetaData] -> [MediaWithMetaData]
applyMetaBlocks tools =
  L.map
    (\t ->
       case mediaContent t of
         TextTool TextMeta -> t
         _                 -> t {mediaMeta = mediaMeta t <> metaInfo})
    tools
  where
    metaInfo = mconcat (mediaMeta <$> filterMetaBlocks tools)

-- |Create metadata from tools
addMetaData :: Tool -> MediaWithMetaData
addMetaData t =
  let mediaFn =
        MediaWithMetaData (toolMediaFile t) (toolId t) (position t) (size t)
      metaFromHover = maybe mempty (hoverMeta . T.unpack) (hoverText t)
      (meta, media) =
        case toolContent t of
          TextContent txt ->
            case toTextBlock (T.unpack txt) of
              LinkBlock l     -> (mempty, TextTool (TextLink l))
              MetaBlock m     -> (m, TextTool TextMeta)
              TextBlock m h l -> (m, TextTool (TextText (T.pack h) l))
          ImageContent i -> (metaFromHover, ImageTool i)
          VideoContent i -> (metaFromHover, VideoTool i)
          AudioContent i -> (metaFromHover, AudioTool i)
   in mediaFn meta media

-- |Process a page, apply metadata.
weaveWithMetaData :: Weave -> [MediaWithMetaData]
weaveWithMetaData weave = applyMetaBlocks $ fmap addMetaData (weaveTools weave)
