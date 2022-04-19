module FloatingPic (
    FloatingPic, Output,
    zero, half,
    hlines, grid,
    trian1, trian2, trianD, rectan,
    simple, fShape, vacía,
    transf
) where
    
import Graphics.Gloss
    (Vector, Picture, blank, line, pictures, rotate, scale, translate)
import Graphics.Gloss.Data.Vector (argV, magV)
import Graphics.Gloss.Geometry.Angle (radToDeg)

import qualified Graphics.Gloss.Data.Point.Arithmetic as V


type FloatingPic = Vector -> Vector -> Vector -> Picture
type Output a = a -> FloatingPic

-- el vector nulo
zero :: Vector
zero = (0,0)

half :: Vector -> Vector
half = (0.5 V.*)

-- Infinitas lineas paralelas horizontales
-- Desde (x, y) para arriba con un largo de mag
hlines :: Vector -> Float -> Float -> [Picture]
hlines (x, y) mag sep = map hline [0,sep..]
    where hline h = line [(x, y + h), (x + mag, y + h)]

-- Una grilla de n líneas, comenzando en v con una separación de sep y
-- una longitud de l (usamos composición para no aplicar este
-- argumento)
grid :: Int -> Vector -> Float -> Float -> Picture
grid n v sep l = pictures [ls, translate 0 (l*toEnum n) (rotate 90 ls)]
    where ls = pictures $ take (n+1) $ hlines v sep l

-- figuras adaptables comunes
trian1 :: FloatingPic
trian1 a b c = line $ map (a V.+) [zero, half b V.+ c , b , zero]

trian2 :: FloatingPic
trian2 a b c = line $ map (a V.+) [zero, c, b,zero]

trianD :: FloatingPic
trianD a b c = line $ map (a V.+) [c, half b , b V.+ c , c]

rectan :: FloatingPic
rectan a b c = line [a, a V.+ b, a V.+ b V.+ c, a V.+ c,a]

simple :: Picture -> FloatingPic
simple p _ _ _ = p

fShape :: FloatingPic
fShape a b c = line . map (a V.+) $ [
        zero,uX, p13, p33, p33 V.+ uY , p13 V.+ uY,
        uX V.+ 4 V.* uY ,uX V.+ 5 V.* uY, x4 V.+ y5,
        x4 V.+ 6 V.* uY, 6 V.* uY, zero
    ]
    where
        p33 = 3 V.* (uX V.+ uY)
        p13 = uX V.+ 3 V.* uY
        x4 = 4 V.* uX
        y5 = 5 V.* uY
        uX = (1/6) V.* b
        uY = (1/6) V.* c

vacía :: FloatingPic
vacía _ _ _ = blank


-- Dada una función que produce una figura a partir de un a y un vector
-- producimos una figura flotante aplicando las transformaciones
-- necesarias. Útil si queremos usar figuras que vienen de archivos bmp.
transf :: (a -> Vector -> Picture) -> a -> Vector -> FloatingPic
transf f d (xs,ys) a b c =
    translate ax ay . scale (magV b/xs) (magV c/ys) . rotate ang $
        f d (xs,ys)
    where
        ang = radToDeg $ argV b
        (ax, ay) = a V.+ half (b V.+ c)
