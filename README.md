# Lab 1 - Paradigmas de la programación - 2022

Integrantes:
• Renison, Iván Ariel
• Salguero, Maciel
• Torres Villegas, Leonardo Luis

# Modularización

## Modularización original

    En el repositorio ya venían los archivos necesarios, y en el enunciado se indicaba que tenia que ir en cada archivo.

    A continuación hay una tabla con cada módulo (cada archivo en un módulo en haskell) que venía y una explicación de su responsabilidad:

| Modulo           | Responsabilidad                                                                                                                                                                                                                                                                                                       |
| ---------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Dibujo`         | Definir la estructura de datos `Dibujo` y sus funciones relacionadas.                                                                                                                                                                                                                                                 |
| `Interp`         | Definir una interpretación de los `Dibujo`s , es decir, una forma de obtener algo graficable por `gloss` a partir de un `Dibujo`.<br/>Lo mas importante aquí es la función `interp`, con la cuál se puede obtener a partir de un `Dibujo` un `FloatingPic` el cual es el tipo que nos permitira graficar con `gloss`. |
| `Main`           | Usar gloss para graficar el dibujo de Escher.                                                                                                                                                                                                                                                                         |
| `Basica.Ejemplo` | Un ejemplo básico de un triangulo.                                                                                                                                                                                                                                                                                    |
| `Basica.Escher`  | La definición de la figura de escher.<br/>Lo mas importante acá es la función `escher`, que es la queda la estructura `Dibujo` para graficar el dibujo de escher.                                                                                                                                                     |

## Nuestra modularización

    Nosotros primero hicimos todo usando la modularización como venía, pero luego la modificamos un poco.

    Luego de nuestras modificaciones los módulos y sus responsabilidades quedaron así:

| Modulo           | Responsabilidad                                                                                                                                                   |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Dibujo`         | Definir la estructura de datos `Dibujo` y sus funciones relacionadas.                                                                                             |
| `FloatingPic`    | Definir el tipo `FloatingPic` y algunos valores y funciones para trabajar con `FloatingPic` y `Graphics.Gloss.Picture`.                                           |
| `Interp`         | Definir una interpretación de los `Dibujo`s, para poder obtener un`FloatingPic` a partir de un `Dibujo`, y para poder graficar un `Dibujo`.                       |
| `Main`           | Graficar el dibujo de Escher.                                                                                                                                     |
| `Basica.Ejemplo` | Un ejemplo básico de un triangulo.                                                                                                                                |
| `Basica.Escher`  | La definición de la figura de escher.<br/>Lo mas importante acá es la función `escher`, que es la queda la estructura `Dibujo` para graficar el dibujo de escher. |

    A varias cosas las movimos de módulo, y también a algunas cosas les cambiamos el nombre para darles un nombre que nos parecía mejor.

    También como parte de la modularización hicimos explícitos todos los imports y exports. Al hacer eso, hubo algunas funciones del enunciado que eliminamos/no exportamos, porque nos pareció que no tenían mucho que ver con el modulo (se pueden ver en los commits viejos). Un ejemplo de eso es la función `comp :: (a -> a) -> Int -> a -> a` del módulo `Dibujo`.

    Otra cosa que hicimos fue mover todo lo que es el código a la carpeta `Código`.

    El principal objetivo de nuestra modularización fue acomodoar todo para en el main poder leer por linea de comandos el nombre del dibujo/animación a graficar. Por eso, hicimos que las cosas relacionadas a cada dibujo/animación estén en el módulo del dibujo/animación, y que en `Main` solo haya una lista de las configuraciones de los dibujos/animaciones.

# Definición del lenguaje

## Primera parte: Sintaxis

    En este laboratorio se nos da la tarea de implementar un lenguaje de dominio especifico (DSL) que nos permita combinar dibujos básicos para obtener creaciones más complejas. Definimos el lenguaje como un tipo de dato polimórfico. El tipo de dato es el que está especificado en las consignas, y es el que está parametrizado por una colección de figuras básicas representado por el terminal `Básica` y el resto de constructores que corresponden a las instrucciones para modificar las figuras: rotar la imagen 90 grados, espejar, y demás, dando origen al tipo de datos `Dibujo` que se encuentra en el módulo `Dibujo`:

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

    En total se nos pide realizar nueve combinadores, los cuales se encuentran todos incluidos.

## Segunda parte: Semántica

    En el apartado anterior se describió las reglas de nuestro lenguaje y como combinar unidades básicas de este para formar elementos mas complejos. Si bien esto es una parte fundamental a la hora del desarrollo de un DSL, hasta ahora solo tenemos un conjunto de símbolos que carecen de significado. En esta parte del laboratorio nos encargamos de solucionar esto y así darle un significado geométrico a cada elemento de nuestro lenguaje. Usando elementos de la librería `Gloss`.

    La parte principal de este modulo es la función `interp`:

