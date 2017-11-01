module DataLayerSpec where

import TestImport
import Control.Monad.Reader (runReader)

spec :: Spec
spec = do
    describe "Datalayer test" $ do
        it "should create an user and fetch it back" $ do
            conf <- getConfig
            runReader (insertUser "Charles" "Vandevoorde" "charles.vandevoorde@hotmail.be") conf
            let user = runReader (getUser "charles.vandevoorde@hotmail.be") conf
            user `shouldBe` Just (User "Charles" "Vandevoorde" "charles.vandevoorde@hotmail.be")
