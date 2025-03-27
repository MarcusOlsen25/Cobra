.data

form:
        .string	"%d\n"

# Paste after this line

.text
red:
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $8, %rsp                   # Allocate space for local variables on the stack
        movq $0, %rax                   # Put a number in %rax
        movq %rax, -8(%rbp)             # Move initialized value into space on stack
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $8, %rsp                   # Allocate space for local variables on the stack
        while_loop_0:
        movq 16(%rbp), %rax             # Assign an argument to %rax
        cmp $0, %rax                    # Check the condition
        je end_while_0                  # Skip if the condition is false
        movq 24(%rbp), %rax             # Assign an argument to %rax
        pushq %rax                      # Push right side to stack
        movq 16(%rbp), %rax             # Assign an argument to %rax
        popq %rbx                       # Pop right side into %rbx
        addq %rbx, %rax                 # Add both sides
        movq %rax, -8(%rbp)             # Move initialized value into space on stack
        movq 24(%rbp), %rax             # Assign an argument to %rax
        pushq %rax                      # Push right side to stack
        movq 16(%rbp), %rax             # Assign an argument to %rax
        popq %rbx                       # Pop right side into %rbx
        subq %rbx, %rax                 # Subtract both sides
        movq %rax, 16(%rbp)
        movq 8(%rbp), %rax              # Assign an argument to %rax
        movq %rax, 8(%rbp)
        jmp while_loop_0                # Restart the loop
        end_while_0:
        addq $8, %rsp                   # Deallocate space for local variables on the stack
        popq %rbp                       # Restore base pointer
        ret                             # Return from the function or scope
        movq 8(%rbp), %rax              # Assign an argument to %rax
        movq %rax, 8(%rbp)
        addq $8, %rsp                   # Deallocate space for local variables on the stack
        popq %rbp                       # Restore base pointer
        ret                             # Return from the function or scope
.globl main
main:
pushq %rbp                      # Save base pointer
movq %rsp, %rbp                 # Make stack pointer new base pointer
movq $5, %rax                   # Put a number in %rax
pushq %rax                      # Push argument number 2 to stack
movq $20, %rax                  # Put a number in %rax
pushq %rax                      # Push argument number 1 to stack
call red                        # Call the red function 
addq $16, %rsp                  # Pop the arguments pushed to the stack
addq $0, %rsp

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
