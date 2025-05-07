.data
heap:
        .space 1000
heap_pointer:
        .quad heap
form:
        .string "%d\n"
.text
three:                  # Function
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $0, %rsp                   # Allocate space for local variables on the stack
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq 24(%rax), %rax             # Traverse static link once
        movq 24(%rax), %rax             # Traverse static link once
        movq -8(%rax), %rax             # Move value into %rax
                                # Start print statement
        leaq form(%rip), %rdi           # Passing string address (1. argument)
        movq %rax, %rsi                 # Passing %rax (2. argument)
        movq $0, %rax                   # No floating point registers used
        testq $15, %rsp                 # Test for 16 byte alignment
        jz print_align_0                # Jump if aligned
        addq $-8, %rsp                  # 16 byte aligning
        callq printf@plt                # Call printf
        addq $8, %rsp                   # Reverting alignment
        jmp end_print_0
        print_align_0:
        callq printf@plt                # Call printf
        end_print_0:
                                # End print statement
end_three:                      # End function
        addq $0, %rsp                   # Deallocate space for variables on the stack
        popq %rbp                       # Restore base pointer
        ret                             # Return from the function
one:                    # Function
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $8, %rsp                   # Allocate space for local variables on the stack
        movq $1, %rax                   # Put a number in %rax
        movq %rax, -8(%rbp)                     # Move initialized value into space on stack
        movq %rbp, %rax                 # Prepare static link
        pushq %rax                      # Push static link
        subq $8, %rsp                   # Add dummy space
        call two                        # Call the two function 
        addq $8, %rsp                   # remove dummy space
        addq $8, %rsp                   # Deallocate space on stack for static link
        addq $0, %rsp                   # Pop the arguments pushed to the stack
end_one:                        # End function
        addq $8, %rsp                   # Deallocate space for variables on the stack
        popq %rbp                       # Restore base pointer
        ret                             # Return from the function
two:                    # Function
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $0, %rsp                   # Allocate space for local variables on the stack
        movq %rbp, %rax                 # Prepare static link
        movq 24(%rax), %rax             # Traverse static link once
        movq 24(%rax), %rax             # Traverse static link once
        pushq %rax                      # Push static link
        subq $8, %rsp                   # Add dummy space
        call three                      # Call the three function 
        addq $8, %rsp                   # remove dummy space
        addq $8, %rsp                   # Deallocate space on stack for static link
        addq $0, %rsp                   # Pop the arguments pushed to the stack
end_two:                        # End function
        addq $0, %rsp                   # Deallocate space for variables on the stack
        popq %rbp                       # Restore base pointer
        ret                             # Return from the function
.globl main
main:
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $8, %rsp                   # Allocate space for local variables on the stack
        movq $2, %rax                   # Put a number in %rax
        movq %rax, -8(%rbp)                     # Move initialized value into space on stack
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq -8(%rax), %rax             # Move value into %rax
        cmp $0, %rax                    # Check the condition
        je end_0                        # Skip if the condition is false
        movq %rbp, %rax                 # Prepare static link
        pushq %rax                      # Push static link
        subq $16, %rsp                  # Add dummy space
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $0, %rsp                   # Allocate space for local variables on the stack
        movq %rbp, %rax                 # Prepare static link
        pushq %rax                      # Push static link
        subq $8, %rsp                   # Add dummy space
        call one                        # Call the one function 
        addq $8, %rsp                   # remove dummy space
        addq $8, %rsp                   # Deallocate space on stack for static link
        addq $0, %rsp                   # Pop the arguments pushed to the stack
end_then_0:                     # Clean up then block stack frame
        addq $0, %rsp                   # Deallocate space for variables on the stack
        popq %rbp                       # Restore base pointer
        addq $16, %rsp                  # Remove dummy space
        addq $8, %rsp                   # Deallocate space on stack for static link
        jmp end_0                       # Skip the else
end_0:
        addq $8, %rsp                   # Deallocate space for variables on the stack
        popq %rbp                       # Restore base pointer
        movq $0, %rax                   # End with error code 0
        ret                     # Return from main
        