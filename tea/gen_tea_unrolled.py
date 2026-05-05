"""Generate TEA encrypt/decrypt programs for the F32IS datapath.

The generated assembly keeps the 32 TEA rounds unrolled, but it uses a
normal outer loop over 64-bit data blocks. That keeps instr_mem small while
still encrypting/decrypting the complete file loaded in data_mem.
"""

from __future__ import annotations

import argparse
import math
import mimetypes
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
TEA_DIR = Path(__file__).resolve().parent
ASM_PARSER = TEA_DIR / "asm_parser.py"
LOGIN_KEY = "0xA9C1F"
MAX_IMM12_POSITIVE = 2047


class Program:
    def __init__(self) -> None:
        self.lines: list[str] = []

    def label(self, name: str) -> None:
        self.lines.append(f"{name}:")

    def emit(self, text: str = "") -> None:
        self.lines.append(text)

    @staticmethod
    def _is_instruction(line: str) -> bool:
        code = line.split(";", 1)[0].split("#", 1)[0].strip()
        return bool(code) and not code.endswith(":")

    def _instruction_indices(self) -> tuple[dict[int, int], dict[str, int]]:
        line_to_index: dict[int, int] = {}
        labels: dict[str, int] = {}
        index = 0

        for line_no, line in enumerate(self.lines):
            code = line.split(";", 1)[0].split("#", 1)[0].strip()
            if not code:
                continue
            if code.endswith(":"):
                labels[code[:-1]] = index
                continue
            line_to_index[line_no] = index
            index += 1

        return line_to_index, labels

    def render(self) -> str:
        line_to_index, labels = self._instruction_indices()
        rendered: list[str] = []

        for line_no, line in enumerate(self.lines):
            code, sep, comment = line.partition(";")
            stripped = code.strip()
            if line_no not in line_to_index:
                rendered.append(line)
                continue

            parts = stripped.split(None, 1)
            if len(parts) == 2:
                op, operands = parts
                split_operands = [operand.strip() for operand in operands.split(",")]
                last = split_operands[-1]
                if last in labels:
                    offset = labels[last] - (line_to_index[line_no] + 1)
                    split_operands[-1] = str(offset)
                    rebuilt = f"    {op} " + ", ".join(split_operands)
                    if sep:
                        rebuilt += f" ;{comment}"
                    rendered.append(rebuilt)
                    continue

            rendered.append(line)

        return "\n".join(rendered).rstrip() + "\n"


def emit_encrypt_round(program: Program, round_no: int) -> None:
    program.emit(f"    ; encrypt round {round_no}")
    program.emit("    send ex, delta")
    program.emit("    padd dx, dx, ex")

    program.emit("    pmovi ex, 4")
    program.emit("    ldvw fx, +0(ax)")
    program.emit("    pslladd gx, cx, ex, fx")
    program.emit("    padd hx, cx, dx")
    program.emit("    pmovi ex, 5")
    program.emit("    ldvw fx, +4(ax)")
    program.emit("    psrladd ex, cx, ex, fx")
    program.emit("    pxorxor gx, gx, hx, ex")
    program.emit("    padd bx, bx, gx")

    program.emit("    pmovi ex, 4")
    program.emit("    ldvw fx, +8(ax)")
    program.emit("    pslladd gx, bx, ex, fx")
    program.emit("    padd hx, bx, dx")
    program.emit("    pmovi ex, 5")
    program.emit("    ldvw fx, +12(ax)")
    program.emit("    psrladd ex, bx, ex, fx")
    program.emit("    pxorxor gx, gx, hx, ex")
    program.emit("    padd cx, cx, gx")
    program.emit()


def emit_decrypt_round(program: Program, round_no: int) -> None:
    program.emit(f"    ; decrypt round {round_no}")
    program.emit("    pmovi ex, 4")
    program.emit("    ldvw fx, +8(ax)")
    program.emit("    pslladd gx, bx, ex, fx")
    program.emit("    padd hx, bx, dx")
    program.emit("    pmovi ex, 5")
    program.emit("    ldvw fx, +12(ax)")
    program.emit("    psrladd ex, bx, ex, fx")
    program.emit("    pxorxor gx, gx, hx, ex")
    program.emit("    psub cx, cx, gx")

    program.emit("    pmovi ex, 4")
    program.emit("    ldvw fx, +0(ax)")
    program.emit("    pslladd gx, cx, ex, fx")
    program.emit("    padd hx, cx, dx")
    program.emit("    pmovi ex, 5")
    program.emit("    ldvw fx, +4(ax)")
    program.emit("    psrladd ex, cx, ex, fx")
    program.emit("    pxorxor gx, gx, hx, ex")
    program.emit("    psub bx, bx, gx")

    program.emit("    send ex, delta")
    program.emit("    psub dx, dx, ex")
    program.emit()


def emit_load_imm(program: Program, reg: str, value: int, comment: str = "") -> None:
    """Load a non-negative integer using ISA immediates that fit in 12 bits."""

    if value < 0:
        raise ValueError("emit_load_imm solo soporta valores no negativos")

    suffix = f"          ; {comment}" if comment else ""
    if value <= MAX_IMM12_POSITIVE:
        program.emit(f"    li {reg}, {value}{suffix}")
        return

    program.emit(f"    li {reg}, 0{suffix}")
    remaining = value
    while remaining:
        chunk = min(remaining, MAX_IMM12_POSITIVE)
        program.emit(f"    addi {reg}, {reg}, {chunk}")
        remaining -= chunk