```hs
interp :: Output a -> Output (Dibujo a)
```

    Que por sinónimos de tipos, se le puede dar el tipo así:

```hs
interp :: (a -> FloatingPic) -> Dibujo a -> FloatingPic
```

    Lo que hace esta función es tomar una función que con un elemento básico del dibujo construye `FloatingPic` (que no es mas que un `Picture` de `Gloss` que espera parámetros), un dibujo, y devuelve un `FloatingPic` que representa al dibujo listo para ser graficado.

    Para lograrlo aplica para cada constructor de `Dibujo` las transformaciones dadas en la consigna, que corresponden al significado matemático representado por cada constructor.

    Aclaración sobre función `sem`:

    En el módulo `Dibujo` está definida la función `sem`, la cuál es un pliegue para `Dibujo`, y se puede usar para darla una interpretación a `Dibujo` (o sea, darle semántica). Lo que acá describimos es una interpretación (la del enunciado).

# Función `grid`

    La función `grid` que en nuestra modularización quedó en el módulo `FloatingPic` tiene cierta complejidad, por eso acá hay una explicación de su funcionamiento:

    `grid n v sep l` se encarga de dibujar una grilla de `n` líneas comenzando
en `v` con una separación de `sep` y una longitud de `l`.
    Para entender como funciona, primero debemos entender el funcionamiento de `hlines`.
    Esta función crea infinitos segmentos paralelos horizontales desde `(x, y)` hacia arriba con un largo de `mag`. A esta función nosotros la modificamos un poco para simplificarla, y le definimos así:

```hs
hlines :: Vector -> Float -> Float -> [Picture]
hlines (x, y) mag sep = map hline [0,sep..]
    where hline h = line [(x, y + h), (x + mag, y + h)]
```

    Para lograr su objetivo se define la función auxiliar `hline` la cual toma un valor y devuelve un segmento (tipo `Picture` de `Gloss`) que está separado hacia arriba en un valor `h` de la recta horizontal que pasa por `(x,y)`. En `hlines` se aplica `hline` a una lista infinita de la forma `[0,sep..]` (o sea, una lista de flotantes separados por `sep`) t con eso se crean infinitas lineas paralelas horizontales con separación `sep` entre ellas.

    Entendiendo esto es muy fácil ver como `grid` logra crear la grilla ya que `grid` lo que se hace es tomar `n+1` elementos de esta lista (o sea, toma los elementos 0, 1, …, n) y luego a estos mismos segmentos los rota 90 grados. Finalmente a todos estos segmentos, los cuales están en una lista, los transforma en una sola `Picture` usando la función de gloss `pictures`.

# Puntos estrella y otros detalles

## Imagenes extras  

Ademas de la figura de escher que pedia la consigna, aprovechamos el DSL para graficar otras figuras. A continuación se lista las figuras dibujadas:  

- Huellas
- Manzano
- Toro
- Toros enfrentado
- Escalera
- Toro Arena 

Notar que las últimas 4 se encuentran dentro del archivo `Manzano.hs`

## Escher animado

    Una de las cosas extras que hicimos fue hacer una animación de escher, que básicamente consiste en hacer el dibujo de escher con distintos niveles de detalle según el tiempo, para que parezca que se va armando de a poco.

    La animación consume muchos recursos, por lo que para que se vea bien es importante compilar con `-O2`.

## Leer dibujo en los argumentos de ejecución del programa

    Otra cosa extra que hicimos fue leer el dibujo/animación a graficar como argumento por linea de comandos. Hacer esto tuvo bastantes implicaciones. En primer lugar tuvimos que hacer que el `Conf` sea distinto para las animaciones que para los dibujos estáticos, ya que en cada caso hacen falta algunas cosas de distinto tipo. También agregamos los campos `name` y `col` para darle un nombre y un color de fondo al dibujo/animación.

    Luego, queríamos hacer una lista que tuviera las configuraciones de los distintos dibujos, pero como `Conf` toma un argumento de tipo, en el haskell normal no se podía, así que tuvimos que usar `ExistentialQuantification` para definir una lista así:

```hs
data ConfList = forall a. Elem (Conf a) ConfList | Nil
```

    Y con eso lo pudimos hacer. (Por ser algo extra no damos muchas mas explicaciones).

    Para parsear los argumento de linea de comando usamos el módulo `System.Console.GetOpt`.

## Función `grilla` de `Feo.hs`

    También simplificamos un poco la definición de la función `grilla` en `Feo.hs`, dejándola así:

```hs
row :: [Dibujo Basica] -> Dibujo Basica
row [] = error "row: no puede ser vacío"
row [d] = d
row (d:ds) = Juntar (length ds) 1 d (row ds)

column :: [Dibujo Basica] -> Dibujo Basica
column [] = error "column: no puede ser vacío"
column [d] = d
column (d:ds) = Apilar (length ds) 1 d (column ds)

grilla :: [[Dibujo Basica]] -> Dibujo Basica
grilla = column . map row
```
