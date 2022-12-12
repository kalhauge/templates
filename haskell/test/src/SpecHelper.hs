module SpecHelper 
  ( module Test.Hspec
  , module Test.Hspec.Expectations.Pretty
  , hedgehog
  ) where


-- hspec
import Test.Hspec hiding (shouldBe, shouldSatisfy)
import Test.Hspec.Expectations.Pretty
import Test.Hspec.Hedgehog (hedgehog)
