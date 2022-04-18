module Interp (
    interp,
    Conf(..),
    isDis, isAnim,
    interpDis, interpAnim,
    initial
) where
    
import Graphics.Gloss
    (Color, Display(InWindow), Picture, animate, display, pictures)

import qualified Graphics.Gloss.Data.Point.Arithmetic as V

import Dibujo (Dibujo, sem)
import FloatingPic (FloatingPic, Output, half)


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
data Conf a = Dis {
        name :: String,
        basic :: Output a,
        fig  :: Dibujo a,
        width :: Float,
        height :: Float,
        col :: Color
    }   
    | Anim {
        name :: String,
        basic :: Output a,
        anim  :: Float -> Dibujo a,
        width :: Float,
        height :: Float,
        col :: Color
    }


isDis :: Conf a -> Bool
isDis Dis{} = True
isDis _ = False

isAnim :: Conf a -> Bool
isAnim Anim{} = True
isAnim _ = False


interpDis :: Conf a -> Picture 
interpDis (Dis _ b f x y _) =
    interp b f (-x/2, -y/2) (x,0) (0,y)
interpDis _ = error "interpDis: no es una configuración de dibujo"

interpAnim :: Conf a -> Float -> Picture
interpAnim (Anim _ b a x y _) t =
    interp b (a t) (-x/2, -y/2) (x,0) (0,y)
interpAnim _ _ = error "interpAnim: no es una configuración de animación"


-- Dada una computación que construye una configuración, mostramos por
-- pantalla la figura de la misma de acuerdo a la interpretación para
-- las figuras básicas. Permitimos una computación para poder leer
-- archivos, tomar argumentos, etc.
initial :: Conf a -> IO ()
initial cfg = do
    let x  = width cfg
        y  = height cfg
        c = col cfg
        n = name cfg
        win = InWindow n (ceiling x, ceiling y) (0, 0)
    if isDis cfg then
        display win c (interpDis cfg)
    else
        animate win c (interpAnim cfg)
