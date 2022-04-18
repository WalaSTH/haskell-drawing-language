module Dibujos.Ejemplo (
    Basica,
    ejemplo,
    interpBas,
    ejemploConf,
    white
) where
    
import Graphics.Gloss ( white )

import Dibujo (Dibujo(Básica))
import FloatingPic (trian1, Output)
import Interp (Conf(..))

type Basica = ()
ejemplo :: Dibujo Basica
ejemplo = Básica ()

interpBas :: Output Basica
interpBas () = trian1

ejemploConf :: Float -> Float -> Conf Basica
ejemploConf x y = Dis {
    name = "Ejemplo",
    basic = interpBas,
    fig = ejemplo,
    width = x,
    height = y,
    col = white
}
