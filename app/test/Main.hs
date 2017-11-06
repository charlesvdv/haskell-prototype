{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE FlexibleContexts           #-}
module Main where

import qualified Spec
import TestImport
import Control.Monad.Reader (runReaderT)
import Database.Persist.Sql (insert)
{-import Prelude hiding (unlines)-}
import Data.Text (Text, pack)

main :: IO ()
main = do
    cfg <- getConfig
    flip runReaderT cfg $ do
        migrateDb
        boostrapTestDb
    hspec Spec.spec

boostrapTestDb :: (MonadIO m, MonadReader Config m) => m ()
boostrapTestDb = runDb $ do
    _ <- insert $ User "Jane" "Doe" "jane.doe@example.com"
    return ()
{-bootstrapTestSql :: Text-}
{-bootstrapTestSql = pack $-}
    {-unlines [ "-- Insert dummy user."-}
            {-, "INSERT INTO user (firstname, lastname, email)"-}
            {-, "('Jane', 'Doe', 'jane.doe@example.com')"-}
    {-]-}
