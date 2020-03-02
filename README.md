# HEC-HMS Toolbox

La librería de **HEC-HMS Toolbox** fue desarrollada en Matlab versión 2018b para manipular el software de modelación hidrológica HEC-HMS. En principio **HEC-HMS Toolbox** fue diseña para manipular la versión 4.2.1 de HEC-HMS. Sin embargo, si el modo de ejecución del programa, la estructura y lógica de los archivos que configuran el HEC-HMS no cambian, la librería debería poder operar independientemente de la versión. En este sentido, se recomienda al usuario verificar las actualizaciones en versiones posteriores a HEC-HMS 4.2.1.

Por le momento **HEC-HMS Toolbox** es funcional para los modelos de Numero de Curva - SCS y transito con Muskingum. La manipulación para configuraciones diferentes aun no se ha desarrollado. 

# ¿Como configurar una ejecución?
**HEC-HMS Toolbox** funciona siguiendo el mismo principio en el cual opera HEC-HMS. En este sentido, lo primero que debemos hacer es configurar nuestro proyecto en HEC-HMS, lo que consiste en definir las unidades de modelación y definir los modelos a utilizar. En esta configuración es necesario incluir parámetros de cada una de las unidades así como también incluir las series climáticas a utilizar (eventos de precipitación). En conclusión, todo el modelo en HEC-HMS se debe construir de manera manual, por lo que si al ejecutarlo no generar ningún error, la configuración quedo realizada adecuadamente. 

### Puntos importantes para la configuración de un proyecto en HEC-HMS
Para que un proyecto sea compatible con **HEC-HMS Toolbox** debe tener en cuenta las siguientes consideraciones:
* Las cuencas debe tener nombre un a combinación alfanumérica sin espacio ni caracteres especiales. Por ejemplo W1001, W1002, ... ect.
* El nombre de los Time-Series-Gage debe tener el mismo nombre de la cuenca a la cual le corresponde la serie. Por ejemplo Precip Gage W1001, Precip Gage W1002, ... etc. 
*  Los tramos de río debe tener nombre un a combinación alfanumérica sin espacio ni caracteres especiales. Por ejemplo R101, R102, ... ect.

### Estructura de capetas y configuración de proyecto
Cuando ya tengamos configurado el modelo, procedemos a crear un carpeta con la siguiente estructura: 
* DATA
* CODES
* MODEL
* RESULTS
* TMP

En la capeta **MODEL** vamos a disponer el modelo ya configurado (toda la carpeta que crea HEC-HMS). En la carpeta **DATA** Vamos a disponer los archivos excel :
* HEC_HMS.csv
* Group_River.csv
* Group_Basin.csv

### Script para ejecución de HEC-HMS

Realizada esta configuración creamos en la carpeta CODES un script en MATLAB para manipular el modelo. En este debemos incluir las siguiente lineas de código:

* Llamado de la librería de  **HEC-HMS Toolbox** a Folder por Default de MATLAB
```
addpath('C:\Users\User\Desktop\HEC-HMS-Toolbox')
```
* Definición del directorio creado para el proyecto (es la carpeta con la estructura creada anteriormente)
```
PathControl     = 'C:\Users\User\Desktop\HEC-HMS-Toolbox\MyProject-HEC';
```
* Directorio donde se encuentra instalado HEC-HMS
```
PathHEC_HMS     = 'C:\Program Files (x86)\HEC\HEC-HMS\4.2.1';
```
* Directorio donde se encuentra instalado HEC-DSS
```
Path_HEC_DSS    = 'C:\Program Files (x86)\HEC\HEC-DSSVue';
```
* Directorio donde se encuentra nuestro modelo 
```
% PathModel       = 'C:\Users\User\Desktop\HEC-HMS-Toolbox\MyProject-HEC\MODEL\MyModel-HEC';
```
* Nombre del proyecto creado en HEC-HMS
```
NameModel       = 'My-HEC';
```
* Nombre de la corrida configurada en HEC-HMS
```
NameRun         = 'Run_1';
```
* Fecha inicial desde la cual se va a ejecutar HEC-HMS.
```
Date_Init       = datetime(2019,10,28,1,0,0);
```
* Fecha final hasta la cual se va a ejecutar HEC-HMS.
```
Date_End        = datetime(2019,10,30,0,0,0);
```
Es muy importante que las fechas de inicio y fin de la ejecución de HEC-HMS, se encuentren debidamente alimentadas con los datos climáticos, de lo contrario generar error. Es decir, las fechas de ejecución del modelo deben ser las mis que los eventos de lluvia configurados.

