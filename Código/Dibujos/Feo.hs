module Dibujos.Feo (
    Basica,
    interpBas,
    testAll,
    feoConf,
    white
) where

import Graphics.Gloss (Picture, blue, color, line, pictures, red, white)

import qualified Graphics.Gloss.Data.Point.Arithmetic as V

import Dibujo (Dibujo(..))
import FloatingPic (Output, half)
import Interp (Conf(..))

-- Les ponemos colorcitos para que no sea _tan_ feo
data Colores = Azul | Rojo
    deriving Show

data Basica = Rectangulo Colores | Cruz Colores | Triangulo Colores
    deriving Show

colorear :: Colores -> Picture -> Picture
colorear Azul = color blue
colorear Rojo = color red

-- Las coordenadas que usamos son:
--
--  x + y
--  |
--  x --- x + w
--
-- por ahi deban ajustarlas
interpBas :: Output Basica
interpBas (Rectangulo c) x y w =
    colorear c $ line [x, x V.+ y, x V.+ y V.+ w, x V.+ w, x]
interpBas (Cruz c) x y w =
    colorear c $ pictures [line [x, x V.+ y V.+ w], line [x V.+ y, x V.+ w]]
interpBas (Triangulo c) x y w =
    colorear c $ line $ map (x V.+) [(0,0), y V.+ half w, w, (0,0)]

-- Diferentes tests para ver que estén bien las operaciones
figRoja :: (Colores -> a) -> Dibujo a
figRoja f = Básica (f Rojo)

figAzul :: (Colores -> a) -> Dibujo a
figAzul f = Básica (f Azul)

-- Debería mostrar un rectángulo azul arriba de otro rojo,
-- conteniendo toda la grilla dentro
apilados :: (Colores -> a) -> Dibujo a
apilados f = Apilar 1 1 (figAzul f) (figRoja f)

-- Debería mostrar un rectángulo azul arriba de otro rojo,
-- conteniendo toda la grilla dentro el primero ocupando 3/4 de la grilla
apilados2 :: (Colores -> a) -> Dibujo a
apilados2 f = Apilar 1 3 (figAzul f) (figRoja f)

-- Debería mostrar un rectángulo azul a derecha de otro rojo,
-- conteniendo toda la grilla dentro
juntados :: (Colores -> a) -> Dibujo a
juntados f = Juntar 1 1 (figAzul f) (figRoja f)

-- Debería mostrar un rectángulo azul a derecha de otro rojo,
-- conteniendo toda la grilla dentro el primero ocupando 3/4 de la grilla
juntados2 :: (Colores -> a) -> Dibujo a
juntados2 f = Juntar 1 3 (figAzul f) (figRoja f)

-- Igual al anterior, pero invertido
flipante1 :: (Colores -> a) -> Dibujo a
flipante1 f = Espejar $ juntados2 f

-- Igual al anterior, pero invertido
flipante2 :: (Colores -> a) -> Dibujo a
flipante2 f = Espejar $ apilados2 f

row :: [Dibujo Basica] -> Dibujo Basica
row [] = error "row: no puede ser vacío"
row [d] = d
row (d:ds) = Juntar (length ds) 1 d (row ds)

column :: [Dibujo Basica] -> Dibujo Basica
column [] = error "column: no puede ser vacío"
column [d] = d
column (d:ds) = Apilar (length ds) 1 d (column ds)

grilla :: [[Dibujo Basica]] -> Dibujo Basica
grilla = column . map row

testAll :: Dibujo Basica
testAll = grilla [
    [figRoja Rectangulo  , Rot45 $ figRoja Triangulo, Rot45 $ figAzul Rectangulo, Rot45 $ figAzul Cruz     ],
    [apilados Rectangulo , apilados2 Rectangulo     , juntados Rectangulo       , juntados2 Rectangulo     ],
    [flipante1 Rectangulo, flipante2 Rectangulo     , figRoja Triangulo         , Rotar $ figAzul Triangulo],
    [apilados Cruz       , apilados2 Cruz           , juntados Cruz             , juntados2 Cruz           ]
    ]


feoConf :: Float -> Float -> Conf Basica
feoConf x y = Dis {
    name = "Feo",
    basic = interpBas,
    fig = testAll,
    width = x,
    height = y,
    col = white
}
