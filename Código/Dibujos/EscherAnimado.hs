module Dibujos.EscherAnimado (
    Escher(..),
    interpEscher,
    escherAnimado,
    escherAnimadoConf,
    white
) where

import Data.Fixed (mod')
import Graphics.Gloss (white)

import Dibujo (Dibujo)
import Dibujos.Escher (Escher(..), escher, interpEscher)
import Interp (Conf(..))



escherAnimado :: Float -> Dibujo Escher
escherAnimado t = escher n Pez
    where
        t' = t `mod'` 4
            -- Reinicia la animación cada 4 segundos
        n = floor (2**t') - 1
            -- El nivel de detalle es exponencial para que la animación crezca linaelmente


escherAnimadoConf :: Float -> Float -> Conf Escher
escherAnimadoConf x y = Anim {
    name = "Escher animado",
    basic = interpEscher,
    anim = escherAnimado,
    width = x,
    height = y,
    col = white
}
