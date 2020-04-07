{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Main where

import Web.Scotty
import Data.Monoid ((<>))
import Data.Aeson (FromJSON, ToJSON)
import GHC.Generics

data Item = Item { itemkId :: Int, itemDesc :: String }
  deriving (Show, Generic)

type ItemList = [Item]

instance ToJSON Task
instance FromJSON Task

item1 :: Item
item1 = Item {itemId = 1, itemDesc = "Complete JSON API"}

item2 :: Item
item2 = Item {itemId = 2, itemDesc = "Implement POST requests"}

allItems :: ItemList
allItems = [item1, item2]

addItem :: ItemList -> Item -> ItemList
addItem = flip (:)

matchesId :: Int -> User -> Bool
matchesId id user = userId user == id

routes :: ScottyM ()
routes = do
    
  get "/items" $ do
    json allItems

  post "/items" $ do
    item <- jsonData :: ActionM Item
    addItem item

main :: IO ()
main = do
  putStrLn "Starting Server..."
  scotty 3000 routes
