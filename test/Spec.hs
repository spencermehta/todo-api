{-# LANGUAGE OverloadedStrings #-}
-- module Spec where

import Lib
import Test.Hspec
import Test.QuickCheck
import Control.Exception (evaluate)
import Database.SQLite.Simple


main :: IO ()
-- main = hspec $ do
--   describe "Prelude.head" $ do
--     it "returns the first element of a list" $ do
--       head [23 ..] `shouldBe` (23 :: Int)

-- main :: IO ()
-- main = putStrLn "Test suite not yet implemented"

main = open "todo.db" >>= \conn ->
    hspec $ before_ flushdb $ do
        describe "insert item" $ do
            it "inserts single successfully" $ 
                insertItem conn (Item (Just 0) "Test Item") `shouldReturn` (Item (Just 4) "Test Item")
            -- it "interts multiple successfully" $
            --     map (\item -> (insertItem conn item) >>= (==) item) items 
        describe "delete item" $ do 
            it "deletes single successfully" $
                deleteItem conn 3 `shouldReturn` [(Item (Just 3) "Test Item 3")]
            it "deletes non existent" $
                deleteItem conn 4 `shouldReturn` []

            
items = [Item (Just 1) "Test Item 1", Item (Just 2) "Test Item 2"]

flushdb = do
    conn <- open "todo.db"
    execute conn "DELETE FROM todo" ()
    execute conn "INSERT INTO todo values (1, 'Test Item 1')" ()
    execute conn "INSERT INTO todo values (2, 'Test Item 2')" ()
    execute conn "INSERT INTO todo values (3, 'Test Item 3')" ()


-- -- Simplest SELECT
-- testSimpleOnePlusOne :: Test
-- testSimpleOnePlusOne = TestCase $ do
--     rows <- query_ conn "SELECT 1+1" :: IO [Only Int]
--     assertEqual "row count" 1 (length rows)
--     assertEqual "value" (Only 2) (head rows)