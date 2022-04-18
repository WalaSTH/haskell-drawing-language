module Dibujos.Ejemplo where
import Graphics.Gloss hiding (color)
import Dibujo
import FloatingPic
import Interp

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
