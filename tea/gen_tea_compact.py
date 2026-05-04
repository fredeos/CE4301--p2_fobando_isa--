"""Generate compact TEA programs that use compiler-style data_mem config.

Memory contract:
  data_mem[0] = base byte address of the payload
  data_mem[4] = number of 64-bit TEA blocks
  data_mem[base + 8*i + 0] = v0
  data_mem[base + 8*i + 4] = v1
"""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path

from gen_tea_unrolled import Program


ROOT = Path(__file__).resolve().parents[1]
TEA_DIR = Path(__file__).resolve().parent
ASM_PARSER = TEA_DIR / "asm_parser.py"


def emit_encrypt_mix(program: Program) -> None:
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


def emit_decrypt_mix(program: Program) -> None:
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


def emit_common_header(program: Program, name: str) -> None:
    program.emit("; Codigo ensamblador generado para TEA compacto")
    program.emit("; data_mem[0] = base byte address, data_mem[4] = block_count")
    program.emit("__init__:")
    program.emit("    li sp, 512")
    program.emit("    call main")
    program.emit("__halt__:")
    program.emit("    jmp -1")
    program.label(name)
    program.emit("    addi sp, sp, 4")
    program.emit("    stw ra, +0(sp)")
    program.emit("    login 0xA9C1F")
    program.emit(f"    beqz lr, {name}_secure_exit")
    program.emit("    li r0, 0")
    program.emit("    ldw r0, +0(r0)    ; base byte address")
    program.emit("    li r3, 4")
    program.emit("    ldw r3, +0(r3)    ; total blocks")
    program.emit("    li r4, 0          ; current block")


def emit_common_footer(program: Program, name: str) -> None:
    program.label(f"{name}_secure_exit")
    program.emit("    quit")
    program.emit("    ldw ra, +0(sp)")
    program.emit("    addi sp, sp, -4")
    program.emit("    ret")
    program.label("main")
    program.emit("    addi sp, sp, 4")
    program.emit("    stw ra, +0(sp)")
    program.emit(f"    call {name}")
    program.emit("    ldw ra, +0(sp)")
    program.emit("    addi sp, sp, -4")
    program.emit("    ret")


def build_encrypt() -> str:
    program = Program()
    emit_common_header(program, "tea_encrypt_file")
    program.label("block_loop")
    program.emit("    bge r4, r3, tea_encrypt_file_secure_exit")
    program.emit("    ldw r1, +0(r0)")
    program.emit("    ldw r2, +4(r0)")
    program.emit("    send bx, r1")
    program.emit("    send cx, r2")
    program.emit("    pmovi dx, 0")
    program.emit("    li r5, 0")
    program.emit("    li r6, 32")
    program.label("round_loop")
    program.emit("    bge r5, r6, round_done")
    emit_encrypt_mix(program)
    program.emit("    addi r5, r5, 1")
    program.emit("    jmp round_loop")
    program.label("round_done")
    program.emit("    recv r1, bx")
    program.emit("    recv r2, cx")
    program.emit("    stw r1, +0(r0)")
    program.emit("    stw r2, +4(r0)")
    program.emit("    addi r0, r0, 8")
    program.emit("    addi r4, r4, 1")
    program.emit("    jmp block_loop")
    emit_common_footer(program, "tea_encrypt_file")
    return program.render()


def build_decrypt() -> str:
    program = Program()
    emit_common_header(program, "tea_decrypt_file")
    program.emit("    pmovi dx, 0")
    program.emit("    li r5, 0")
    program.emit("    li r6, 32")
    program.label("sum_loop")
    program.emit("    bge r5, r6, sum_done")
    program.emit("    send ex, delta")
    program.emit("    padd dx, dx, ex")
    program.emit("    addi r5, r5, 1")
    program.emit("    jmp sum_loop")
    program.label("sum_done")
    program.emit("    recv r7, dx")
    program.label("block_loop")
    program.emit("    bge r4, r3, tea_decrypt_file_secure_exit")
    program.emit("    ldw r1, +0(r0)")
    program.emit("    ldw r2, +4(r0)")
    program.emit("    send bx, r1")
    program.emit("    send cx, r2")
    program.emit("    send dx, r7")
    program.emit("    li r5, 0")
    program.emit("    li r6, 32")
    program.label("round_loop")
    program.emit("    bge r5, r6, round_done")
    emit_decrypt_mix(program)
    program.emit("    addi r5, r5, 1")
    program.emit("    jmp round_loop")
    program.label("round_done")
    program.emit("    recv r1, bx")
    program.emit("    recv r2, cx")
    program.emit("    stw r1, +0(r0)")
    program.emit("    stw r2, +4(r0)")
    program.emit("    addi r0, r0, 8")
    program.emit("    addi r4, r4, 1")
    program.emit("    jmp block_loop")
    emit_common_footer(program, "tea_decrypt_file")
    return program.render()


def assemble(asm_name: str, hex_name: str) -> None:
    subprocess.run(
        [sys.executable, str(ASM_PARSER), str(TEA_DIR / asm_name), str(TEA_DIR / hex_name)],
        cwd=ROOT,
        check=True,
    )


def main() -> None:
    (TEA_DIR / "tea_encrypt.asm").write_text(build_encrypt(), encoding="utf-8")
    assemble("tea_encrypt.asm", "tea_encrypt.hex")
    (TEA_DIR / "tea_decrypt.asm").write_text(build_decrypt(), encoding="utf-8")
    assemble("tea_decrypt.asm", "tea_decrypt.hex")


if __name__ == "__main__":
    main()
