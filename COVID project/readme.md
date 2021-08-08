# Proyecto sobre datos del COVID

_Este es mi primer proyecto que comparto en GitHub._

## Datos

_El dataset con el que trabajo lo descargué en [Our world in data](https://ourworldindata.org/covid-deaths) y contiene 
las siguientes caracteristicas principales con las que estaremos explorando:_

* ISO_Code: Son codigos de tres letras que representan el nombre de un país y sus subdivisiones.
* Continent: Nos muestra el continente en el cual está el país seleccionado.
* Location: El país correspondiente. Este dataset cuenta por ejemplo "World" como una localizacion, 
lo cual distorciona los resultados finales. Es por eso que en el proyecto explico como quitarlo
para su posterior estudio por separado.
* Date: Fecha.
* Total_cases: Los casos totales hasta el día de hoy.
* New_cases: Casos nuevos a la fecha (en la que el DATASET fue creado)
* New_cases_smoothed: Data Smoothing es usado para remover "ruido" de un dataset. 
Es interesante esta columna a mi parecer porque nos permite simplificar los cambios
para un mejor analisis. En este caso, de nuevos casos.
* Population: La poblacion total de un pais.
* Population_density: Es un dato tambien denominado Poblacion Relativa, se refiere al numero promedio de habitantes del país,
en relacion a una unidad de superficie del territorio donde se encuentra dicho país.










