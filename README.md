# Lab 1 - Paradigmas de la programación - 2022

Integrantes:
• Renison, Iván Ariel
• Salguero, Maciel
• Torres Villegas, Leonardo Luis

# Modularización

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

    También como parte de la modularización hicimos explícitos todos los imports y exports. Al hacer eso, hubo algunas funciones del enunciado que eliminamos/no exportamos, porque nos pareció que no tenían mucho que ver con el modulo (se pueden ver en los commits viejos). Un ejemplo de eso es la función `comp :: (a -> a) -> Int -> a -> a` del módulo `Dibujo`.

    Otra cosa que hicimos fue mover todo lo que es el código a la carpeta `Código`.

    El principal objetivo de nuestra modularización fue acomodoar todo para en el main leer por linea de comandos el nombre del dibujo/animación a graficar. Por eso, hicimos que las cosas relacionadas a cada dibujo/animación estén en el módulo del dibujo/animación, y que en `Main` solo haya una lista de las configuraciones de los dibujos/animaciones.

# Definición del lenguaje

## Primera parte: Sintaxis

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

## Segunda parte: Semántica

# `Interp.grid`
`Interp.grid n v sep l` se encarga de dibujar una grilla de n líneas comenzando
en v con una separación de sep y una longitud de l.  
¿Como lo hace?
Primero debemos entender el funcionamiento de `hlines (x,y) mag sep`.
Esta función crea infinitas lineas paralelas horizontales desde (x, y) hacia arriba con un largo de mag ¿como? recordemos el código de hlines:
```hs
hlines (x,y) mag sep = map (hline . (*sep)) [0..]  
    where hline h = line [(x,y+h),(x+mag,y+h)]
```
Para lograr esto se define la función hline la cual toma un valor y devuelve un segmento (tipo Picture en Gloss). Este segmento tiene la particularidad de estar separada en un valor de (0,h) de la recta horizontal que pasa por (x,y). Luego multiplicamos por sep a cada elemento de `[0..]` y finalmente a cada elemento de la lista resultante le aplicamos la función hline, obteniendo de esta forma una lista de segmentos (tipo Pictures en Gloss)

Entendiendo esto es muy facil ver como grid logra crear la grilla ya que grid lo que se hace es tomar n+1 elementos de esta lista (nótese que la lista la creamos desde el elemento 0) y luego a estos mismos segmentos los rota 90 grados. Finalmente a todos estos segmentos ,los cuales estan en una lista, los transforma en una sola `Picture` usando la función de gloss `pictures`

# Puntos estrella y otros detalles

## Escher animado



## Leer dibujo en los argumentos de ejecución del programa



## Función `grilla` de `Feo.hs`
