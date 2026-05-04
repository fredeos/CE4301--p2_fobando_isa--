; TEA decrypt completo in-place.
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

    ; r5 guarda delta * 32 para reiniciar sum en cada bloque
    pmovi dx, 0
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    send ex, delta
    padd dx, dx, ex
    recv r5, dx

block_loop:
    bge r3, r4, 652

    ldw r1, +0(r0)
    ldw r2, +4(r0)
    send bx, r1        ; v0
    send cx, r2        ; v1
    send dx, r5        ; sum = delta * 32

    ; decrypt round 1
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 2
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 3
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 4
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 5
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 6
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 7
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 8
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 9
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 10
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 11
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 12
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 13
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 14
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 15
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 16
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 17
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 18
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 19
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 20
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 21
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 22
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 23
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 24
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 25
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 26
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 27
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 28
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 29
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 30
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 31
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

    ; decrypt round 32
    pmovi ex, 4
    ldvw fx, +8(ax)
    pslladd gx, bx, ex, fx
    padd hx, bx, dx
    pmovi ex, 5
    ldvw fx, +12(ax)
    psrladd ex, bx, ex, fx
    pxorxor gx, gx, hx, ex
    psub cx, cx, gx
    pmovi ex, 4
    ldvw fx, +0(ax)
    pslladd gx, cx, ex, fx
    padd hx, cx, dx
    pmovi ex, 5
    ldvw fx, +4(ax)
    psrladd ex, cx, ex, fx
    pxorxor gx, gx, hx, ex
    psub bx, bx, gx
    send ex, delta
    psub dx, dx, ex

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
