module Main where
import Interp
import Dibujos.Escher





main :: IO ()
main = initial $ escherConf 400 400
