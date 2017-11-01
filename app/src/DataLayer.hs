{-# LANGUAGE FlexibleContexts           #-}
module DataLayer where

import Control.Monad.IO.Class
import Database.Persist.Sql
import Control.Monad.Reader (MonadReader, ReaderT, asks)
import Control.Monad.Trans.Control (MonadBaseControl)

import Models
import Config

runDb :: (MonadIO m, MonadReader Config m) => SqlPersistT IO b -> m b
runDb query = do
    pool <- asks pool
    liftIO $ runSqlPool query pool

-- | Insert a new user only if the email is not yet on the db.
insertUser :: (MonadIO m, MonadReader Config m) => Firstname -> Lastname -> Email -> m UserId
insertUser first last email = runDb $ do
    maybe_user <- getBy $ UniqueUser email
    case maybe_user of
        Nothing -> insert $ User first last email
        Just (Entity u _) -> return u

-- | Get an user according to his email address.
getUser :: (MonadIO m, MonadReader Config m) => Email -> m (Maybe User)
getUser email = runDb $ do
    maybe_user <- getBy (UniqueUser email)
    case maybe_user of
      Just (Entity _ user) -> return $ Just user
      Nothing -> return Nothing