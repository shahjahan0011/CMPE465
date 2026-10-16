#Part 2B: regression test covering each supported instruction.
.section .text
.globl _start
_start:
    addi x1, x0, 5 # x1 = 5
    addi x2, x0, -3 # x2 = -3, sign extension
    add x3, x1, x2 # x3 = 2
    sub x4, x1, x2 # x4 = 8
    and x5, x1, x2 # x5 = 5
    andi x6, x2, 6 # x6 = 4
    or x7, x1, x2 # x7 = -3 (all high bits are 1)
    ori x8, x1, 8 # x8 = 13
    slt x9, x2, x1 # x9 = 1 (signed)
    slti x10, x2, 0 # x10 = 1
    sw x4, 0(x0) # memory[0] = 8
    lw x11, 0(x0) # x11 = 8
    beq x11, x4, equal # Taken: skip x12=99
    addi x12, x0, 99
    beq x0, x0, finish # This must NOT run
equal:
    addi x12, x0, 42
    beq x1, x2, finish # Not taken: 5 != -3
    addi x13, x0, 7
finish:
    addi x14, x0, 0 # Explicitly test the zero result
stop:
    beq x0, x0, stop