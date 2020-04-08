module Main where

import Lib
import Web.Scotty
import Database.SQLite.Simple

main :: IO ()
main = do
  putStrLn "Starting Server..."
  conn <- open "todo.db"
  scotty 3000 $ routes conn
