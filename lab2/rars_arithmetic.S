#RARS Activity A: registers, signed comparison, and two BEQ outcomes.
.text
.globl main
main:
    addi x1, x0, 5 # x1 = 5; x0 always reads zero
    addi x2, x0, 7 # x2 = 7
    add x3, x1, x2 # x3 = 12
    sub x4, x3, x1 # x4 = 7
    slt x5, x1, x2 # x5 = 1 because 5 < 7 (signed)
    andi x6, x3, 10 # x6 = 8 because 12 & 10 = 8
    ori x7, x1, 8 # x7 = 13 because 5 | 8 = 13
    beq x3, x4, wrong # NOT taken: 12 != 7
    addi x8, x0, 1 # x8 = 1
    beq x3, x3, done # TAKEN: skips the wrong-path write
wrong:
    addi x9, x0, 99 # Must NOT run; x9 remains zero
done:
    addi x10, x0, 42 # Success marker
    addi a7, x0, 10 # RARS service 10 = exit (not part of RV32I CPU lab)
    ecall # Stop cleanly in RARS