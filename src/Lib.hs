{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( startApp
    , app
    ) where

import Servant
import Network.Wai.Handler.Warp
import Data.Aeson
import Data.Aeson.TH
import GHC.Generics (Generic)
import qualified Data.Map as M
import Control.Concurrent.MVar
import Control.Monad.IO.Class (liftIO)
import Data.Word (Word32)
import Data.Digest.Pure.MD5 (md5)
import qualified Data.ByteString.Lazy.Char8 as BL
import qualified Data.ByteString.Char8 as B8
import Network.Wai ()
import Network.HTTP.Types ()
import Network.Wai.Internal ()
import Data.Bits ()
import Data.Char ()

data UrlRequest = UrlRequest
  { url :: String
  } deriving (Eq, Show, Generic)

data UrlResponse = UrlResponse
  { shortUrl :: String
  } deriving (Eq, Show, Generic)

$(deriveJSON defaultOptions ''UrlRequest)
$(deriveJSON defaultOptions ''UrlResponse)

type API =
       "shorten" :> ReqBody '[JSON] UrlRequest :> Post '[JSON] UrlResponse
  :<|> Capture "code" String :> Get '[JSON] NoContent

api :: Proxy API
api = Proxy

type Store = M.Map String String

startApp :: Int -> IO ()
startApp port = do
    store <- newMVar M.empty
    putStrLn $ "Running on https://localhost:" ++ show port
    run port (app store)

app :: MVar Store -> Application
app store = serve api (server store)

server :: MVar Store -> Server API
server store =
    shortenHandler store :<|> redirectHandler store

shortenHandler :: MVar Store -> UrlRequest -> Handler UrlResponse
shortenHandler store (UrlRequest longUrl) = do
    let code = hash longUrl
        short = "http://localhost:PORT/" ++ code
    liftIO $ modifyMVar_ store (pure . M.insert code longUrl)
    pure (UrlResponse short)

redirectHandler :: MVar Store -> String -> Handler NoContent
redirectHandler store code = do
    urls <- liftIO $ readMVar store
    case M.lookup code urls of
        Just longUrl -> throwError err302
            { errHeaders = [("Location", B8.pack longUrl)] }
        Nothing -> throwError err404

base62 :: String
base62 = ['0'..'9'] ++ ['A'..'Z'] ++ ['a'..'z']

toBase62 :: Word32 -> String
toBase62 0 = [base62 !! 0]
toBase62 n = go n
  where
    go 0 = []
    go x = let (q, r) = x `divMod` 62
           in (base62 !! fromIntegral r) : go q

hash :: String -> String
hash s =
    let digest = md5 (BL.pack s)
        w32 = fromIntegral (sum $ map fromEnum (show digest)) :: Word32
    in take 6 (toBase62 w32)
