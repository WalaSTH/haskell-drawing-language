module Basica.Escher where
import Graphics.Gloss

import Dibujo
import Interp



type Escher = FloatingPic


-- Esquina con nivel de detalle en base a la figura p.
esquina :: Int -> Dibujo Escher -> Dibujo Escher
esquina 0 _ = Básica vacía
esquina n p
    | n > 0 =  cuarteto (esquina (n-1) p) (lado (n-1) p) (Rotar $ lado (n-1) p) (dibujoU p)
    | otherwise = error "esquina: nivel de detalle negativo"

-- Lado con nivel de detalle.
lado :: Int -> Dibujo Escher -> Dibujo Escher
lado 0 _ = Básica vacía
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


-- Por suerte no tenemos que poner el tipo!
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
escher n f = noneto p q r s t u v w x  
            where
                p = esquina n (Básica f)
                q = lado n (Básica f)
                r = Rotar $ Rotar $ Rotar (esquina n (Básica f))
                s = Rotar q
                t = Básica f
                u = Rotar $ Rotar (s)
                v = Rotar p
                w = Rotar $ Rotar  q
                x = Rotar $ Rotar p

fish :: FloatingPic 
fish = trian2


