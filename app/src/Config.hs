{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE TypeFamilies               #-}
module Config (
    Config(..),
    Environment(..),
    makePool,
) where

import Database.Persist.Postgresql (ConnectionPool, ConnectionString, createPostgresqlPool)
import System.Environment (lookupEnv)
import qualified Data.ByteString.Char8 as BS
import Control.Monad.Logger (MonadLogger, runStdoutLoggingT, runNoLoggingT, LoggingT)
import Data.Maybe (fromMaybe)
import Control.Monad.IO.Class
import Control.Monad.Trans.Control (MonadBaseControl)

data Config =
    Config
    { pool :: ConnectionPool
    }

-- | Defines the environment types of the running programs.
data Environment
    = Test
    | Dev
    | Production
    deriving (Show, Eq)

-- | Create the postgresql database connection pool with appropriate logger.
makePool :: MonadIO m => Environment -> m ConnectionPool
makePool Test = liftIO $ runNoLoggingT $ makePool_ Test
makePool e = liftIO $ runStdoutLoggingT $ makePool_ e

-- | Create a postgresql database connection pool without logger handling.
makePool_ :: (MonadIO m, MonadBaseControl IO m, MonadLogger m) => Environment -> m ConnectionPool
makePool_ env = connStr >>= (`createPostgresqlPool` envPool env)

-- | Env variable needed to create the connection pool.
-- Tuples parameters are:
--  * key to build the connection string
--  * env variable
--  * default value
dbEnv = [ ("host", "DB_HOST", "localhost")
        , ("port", "DB_PORT", "5432")
        , ("user", "DB_USER", "test")
        , ("password", "DB_PASSWORD", "test")
        , ("dbname", "DB_NAME", "test-app")
        ]

-- | Create the connection string.
connStr :: MonadIO m => m ConnectionString
connStr = do
    key_values <- liftIO $ mapM key_value dbEnv
    return $ BS.intercalate " " key_values
        where key_value (key, env, default_val) = do env_value <- lookupEnv env
                                                     return . BS.pack $ key ++ "=" ++ fromMaybe default_val env_value
-- | Defines the number of pool available.
envPool :: Environment -> Int
envPool Test        = 1
envPool Dev         = 1
envPool Production  = 10
