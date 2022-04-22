module Dibujos.Manzano (
    Forma(..),
    manzano,
    interpForma,
    toroConfig,
    torosEnfrentadosConfig,
    toroArenaConfig,
    escaleraConfig,
    manzanoConfig,
    white
) where

import Dibujo (Dibujo(..), r180, r270, (^^^))
import FloatingPic (FloatingPic, rectan, fShape, vacía)
import Interp (Conf(..))
import Graphics.Gloss ( white, Rectangle (Rectangle) ) 

data Forma = Rectangulo | Efe | Blanco

interpForma :: Forma -> FloatingPic
interpForma Rectangulo = rectan 
interpForma Efe = fShape 
interpForma Blanco = vacía

-- Escalera al abismo (el comienzo de todo)
escalera :: Int -> Dibujo Forma
escalera 1 = (Básica Efe) ^^^ Espejar (Básica Efe) ^^^ (r180 (Básica Efe)) ^^^ Espejar (r180 (Básica Efe))
escalera n = (Rot45 $ escalera (n-1)) ^^^ escalera (n-1)

-- Toro
toro :: Int -> Dibujo Forma
toro n = (escalera n) ^^^ (Espejar (escalera n)) 

torosEnfrentados :: Int -> Dibujo Forma
torosEnfrentados n = (escalera n) ^^^ (Espejar (escalera n)) ^^^ (r180 $ escalera n)  ^^^ (Espejar $ r180 $ escalera n)


toroArena :: Dibujo Forma
toroArena = torosEnfrentados 10 ^^^ (Rotar $ (torosEnfrentados 10))

-- Manzano
hojas :: Dibujo Forma
hojas = r270 (torosEnfrentados 5 ^^^ (Rotar $ (toro 10)))

tronco :: Dibujo Forma
tronco = Básica Rectangulo

noneto' ::
    Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a
    -> Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a
    -> Dibujo a
noneto'
    p q r
    s t u
    v w x = 
    Apilar 2 1 (Juntar 2 1 p (Juntar 1 1 q r)) $
        Apilar 1 1 (Juntar 2 1 s (Juntar 1 1 t u)) $
            Juntar 2 1 v (Juntar 1 1 w x)  

manzano :: Dibujo Forma
manzano = noneto' hojas    hojas          hojas
                (Rotar hojas)    tronco         (r270 hojas)
               (Básica Blanco) tronco (Básica Blanco)

-- Configs
manzanoConfig :: Float -> Float -> Conf Forma
manzanoConfig x y = Dis {
    name = "Manzano",
    basic = interpForma,
    fig = manzano, 
    width = x,
    height = y,
    col = white
}

toroConfig :: Float -> Float -> Conf Forma
toroConfig x y = Dis {
    name = "Toro",
    basic = interpForma,
    fig = toro 10, 
    width = x,
    height = y,
    col = white
}

torosEnfrentadosConfig :: Float -> Float -> Conf Forma
torosEnfrentadosConfig x y = Dis {
    name = "TorosEnfrentados",
    basic = interpForma,
    fig = torosEnfrentados 10, 
    width = x,
    height = y,
    col = white
}

toroArenaConfig :: Float -> Float -> Conf Forma
toroArenaConfig x y = Dis {
    name = "ToroArena",
    basic = interpForma,
    fig = toroArena, 
    width = x,
    height = y,
    col = white
}  

escaleraConfig :: Float -> Float -> Conf Forma
escaleraConfig x y = Dis {
    name = "Escalera",
    basic = interpForma,
    fig = escalera 10, 
    width = x,
    height = y,
    col = white
}

