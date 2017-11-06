module TestImport
    ( module X
    , module TestImport
    ) where


-- | Library specifics imports
import Models as X
import DataLayer as X
import Config as X

import Test.Hspec as X
{-import Test.Hspec as X hiding-}
    {-( expectationFailure-}
    {-, shouldContain-}
    {-, shouldEndWith-}
    {-, shouldMatchList-}
    {-, shouldNotBe-}
    {-, shouldNotContain-}
    {-, shouldNotReturn-}
    {-, shouldNotSatisfy-}
    {-, shouldSatisfy-}
    {-, shouldStartWith-}
    {-, shouldBe-}
    {-, shouldReturn-}
    {-)-}
{-import Test.Hspec.Expectations.Lifted as X-}

import Control.Monad.IO.Class as X
import Control.Monad.Reader as X

withConfig :: SpecWith Config -> Spec
withConfig = before getConfig

getConfig :: MonadIO m => m Config
getConfig = do
    pool <- makePool Test
    return Config { pool=pool }
