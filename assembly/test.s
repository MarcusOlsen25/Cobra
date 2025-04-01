.data

form:
        .string	"%d\n"

# Paste after this line

.text
.globl main
main:
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $8, %rsp                   # Allocate space for local variables on the stack
        movq $2, %rax                   # Put a number in %rax
        movq %rax, -8(%rbp)             # Move initialized value into space on stack
        movq %rbp, %rax                 # Prepare static link
        pushq %rax                      # Push static link
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $0, %rsp                   # Allocate space for local variables on the stack
        movq $3, %rax                   # Put a number in %rax
        cmp $0, %rax                    # Check the condition
        je end_if_0                     # Skip if the condition is false
        movq %rbp, %rax
        movq 8(%rax), %rax
        movq -8(%rax), %rax             # Assign value to %rax
        end_if_0:
        addq $8, %rsp                   # Deallocate space on stack for static link
        addq $0, %rsp                   # Deallocate space for local variables on the stack
        popq %rbp                       # Restore base pointer
        addq $8, %rsp                   # Deallocate global variables

# Paste before this line



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

	popq %rbp			# Callee epilogue
        movq $0, %rax           # Return "no error" exit code
	ret		# Return from call
