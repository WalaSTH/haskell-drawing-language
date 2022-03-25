module Dibujo where


{-
Gramática de las figuras:
<Fig> ::= Basica <Bas> | Rotar <Fig> | Espejar <Fig> | Rot45 <Fig>
    | Apilar <Int> <Int> <Fig> <Fig> 
    | Juntar <Int> <Int> <Fig> <Fig> 
    | Encimar <Fig> <Fig>
-}


data Dibujo a =
    Básica a
    | Rotar (Dibujo a)
    | Espejar (Dibujo a)
    | Rot45 (Dibujo a)
    | Apilar Int Int (Dibujo a) (Dibujo a)
    | Juntar Int Int (Dibujo a) (Dibujo a)
    | Encimar (Dibujo a) (Dibujo a)


-- Composición n-veces de una función con sí misma.
comp :: (a -> a) -> Int -> a -> a
comp f n
    | n < 0 = error "comp: número negativo"
    | otherwise = foldr (.) id $ replicate n f

-- Rotaciones de múltiplos de 90.
r180 :: Dibujo a -> Dibujo a
r180 = Rotar . Rotar

r270 :: Dibujo a -> Dibujo a
r270 = r180 . Rotar

-- Pone una figura sobre la otra, ambas ocupan el mismo espacio.
(.-.) :: Dibujo a -> Dibujo a -> Dibujo a
(.-.) = Apilar 1 1

-- Pone una figura al lado de la otra, ambas ocupan el mismo espacio.
(///) :: Dibujo a -> Dibujo a -> Dibujo a
(///) = Juntar 1 1

-- Superpone una figura con otra.
(^^^) :: Dibujo a -> Dibujo a -> Dibujo a
(^^^) = Encimar

-- Dadas cuatro figuras las ubica en los cuatro cuadrantes.
cuarteto :: Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a
cuarteto d0 d1 d2 d3 = (d0 /// d1) .-. (d2 /// d3)

-- Una figura repetida con las cuatro rotaciones, superpuestas.
encimar4 :: Dibujo a -> Dibujo a 
encimar4 d = d ^^^ Rotar d ^^^ r180 d ^^^ r270 d

-- Cuadrado con la misma figura rotada i * 90, para i ∈ {0, ..., 3}.
-- No confundir con encimar4!
ciclar :: Dibujo a -> Dibujo a
ciclar d = cuarteto d (Rotar d) (r180 d) (r270 d)  

