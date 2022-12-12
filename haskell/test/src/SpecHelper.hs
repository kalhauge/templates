module SpecHelper 
  ( module Test.Hspec
  , -- * Other exports
    shouldBe
  , shouldSatisfy
  , hedgehog
  ) where

-- hspec
import Test.Hspec hiding (shouldBe, shouldSatisfy)
import Test.Hspec.Expectations.Pretty
import Test.Hspec.Hedgehog (hedgehog)
