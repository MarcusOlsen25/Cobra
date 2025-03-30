.data

form:
        .string	"%d\n"

# Paste after this line

.text
one:
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $0, %rsp                   # Allocate space for local variables on the stack
        movq %rbp, %rax                 # Prepare static link
        pushq %rax                      # Push static link
        call two                        # Call the two function 
        addq $8, %rsp                   # Deallocate space on stack for static link
        addq $0, %rsp                   # Pop the arguments pushed to the stack
        addq $0, %rsp                   # Deallocate space for local variables on the stack
        popq %rbp                       # Restore base pointer
        ret                             # Return from the function
five:
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $0, %rsp                   # Allocate space for local variables on the stack
        movq %rbp, %rax
        movq 16(%rax), %rax
        movq 16(%rax), %rax
        movq -8(%rax), %rax             # Assign value to %rax
        addq $0, %rsp                   # Deallocate space for local variables on the stack
        popq %rbp                       # Restore base pointer
        ret                             # Return from the function
two:
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $0, %rsp                   # Allocate space for local variables on the stack
        movq $3, %rax                   # Put a number in %rax
        movq %rax, %rdx
        movq %rbp, %rax
        movq 16(%rax), %rax
        movq 16(%rax), %rax
        movq %rdx, -8(%rax)
        movq %rbp, %rax                 # Prepare static link
        pushq %rax                      # Push static link
        call three                      # Call the three function 
        addq $8, %rsp                   # Deallocate space on stack for static link
        addq $0, %rsp                   # Pop the arguments pushed to the stack
        addq $0, %rsp                   # Deallocate space for local variables on the stack
        popq %rbp                       # Restore base pointer
        ret                             # Return from the function
six:
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $0, %rsp                   # Allocate space for local variables on the stack
        movq %rbp, %rax                 # Prepare static link
        movq 16(%rax), %rax                     # Traverse static link once
        movq 16(%rax), %rax                     # Traverse static link once
        pushq %rax                      # Push static link
        call five                       # Call the five function 
        addq $8, %rsp                   # Deallocate space on stack for static link
        addq $0, %rsp                   # Pop the arguments pushed to the stack
        addq $0, %rsp                   # Deallocate space for local variables on the stack
        popq %rbp                       # Restore base pointer
        ret                             # Return from the function
three:
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $0, %rsp                   # Allocate space for local variables on the stack
        movq %rbp, %rax                 # Prepare static link
        pushq %rax                      # Push static link
        call four                       # Call the four function 
        addq $8, %rsp                   # Deallocate space on stack for static link
        addq $0, %rsp                   # Pop the arguments pushed to the stack
        movq %rbp, %rax                 # Prepare static link
        movq 16(%rax), %rax                     # Traverse static link once
        pushq %rax                      # Push static link
        call six                        # Call the six function 
        addq $8, %rsp                   # Deallocate space on stack for static link
        addq $0, %rsp                   # Pop the arguments pushed to the stack
        addq $0, %rsp                   # Deallocate space for local variables on the stack
        popq %rbp                       # Restore base pointer
        ret                             # Return from the function
four:
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $0, %rsp                   # Allocate space for local variables on the stack
        movq %rbp, %rax                 # Prepare static link
        movq 16(%rax), %rax                     # Traverse static link once
        movq 16(%rax), %rax                     # Traverse static link once
        pushq %rax                      # Push static link
        call six                        # Call the six function 
        addq $8, %rsp                   # Deallocate space on stack for static link
        addq $0, %rsp                   # Pop the arguments pushed to the stack
        addq $0, %rsp                   # Deallocate space for local variables on the stack
        popq %rbp                       # Restore base pointer
        ret                             # Return from the function
.globl main
main:
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $8, %rsp                   # Allocate space for local variables on the stack
        movq $4, %rax                   # Put a number in %rax
        movq %rax, -8(%rbp)             # Move initialized value into space on stack
        movq %rbp, %rax                 # Prepare static link
        pushq %rax                      # Push static link
        call one                        # Call the one function 
        addq $8, %rsp                   # Deallocate space on stack for static link
        addq $0, %rsp                   # Pop the arguments pushed to the stack
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
