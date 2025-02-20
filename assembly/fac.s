.data

form:
        .string	"%d\n"

.text

fac:
				# Callee prologue
	pushq %rbp		# Saving base pointer
	movq %rsp,%rbp		# Making stack pointer new base pointer
	
	movq 16(%rbp),%rax	# Assigning argument 1 to %rax; SL was omitted
	cmp $0,%rax		# Comparing %rax to the constant 0
	jne else		# Jump to else if not equal
	movq $1,%rax		# Assigning the result (the constant 1) to %rax
	jmp end			# Jump to end
else:
        pushq %rax              # Save argument for after the recursive calls
	addq $-1,%rax		# Adding -1 to %rax
	
				# Caller prologue
	pushq %rax		# Pushing %rax (1. argument)
	call fac		# Automatically pushes return address
				# Caller epilogue
	addq $8,%rsp		# Popping argument off stack
				# By convention, return value is now in %rax
	
	popq %rdx		# Move earlier saved original argument to %rdx
	imulq %rdx,%rax		# %rax = %rdx * %rax ~ n * fac(n-1)
end:
				# Callee epilogue
	popq %rbp		# Restoring base pointer
	ret			# Return from call

.globl main
main:				# Program starts here
				# Callee prologue
	pushq %rbp		# Saving base pointer
	movq %rsp,%rbp		# Making stack pointer new base pointer

				# Caller prologue
	pushq $5		# Pushing the constant 5 (1. argument)
        call fac		# Automatically pushes return address
                                # Caller epilogue
	addq $8,%rsp		# Popping argument off stack
				# By convention, return value is now in %rax

				# Caller prologue
 	leaq form(%rip), %rdi	# Passing string address (1. argument)
	movq %rax,%rsi		# Passing %rax (2. argument)
        movq $0, %rax           # No floating point registers used
        testq $15, %rsp         # Test for 16 byte alignment
        jz sba                  # Jump if aligned
        addq $-8, %rsp          # 16 byte aligning
        callq printf@plt        # Call printf
        addq $8, %rsp           # Reverting alignment
        jmp endsba
sba:
        callq printf@plt        # Call printf
endsba:
				# Caller epilogue (empty)

				# Callee epilogue
	popq %rbp		# Restoring base pointer
        movq $0, %rax           # Return "no error" exit code
	ret			# Return from call
