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
escherAnimado t = escher (floor (2**(t `mod'` 4)) - 1) Pez

escherAnimadoConf :: Float -> Float -> Conf Escher
escherAnimadoConf x y = Anim {
    name = "Escher animado",
    basic = interpEscher,
    anim = escherAnimado,
    width = x,
    height = y,
    col = white
}
