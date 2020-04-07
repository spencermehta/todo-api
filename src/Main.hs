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

data Item = Item { itemDesc :: String }
  deriving (Show, Generic)

type ItemList = [Item]

instance FromRow Item where
    fromRow = Item <$> field

instance ToRow Item where
    toRow i = [toField $ itemText i, toField $ finished i, toField $ checklist i]

instance ToJSON Item
instance FromJSON Item

withConn :: String -> (Connection -> IO ()) -> IO ()
withConn dbName action = do
   conn <- open dbName
   action conn
   close conn

addItem :: String -> IO ()
addItem itemDesc = withConn "todo.db" $
          \conn -> do
            execute conn "INSERT INTO todo (itemDesc) VALUES (?)"
              (Only (itemDesc :: String))
            r <- query_ conn "SELECT * FROM todo" :: IO [(Int, String)]
            mapM_ print r
-- addItem :: Item -> IO ()
-- addItem (Item item) = withConn "todo.db" $
--           \conn -> do
--             execute conn "INSERT INTO todo (itemDesc) VALUES (?)"
--               (Only item)
--             r <- query_ conn "SELECT * FROM todo WHERE itemId = 10" :: IO [(Int, String)]
--             mapM_ print r

-- matchesId :: Int -> Item -> Bool
-- matchesId id item = itemId item == id

routes :: ScottyM ()
routes conn = do
    
  get "/items" $ do
    items <- liftIO (query_ conn "select * from todo" :: IO [Item])

  post "/items:item" $ do
    item <- param "item"
    liftIO (addItem item)
    text ("hello !")

  -- post "/items" $ do
  --   item <- jsonData :: ActionM Item
  --   addItem item

main :: IO ()
main = do
  putStrLn "Starting Server..."
  conn <- open "todo.db"
  scotty 3000 $ routes conn
