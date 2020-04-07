{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Main where

import Web.Scotty
import Data.Monoid ((<>))
import Data.Aeson (FromJSON, ToJSON)
import GHC.Generics
import Control.Applicative
import Control.Monad.IO.Class
import Database.SQLite.Simple
import Database.SQLite.Simple.FromRow
import Database.SQLite.Simple.ToField

data Item = Item { itemId :: Maybe Int, itemDesc :: String }
  deriving (Show, Generic)

type ItemList = [Item]

instance FromRow Item where
    fromRow = Item <$> field <*> field

instance ToRow Item where
    toRow i = [toField $ itemId i, toField $ itemDesc i]

instance ToJSON Item

instance FromJSON Item


insertChecklist :: Connection -> Item -> IO Item
insertChecklist conn item = do
    let insertQuery = "insert into todo (itemDesc) values (?) returning itemId"
    [Only id] <- query conn insertQuery item
    return item { itemId = id }

routes :: Connection -> ScottyM ()
routes conn = do
    
  get "/items" $ do
    items <- liftIO (query_ conn "select * from todo" :: IO [Item])
    json items

  post "/items" $ do
          item <- jsonData :: ActionM Item
          newItem <- liftIO (insertChecklist conn item)
          json newItem

main :: IO ()
main = do
  putStrLn "Starting Server..."
  conn <- open "todo.db"
  scotty 3000 $ routes conn
