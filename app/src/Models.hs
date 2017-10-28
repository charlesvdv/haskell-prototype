{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}
module Models where

import Database.Persist
import Database.Persist.Postgresql
import Database.Persist.TH
import Data.Time (UTCTime)

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
User
    firstname String
    lastname String
    email String
    deriving Show

Link
    url String
    title String
    deriving Show

Category
    category String
    deriving Show

UserLink
    userId UserId
    linkId LinkId
    created UTCTime default=CURRENT_TIMESTAMP
    deriving Show

UserLinkCategory
    userLinkId UserLinkId
    categoryId CategoryId
    deriving Show
|]
