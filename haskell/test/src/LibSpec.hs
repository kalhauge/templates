{-# LANGUAGE BlockArguments #-}
module LibSpec where

-- spec
import SpecHelper

-- hedgehog
import Hedgehog
import qualified Hedgehog.Gen as Gen
import qualified Hedgehog.Range as Range

-- library
import qualified Lib

spec :: Spec
spec = do
  specAdd

specAdd :: Spec
specAdd = describe "add" do
  it "should be communative" do
    hedgehog do 
      let smallInts = Gen.intergral (Range.linearFrom 0 (-100) (100))
      x <- forAll smallInts
      y <- forAll smallInts
      Lib.add x y === Lib.add y x

