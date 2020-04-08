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

-- data type for a todo item 
-- can easily be expanded to include more fields
data Item = Item { itemId :: Maybe Int, itemDesc :: String }
  deriving (Show, Generic)

-- defines conversion from a database record into an Item 
instance FromRow Item where
  fromRow = Item <$> field <*> field

-- defines conversion from an Item into a database record 
instance ToRow Item where
  toRow i = [toField $ itemDesc i]

-- defines conversion from an Int to a database record
instance ToRow Int where
  toRow i = [toField i]

instance ToJSON Item
instance FromJSON Item

-- insert an Item into the database
-- takes database connection and an Item  
-- inserts new record 
-- retrieves and returns Item with key field filled
insertItem :: Connection -> Item -> IO Item
insertItem conn item = do
  let insertQuery = "insert into todo (itemDesc) values (?)"
      keyQuery = "select last_insert_rowid()"
  execute conn insertQuery item
  [Only id] <- query conn keyQuery ()
  return item { itemId = id }

-- delete Item from database
-- takes database connection and Int item id 
-- deletes record where id matches
deleteItem :: Connection -> Int -> IO ()
deleteItem conn id = do
  let deleteQuery = "delete from todo where itemId = ?"
  execute conn deleteQuery id

-- endpoints
-- takes database connection
routes :: Connection -> ScottyM ()
routes conn = do
    
  -- GET /items
  -- queries TODO table
  -- returns JSON array of Item records of table
  get "/items" $ do
    items <- liftIO (query_ conn "select * from todo" :: IO [Item])
    json items

  -- POST /items
  -- receives new Item in JSON form, missing itemId
  -- inserts into table
  -- returns new Item in JSON form, with itemId assigned by database
  post "/items" $ do
    item <- jsonData :: ActionM Item
    newItem <- liftIO (insertItem conn item)
    json newItem

  -- DELETE /items/:id
  -- gets :id parameter
  -- deletes Item record with itemId = id from database
  -- returns string 'del' to confirm deletion
  delete "/items/:id" $ do
    id <- param "id"
    liftIO (deleteItem conn id)
    text "del"


main :: IO ()
main = do
  putStrLn "Starting Server..."
  conn <- open "todo.db"
  scotty 3000 $ routes conn
