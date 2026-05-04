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
  - Estado de salida de memoria de datos: `data_mem_exit.hex`
  - Estado de salida de bóveda: `vault_exit.hex`
  - Estado de salida de banco de registros: `regfile_exit.hex`
  - Estado de salida de memoria segura: `secmem_exit.hex`
- El TARGET especificado en el comando especifica un archivo .gtkw con una configuración de señales establecida, pero se puede especificar otro archivo de este tipo que se tenga guardado en el directorio `/output`. Por el contrario, si no se tiene un archivo de este tipo o la simulación no contiene las señales configuradas en este, puede ejecutar el comando (que no tiene ninguna configuración):

```bash
$ make run
```

## Carga de datos a las memorias
Para cargar datos en las memorias, ya sea en para instrucciones o datos, debe ejecutar el comando:

```bash
$ make pyload-mem INPUT=<archivo> OUTPUT=<memoria> ADDRESS=<direccion>
```

Note que:

- `<archivo>` se sustituye por el nombre de un archivo en el directorio `/input` que se desea escribir a una memoria
- `<output>` corresponde al archivo HEX de la memoria a la que se desea escribir los datos. Este se debe sustituir por:
  - Para memoria de datos: `datamem/data_mem.hex`
  - Para memoria de instrucciones: `instrmem/instr_mem.hex`
- `<direccion>` corresponde a la posición en bytes sobre la cuál el contenido del archivo se va a escribir en la memoria (ej. 0x4)

## Extracción de datos de las memorias
Para extraer datos de la memoria de datos y guardarlos en un archivo debe ejecutar el comando:

```bash
$ make pyextract-data INPUT=<memoria> ADDRESS=<direccion> SIZE=<tamaño> OUTPUT=<archivo>
```

Note que:

- `<memoria>` es el nombre del archivo de estado de salida para una de las memorias en el directorio `/output`.
- `<direccion>` es la dirección en bytes sobre la cual se comienza a leer en la memoria para generar el archivo de salida (ej. 0x4)
- `<tamaño>` indica el tamaño en bytes del archivo de salida (ej. 245)
- `<archivo>` nombre del archivo (con extensión) en el que se guardan los datos leídos de la memoria (ej. *imagen.png*). Este archivo es guardado en el directorio `/output`
