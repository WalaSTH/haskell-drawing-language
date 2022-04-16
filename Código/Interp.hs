module Interp where
import Graphics.Gloss hiding (color)
import qualified Graphics.Gloss.Data.Point.Arithmetic as V

import Dibujo
import FloatingPic


-- Interpretación de un dibujo
-- formulas sacadas del enunciado
interp :: Output a -> Output (Dibujo a)
interp f =
    sem f interpRotar interpEspejar interpRot45 interpApilar interpJuntar interpEncimar
    where
        interpRotar :: FloatingPic -> FloatingPic
        interpRotar g x w h = g (x V.+ w) h (V.negate w)
        interpEspejar :: FloatingPic -> FloatingPic
        interpEspejar g x w h = g (x V.+ w) (V.negate w) h
        interpRot45 :: FloatingPic -> FloatingPic
        interpRot45 g x w h = g (x V.+ half (w V.+ h)) (half $ w V.+ h) (half $ h V.- w)
        interpApilar :: Int -> Int -> FloatingPic -> FloatingPic -> FloatingPic
        interpApilar n m g0 g1 x w h = pictures [g0 (x V.+ h') w (r V.* h), g1 x w h']
            where
                r' = fromIntegral n / fromIntegral (m+n)
                r =  fromIntegral m / fromIntegral (m+n)
                h' = r' V.* h
        interpJuntar :: Int -> Int -> FloatingPic -> FloatingPic -> FloatingPic
        interpJuntar n m g0 g1 x w h = pictures [g0 x w' h, g1 (x V.+ w') (r' V.* w) h]
            where
                r' = fromIntegral n / fromIntegral (m+n)
                r =  fromIntegral m / fromIntegral (m+n)
                w' = r V.* w
        interpEncimar :: FloatingPic -> FloatingPic -> FloatingPic
        interpEncimar g0 g1 x w h = pictures [g0 x w h, g1 x w h]


-- Configuración de la interpretación
data Conf a = Conf {
    name :: String,
    basic :: Output a,
    fig  :: Dibujo a,
    width :: Float,
    height :: Float,
    color :: Color
}

interpConf :: Conf a -> Picture 
interpConf (Conf _ b f x y _) =
    interp b f (-x/2, -y/2) (x,0) (0,y)


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
