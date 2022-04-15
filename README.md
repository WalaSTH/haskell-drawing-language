# Lab 1 - Paradigmas de la programación - 2022

Integrantes:
• Renison, Iván Ariel
• Salguero, Maciel
• Torres Villegas, Leonardo Luis

## El lenguaje 
### Primera parte: Sintaxis
En este laboratorio se nos da la tarea de implementar un lenguaje de dominio especifico (DSL) que nos permita combinar dibujos básicos para obtener creaciones más complejas. 
Definimos el lenguaje como un tipo de dato polimorfico. El tipo de dato es el que está especificado en las consignas, y es el que está parametrizado por una coleccion de figuras básicas representado por el no terminal Básica y el resto de constructores corresponden a las instrucciones para modificar las figuras: rotar la imagen 90 grados, espejar, y demas, dando origen al tipo de datos Dibujo que se encuentra en el módulo Dibujo.hs:

```haskell
data Dibujo a =
    Básica a
    | Rotar (Dibujo a)
    | Espejar (Dibujo a)
    | Rot45 (Dibujo a)
    | Apilar Int Int (Dibujo a) (Dibujo a)
    | Juntar Int Int (Dibujo a) (Dibujo a)
    | Encimar (Dibujo a) (Dibujo a)
```

La semántica de dichas operaciones estará dado por una función que producirá una imagen, pero esto lo veremos mas a detalle en la seccion de semántica.

Teniendo ya el tipo Dibujo podemos definir funciones que combinen programas Dibujo para producir otros. Es decir, podemos definir los combinadores. Un ejemplo es r180, el cual aplicaría la operacion de rotar dos veces a una figura:

```hs
r180 :: Dibujo a -> Dibujo a
r180 = Rotar . Rotar
```

En total se nos pide realizar nueve combinadores, los cuales se encuentran todos incluidos 

### Segunda parte: Semantica


## Modularización



## Definición del lenguaje



## `Interp.grid`
