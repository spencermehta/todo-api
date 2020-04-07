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
  toRow i = [toField $ itemDesc i]

instance ToRow Int where
  toRow i = [toField i]

instance ToJSON Item

instance FromJSON Item

insertItem :: Connection -> Item -> IO Item
insertItem conn item = do
  let insertQuery = "insert into todo (itemDesc) values (?)"
      keyQuery = "select last_insert_rowid()"
  execute conn insertQuery item
  [Only id] <- query conn keyQuery ()
  return item { itemId = id }

deleteItem :: Connection -> Int -> IO ()
deleteItem conn id = do
  let deleteQuery = "delete from todo where itemId = ?"
  execute conn deleteQuery id

routes :: Connection -> ScottyM ()
routes conn = do
    
  get "/items" $ do
    items <- liftIO (query_ conn "select * from todo" :: IO [Item])
    json items

  post "/items" $ do
    item <- jsonData :: ActionM Item
    newItem <- liftIO (insertItem conn item)
    json newItem

  delete "/items/:id" $ do
    id <- param "id"
    liftIO (deleteItem conn id)
    text "del"


main :: IO ()
main = do
  putStrLn "Starting Server..."
  conn <- open "todo.db"
  scotty 3000 $ routes conn
