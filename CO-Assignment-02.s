
.text
    output: .asciz "So the result is %ld.\n"
    inputbase: .asciz "Please give me a non-negative base nunber:\n"
    inputxponent: .asciz "Please give me a non-negative exponent:\n"
    formatstr: .asciz "%ld"


inout:
    pushq %rbp  # prologue
    movq %rsp, %rbp

    # base number input prompt
    movq $0, %rax
    movq $inputbase, %rdi
    call printf

    # base number input
    subq $16, %rsp  # make space for one variable
    movq $0, %rax
    leaq -16(%rbp), %rsi # base # it is 16 because we pushed rbp in the beginning of main??
    movq $formatstr, %rdi
    call scanf

    # calculate factorial
    pushq -16(%rbp)   # pass base variable
    call factorial

    # print result
    movq %rax, %rsi # put the result from %rax to %rsi for printing
    movq $output, %rdi  # the format string
    movq $0, %rax   # no vector registers
    call printf

    # epilogue
    movq %rbp, %rsp
    popq %rbp
    ret

factorial:
    # probably not necessary #prologue
    push %rbp
    movq %rsp, %rbp

    movq 16(%rbp), %rax   # the current number
    cmpq $1, %rax
    je endfac

    decq %rax   # decrease the nunber
    pushq %rax  # push the decreased value to the stack to pass the value to inner subroutine
    call factorial
    addq $8, %rsp   # clear the pushed decreased value
    imulq 16(%rbp), %rax    # current number multiply all the other factorial sum




endfac:
    # epilogue, exit the loop
    movq %rbp , %rsp
    popq %rbp
    ret


.global main
main:
    pushq %rbp  # prologue
    movq %rsp, %rbp

    call inout # call the inout function to get input and calculate the exponent.

    # epilogue, stop the program
    movq %rbp, %rsp
    popq %rbp

    movq $0, %rdi
    call exit