* Nombre del nodo de desembocadura del área configurada en HEC-HMS
```
Name_Output = 'Pte_Av_Domingo_Diaz';
```
* Definición de los pasos de tiempo de ejecución y de los eventos de lluvias configurados. HEC-HMS presenta por default los siguiente pasos de tiempo los cuales han sigo codificados de la siguiente manera:

| Código | Tiempo HEC-HMS|
|--|--|
|   1   | 1 MIN |
|   2   | 2 MIN |
|   3   | 3 MIN |
|   4   | 4 MIN |
|   5   | 5 MIN |
|   6   | 6 MIN |
|   7   | 10 MIN |
|   8   | 12 MIN |
|   9   | 15 MIN |
|   10  | 20 MIN | 
|   11  | 30 MIN |
|   12  | 1 HOUR |
|   13  | 2 HOUR |
|   14  | 3 HOUR |
|   15  | 6 HOUR |
|   16  | 8 HOUR |
|   17  | 12 HOUR |

En este sentido, si queremos que el paso de tiempo en el cual se ejecute HEC-HMS sea de 5 Minutos, debemos tomar el código 5; 
```
Code_dt_Run_Model = 5;
```
Ahora bien, los pasos de tiempo de la ejecución y el de los eventos no avariciosamente deben ser igual, por lo que también se debe definir éste paso de tiempo.  Por ejemplo  si la serie esta configurada cada hora, el código seria 12.
```
Code_dt_TimeSeries = 12;
```
Cuando HEC-HMS genera un proyecto, éste crea un .dss el cual es la base de datos con la cual opera HEC-HMS. En este archivo guarda todas las series de tiempo de cada una de las cuencas configuradas en el proyecto. HEC estructura las series de los eventos al interior del dss de la siguiente manera:
* Number : es el id de la serie
* Part A : Es un campo para identificar a que escenario corresponde la serie
* Part B: Es el nombre de Gauges creado en HEC-HMS
* Part C: Es el tipo de variable. para precipitación por default es PRECIP-INC
* Part D/ Range: es la fecha de de inicio de la serie de tiempo
* Part E: Es el paso de tiempo de la serie de tiempo
* Part F: GAGE

Para finalizar la configuración, debemos brindar la Part A, C y F. Por ejemplo:
```
A = 'HIST_TR_100';
C = 'PRECIP-INC';
F = 'GAGE';
```
Con la información anteriormente configuradas podemos crear un Objeto en MATLAB que representa un ejecución. 
```
Model = HEC_HMS( PathModel, PathHEC_HMS, Path_HEC_DSS, PathControl,...
                                     NameModel, NameRun, Date_Init, Date_End,...
                                     Code_dt_Run_Model, Code_dt_TimeSeries,...
                                     A, C, F);
```
Para ejecutar HEC-HMS ejecutamos el siguiente comando 
```
Model.Cal_Lag;
Model.Run_HEC_HMS;
```

##  ¿Como configurar archivo HEC-HMS.csv? 
El archivo HEC-HMS contiene la información de las parametrización del modelo, para cada una de las unidades configuradas.
Este archivo contiene las siguientes columnas.
* NameBasin -> Nombre de las cuencas configuradas
* NameRiver -> Nombre de los segmentos de río configurados para transito
* AreaBasin -> Área de la cuenca (km2)
* Slope -> Pendiente de la cuenca (%)
* Longest -> Longitud del tramo de río (m)
* GroupRiver -> Numero de grupos para segmentar parámetros entre tramos de río
* GroupBasin -> Numero de grupos para segmentar parámetros entre cuencas
* Alpha_Ia -> Parámetro alfa para condición inicial en el método de numero de curva
* K -> Paramento de Muskingum
* X -> Paramento de Muskingum
* Step -> Paramento de Muskingum. Discretización numérica