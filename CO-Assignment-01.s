# ************************************************************
# Program: power                                             *
# Description: calculate power of a number based on user     *
#              input                                         *
# ************************************************************


.text
    output: .asciz "So the result is %ld.\n"
    inputbase: .asciz "Please give me a non-negative base nunber:\n"
    inputxponent: .asciz "Please give me a non-negative exponent:\n"
    formatstr: .asciz "%ld"

# ************************************************************
# Subroutine: inout                                          *
# Description: get input from user and print the result      *
#               the result is the power of the input         *                                           *
#                                                            *
# Parameters:                                                *
#   first: takes no parameters                               *
#   return: no return value                                  *
# ************************************************************
inout:
    pushq %rbp  # prologue
    movq %rsp, %rbp

    # prompt for entering base number
    movq $0, %rax                   # no vector registers for printf
    movq $inputbase, %rdi           # pass the format string address to printf
    call printf

    # base number input
    movq $0, %rax                   # no vector registers for scanf
    subq $16, %rsp                  # make space for two variables
    leaq -8(%rbp), %rsi             # pass the address to store the scanned input
    movq $formatstr, %rdi           # pass the format string address to scanf
    call scanf

    # prompt for entering exponent number
    movq $0, %rax                   # no vector registers for printf
    mov $inputxponent, %rdi         # pass the format string address to printf
    call printf

    # exponent number input
    movq $0, %rax                   # no vector registers for printf
    leaq -16(%rbp), %rsi            # pass the address to store the scanned input
    movq $formatstr, %rdi           # pass the format string address to scanf
    call scanf

    # calculate power
    movq -16(%rbp), %rsi            # pass exponent variable
    movq -8(%rbp), %rdi             # pass base variable
    call pow                        # call subroutine pow to calculate power


    # print result
    movq %rax, %rsi                 # put the result from %rax to %rsi for printing
    movq $output, %rdi              # pass the format string address
    movq $0, %rax                   # no vector registers
    call printf

    # epilogue
    movq %rbp, %rsp
    popq %rbp
    ret                             # return to main


# ************************************************************
# Subroutine: pow                                            *
# Description: cal culate power                              *
#                                                            *
# Parameters:                                                *
#   first: base number                                       *
#   second: exponent number                                  *
#   return: returns the result                               *
# ************************************************************
pow:
    push %rbp                       # prologue
    movq %rsp, %rbp

    movq $1, %rax                   # the sum

powerloop:
    cmpq $0, %rsi                   # compare exponent to 1
    jle end                         # if less or equalt to 0 jump to end
    imulq %rdi, %rax                # if not calculate the power
    decq %rsi                       # derement exponent
    jmp powerloop                   # repeat the process

end:
    movq %rbp , %rsp                # epilogue, exit the loop
    popq %rbp
    ret                             # return to inout subroutine


.global main
main:
    pushq %rbp                      # prologue
    movq %rsp, %rbp

    call inout                      # call the inout function to get input from user and calculate the exponent.

    movq %rbp, %rsp                 # epilogue, before stopping the program
    popq %rbp

    movq $0, %rdi                   # pass the exit code
    call exit                       # exit this program

