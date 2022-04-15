module Main where
import Graphics.Gloss hiding (color)
import Interp
import Dibujos.Escher


-- Dada una computación que construye una configuración, mostramos por
-- pantalla la figura de la misma de acuerdo a la interpretación para
-- las figuras básicas. Permitimos una computación para poder leer
-- archivos, tomar argumentos, etc.
initial :: Conf a -> IO ()
initial cfg = do
    let x  = width cfg
        y  = height cfg
        c = color cfg
        n = name cfg
        win = InWindow n (ceiling x, ceiling y) (0, 0)
    display win c $ interpConf cfg


main :: IO ()
main = initial $ escherConf 400 400
