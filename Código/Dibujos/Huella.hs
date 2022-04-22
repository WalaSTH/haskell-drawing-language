module Dibujos.Huella where

import Dibujo 
import FloatingPic
import Interp  
import Graphics.Gloss ( white, Rectangle (Rectangle) ) 
import Dibujo (Dibujo)
import Interp (interp)

data Forma = Triangulo

interpForma :: Forma -> FloatingPic
interpForma Triangulo = trian2

huella :: Int -> Dibujo Forma
huella 1 = r180 (Básica Triangulo) 
huella n =  (r270 (huella (n-1) ))  /// (Rot45( r180 (huella (n-1))))

huellaConfig :: Float -> Float -> Conf Forma
huellaConfig x y = Dis {
    name = "L",
    basic = interpForma,
    fig = escalera 10, 
    width = x,
    height = y,
    col = white
}