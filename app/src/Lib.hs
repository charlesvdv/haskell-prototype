{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE TypeFamilies               #-}
module Lib
    ( default_main
    ) where

import Control.Monad.Logger (runStderrLoggingT)
import Control.Monad.IO.Class (liftIO)
import Database.Persist.Postgresql
import Database.Persist.Sql (runSqlPool)

import Models
import Config (makePool, Environment(..))

default_main :: IO ()
default_main = do
    pool <- makePool Dev
    runSqlPool (runMigration migrateAll) pool
