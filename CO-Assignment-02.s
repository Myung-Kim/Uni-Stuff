# ************************************************************
# Program: factorial                                         *
# Description: calculate factorial according to the user     *
#              input                                         *
# ************************************************************

.text
    output: .asciz "So the result is %ld.\n"
    inputbase: .asciz "Please give me a nunber:\n"
    formatstr: .asciz "%ld"
    hellostring: .asciz "names: Mingyi Jin, Yanzhi Chen NedIDs: mingyijin, tomchen\n"


# ************************************************************
# Subroutine: factorial                                      *
# Description: calculate factorial                           *
#                                                            *
# Parameters:                                                *
#   first: input number                                      *
#   return: returns the result                               *
# ************************************************************
factorial:
    # probably not necessary #prologue
    push %rbp
    movq %rsp, %rbp

    movq 16(%rbp), %rax         # get the value from this stack position
    cmpq $1, %rax
    jle endfac                  # end this line if rax is equal or less than 1

    decq %rax                   # decrement the nunber
    pushq %rax                  # push the dcremented value to the stack to pass the value to recursive subroutine
    call factorial
    addq $8, %rsp               # clear the pushed decremented value
    imulq 16(%rbp), %rax        # current number multiply all the other factorial sum


endfac:
    # epilogue
    movq %rbp , %rsp
    popq %rbp
    ret



.global main
main:
    pushq %rbp                          # prologue
    movq %rsp, %rbp

    movq $0, %rax                       # no vector registers for printf
    movq $hellostring, %rdi             # print hello string
    call printf

    # base number input prompt
    movq $0, %rax                        # no vector registers for printf
    movq $inputbase, %rdi                # print input prompt
    call printf

    # base number input
    subq $16, %rsp                       # make space for one variable
    movq $0, %rax                        # no vector registers
    leaq -16(%rbp), %rsi                 # pass the address where the input should be stored
    movq $formatstr, %rdi
    call scanf

    # calculate factorial
    pushq -16(%rbp)                     # pass variable to subroutine
    call factorial

    # print result
    movq %rax, %rsi                     # put the result from %rax to %rsi for printing
    movq $output, %rdi                  # the format string
    movq $0, %rax                       # no vector registers
    call printf

    # epilogue
    movq %rbp, %rsp
    popq %rbp

    movq $0, %rdi
    call exit


