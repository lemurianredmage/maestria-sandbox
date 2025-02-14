# Practica No. 1 - Contador de 4 dígitos

|              |                                                                                             |
| ------------ | ------------------------------------------------------------------------------------------- |
| **Materia:** | Sistemas Digitales Aplicados para el procesamiento de señales                               |
| **Maestro:** | Yazmin Maldonado Robles                                                                     |
| **Alumnos:** | Benjamin Gerardo Fajardo Hernandez - M24210050 <br/> Lucio Yovanny Nogales Vera - M24210051 |
| **Fecha:**   | 2024-02-13                                                                                  |

## Objetivo

Diseñar en código VHDL un contador de cuatro dígitos y mostrarlo en
el display de la Basys-3.

## Procedimiento y Metodologia Experimental

| Ejercicio            | Testbench               | Esquematicos                        | Descripción de tarea                                                                                                                                                                                                                                                                                                               |
| -------------------- | ----------------------- | ----------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| P01_Ejercicio_01.vhd | P01_Ejercicio_01_tb.vhd | [Esquema](P01_Ejercicio_01_sch.pdf) | Diseñe, simule e implemente un contador de 0 a 9, utilizando un divisor de frecuencia de 1Hz y un solo dígito del display (apagar los otros 3 dígitos).                                                                                                                                                                            |
| P01_Ejercicio_02.vhd | P01_Ejercicio_02_tb.vhd | [Esquema](P01_Ejercicio_02_sch.pdf) | Diseñe, simule e implemente un contador de 0000 a 9999, utilizando un divisor de frecuencia de X Hz. Para definir la frecuencia (X) del divisor, investigar el rango de frecuencia que percibe el ojo y elija una de esas frecuencias para el conteo (la más rápida en donde las unidades de millar y centenas sean perceptibles). |
| P01_Ejercicio_03.vhd | P01_Ejercicio_03_tb.vhd | [Esquema](P01_Ejercicio_03_sch.pdf) | Diseñe, simule e implemente un letrero digital en el display, el mensaje debe contener al menos 3 palabras y debe desplazarse a la izquierda, una vez que se imprima la última palabra el mensaje debe volver a imprimirse, elija la frecuencia apropiada para el                                                                  |

## Resultados

La siguiente práctica presentó muchos retos, esto debido que mientras se cuenta con experiencia en campo como desarrolladores de software, el desarrollo de hardware no es un campo al que hemos estado expuestos. Sin contar que el lenguaje de programación utilizado es muy diferente a lenguajes mas populares como Java o Python.

Uno de los retos mas importantes fue el entender como poder simular, ya que el no contar con una tarjeta física para poder realizar las pruebas, dificultó la creación de código para poder adaptar al simulador de Vivado. Esto provocó que nuestro código tuviera algunas rutinas extras que podrían ser confusas.

Otro reto fue entender como interpretar el simulador de Vivado y como configurar el mismo para poder correr pruebas y revisar las señales simuladas.

## Conclusiones

Durante la investigación se encontró los distintos uso, así como distintas tarjetas y sus tipos que sirven para fines similares. Para un desarrollador de software, este lenguaje y forma de programación puede resultar algo obsoleto, pero la realidad es que es algo muy vigente que funciona y por eso no tiene la necesidad de cambiar seguido.

## Bibliografía

- Programación de sistemas digitales con VHDL - David G. Maxinez
- [FPGA 4 Students](https://www.fpga4student.com/)
