{-# LANGUAGE LambdaCase #-}
module Dibujo (
    Dibujo(..),
    r180, r270,
    (.-.), (///), (^^^),
    cuarteto, encimar4, ciclar,
    pureDib,
    sem,
    Pred,
    cambiar,
    anyDib, allDib,
    andP, ordP,
    desc,
    basicas,
    esRot360, esFlip2, tieneRot360, tieneFlip2,
    Superfluo(..),
    check
) where


{-
Gramática de las figuras:
<Fig> ::= Basica <Bas> | Rotar <Fig> | Espejar <Fig> | Rot45 <Fig>
    | Apilar <Int> <Int> <Fig> <Fig> 
    | Juntar <Int> <Int> <Fig> <Fig> 
    | Encimar <Fig> <Fig>
-}


data Dibujo a =
    Básica a
    | Rotar (Dibujo a)
    | Espejar (Dibujo a)
    | Rot45 (Dibujo a)
    | Apilar Int Int (Dibujo a) (Dibujo a)
    | Juntar Int Int (Dibujo a) (Dibujo a)
    | Encimar (Dibujo a) (Dibujo a)


-- Rotaciones de múltiplos de 90.
r180 :: Dibujo a -> Dibujo a
r180 = Rotar . Rotar

r270 :: Dibujo a -> Dibujo a
r270 = r180 . Rotar

-- Pone una figura sobre la otra, ambas ocupan el mismo espacio.
(.-.) :: Dibujo a -> Dibujo a -> Dibujo a
(.-.) = Apilar 1 1

-- Pone una figura al lado de la otra, ambas ocupan el mismo espacio.
(///) :: Dibujo a -> Dibujo a -> Dibujo a
(///) = Juntar 1 1

-- Superpone una figura con otra.
(^^^) :: Dibujo a -> Dibujo a -> Dibujo a
(^^^) = Encimar

-- Dadas cuatro figuras las ubica en los cuatro cuadrantes.
cuarteto :: Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a
cuarteto d0 d1 d2 d3 = (d0 /// d1) .-. (d2 /// d3)

-- Una figura repetida con las cuatro rotaciones, superpuestas.
encimar4 :: Dibujo a -> Dibujo a 
encimar4 d = d ^^^ Rotar d ^^^ r180 d ^^^ r270 d

-- Cuadrado con la misma figura rotada i * 90, para i ∈ {0, ..., 3}.
-- No confundir con encimar4!
ciclar :: Dibujo a -> Dibujo a
ciclar d = cuarteto d (Rotar d) (r180 d) (r270 d)  

instance Functor Dibujo where
    fmap f (Básica a) = Básica (f a)
    fmap f (Rotar d) = Rotar (fmap f d)
    fmap f (Espejar d) = Espejar (fmap f d)
    fmap f (Rot45 d) = Rot45 (fmap f d)
    fmap f (Apilar n m d0 d1) = Apilar n m (fmap f d0) (fmap f d1)
    fmap f (Juntar n m d0 d1) = Juntar n m (fmap f d0) (fmap f d1)
    fmap f (Encimar d0 d1) = Encimar (fmap f d0) (fmap f d1)
    {- Las instancias de Functor deben satisfacer los axiomas:
            fmap id ≡ id
            fmap (f . g) ≡ fmap f . fmap g
    
    Demostración:

    fmap id ≡ id:

        fmap id ≡ id
    ≡
        ∀a . fmap id a = a

    Probamos esto por inducción

        Caso base:
                fmap id (Básica a)
            =
                Básica (id a)
            = 
                Básica a
        
        Casos inductivos:
        Sea T = Rotar, Espejar, Rot45
                fmap id (T d)
            =
                T (fmap id d)
            = {Hipótesis inductiva}
                T d

        Sea T = Apilar n m, Juntar n m, Encimar
        
                fmap id (T d0 d1)
            =
                T (fmap id d0) (fmap id d1)
            = {Hipótesis inductiva}
                T d0 d1


    fmap (f . g) ≡ fmap f . fmap g:

        fmap (f . g) ≡ fmap f . fmap g
    ≡
        ∀a . fmap (f . g) a = (fmap f . fmap g) a

    Probamos esto por inducción

        Caso base:
                fmap (f . g) (Básica a)
            =
                Básica ((f . g) a)
            =
                Básica (f (g a))
            =
                fmap f (Básica (g a))
            =
                fmap f (fmap g (Básica a))
            =
                (fmap f . fmap g) a
            
        Casos inductivos:
        Sea T = Rotar, Espejar, Rot45

                fmap (f . g) (T a)
            =
                T (fmap (f . g) a)
            = {Hipótesis inductiva}
                T ((fmap f . fmap g) a)
            =
                T (fmap f (fmap g a))
            =
                fmap f (T (fmap g a))
            =
                (fmap f . fmap g) (T a)
            
        Sea T = Apilar n m, Juntar n m, Encimar

                fmap (f . g) (T d0 d1)
            =
                T (fmap (f . g) d0) (fmap (f . g) d1)
            = {Hipótesis inductiva}
                T (fmap f . fmap g) d0)) ((fmap f . fmap g) d1))
            =
                T (fmap f (fmap g d0)) (fmap f (fmap g d1))
            =
                fmap f (T (fmap g d0) (fmap g d1))
            =
                (fmap f . fmap g) (T d0 d1)
    -}


-- Ver un a como una figura.
pureDib :: a -> Dibujo a
pureDib = Básica


-- Estructura general para la semántica (a no asustarse). Ayuda: 
-- pensar en foldr y las definiciones de intro a la lógica
sem :: (a -> b) -> (b -> b) -> (b -> b) -> (b -> b) ->
       (Int -> Int -> b -> b -> b) -> 
       (Int -> Int -> b -> b -> b) -> 
       (b -> b -> b) ->
       Dibujo a -> b
sem básica rotar espejar rot45 apilar juntar encimar =
    let f = sem básica rotar espejar rot45 apilar juntar encimar in
    \case
        Básica a -> básica a
        Rotar d -> rotar (f d)
        Espejar d -> espejar (f d)
        Rot45 d -> rot45 (f d)
        Apilar n m d0 d1 -> apilar n m (f d0) (f d1)
        Juntar n m d0 d1 -> juntar n m (f d0) (f d1)
        Encimar d0 d1 -> encimar (f d0) (f d1)


type Pred a = a -> Bool

-- Dado un predicado sobre básicas, cambiar todas las que satisfacen
-- el predicado por la figura básica indicada por el segundo argumento.
cambiar :: Pred a -> a -> Dibujo a -> Dibujo a
cambiar p a = fmap (\x -> if p x then a else x)


-- Alguna básica satisface el predicado.
anyDib :: Pred a -> Dibujo a -> Bool
anyDib f = sem f id id id (\_ _ -> (||)) (\_ _ -> (||)) (||)

-- Todas las básicas satisfacen el predicado.
allDib :: Pred a -> Dibujo a -> Bool
allDib f = not . anyDib (not . f)

-- Los dos predicados se cumplen para el elemento recibido.
andP :: Pred a -> Pred a -> Pred a
andP f g x = f x && g x 

-- Algún predicado se cumple para el elemento recibido.
ordP :: Pred a -> Pred a -> Pred a
ordP f g x = f x || g x

-- Describe la figura. Ejemplos: 
--   desc (const "b") (Basica b) = "b"
--   desc (const "b") (Rotar (Basica b)) = "rot (b)"
--   desc (const "b") (Apilar n m (Basica b) (Basica b)) = "api n m (b) (b)"
-- La descripción de cada constructor son sus tres primeros
-- símbolos en minúscula, excepto `Rot45` al que se le agrega el `45`.
desc :: (a -> String) -> Dibujo a -> String
desc f = sem f
    (\x -> "rot (" ++ x ++ ")")
    (\x -> "espe (" ++ x ++ ")")
    (\x -> "rot45 (" ++ x ++ ")")
    (\n m s t -> "api " ++ show n ++ " " ++ show m ++ " (" ++ s ++ ") (" ++ t ++ ")")
    (\n m s t -> "junt " ++ show n ++ " " ++ show m ++ " (" ++ s ++ ") (" ++ t ++")")
    (\s t -> "enc (" ++ s ++ ") (" ++ t ++ ")")

instance Show a => Show (Dibujo a) where
    show = desc show

-- Junta todas las figuras básicas de un dibujo.
basicas :: Dibujo a -> [a]
basicas =
    sem (:[]) id id id (\_ _ -> (++)) (\_ _ -> (++)) (++)



-- El dibujo es 4 rotaciones seguidas.
esRot360 :: Pred (Dibujo a)
esRot360 (Rotar (Rotar (Rotar (Rotar _)))) = True
esRot360 _ = False

-- El dibujo es 2 espejados seguidos.
esFlip2 :: Pred (Dibujo a)
esFlip2 (Espejar (Espejar _)) = True
esFlip2 _ = False

-- El dibujo tiene en algún lado 4 rotaciones seguidas
tieneRot360 :: Pred (Dibujo a)
tieneRot360 d = case check d of
    Left xs -> RotacionSuperflua `elem` xs
    _ -> False

-- EL dibujo tiene en algún lado 2 espejados seguidos
tieneFlip2 :: Pred (Dibujo a)
tieneFlip2 d = case check d of
    Left xs -> FlipSuperfluo `elem` xs
    _ -> False

data Superfluo = RotacionSuperflua | FlipSuperfluo deriving (Eq, Show)

-- Aplica todos los chequeos y acumula todos los errores, y
-- sólo devuelve la figura si no hubo ningún error.
check :: Dibujo a -> Either [Superfluo] (Dibujo a)
check = \case
    d@(Básica _) -> Right d
    (Rotar (Rotar (Rotar (Rotar d)))) -> case check d of
        Left errores -> Left (RotacionSuperflua : errores)
        Right _ -> Left [RotacionSuperflua]
    d@(Rotar d') -> check1 d d'
    (Espejar (Espejar d)) -> case check d of
        Left errores -> Left (FlipSuperfluo : errores)
        Right _ -> Left [FlipSuperfluo]
    d@(Espejar d') -> check1 d d'
    d@(Rot45 d') -> check1 d d'
    d@(Apilar _ _ d0 d1) -> check2 d d0 d1
    d@(Juntar _ _ d0 d1) -> check2 d d0 d1
    d@(Encimar d0 d1) -> check2 d d0 d1
    where
        -- Hace un chequeo de d', en caso de errores los devuelve, y si no devuelve d
        check1 :: Dibujo a -> Dibujo b -> Either [Superfluo] (Dibujo a)
        check1 d d' = case check d' of
            Left errores -> Left errores
            Right _ -> Right d

        -- Hace un chequeo de d0 y d1, en caso de errores los devuelve, y si no devuelve d
        check2 :: Dibujo a -> Dibujo b -> Dibujo c -> Either [Superfluo] (Dibujo a)
        check2 d d0 d1 = case (check d0, check d1) of
            (Left errores0, Left errores1) -> Left $ errores0 ++ errores1
            (Left errores, _) -> Left errores
            (_, Left errores) -> Left errores
            _ -> Right d

