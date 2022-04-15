# Lab 1 - Paradigmas de la programación - 2022

Integrantes:
• Renison, Iván Ariel
• Salguero, Maciel
• Torres Villegas, Leonardo Luis

## Modularización

## Modularización original

    En el repositorio ya venían los archivos necesarios, y en el enunciado se indicaba que tenia que ir en cada archivo.

    A continuación hay una tabla con cada modulo (cada archivo en un modulo en haskell) que venia y una explicación de su responsabilidad:

| Modulo           | Responsabilidad                                                                                                                                                                                                                                                                                                       |
| ---------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Dibujo`         | Definir la estructura de datos `Dibujo` y sus funciones relacionadas.                                                                                                                                                                                                                                                 |
| `Interp`         | Definir una interpretación de los `Dibujo`s , es decir, una forme de obtener algo graficable por `gloss` a partir de un `Dibujo`.<br/>Lo mas importante aquí es la función `interp`, con la cuál se puede obtener a partir de un `Dibujo` un `FloatingPic`, que es algo que se puede graficar fácilmente con `gloss`. |
| `Main`           | Usar gloss para graficar el dibujo de Escher                                                                                                                                                                                                                                                                          |
| `Basica.Ejemplo` | Un ejemplo básico de un triangulo.                                                                                                                                                                                                                                                                                    |
| `Basica.Escher`  | La definición de la figura de escher.<br/>Lo mas importante acá es la función `escher`, que es la queda la estructura `Dibujo` para graficar el dibujo de escher.                                                                                                                                                     |

## Nuestra modularización

    Nosotros primero hicimos todo usando la modularización como venía, pero luego la modificamos un poco.





## Definición del lenguaje

## `Interp.grid`
