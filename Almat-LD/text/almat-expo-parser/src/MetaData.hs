{-# LANGUAGE DeriveGeneric        #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TypeSynonymInstances #-}

module MetaData
  ( ParsedMetaData(..)
  , decodeMetaData
  ) where

import           Data.Aeson            (ToJSON)
import qualified Data.ByteString.Char8 as B
import qualified Data.Vector           as V
import           Data.Yaml
import           GHC.Generics

data ParsedMetaData =
  ParsedMetaData
    { linksTo  :: Maybe Value
    , kind     :: Maybe Value
    , author   :: Maybe Value
    , keywords :: Maybe Value
    , persons  :: Maybe Value
    , date     :: Maybe Value
    , place    :: Maybe Value
    }
  deriving (Generic, Show, Eq)

instance ToJSON ParsedMetaData

instance FromJSON ParsedMetaData

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
      (keywords m1 <> keywords m2)
      (persons m1 <> persons m2)
      (date m1 <> date m2)
      (place m1 <> place m2)

instance Monoid ParsedMetaData where
  mempty =
    ParsedMetaData Nothing Nothing Nothing Nothing Nothing Nothing Nothing

decodeMetaData :: String -> Maybe ParsedMetaData
decodeMetaData str =
  case decodeEither' (B.pack str) :: Either ParseException ParsedMetaData of
    Right d -> Just d
    Left _  -> Nothing
