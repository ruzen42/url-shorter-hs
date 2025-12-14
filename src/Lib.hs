module Lib (startapp) where

data UrlQuery

type API = "shorten" :> Post '[JSON]

startapp :: Int -> Int -> IO ()

