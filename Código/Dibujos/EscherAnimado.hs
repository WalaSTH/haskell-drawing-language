module Dibujos.EscherAnimado where

import Data.Fixed
import Graphics.Gloss hiding (color)

import Dibujos.Escher
import Dibujo
import Interp



escherAnimado :: Float -> Dibujo Escher
escherAnimado t = escher (floor (2**(t `mod'` 4)) - 1) Pez

escherAnimadoConf :: Float -> Float -> Conf Escher
escherAnimadoConf x y = Anim {
    name = "Escher animado",
    basic = interpEscher,
    anim = escherAnimado,
    width = x,
    height = y,
    color = white
}
