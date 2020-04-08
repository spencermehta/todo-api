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
        describe "Lib.insertItem" $ do
            it "inserts successfully" $ 
                insertItem conn (Item (Just 0) "Test Item") `shouldReturn` (Item (Just 1) "Test Item")

flushdb = do
    conn <- open "todo.db"
    execute conn "DELETE FROM todo" ()

-- -- Simplest SELECT
-- testSimpleOnePlusOne :: Test
-- testSimpleOnePlusOne = TestCase $ do
--     rows <- query_ conn "SELECT 1+1" :: IO [Only Int]
--     assertEqual "row count" 1 (length rows)
--     assertEqual "value" (Only 2) (head rows)