{-# Language ScopedTypeVariables #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
module Main where

import Control.Applicative

import Data.Int
import Data.Word
import Data.Time
import qualified Data.Text as T
import qualified Data.Text.Lazy as L

import Test.Hspec
import Test.Hspec.QuickCheck(prop)
import Test.QuickCheck

import Web.PathPieces

instance Arbitrary T.Text where
  arbitrary = T.pack <$> arbitrary

instance Arbitrary L.Text where
  arbitrary = L.pack <$> arbitrary

instance Arbitrary Day where
  arbitrary = liftA3 fromGregorian (fmap abs arbitrary) arbitrary arbitrary

main :: IO ()
main = hspec spec

(<=>) :: Eq a => (a -> b) -> (b -> Maybe a) -> a -> Bool
(f <=> g) x = g (f x) == Just x

spec :: Spec
spec = do
  describe "PathPiece" $ do
    prop "toPathPiece <=> fromPathPiece Bool"         $ \(p :: Bool)   -> (toPathPiece <=> fromPathPiece) p
    prop "toPathPiece <=> fromPathPiece Int"          $ \(p :: Int)    -> (toPathPiece <=> fromPathPiece) p
    prop "toPathPiece <=> fromPathPiece Int8"         $ \(p :: Int8)   -> (toPathPiece <=> fromPathPiece) p
    prop "toPathPiece <=> fromPathPiece Int16"        $ \(p :: Int16)  -> (toPathPiece <=> fromPathPiece) p
    prop "toPathPiece <=> fromPathPiece Int32"        $ \(p :: Int32)  -> (toPathPiece <=> fromPathPiece) p
    prop "toPathPiece <=> fromPathPiece Word"         $ \(p :: Word)   -> (toPathPiece <=> fromPathPiece) p
    prop "toPathPiece <=> fromPathPiece Word8"        $ \(p :: Word8)  -> (toPathPiece <=> fromPathPiece) p
    prop "toPathPiece <=> fromPathPiece Word16"       $ \(p :: Word16) -> (toPathPiece <=> fromPathPiece) p
    prop "toPathPiece <=> fromPathPiece Word32"       $ \(p :: Word32) -> (toPathPiece <=> fromPathPiece) p
    prop "toPathPiece <=> fromPathPiece Word64"       $ \(p :: Word64) -> (toPathPiece <=> fromPathPiece) p
    prop "toPathPiece <=> fromPathPiece Word64"       $ \(p :: Word64) -> (toPathPiece <=> fromPathPiece) p
    prop "toPathPiece <=> fromPathPiece String"       $ \(p :: String) -> (toPathPiece <=> fromPathPiece) p
    prop "toPathPiece <=> fromPathPiece Text.Strict"  $ \(p :: T.Text) -> (toPathPiece <=> fromPathPiece) p
    prop "toPathPiece <=> fromPathPiece Text.Lazy"    $ \(p :: L.Text) -> (toPathPiece <=> fromPathPiece) p
    prop "toPathPiece <=> fromPathPiece Day"          $ \(p :: Day)    -> (toPathPiece <=> fromPathPiece) p

    prop "toPathPiece <=> fromPathPiece Maybe String" $ \(p::Maybe String) -> (toPathPiece <=> fromPathPiece) p

  describe "PathMultiPiece" $ do
    prop "toPathMultiPiece <=> fromPathMultiPiece String" $ \(p::[String]) -> (toPathMultiPiece <=> fromPathMultiPiece) p
    prop "toPathMultiPiece <=> fromPathMultiPiece Text"   $ \(p::[T.Text]) -> (toPathMultiPiece <=> fromPathMultiPiece) p

  it "bad ints are rejected" $ fromPathPiece (T.pack "123hello")
    `shouldBe` (Nothing :: Maybe Int)

