module DataLayerSpec where

import TestImport
import Data.Maybe (fromJust)

spec :: Spec
spec = do
    describe "Datalayer test" $ do
        it "should create an user and fetch it back" $ do
            conf <- getConfig
            runReaderT (insertUser "Charles" "Vandevoorde" "charles.vandevoorde@hotmail.be") conf
            user <- runReaderT (getUser "charles.vandevoorde@hotmail.be") conf
            (userEmail $ fromJust user) `shouldBe` "charles.vandevoorde@hotmail.be"
