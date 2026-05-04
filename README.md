# CE4301--p2_fobando_isa--

Este repositorio contiene el desarrollo del primer proyecto grupal del curso CE4301 – Arquitectura de Computadores I. El objetivo del proyecto es diseñar e implementar una arquitectura de set de instrucciones (ISA) tipo RISC orientada a aplicaciones de seguridad informática, utilizando SystemVerilog.

La propuesta incorpora soporte a nivel de hardware para operaciones criptográficas eficientes, mediante la implementación del algoritmo TEA, así como un mecanismo seguro de almacenamiento de llaves criptográficas basado en una bóveda protegida. Todo el sistema es validado mediante simulación, permitiendo analizar su funcionalidad de manera correcta.

## Estructura del repositorio

```

├── images/              # Imagenes utilizadas en la documentacion
├── input/               # Archivos de entrada (texto, imágenes, etc.)
├── output/              # Resultados generados por la simulación
├── res/                 # Recursos adicionales
├── src/                 # Código fuente
│   ├── alu/                    # Implementación de las ALUs
│   ├── control/                # Unidad de control
│   ├── datamem/                # Memoria de datos
│   ├── datapath/               # Datapath del procesador
│   ├── hazard/                 # Unidad de Hazard
│   ├── instrmem/               # Memoria de instrucciones
│   ├── regfile/                # Banco de registros
│   ├── secmem/                 # Memoria segura
│   ├── vault/                  # Bóveda de llaves criptográficas
│   ├── extract_data.py         # Genera archivo con datos extraídos
│   ├── gen_file.py             # Generador de archivos
│   └── load_file.py            # Carga de archivos a memoria
├── .gitignore
├── commands.txt           # Comandos útiles y scripts de ejecución
├── LICENSE
├── Makefile               # Automatización de compilación/simulación
├── isa.md                 # Green sheet del ISA desarrollado
├── microarchitecture.md   # Descripción de la microarquitectura
├── simulation.md          # Detalles sobre la simulación
└── README.md

```
Nota: Cada carpeta funcional dentro de `src/` contiene un subdirectorio `test/` donde se encuentran los testbenches asociados a ese módulo (por ejemplo: `alu/test/`, `vault/test/`, etc.).

---

## Requisitos previos

Antes de ejecutar el proyecto, asegúrese de tener instalado lo siguiente:

| Herramienta | Descripción |
|---|---|
| [Icarus Verilog](https://bleyer.org/icarus/) | Compilador y simulador de Verilog/SystemVerilog |
| [GTKWave](https://bleyer.org/icarus/) | Visualizador de waveforms (incluido en el instalador de Icarus) |
| Git Bash | Terminal para ejecutar los comandos `make` en Windows |
| Python 3.x | Requerido para los scripts de preprocesamiento |

>  **Sistema Operativo soportado:** Windows  
> Los comandos de compilación y simulación utilizan `make` a través de Git Bash. No se garantiza compatibilidad con CMD o PowerShell.

## Instrucciones de ejecución

Todos los comandos deben ejecutarse desde la **raíz del repositorio** usando **Git Bash**.

Las memorias del procesador se inicializan a partir de archivos `.HEX` ubicados en las siguientes carpetas:

| Carpeta | Descripción |
|---|---|
| `src/instrmem/` | Memoria de instrucciones |
| `src/datamem/` | Memoria de datos de entrada/salida |
| `src/vault/` | Bóveda de llaves criptográficas |

---

### Sección A: Ejecución del Algoritmo TEA

Esta sección describe el flujo completo para encriptar y desencriptar un archivo usando el algoritmo TEA sobre el procesador simulado.

>  En los comandos de Python, `python3` puede sustituirse por `python` o `py` dependiendo de su instalación.

---

#### Encriptado

**1. Generar las instrucciones TEA y preparar la memoria de datos**

Se carga el archivo de entrada en la memoria de datos. El archivo de entrada puede ser cualquier tipo de archivo (`.png`, `.jpeg`, `.txt`, etc.)

```bash
python3 tea/gen_tea_unrolled.py --input input/<archivo_entrada> --address 0x0 --mode both
python3 src/load_file.py --input input/<archivo_entrada> --output ./datamem/data_mem.hex --address 0x0
```

**2. Cargar el programa de encriptado en la memoria de instrucciones**

```bash
cp tea/tea_encrypt.hex src/instrmem/instr_mem.hex
```

**3. Compilar y ejecutar la simulación**

```bash
make Datapath
make run
```

O bien, para ejecutar con un waveform predeterminado que muestra las señales de cada etapa del pipeline y el ciclo correspondiente:

```bash
make run-config TARGET=wave
```

**4. Guardar el resultado encriptado**

```bash
cp output/data_mem_exit.hex tea/proof/<nombre>_encrypted.hex
```

---

#### Desencriptado

**1. Cargar el archivo encriptado y el programa de desencriptado**

```bash
cp tea/proof/<nombre>.hex src/datamem/data_mem.hex
cp tea/tea_decrypt.hex src/instrmem/instr_mem.hex
```

**2. Ejecutar la simulación**

```bash
make run
```

O con waveform:

```bash
make run-config TARGET=wave
```

**3. Guardar el resultado y extraer el archivo original**

Primero se copia la memoria de salida:

```bash
cp output/data_mem_exit.hex tea/proof/<nombre>_decrypted_mem.hex
```

Luego se extrae el archivo recuperado. El parámetro `--size` corresponde al tamaño del archivo original en bytes, y `--output` define el nombre y extensión del archivo reconstruido:

```bash
python3 src/extract_file.py \
  --memory tea/proof/<nombre>_decrypted_mem.hex \
  --address 0x0 \
  --size <tamano_archivo_orig> \
  --output tea/proof/<nombre>_decrypted.<extension_archivo_original>
```

---

### Sección B: Ejecución de códigos de prueba

Esta sección describe cómo cargar y ejecutar un programa personalizado en el procesador.

**1. Cargar el programa en la memoria de instrucciones**

Copie el archivo `.HEX` con las instrucciones de su programa a la memoria de instrucciones. Las instrucciones deben estar codificadas en hexadecimal según el ISA definido en [`isa.md`](isa.md):

```bash
cp input/<programa_prueba>.hex src/instrmem/instr_mem.hex
```

**2. Compilar el diseño**

```bash
make Datapath
```

Este comando compila el diseño completo en SystemVerilog y prepara el testbench con los contenidos actuales de las memorias.

**3. Ejecutar la simulación**

```bash
make run
```

O con waveform predeterminado:

```bash
make run-config TARGET=wave
```

>  **Límite de ciclos:** El testbench está configurado para un máximo de 1000 ciclos de reloj. Si su programa requiere más ciclos para completarse, deberá ajustar el parámetro correspondiente en el testbench del datapath (`src/datapath/test/`).

---
## Ejemplos de uso

---
## Integrantes
- [@fredeos](https://github.com/fredeos) Frederick Obando
- [@diegosalaov](https://github.com/diegosalasov) Diego Salas
- [@SpaceBa13](https://github.com/SpaceBa13) Brayan Alpizar
- [@maarigonzalezz](https://github.com/maarigonzalezz) Mariana González

