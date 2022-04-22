{-# LANGUAGE ExistentialQuantification, NondecreasingIndentation #-}
module Main (main) where

import Data.Maybe (fromMaybe)
import System.Console.GetOpt (ArgDescr(..), ArgOrder(..), OptDescr(..), getOpt)
import System.Environment (getArgs)
import Text.Read (readMaybe)

import Interp (Conf(name), initial)
import Dibujos.Ejemplo (ejemploConf)
import Dibujos.Escher (escherConf)
import Dibujos.EscherAnimado (escherAnimadoConf)
import Dibujos.Feo (feoConf)
import Dibujos.Huella (huellaConfig)
import Dibujos.Manzano
    (manzanoConfig, toroConfig, torosEnfrentadosConfig, toroArenaConfig, escaleraConfig)


-- Tipo para tener una lista de las configuraciones de todos los dibujos
data ConfList = forall a. Elem (Conf a) ConfList | Nil

infixr `Elem`

-- Lista de configuraciones de los dibujos
configs :: Float -> Float -> ConfList
configs x y =
    ejemploConf x y `Elem`
    escherConf x y `Elem`
    feoConf x y `Elem`
    escherAnimadoConf x y `Elem`
    huellaConfig x y `Elem`
    manzanoConfig x y `Elem`
    toroConfig x y `Elem`
    torosEnfrentadosConfig x y `Elem`
    toroArenaConfig x y `Elem`
    escaleraConfig x y `Elem`
    Nil


-- Dibuja el dibujo n
initial' :: ConfList -> String -> IO ()
initial' Nil n = do
    putStrLn $
        "No hay un dibujo llamado " ++ n
        ++ "\n    --list para ver lista de dibujos"
initial' (c `Elem` cs) n = 
    if n == name c then
        initial c
    else
        initial' cs n


-- Obtener nombres de una lista de configuraciones
names :: ConfList -> [String]
names Nil = []
names (c `Elem` cs) = name c : names cs


-- Parseo de argumentos

data Flag = List | Size String
    deriving (Eq, Show)

getSize :: [Flag] -> Maybe String
getSize [] = Nothing
getSize (Size s : _) = Just s
getSize (_ : fs) = getSize fs

options :: [OptDescr Flag]
options = [
        Option ['l'] ["list"] (NoArg List) "Lista de dibujos",
        Option ['s'] ["size"] (ReqArg Size "SIZE") "Setear tamaño de la ventana"
    ]


main :: IO ()
main = do
    args <- getArgs
    let (flags, args', err) = getOpt Permute options args
    if not $ null err then
        putStrLn $ concat err
    else do
    let size = fromMaybe 400 $ do -- Esto así da 400 si el argumento no es un número
            ss <- getSize flags   -- Seguramente se podría mejorar
            readMaybe ss
        confs = configs size size
    if List `elem` flags then
        putStrLn $ unlines $ names confs
    else if null args' then
        putStrLn "Falta nombre de dibujo"
    else do
    initial' confs $ head args'
