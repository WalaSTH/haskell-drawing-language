module Main where
import Graphics.Gloss
import Dibujo
import Interp
import qualified Basica.Escher as E

data Conf a = Conf {
    basic :: Output a
  , fig  :: Dibujo a
  , width :: Float
  , height :: Float
  }

ej :: Float -> Float -> Conf E.Escher
ej x y = Conf {
                basic = E.interpEscher 
              , fig = E.escher 5 E.Pez
              , width = x
              , height = y
              }

-- Dada una computación que construye una configuración, mostramos por
-- pantalla la figura de la misma de acuerdo a la interpretación para
-- las figuras básicas. Permitimos una computación para poder leer
-- archivos, tomar argumentos, etc.
initial :: IO (Conf a) -> IO ()
initial cf = do
    cfg <- cf
    let x  = width cfg
        y  = height cfg
        win = InWindow "Nice Window" (ceiling x, ceiling y) (0, 0)
    display win white $ interp (basic cfg) (fig cfg) (-x/2, -y/2) (x,0) (0,y)
{-     display win white . withGrid $ interp (basic cfg) (fig cfg) (-x/2, -y/2) (x,0) (0,y)
  where withGrid p = pictures [p, color grey $ grid 10 (0,0) 100 10]
        grey = makeColorI 120 120 120 120 -}


main :: IO ()
main = initial $ return (ej 400 400)
