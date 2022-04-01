module Basica.Escher where
import Graphics.Gloss

import Dibujo
import Interp



type Escher = Picture 


-- Esquina con nivel de detalle en base a la figura p.
esquina :: Int -> Dibujo Escher -> Dibujo Escher
esquina 1 p = cuarteto (Básica blank) (Básica blank) (Básica blank) (dibujoU p)
esquina 2 p =  cuarteto (esquina 1 p) (lado 1 p) (Rotar $ lado 1 p) (dibujoU p)
esquina _ _ = error "esquina: nivel de detalle no válido"

-- Lado con nivel de detalle.
lado :: Int -> Dibujo Escher -> Dibujo Escher
lado 1 p = cuarteto (Básica blank) (Básica blank) (Rotar p) p
lado 2 p = cuarteto (lado 1 p) (lado 1 p) (Rotar p) p
lado _ _ = error "lado: nivel de detalle no válido"

-- El dibujoU.
dibujoU :: Dibujo Escher -> Dibujo Escher
dibujoU p = undefined 

-- El dibujo t.
dibujoT :: Dibujo Escher -> Dibujo Escher
dibujoT p = undefined 



-- Por suerte no tenemos que poner el tipo!
noneto p q r s t u v w x = undefined

-- El dibujo de Escher:
escher :: Int -> Escher -> Dibujo Escher
escher = undefined

