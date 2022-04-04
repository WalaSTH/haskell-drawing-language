module Basica.Escher where
import Graphics.Gloss

import Dibujo
import Interp



type Escher = Picture 


-- Esquina con nivel de detalle en base a la figura p.
esquina :: Int -> Dibujo Escher -> Dibujo Escher
esquina 1 p = cuarteto (Básica blank) (Básica blank) (Básica blank) (dibujoU p)
esquina n p
    | n > 1 =  cuarteto (esquina (n-1) p) (lado (n-1) p) (Rotar p) (dibujoU p)
    | otherwise = error "esquina: nivel de detalle negativo"

-- Lado con nivel de detalle.
lado :: Int -> Dibujo Escher -> Dibujo Escher
lado 1 p = cuarteto (Básica blank) (Básica blank) (Rotar p) p
lado n p
    | n > 1 = cuarteto (lado (n-1) p) (lado (n-1) p) (Rotar p) p
    | otherwise  = error "lado: nivel de detalle no válido"

-- El dibujoU.
dibujoU :: Dibujo Escher -> Dibujo Escher
dibujoU p = encimar4 p'
    where
        p' = Rot45 p

-- El dibujo t.
dibujoT :: Dibujo Escher -> Dibujo Escher
dibujoT p = p' ^^^ r270 p'
    where
        p' = Rot45 p


-- Por suerte no tenemos que poner el tipo!
noneto p q r s t u v w x =  Apilar 1 2 (Juntar 1 2 p (Juntar 1 1 q r)) 
                           (Apilar 1 1 (Juntar 1 2 s (Juntar 1 1 t u))
                                       (Juntar 1 2 v (Juntar 1 1 w x)))          

-- El dibujo de Escher:
escher :: Int -> Escher -> Dibujo Escher
escher = undefined

