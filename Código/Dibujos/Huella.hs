module Dibujos.Huella (
    Forma(..),
    huella,
    interpForma,
    huellaConfig,
    white
) where
    

import Dibujo (Dibujo(..), ///, r180, r270, (^^^))
import FloatingPic (FloatingPic, trian2)
import Interp  (Conf(..))
import Graphics.Gloss ( white, Rectangle (Rectangle) ) 


data Forma = Triangulo

interpForma :: Forma -> FloatingPic
interpForma Triangulo = trian2

huella' :: Int -> Dibujo Forma
huella' 1 = r180 (Básica Triangulo) 
huella' n =  r270 (huella' (n-1)) /// Rot45 (r180 (huella' (n-1)))

huella :: Dibujo Forma 
huella = huella' 15

huellaConfig :: Float -> Float -> Conf Forma
huellaConfig x y = Dis {
    name = "Huella",
    basic = interpForma,
    fig = huella, 
    width = x,
    height = y,
    col = white
}