def emit_program(mode: str, blocks: int, size_bytes: int, address: int, runtime_config: bool = False) -> str:
    program = Program()
    op_name = "encrypt" if mode == "encrypt" else "decrypt"
    padded_size = blocks * 8

    program.emit(f"; TEA {op_name} completo in-place.")
    if runtime_config:
        program.emit("; Configuracion en runtime:")
        program.emit(";   data_mem[0] = direccion byte inicial del archivo.")
        program.emit(";   data_mem[4] = cantidad de bloques de 64 bits.")
        program.emit("; El archivo empieza en data_mem[data_mem[0]].")
    else:
        program.emit(f"; Archivo: {size_bytes} bytes, {blocks} bloques de 64 bits.")
        program.emit(f"; Padding TEA: {padded_size - size_bytes} bytes.")
        program.emit(f"; Entrada/salida: data_mem desde address 0x{address:x}.")
    program.emit("; Llave TEA: vault[0..3].")
    program.emit()

    program.label("__init__")
    emit_load_imm(program, "sp", 512)
    emit_load_imm(program, "r3", 0, "bloque actual")
    if runtime_config:
        emit_load_imm(program, "r6", 0, "base de configuracion TEA")
        program.emit("    ldw r0, +0(r6)    ; byte address base en data_mem")
        program.emit("    ldw r4, +4(r6)    ; total de bloques")
    else:
        emit_load_imm(program, "r0", address, "byte address base en data_mem")
        emit_load_imm(program, "r4", blocks, "total de bloques")
    program.emit()
    program.emit(f"    login {LOGIN_KEY}")
    program.emit()

    if mode == "decrypt":
        program.emit("    ; r5 guarda delta * 32 para reiniciar sum en cada bloque")
        program.emit("    pmovi dx, 0")
        for _ in range(32):
            program.emit("    send ex, delta")
            program.emit("    padd dx, dx, ex")
        program.emit("    recv r5, dx")
        program.emit()

    program.label("block_loop")
    program.emit("    bge r3, r4, done")
    program.emit()
    program.emit("    ldw r1, +0(r0)")
    program.emit("    ldw r2, +4(r0)")
    program.emit("    send bx, r1        ; v0")
    program.emit("    send cx, r2        ; v1")
    if mode == "encrypt":
        program.emit("    pmovi dx, 0        ; sum")
    else:
        program.emit("    send dx, r5        ; sum = delta * 32")
    program.emit()

    for round_no in range(1, 33):
        if mode == "encrypt":
            emit_encrypt_round(program, round_no)
        else:
            emit_decrypt_round(program, round_no)

    program.emit("    recv r1, bx")
    program.emit("    recv r2, cx")
    program.emit("    stw r1, +0(r0)")
    program.emit("    stw r2, +4(r0)")
    program.emit("    addi r0, r0, 8")
    program.emit("    addi r3, r3, 1")
    program.emit("    jmp block_loop")
    program.emit()

    program.label("done")
    program.emit("    quit")
    program.emit()
    program.label("__halt__")
    program.emit("    jmp -1")

    return program.render()


def assemble(asm_path: Path, hex_path: Path) -> None:
    subprocess.run(
        [sys.executable, str(ASM_PARSER), str(asm_path), str(hex_path)],
        check=True,
        cwd=ROOT,
    )


def write_program(mode: str, blocks: int, size_bytes: int, address: int, runtime_config: bool) -> None:
    asm_path = TEA_DIR / f"tea_{mode}.asm"
    hex_path = TEA_DIR / f"tea_{mode}.hex"
    asm_path.write_text(emit_program(mode, blocks, size_bytes, address, runtime_config), encoding="utf-8")
    assemble(asm_path, hex_path)


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate complete-file TEA programs.")
    parser.add_argument("--input", help="Archivo a procesar; se usa para detectar tamano y tipo.")
    parser.add_argument("--size", type=int, help="Tamano en bytes si no se pasa --input.")
    parser.add_argument("--address", default="0x0", help="Direccion inicial en data_mem, en bytes.")
    parser.add_argument("--mode", choices=["encrypt", "decrypt", "both"], default="both")
    parser.add_argument(
        "--runtime-config",
        action="store_true",
        help="Genera TEA para leer base y cantidad de bloques desde data_mem[0] y data_mem[4].",
    )
    args = parser.parse_args()

    if args.input:
        input_path = Path(args.input)
        if not input_path.exists():
            raise SystemExit(f"No existe el archivo: {input_path}")
        size_bytes = input_path.stat().st_size
        detected_type = mimetypes.guess_type(input_path.name)[0] or "application/octet-stream"
    elif args.size is not None:
        size_bytes = args.size
        detected_type = "desconocido"
    else:
        raise SystemExit("Indica --input archivo o --size bytes.")

    address = int(args.address, 0)
    if address % 4 != 0:
        raise SystemExit("La direccion debe estar alineada a 4 bytes para ldw/stw y readmemh.")
    if size_bytes <= 0:
        raise SystemExit("El tamano debe ser mayor que cero.")

    blocks = math.ceil(size_bytes / 8)
    padded_size = blocks * 8
    modes = ["encrypt", "decrypt"] if args.mode == "both" else [args.mode]

    for mode in modes:
        write_program(mode, blocks, size_bytes, address, args.runtime_config)

    print("--- TEA program generado ---")
    print(f"Modo(s): {', '.join(modes)}")
    print(f"Tipo detectado: {detected_type}")
    print(f"Tamano original: {size_bytes} bytes")
    print(f"Bloques TEA: {blocks} de 64 bits")
    print(f"Padding final: {padded_size - size_bytes} bytes")
    if args.runtime_config:
        print("Configuracion runtime: data_mem[0]=base, data_mem[4]=bloques")
    else:
        print(f"Rango de memoria: 0x{address:x} -> 0x{address + padded_size - 1:x}")


if __name__ == "__main__":
    main()
