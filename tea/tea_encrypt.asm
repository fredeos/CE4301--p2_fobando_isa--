; TEA encrypt completo in-place.
; Archivo: 103 bytes, 13 bloques de 64 bits.
; Padding TEA: 1 bytes.
; Entrada/salida: data_mem desde address 0x654.
; Llave TEA: vault[0..3].

__init__:
    li sp, 512
    li r0, 1620          ; byte address base en data_mem
    li r3, 0          ; bloque actual
    li r4, 13          ; total de bloques

    login 0xA9C1F

block_loop:
    bge r3, r4, 652

    ldw r1, +0(r0)
    ldw r2, +4(r0)
    send bx, r1        ; v0
    send cx, r2        ; v1
    pmovi dx, 0        ; sum

    ; encrypt round 1
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 2
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 3
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 4
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 5
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 6
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 7
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 8
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 9
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 10
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 11
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 12
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 13
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 14
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 15
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 16
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 17
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 18
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 19
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 20
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 21
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 22
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 23
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 24
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 25
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 26
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 27
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 28
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 29
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 30
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 31
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    ; encrypt round 32
    send ex, delta
    padd dx, dx, ex
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    padd bx, bx, gx
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    padd cx, cx, gx

    recv r1, bx
    recv r2, cx
    stw r1, +0(r0)
    stw r2, +4(r0)
    addi r0, r0, 8
    addi r3, r3, 1
    jmp -653

done:
    quit

__halt__:
    jmp -1
