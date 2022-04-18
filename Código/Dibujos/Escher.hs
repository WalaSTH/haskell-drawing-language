module Dibujos.Escher (
    Escher(..),
    escher, -- Necesario para EscherAnimado
    interpEscher,
    escherConf,
    white
) where

import Dibujo (r180, r270, (^^^), encimar4, cuarteto, Dibujo(..))
import FloatingPic (vacía, trian2, FloatingPic)
import Interp (Conf(..))
import Graphics.Gloss ( white )



data Escher = Blanco | Pez


-- Esquina con nivel de detalle en base a la figura p.
esquina :: Int -> Dibujo Escher -> Dibujo Escher
esquina 0 _ = Básica Blanco
esquina n p
    | n > 0 =  cuarteto (esquina (n-1) p) (lado (n-1) p) (Rotar $ lado (n-1) p) (dibujoU p)
    | otherwise = error "esquina: nivel de detalle negativo"

-- Lado con nivel de detalle.
lado :: Int -> Dibujo Escher -> Dibujo Escher
lado 0 _ = Básica Blanco
lado n p
    | n > 0 = cuarteto (lado (n-1) p) (lado (n-1) p) (Rotar $ dibujoT p) (dibujoT p)
    | otherwise  = error "lado: nivel de detalle no válido"

-- El dibujoU.
dibujoU :: Dibujo Escher -> Dibujo Escher
dibujoU p = encimar4 p'
    where
        p' = Rot45 p

-- El dibujo t.
dibujoT :: Dibujo Escher -> Dibujo Escher
dibujoT p = Encimar p (p' ^^^ r270 p')
    where
        p' = Rot45 p


noneto ::
    Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a
    -> Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a
    -> Dibujo a
noneto
    p q r
    s t u
    v w x = 
    Apilar 2 1 (Juntar 2 1 p (Juntar 1 1 q r)) $
        Apilar 1 1 (Juntar 2 1 s (Juntar 1 1 t u)) $
            Juntar 2 1 v (Juntar 1 1 w x)  

-- El dibujo de Escher:
escher :: Int -> Escher -> Dibujo Escher
escher n f =
    noneto
        p q r
        s t u
        v w x  
    where
        p = esquina n $ Básica f
        q = lado n $ Básica f
        r = r270 p
        s = Rotar q
        t = dibujoU $ Básica f
        u = r270 q
        v = Rotar p
        w = r180 q
        x = r180 p

-- Figura básica para usar en el dibujo de Escher
pez :: FloatingPic 
pez = trian2

interpEscher :: Escher -> FloatingPic 
interpEscher Blanco = vacía
interpEscher Pez = pez

-- Configuración para interpretar el dibujo de Escher
escherConf :: Float -> Float -> Conf Escher
escherConf x y = Dis {
    name = "Escher",
    basic = interpEscher ,
    fig = escher 5 Pez,
    width = x,
    height = y,
    col = white
}
