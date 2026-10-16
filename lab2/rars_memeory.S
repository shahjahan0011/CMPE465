#RARS Activity B: a label and one word in the data segment.
.data
.align 2 # Align the next word to a 4-byte boundary
slot: .word 0 # Reserve and initialize a 32-bit word
.text
.globl main
main:
    la x5, slot # Assembler pseudo-instruction: address of slot
    addi x6, x0, 21 # Value to store
    sw x6, 0(x5) # Store 21 at slot
    lw x7, 0(x5) # Read 21 from slot
    addi x8, x7, 1 # x8 = 22
    addi a7, x0, 10 # RARS exit service
    ecall # Stop simulation
