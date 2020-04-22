{-# LANGUAGE BangPatterns         #-}
{-# LANGUAGE DeriveGeneric        #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE RecordWildCards      #-}
{-# LANGUAGE TypeSynonymInstances #-}

module MetaData
  ( ParsedMetaData(..)
  , decodeMetaData
  ) where

import           Control.Monad
import           Control.Monad.Trans.Writer
import           Data.Aeson                 (ToJSON)
import qualified Data.ByteString.Char8      as B
import           Data.Text                  as T
import qualified Data.Vector                as V
import           Data.Yaml
import           Debug.Trace                (trace)
import           GHC.Generics

data ElementKind
  = Logo
  | Screenshot
  | Diagram
  | Photo
  | Video
  | Scan
  | Footer
  | Code
  | Sound
  | Bib
  | Resume
  | Conversation
  | Essay
  | Passim
  | Biography
  | Quote
  | Collage
  | Title
  | Program
  | Slideshow
  | Note
  | Diary
  deriving (Generic, Show, Eq)

instance ToJSON ElementKind

instance FromJSON ElementKind

instance Semigroup ElementKind where
  v <> v' = v'

data ElementFunction
  = Contextual
  | Comment
  | Caption
  | Proposal
  | Description
  | Experiment
  | Overview
  | Info
  | Survey
  | Definition
  | Presentation
  | Documentation
  deriving (Generic, Show, Eq)

instance FromJSON ElementFunction

instance ToJSON ElementFunction

instance Semigroup ElementFunction where
  v <> v' = v'

data ElementOrigin
  = ProjectProposal
  | Spoken
  | Email
  | Presentation
  | ProgramNotes
  | RC
  | Skype
  deriving (Generic, Show, Eq)

instance ToJSON ElementOrigin

instance FromJSON ElementOrigin

instance Semigroup ElementOrigin where
  v <> v' = v'

data ElementArtwork
  = TheFifthRoothOfTwo
  | ListeningToTheAir
  | PinchAndSoothe
  | Moor
  | Notebook
  | Hough
  | Site
  | Fragments
  | Spokes
  | Knots
  | PreciousObjects
  | LeapSpace
  deriving (Generic, Show, Eq)

instance ToJSON ElementArtwork

instance FromJSON ElementArtwork

instance Semigroup ElementArtwork where
  v <> v' = v'

data ElementEvent
  = SCmeeting
  | openCUBE
  | signaleSoiree
  | thresholdsOfTheAlgorithmic
  | SimulationAndComputerExperimentationInMusicAndSoundArt
  | imperfectReconstruction
  | interpolations
  | artsBirthday2017
  deriving (Generic, Show, Eq)

instance ToJSON ElementEvent

instance FromJSON ElementEvent

instance Semigroup ElementEvent where
  v <> v' = v'
  
data ParsedMetaData =
  ParsedMetaData
    { linksTo  :: Maybe Value
    , meta     :: Bool
    , kind     :: Maybe ElementKind
    , author   :: Maybe Value
    , function :: Maybe ElementFunction
    , keywords :: Maybe Value
    , persons  :: Maybe Value
    , date     :: Maybe Value
    , place    :: Maybe Value
    , origin   :: ElementOrigin
    }
  deriving (Generic, Show, Eq)

instance ToJSON ParsedMetaData

-- instance FromJSON ParsedMetaData
instance FromJSON ParsedMetaData where
  parseJSON =
    withObject "ParsedMetaData" $ \v ->
      ParsedMetaData <$> v .:? "links-to" <*> v .:? "meta" .!= False <*>
      v .:? "kind" <*>
      v .:? "author" <*>
      v .:? "function" <*>
      v .:? "keywords" <*>
      v .:? "persons" <*>
      v .:? "date" <*>
      v .:? "place" <*>
      v .:? "origin" .!= RC

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
      (meta m1 && meta m2)
      (kind m1 <> kind m2)
      (author m1 <> author m2)
      (function m1 <> function m2)
      (keywords m1 <> keywords m2)
      (persons m1 <> persons m2)
      (date m1 <> date m2)
      (place m1 <> place m2)
      (origin m1 <> origin m2)

instance Monoid ParsedMetaData where
  mempty =
    ParsedMetaData
      Nothing
      False
      Nothing
      Nothing
      Nothing
      Nothing
      Nothing
      Nothing
      Nothing
      RC

decodeMetaData :: String -> Writer [String] (Maybe ParsedMetaData)
decodeMetaData str =
  case decodeEither' (B.pack str) :: Either ParseException ParsedMetaData of
    Right d -> return $ Just d
    Left f -> do
      tell ["Tried parsing: \n" ++ str ++ "\nError: " ++ (show f) ++ "\n\n"]
      return Nothing
