.text
    output: .asciz "So the result is %ld.\n"
    inputbase: .asciz "Please give me a nunber:\n"
    formatstr: .asciz "%ld"
    MESSAGE: .asciz "CCCCCCCCSSSSEE1111444400000000The answer for exam question 42 is not F.CCCCCCCCSSSSEE1111444400000000"

.data
    # buffer: .skip 3126

    RLE: .asciz "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
# .bss
#    .lcomm buffer, 3126

# .include "file.s"

.global main

main:
    pushq %rbp                          # prologue
    movq %rsp, %rbp

    # # calculate factorial
    # movq -16(%rbp), %rdi                     # pass variable to subroutine using rdi
    call compe

    # print result
    movq %rax, %rsi                         # put the result from %rax to %rsi for printing
    movq $output, %rdi                      # the format string
    movq $0, %rax                           # no vector registers
    call printf

    # epilogue
    movq %rbp, %rsp
    popq %rbp

    movq $0, %rdi
    call exit


compe:
    pushq %rbp                      # prologue
    movq %rsp, %rbp

    movq $0, %r12                   # index for message
    movq $0, %r13                   # index for RLE
comp_start:

    movb MESSAGE(, %r12, 1), %dil

    cmpq $0, %r12
    jne rle_inc                     # jump if not first time

    movb %dil, %r14b                 # initialize
    movb %dil, RLE(,%r13, 1)
    incq %r13                       # increment RLE index
    movb $1, RLE(, %r13, 1)         # set initial count 1
rle_inc:

    cmpb %r14b, %dil
    jne rle_not
    addb $1, RLE(,%r13, 1)          # character count plus 1
    jmp rle_next

rle_not:                             # if differrent character
    incq %r13                       # increment RLE index to char digit
    movb RLE(,%r13, 1), %dil        # write new character
    incq %r13                       # increment RLE index to count digit
    movb $1, RLE(, %r13, 1)         # set initial count 1
rle_next:
    incq %r12                       # increment message index
    cmpq $20, %r12                   # set a limit
    jne comp_start

    # epilogue
    movq %rbp, %rsp
    popq %rbp
    ret







