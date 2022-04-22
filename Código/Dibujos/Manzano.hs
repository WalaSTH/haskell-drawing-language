module Dibujos.Qcyo where

import Dibujo 
import FloatingPic
import Interp 
import Graphics.Gloss ( white, Rectangle (Rectangle) ) 
import Dibujo (Dibujo)
import Interp (interp)

data Forma = Rectangulo | Efe | Blanco

interpForma :: Forma -> FloatingPic
interpForma Rectangulo = rectan 
interpForma Efe = fShape 
interpForma Blanco = vacía

escalera :: Int -> Dibujo Forma
escalera 1 = (Básica Efe) ^^^ Espejar (Básica Efe) ^^^ (r180 (Básica Efe)) ^^^ Espejar (r180 (Básica Efe))
escalera n = (Rot45 $ escalera (n-1)) ^^^ escalera (n-1)

toro :: Int -> Dibujo Forma
toro n = (escalera n) ^^^ (Espejar (escalera n)) 

torosEnfrentados :: Int -> Dibujo Forma
torosEnfrentados n = (escalera n) ^^^ (Espejar (escalera n)) ^^^ (r180 $ escalera n)  ^^^ (Espejar $ r180 $ escalera n)

formaConfig :: Float -> Float -> Conf Forma
formaConfig x y = Dis {
    name = "L",
    basic = interpForma,
    fig = torosEnfrentados 10, 
    width = x,
    height = y,
    col = white
}
