{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
#if __GLASGOW_HASKELL__ >= 810
{-# OPTIONS_GHC -Wno-prepositive-qualified-module #-}
#endif
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_url_shorter (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath




bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/home/ruzen42/src/url-shorter/.stack-work/install/x86_64-linux-nix/a6c75ca328dfd32587877d506b6883c7766a0cc511ef43a63e247e2d70a478ec/9.10.2/bin"
libdir     = "/home/ruzen42/src/url-shorter/.stack-work/install/x86_64-linux-nix/a6c75ca328dfd32587877d506b6883c7766a0cc511ef43a63e247e2d70a478ec/9.10.2/lib/x86_64-linux-ghc-9.10.2-2c4c/url-shorter-0.1.0.0-7xKAx6YhVsQKQKcojfvlPm"
dynlibdir  = "/home/ruzen42/src/url-shorter/.stack-work/install/x86_64-linux-nix/a6c75ca328dfd32587877d506b6883c7766a0cc511ef43a63e247e2d70a478ec/9.10.2/lib/x86_64-linux-ghc-9.10.2-2c4c"
datadir    = "/home/ruzen42/src/url-shorter/.stack-work/install/x86_64-linux-nix/a6c75ca328dfd32587877d506b6883c7766a0cc511ef43a63e247e2d70a478ec/9.10.2/share/x86_64-linux-ghc-9.10.2-2c4c/url-shorter-0.1.0.0"
libexecdir = "/home/ruzen42/src/url-shorter/.stack-work/install/x86_64-linux-nix/a6c75ca328dfd32587877d506b6883c7766a0cc511ef43a63e247e2d70a478ec/9.10.2/libexec/x86_64-linux-ghc-9.10.2-2c4c/url-shorter-0.1.0.0"
sysconfdir = "/home/ruzen42/src/url-shorter/.stack-work/install/x86_64-linux-nix/a6c75ca328dfd32587877d506b6883c7766a0cc511ef43a63e247e2d70a478ec/9.10.2/etc"

getBinDir     = catchIO (getEnv "url_shorter_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "url_shorter_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "url_shorter_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "url_shorter_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "url_shorter_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "url_shorter_sysconfdir") (\_ -> return sysconfdir)



joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '/'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/'
