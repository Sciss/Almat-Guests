
e{-# LANGUAGE DeriveGeneric        #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE BangPatterns #-}

module MetaData
  ( ParsedMetaData(..)
  , decodeMetaData
  ) where

import           Data.Aeson            (ToJSON)
import qualified Data.ByteString.Char8 as B
import qualified Data.Vector           as V
import           Data.Yaml
import           GHC.Generics
import Debug.Trace (trace)
import Data.Text as T

data ElementKind =
  Logo 
  | Screenshot 
  | Photo
  | Meta
  | Dialogue
  deriving (Generic, Show, Eq)

instance ToJSON ElementKind

-- instance FromJSON ElementKind

instance FromJSON ElementKind  where
  parseJSON (String s) =
    let !_a = trace ("string is " ++ (T.unpack s)) s in
    case s of
      "logo" -> return Logo
      "screenshot" -> return Screenshot
      "photo" -> return Photo
      "meta" -> return Meta
      "Dialogue" -> return Dialogue -- only testing
      _ -> mempty


instance Semigroup ElementKind where
  v <> v' = v'


data ElementType =
  Contextual
  | Comment
  | Caption
  | Proposal
  | Description
  | Code
  | Experiment
  | Bib
  deriving (Generic, Show, Eq)


instance FromJSON ElementType

-- instance FromJSON ElementType  where
--   parseJSON (String s) = case s of
--     "contextual" -> return Contextual
--     "comment" -> return Comment
--     "caption" -> return Caption
--     "proposal" -> return Proposal
--     "description" -> return Description
--     "code" -> return Code
--     "experiment" -> return Experiment
--     "bib" -> return Bib
--     _ -> mempty


instance ToJSON ElementType

instance Semigroup ElementType where
  v <> v' = v'


data ElementOrigin =
  Conversation | Email | Presentation | ProgramNotes | Online 
  deriving (Generic, Show, Eq)

instance ToJSON ElementOrigin

instance Semigroup ElementOrigin where
  v <> v' = v'

instance FromJSON ElementOrigin  where
  parseJSON (String s) = case s of
    "conversation" -> return Conversation
    "email" -> return Email
    "presentation" -> return Presentation
    "program notes" -> return ProgramNotes
    _ -> return Online


data ParsedMetaData =
  ParsedMetaData
    { linksTo  :: Maybe Value
    , kind     :: Maybe ElementKind
    , author   :: Maybe Value
    , elementType   :: Maybe ElementType
    , keywords :: Maybe Value
    , persons  :: Maybe Value
    , date     :: Maybe Value
    , place    :: Maybe Value
    , origin    :: ElementOrigin
    }
  deriving (Generic, Show, Eq)

instance ToJSON ParsedMetaData

-- instance FromJSON ParsedMetaData

instance FromJSON ParsedMetaData where
    parseJSON = withObject "ParsedMetaData" $ \v -> ParsedMetaData
        <$> v .:? "links-to" 
        <*> v .:? "kind"
        <*> v .:? "author"
        <*> v .:? "type"
        <*> v .:? "keywords"
        <*> v .:? "persons"
        <*> v .:? "date"
        <*> v .:? "place"
        <*> v .:? "origin" .!= Online

-- |Specific JSON 'Value' semigroup for metadata "inheritance"
instance Semigroup Value where
  Array v <> Array v' =
    if V.elem (String "_") v'
      then Array (v <> v')
      else Array v'
  Array v <> e = Array (V.cons e v)
  e <> Array v =
    if V.elem (String "_") v
      then Array (V.cons e v)
      else Array v
  _ <> y = y

-- |'ParsedMetaData' can be concatenated
instance Semigroup ParsedMetaData where
  m1 <> m2 =
    ParsedMetaData
      (linksTo m1 <> linksTo m2)
      (kind m1 <> kind m2)
      (author m1 <> author m2)
      (elementType m1 <> elementType m2)
      (keywords m1 <> keywords m2)
      (persons m1 <> persons m2)
      (date m1 <> date m2)
      (place m1 <> place m2)
      (origin m1 <> origin m2)

instance Monoid ParsedMetaData where
  mempty =
    ParsedMetaData Nothing Nothing Nothing Nothing Nothing Nothing Nothing Nothing Online

decodeMetaData :: String -> Maybe ParsedMetaData
decodeMetaData str =
  case decodeEither' (B.pack str) :: Either ParseException ParsedMetaData of
    Right d -> Just d
    Left f  -> trace (show f) Nothing
