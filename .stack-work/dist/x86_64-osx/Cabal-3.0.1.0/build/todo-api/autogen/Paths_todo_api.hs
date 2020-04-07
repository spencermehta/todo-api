{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_todo_api (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
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
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/spencer/cs2/todo-api/.stack-work/install/x86_64-osx/20503112e8c30bb7dd2dc1bb017b09fda5fbacf6558dfd00ce262572f9736379/8.8.3/bin"
libdir     = "/Users/spencer/cs2/todo-api/.stack-work/install/x86_64-osx/20503112e8c30bb7dd2dc1bb017b09fda5fbacf6558dfd00ce262572f9736379/8.8.3/lib/x86_64-osx-ghc-8.8.3/todo-api-0.1.0.0-6Q6fDtPoVvfEYwOme52tcF-todo-api"
dynlibdir  = "/Users/spencer/cs2/todo-api/.stack-work/install/x86_64-osx/20503112e8c30bb7dd2dc1bb017b09fda5fbacf6558dfd00ce262572f9736379/8.8.3/lib/x86_64-osx-ghc-8.8.3"
datadir    = "/Users/spencer/cs2/todo-api/.stack-work/install/x86_64-osx/20503112e8c30bb7dd2dc1bb017b09fda5fbacf6558dfd00ce262572f9736379/8.8.3/share/x86_64-osx-ghc-8.8.3/todo-api-0.1.0.0"
libexecdir = "/Users/spencer/cs2/todo-api/.stack-work/install/x86_64-osx/20503112e8c30bb7dd2dc1bb017b09fda5fbacf6558dfd00ce262572f9736379/8.8.3/libexec/x86_64-osx-ghc-8.8.3/todo-api-0.1.0.0"
sysconfdir = "/Users/spencer/cs2/todo-api/.stack-work/install/x86_64-osx/20503112e8c30bb7dd2dc1bb017b09fda5fbacf6558dfd00ce262572f9736379/8.8.3/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "todo_api_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "todo_api_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "todo_api_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "todo_api_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "todo_api_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "todo_api_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
