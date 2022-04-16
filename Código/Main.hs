module Main where
import Graphics.Gloss hiding (color)
import Interp
import Dibujos.Escher





main :: IO ()
main = initial $ escherConf 400 400
