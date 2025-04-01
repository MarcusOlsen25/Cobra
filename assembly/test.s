.data

form:
        .string	"%d\n"

# Paste after this line

.text
.globl main
main:
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $16, %rsp                  # Allocate space for local variables on the stack
        movq $2, %rax                   # Put a number in %rax
        movq %rax, -8(%rbp)             # Move initialized value into space on stack
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq -8(%rax), %rax             # Assign value to %rax

        leaq form(%rip), %rdi	# Passing string address (1. argument)
	movq %rax, %rsi		# Passing %rax (2. argument)
        movq $0, %rax           # No floating point registers used
        testq $15, %rsp         # Test for 16 byte alignment
        jz sba1                 # Jump if aligned
        addq $-8, %rsp          # 16 byte aligning
        callq printf@plt        # Call printf
        addq $8, %rsp           # Reverting alignment
        jmp endsba1
sba1:
        callq printf@plt        # Call printf
endsba1:

        movq $0, %rax                   # Put a number in %rax
        movq %rax, -16(%rbp)            # Move initialized value into space on stack
        movq $4, %rax                   # Put a number in %rax
        movq %rax, %rdx
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq %rdx, -8(%rax)
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq -8(%rax), %rax             # Assign value to %rax
        addq $16, %rsp                  # Deallocate global variables

# Paste before this line

        leaq form(%rip), %rdi	# Passing string address (1. argument)
	movq %rax, %rsi		# Passing %rax (2. argument)
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

	popq %rbp		# Callee epilogue
        movq $0, %rax           # Return "no error" exit code
	ret		        # Return from call
