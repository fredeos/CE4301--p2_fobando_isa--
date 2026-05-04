# Simulación de procesador

-----------

## Compilación del procesador

Para poder compilar el procesador debe ejecutar el comando:

```bash
$ make Datapath
```

## Simulación del procesador
Para poder simular la ejecución de un programa en el procesador ejecute el comando:

```bash
$ make run-config TARGET=wave
```

Note que:

- En el directorio `/output` se generan los siguientes archivos:
  - Estado de salida de memoria de datos:
  - Estado de salida de bóveda:
  - Estado de salida de banco de registros:
  - Estado de salida de memoria segura:
- El TARGET especificado en el comando especifica un archivo .gtkw con una configuración de señales establecida, pero se puede especificar otro archivo de este tipo que se tenga guardado en el directorio `/output`. Por el contrario, si no se tiene un archivo de este tipo o la simulación no contiene las señales configuradas en este, puede ejecutar el comando (que no tiene ninguna configuración):

```bash
make run
```

## Carga de datos a las memorias
Para cargar datos en las memorias, ya sea en para instrucciones o datos, debe ejecutar el comando:

```bash

```

Donde x es el archivo de entrada y z es el archivo de salida. Note que:

- En el comando puede especificar la ruta de cualquier archivo pero idealmente los archivos que se quieran cargar deben quedar en el directorio `/input`
- Para especificar a cual memoria se van a insertar los datos en el output debe tomar en consideración:
  - Para memoria de datos: sustituir x por y
  - Para memoria de instrucciones: sustituir x por y 

## Extracción de datos de las memorias
Para extraer datos de la memoria de datos y guardarlos en un archivo debe ejecutar el comando:

```bash

```

Donde x es el archivo de salida donde se van guardar los datos en el tipo de formato especificado. Note que:

- En el comando puede especificar la ruta de cualquier archivo de salida, pero idealmente deben quedar en el directorio `/output`
