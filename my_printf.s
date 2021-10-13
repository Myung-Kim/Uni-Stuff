.data
BUFFER: .skip 256

.text
formatstr:
    .asciz "My name is %d. I think % I’ll get a %u for my exam. %s What does %r do? And %%? And finally some random number %d, %d, %d, %d. \n"

nonsense:
    .asciz "<inserted string>"


.global main


my_printf:
    pushq	%rbp
	movq	%rsp, %rbp          # prologue

    pushq  24(%rbp)             # push the last two arguments to stack
    pushq  16(%rbp)
    # pushq   %r9               # these registers are not changed
    # pushq   %r8
    # pushq   %rcx
    # pushq   %rdx
    # pushq   %rsi
    # pushq   %rdi



    # returns buffer string length
    call str_parse
    pushq %rax              # save buffer string length

    movq $1 , %rax          # system call 1 is syswrite
    movq $1 , %rdi          # first argument i s where to write; stdout is 1
    movq $BUFFER , %rsi     # next argument: what to write (address)
    popq    %rdx               # last argument: how many bytes to write
    syscall

    movq	%rbp, %rsp		# epiligue
	popq	%rbp
	ret

str_parse:
    pushq	%rbp
	movq	%rsp, %rbp          # prologue

    pushq   24(%rbp)
    pushq   16(%rbp)
    pushq   %r9                 # no need for parse? because pushed in parent
    pushq   %r8
    pushq   %rcx
    pushq   %rdx
    pushq   %rsi                # push arguments
    # pushq   %rdi                # push address to stack for later use

    movq $0, %rdx               # set initial indiex (source)
    movq $0, %rsi               # set initial buffer index (target)
parse_loop:
    cmpb $0, (%rdi, %rdx, 1)    # check if strig end
    je parse_end
    cmpb $37, (%rdi, %rdx, 1)   # check if current is % sign '%' == 37
    je parse_percent

    movb (%rdi, %rdx, 1), %cl   # store to buffer if current is not %(37)
    movb %cl, BUFFER(, %rsi, 1) # ... above
    incq %rdx
    incq %rsi
    jmp parse_loop

parse_percent:
    incq %rdx                       # increment string index to check place-holder type
    # incq %rdx                     # inc two
    cmpb $117, (%rdi, %rdx, 1)      # if unsigned. 'u' == 117
    je  parse_unsigned
    cmpb $100, (%rdi, %rdx, 1)      # if signed. 'd' == 100
    je parse_signed                 # ignore for now
    cmpb $115, (%rdi, %rdx, 1)      # if string. 's' == 115
    je parse_string                 # ignore for now
    cmpb $37, (%rdi, %rdx, 1)       # if double %. '%' == 37
    je parse_db_pct
    jmp parse_unkown
    # incq %rdx                       # if not above character, string index ++1
    # jmp parse_loop                  # jump to next parsing loop
parse_end:
    movb $0, BUFFER(, %rsi, 1)  # add termination character at the end of the string buffer
    incq %rsi                   # the first is 0, so length need to plus 1
    movq %rsi, %rax             # return buffer string length

    movq %rbp, %rsp		        # epiligue
	popq %rbp
	ret

# parse unsigned
parse_unsigned:
    movq %rdx, %r8              # transfer string index to r8 (to reserver)
    movq $0, %r9                # result digit count
    popq    %rax                # get printf arguments (lower bits)

parse_us_loop:
    movq $0, %rdx               # prepare for division (upper bits)

    movq $10, %rcx              # move 10 to rcx for division
    divq %rcx                   # quotient(can loop back) -> %rax, remainder -> %rdx
    addq $48, %rdx              # add 48 to convert to ascii
    pushq %rdx                  # push remainder to stack for reversing
    incq %r9                    # result digit ++1

    cmpq $10, %rax
    jge parse_us_loop           # jump back if great or equal than 10.

    cmpq $0, %rax               # jump the unisgned input is only 1 digit
    je  parse_us_write
    # fall through to us_write, if not 1 digit number
    addq $48, %rax              # ascii shift for first digit
    pushq %rax                  # push the first digit(from last division calculation)
    incq %r9
parse_us_write:

    popq %rcx                   # pop digit number to %rcx
    movb %cl, BUFFER(, %rsi, 1) # move popped digit to string buffer
    incq %rsi                   # string buffer index ++1
    decq %r9                    # result digit count --1
    cmpq $0, %r9                # if digit count != 0, loop back
    jne parse_us_write

    movq %r8, %rdx              # restore string index from %r8
    incq    %rdx                # string index ++1
    jmp parse_loop



# parse signed integer
parse_signed:
    movq %rdx, %r8              # transfer string index to r8 (to reserve)
    movq $0, %r9                # result digit count
    popq    %rax                # get printf arguments

    cmpq $0, %rax               # check if negative integer
    jge parse_us_loop           # jump to unsigned parse

    negq %rax                   # negate if negative integer
    movb $45, BUFFER(, %rsi, 1)
    incq %rsi

    jmp parse_us_loop           # jump to unsigned parse. smart move :)



# parse string
parse_string:
    movq %rdx, %r8              # transfer string index to r8 (no use this time)
    movq $0, %r9                # short string index (this time)
    popq    %rax                # get printf arguments (short string address this time)

parse_str_loop:
    cmpb $0, (%rax, %r9, 1)     # check if short string is null
    je parse_str_end

    movb (%rax, %r9, 1), %cl
    movb %cl, BUFFER(, %rsi, 1)
    incq %r9                    # short string index ++1
    incq %rsi                   # string buffer index ++1
    jmp parse_str_loop

parse_str_end:
    movq %r8, %rdx              # restore string index to %rdx (no use this time)
    incq %rdx                   # original string index ++1
    jmp parse_loop


# parse double percent sign
parse_db_pct:
    movb $37, BUFFER(, %rsi, 1)
    incq %rsi                   # string buffer index ++1
    incq %rdx                   # string index ++1
    jmp parse_loop



# deal with unkown place holders
parse_unkown:
    movb $37, BUFFER(, %rsi, 1) # add a '%' sign
    incq %rsi                   # string buffer index ++1
    movb (%rdi, %rdx, 1), %cl   # get the byte after '%'
    movb %cl, BUFFER(, %rsi, 1) # add this byte after '%'
    incq %rsi                   # string buffer index ++1
    incq %rdx                   # string index ++1
    jmp parse_loop

get_len:
    pushq %rbp 			# prologue
	movq %rsp, %rbp

    movq $0, %rsi               # counts
    movq $0, %rdx               # position index

len_loop:
    cmpb $0, (%rdi, %rdx, 1)      # rdi is string address.
    # cmpb $0, %cl                # check if string end. terminiation character is 0 in ascii.
    je len_loop_end
    incq    %rsi                # count increments (length)
    incq    %rdx                # position index +1
    jmp len_loop

len_loop_end:
    incq %rsi                   # increment 1 for termination character (null 0)
    movq %rsi, %rax
    movq %rbp, %rsp		        # epiligue
	popq %rbp
	ret

main:
	pushq   %rbp 			    # push the base pointer (and align the stack)
	movq    %rsp, %rbp		    # copy stack pointer value to base pointer

    pushq   $-32
    pushq   $-32
    movq    $-21, %r9
    movq    $318, %r8
    movq    $nonsense, %rcx     # pass a short string address
    movq    $5678, %rdx         # pass a signed integer
    movq    $-2345, %rsi        # pass a unsigned integer
    movq    $formatstr, %rdi    # pass the address of to be printed
    call    my_printf

	movq    $0, %rdi		    # load program exit code
	call    exit			    # exit the program

