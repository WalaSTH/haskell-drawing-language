# Lab 1 - Paradigmas de la programación - 2022

Integrantes:
• Renison, Iván Ariel
• Salguero, Maciel
• Torres Villegas, Leonardo Luis

## El lenguaje

### Primera parte: Sintaxis

    En este laboratorio se nos da la tarea de implementar un lenguaje de dominio especifico (DSL) que nos permita combinar dibujos básicos para obtener creaciones más complejas. 
    Definimos el lenguaje como un tipo de dato polimórfico. El tipo de dato es el que está especificado en las consignas, y es el que está parametrizado por una colección de figuras básicas representado por el terminal `Básica` y el resto de constructores corresponden a las instrucciones para modificar las figuras: rotar la imagen 90 grados, espejar, y demás, dando origen al tipo de datos `Dibujo` que se encuentra en el módulo `Dibujo`:

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

    La semántica de dichas operaciones estará dado por una función que producirá una imagen, pero esto lo veremos mas a detalle en la sección de semántica.

    Teniendo ya el tipo Dibujo podemos definir funciones que combinen `Dibujo`s para producir otros. Es decir, podemos definir los combinadores. Un ejemplo es `r180`, el cual aplicaría la operación de rotar dos veces a una figura:

```hs
r180 :: Dibujo a -> Dibujo a
r180 = Rotar . Rotar
```

    En total se nos pide realizar nueve combinadores, los cuales se encuentran todos incluidos 

### Segunda parte: Semántica

## Modularización

## Modularización original

    En el repositorio ya venían los archivos necesarios, y en el enunciado se indicaba que tenia que ir en cada archivo.

    A continuación hay una tabla con cada módulo (cada archivo en un módulo en haskell) que venia y una explicación de su responsabilidad:

| Modulo           | Responsabilidad                                                                                                                                                                                                                                                                                                       |
| ---------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Dibujo`         | Definir la estructura de datos `Dibujo` y sus funciones relacionadas.                                                                                                                                                                                                                                                 |
| `Interp`         | Definir una interpretación de los `Dibujo`s , es decir, una forme de obtener algo graficable por `gloss` a partir de un `Dibujo`.<br/>Lo mas importante aquí es la función `interp`, con la cuál se puede obtener a partir de un `Dibujo` un `FloatingPic`, que es algo que se puede graficar fácilmente con `gloss`. |
| `Main`           | Usar gloss para graficar el dibujo de Escher                                                                                                                                                                                                                                                                          |
| `Basica.Ejemplo` | Un ejemplo básico de un triangulo.                                                                                                                                                                                                                                                                                    |
| `Basica.Escher`  | La definición de la figura de escher.<br/>Lo mas importante acá es la función `escher`, que es la queda la estructura `Dibujo` para graficar el dibujo de escher.                                                                                                                                                     |

## Nuestra modularización

    Nosotros primero hicimos todo usando la modularización como venía, pero luego la modificamos un poco.

    Luego de nuestras modificaciones los módulos y sus responsabilidades quedaron así:

| Modulo           | Responsabilidad                                                                                                                                                   |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Dibujo`         | Definir la estructura de datos `Dibujo` y sus funciones relacionadas.                                                                                             |
| `FloatingPic`    | Definir el tipo `FloatingPic` y algunos valores y funciones para trabajar con `FloatingPic` y `Graphics.Gloss.Picture`                                            |
| `Interp`         | Definir una interpretación de los `Dibujo`s, para poder obtener un`FloatingPic` a partir de un `Dibujo`, y para poder graficar un `Dibujo`                        |
| `Main`           | Graficar el dibujo de Escher                                                                                                                                      |
| `Basica.Ejemplo` | Un ejemplo básico de un triangulo.                                                                                                                                |
| `Basica.Escher`  | La definición de la figura de escher.<br/>Lo mas importante acá es la función `escher`, que es la queda la estructura `Dibujo` para graficar el dibujo de escher. |

    A varias cosas las movimos de módulo, y también a algunas cosas las cambiamos de nombre para darles un nombre que nos parecía mejor.

    Otra cosa que hicimos fue mover todo lo que es el código a la carpeta `Código`.

## Definición del lenguaje

## `Interp.grid`
