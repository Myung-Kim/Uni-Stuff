

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
    movq $0, %rax
    subq $16, %rsp  # make space for two variables
    leaq -8(%rbp), %rsi # base
    movq $formatstr, %rdi
    call scanf
    # exponent number input prompt
    movq $0, %rax   # base number input prompt
    mov $inputxponent, %rdi
    call printf
    # exponent number input
    movq $0, %rax
    leaq -16(%rbp), %rsi
    movq $formatstr, %rdi
    call scanf

    # calculate power
    movq -16(%rbp), %rsi   # pass exponent variable
    movq -8(%rbp), %rdi   # pass base variable
    call pow


    # print result
    movq %rax, %rsi # put the result from %rax to %rsi for printing
    movq $output, %rdi  # the format string
    movq $0, %rax   # no vector registers
    call printf

    # epilogue
    movq %rbp, %rsp
    popq %rbp
    ret


pow:
    # probably not necessary #prologue
    push %rbp
    movq %rsp, %rbp

    movq $1, %rax   # the sum

powerloop:
    cmpq $0, %rsi   # compare exponent to 1
    jle end
    imulq %rdi, %rax # calculate power
    decq %rsi   # derement exponent
    jmp powerloop

end:
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



