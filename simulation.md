# Modelado de la simulación

- **Entorno de simulación**: testbench. Todos lo módulos implementados vienen con su respectivo testbench para simulación. No todos los testbench hacen uso del visualizador de ondas.
- **Estímulos**: casos de prueba. Ya sea qué el módulo describa un circuito combinacional o secuencial, las pruebas se realizan estimulando las señales de entrada de los módulos y verificando las salidas por medio de `$display()` para diferentes casos.
- **Temporización**: para módulos secuenciales se realiza la temporización por medio de pulsaciones controladas de las señales de reloj por medio de `always #5 clk = ~clk`, entre otros. La lógica de los circuitos secuenciales se diseña para flancos positivos.
- **Otras herramientas**: para los módulos con memorias modificables se hacen volcados de memoria para guardar el estado final en archivos hexadecimales en el directorio `/output`.

-----------

## Compilación de un módulo

Para poder compilar un módulo y sus dependencias con su respectivo testbench debe ejecutar el comando respectivo de los mostrados a continuación:

```bash
$ make ControlUnit        # Unidad de Control
$ make CondUnit           # Unidad de Condiciones
$ make AdminUnit          # Unidad de Administradord
$ make SSU                # Unidad de Selección Segura
$ make SecureMemory       # Memoria Segura
$ make RegFile            # Banco de Registros
$ make Hazard             # Unidad de Riesgos
$ make InstructionMemory  # Memoria de Instrucciones
$ make DataMemory         # Memoria de Datos
$ make Vault              # Bóveda
$ make pALU               # ALU primaria
$ make sALU               # ALU secundaria
$ make ImmExt             # Unidad de Extensión de Inmediatos
$ make Datapath           # Datapath del procesador
```

## Simulación por medio de ejecución del testbench

Para poder ejecutar la simulación sin ningún tipo de configuración para el graficador de ondas, ejecute el comando:

```bash
$ make run
```

Para poder ejecutar la simulación con una configuración de señales para el generador de ondas, ejecute el comando:

```bash
$ make run-config TARGET=wave
```

Estos comandos ejecutan el testbench respectivo para el módulo compilado.

Note que:

- En todos los casos en el directorio `/output` se generan los archivos:
  - `sim.out`: archivo de simulación
  - `wave.vcd`: graficador de ondas para la simulación
- En casos de módulos con memorias, en el directorio `/output` se generan los siguientes archivos:
  - Estado de salida de memoria de datos: `data_mem_exit.hex` (datapath y memoria de datos)
  - Estado de salida de bóveda: `vault_exit.hex` (datapath y bóveda)
  - Estado de salida de banco de registros: `regfile_exit.hex` (datapath)
  - Estado de salida de memoria segura: `secmem_exit.hex` (datapath)

- El TARGET especificado en el comando especifica un archivo .gtkw con una configuración de señales establecida, pero se puede especificar otro archivo de este tipo que se tenga guardado en el directorio `/output`.

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
