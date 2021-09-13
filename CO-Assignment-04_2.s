.text
	formatstr: .asciz "%c"
	output: .asciz "\033[38;5;%ld;48;5;%ldm%c\033[0m"
	soutput: .asciz "\033[6m%c\033[0m"
	# \033[0m

.data
	character: .quad 0x0000000000000000
	amount:	.quad 0x0000000000000000
	position: .quad 0x0000000000000000
    bgcolor: .quad 0x0000000000000000
    fgcolor: .quad 0x0000000000000000

.include "final.s"

.global main

# ************************************************************
# Subroutine: decode                                         *
# Description: decodes message as defined in Assignment 3    *
#   - 2 byte unknown                                         *
#   - 4 byte index                                           *
#   - 1 byte amount                                          *
#   - 1 byte character                                       *
# Parameters:                                                *
#   first: the address of the message to read                *
#   return: no return value                                  *
# ************************************************************
decode:
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	# your code goes here
start:
	# movq $0, %rcx
	movq (%rdi), %rcx
	movb %cl, character		# move char to memory
	shr $8, %rcx			# bit shift to point to the amount
	movb %cl, amount		# get the amount
	shr $8, %rcx			# bit shift to get next memory block index
	movl %ecx, position		# get next memory block index
    shr $32, %rcx           # bit shift to the foreground color bit
    movb %cl, fgcolor       # get the foreground color bit
    shr $8, %rcx            # bit shift to the background color bit
    movb %cl, bgcolor       # get the background color bit

ploop:						# printing loop

	cmpq $0, amount			# check how many times need to be printed
	jle next				# jump to 'next' section to get next memory block position
	movq bgcolor, %rdx		# move background color for compare??????
	cmpq %rdx, fgcolor	# compare foreground and background color
	je addeffect			# if colors are equal, jump to add special effects
	jmp noeffect			# jump to no effect printing section

addeffect:
	movq character, %rsi
	movq $soutput, %rdi
	jmp callprint			# jump to skip no effect printing section

noeffect:
	movq character, %rcx	# character to print
	movq bgcolor, %rdx		# pass background color
	movq fgcolor, %rsi		# pass foreground color
    movq $output, %rdi	    # pass the format string
callprint:
	movq $0, %rax			# no vector registers. (for printf)
    call printf
	decq amount				# decrease the amount
	jmp ploop				# jump to printing loop
next:
	cmpq $0, position		# check if is is the last position
	je end

	# movq $0, %rcx
	movq position, %rcx
	leaq MESSAGE(, %rcx, 8), %rdi	# get next address

	jmp start



end:
	# epilogue
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%rbp			# restore base pointer location
	ret

main:
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	movq	$MESSAGE, %rdi	# first parameter: address of the message
	call	decode			# call decode

	popq	%rbp			# restore base pointer location
	movq	$0, %rdi		# load program exit code
	call	exit			# exit the program
