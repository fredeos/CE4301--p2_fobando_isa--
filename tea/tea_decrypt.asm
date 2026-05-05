; Codigo ensamblador generado para TEA compacto
; data_mem[0] = base byte address, data_mem[4] = block_count
__init__:
    li sp, 512
    call 61
__halt__:
    jmp -1
tea_decrypt_file:
    addi sp, sp, 4
    stw ra, +0(sp)
    login 0xA9C1F
    beqz lr, 52
    li r0, 0
    ldw r0, +0(r0)    ; base byte address
    li r3, 4
    ldw r3, +0(r3)    ; total blocks
    li r4, 0          ; current block
    pmovi dx, 0
    li r5, 0
    li r6, 32
sum_loop:
    bge r5, r6, 4
    send ex, delta
    padd dx, dx, ex
    addi r5, r5, 1
    jmp -5
sum_done:
    recv r7, dx
block_loop:
    bge r4, r3, 37
    ldw r1, +0(r0)
    ldw r2, +4(r0)
    send bx, r1
    send cx, r2
    send dx, r7
    li r5, 0
    li r6, 32
round_loop:
    bge r5, r6, 22
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
    addi r5, r5, 1
    jmp -23
round_done:
    recv r1, bx
    recv r2, cx
    stw r1, +0(r0)
    stw r2, +4(r0)
    addi r0, r0, 8
    addi r4, r4, 1
    jmp -38
tea_decrypt_file_secure_exit:
    quit
    ldw ra, +0(sp)
    addi sp, sp, -4
    ret
main:
    addi sp, sp, 4
    stw ra, +0(sp)
    call -63
    ldw ra, +0(sp)
    addi sp, sp, -4
    ret
