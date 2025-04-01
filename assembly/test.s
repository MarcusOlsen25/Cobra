.data

form:
        .string	"%d\n"

# Paste after this line

.text
one:
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $8, %rsp                   # Allocate space for local variables on the stack
        movq $2, %rax                   # Put a number in %rax
        movq %rax, -8(%rbp)             # Move initialized value into space on stack
        movq %rbp, %rax                 # Prepare static link
        pushq %rax                      # Push static link
        call three                      # Call the three function 
        addq $8, %rsp                   # Deallocate space on stack for static link
        addq $0, %rsp                   # Pop the arguments pushed to the stack
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq 16(%rax), %rax                     # Traverse static link once
        movq -16(%rax), %rax            # Assign value to %rax
                                # Start print statement
        leaq form(%rip), %rdi                   # Passing string address (1. argument)
        movq %rax, %rsi                 # Passing %rax (2. argument)
        movq $0, %rax                   # No floating point registers used
        testq $15, %rsp                 # Test for 16 byte alignment
        jz print_align_3                        # Jump if aligned
        addq $-8, %rsp                  # 16 byte aligning
        callq printf@plt                        # Call printf
        addq $8, %rsp                   # Reverting alignment
        jmp end_print_3
        print_align_3:
        callq printf@plt                        # Call printf
        end_print_3:
                                # End print statement
        addq $8, %rsp                   # Deallocate space for variables on the stack
        popq %rbp                       # Restore base pointer
        ret                             # Return from the function
two:
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $0, %rsp                   # Allocate space for local variables on the stack
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq 16(%rax), %rax                     # Traverse static link once
        movq 16(%rax), %rax                     # Traverse static link once
        movq -8(%rax), %rax             # Assign value to %rax
                                # Start print statement
        leaq form(%rip), %rdi                   # Passing string address (1. argument)
        movq %rax, %rsi                 # Passing %rax (2. argument)
        movq $0, %rax                   # No floating point registers used
        testq $15, %rsp                 # Test for 16 byte alignment
        jz print_align_1                        # Jump if aligned
        addq $-8, %rsp                  # 16 byte aligning
        callq printf@plt                        # Call printf
        addq $8, %rsp                   # Reverting alignment
        jmp end_print_1
        print_align_1:
        callq printf@plt                        # Call printf
        end_print_1:
                                # End print statement
        addq $0, %rsp                   # Deallocate space for variables on the stack
        popq %rbp                       # Restore base pointer
        ret                             # Return from the function
three:
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $8, %rsp                   # Allocate space for local variables on the stack
        movq $3, %rax                   # Put a number in %rax
        movq %rax, -8(%rbp)             # Move initialized value into space on stack
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq -8(%rax), %rax             # Assign value to %rax
                                # Start print statement
        leaq form(%rip), %rdi                   # Passing string address (1. argument)
        movq %rax, %rsi                 # Passing %rax (2. argument)
        movq $0, %rax                   # No floating point registers used
        testq $15, %rsp                 # Test for 16 byte alignment
        jz print_align_2                        # Jump if aligned
        addq $-8, %rsp                  # 16 byte aligning
        callq printf@plt                        # Call printf
        addq $8, %rsp                   # Reverting alignment
        jmp end_print_2
        print_align_2:
        callq printf@plt                        # Call printf
        end_print_2:
                                # End print statement
        movq %rbp, %rax                 # Prepare static link
        movq 16(%rax), %rax                     # Traverse static link once
        pushq %rax                      # Push static link
        call two                        # Call the two function 
        addq $8, %rsp                   # Deallocate space on stack for static link
        addq $0, %rsp                   # Pop the arguments pushed to the stack
        addq $8, %rsp                   # Deallocate space for variables on the stack
        popq %rbp                       # Restore base pointer
        ret                             # Return from the function
.globl main
main:
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $16, %rsp                  # Allocate space for local variables on the stack
        movq $4, %rax                   # Put a number in %rax
        movq %rax, -8(%rbp)             # Move initialized value into space on stack
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq -8(%rax), %rax             # Assign value to %rax
                                # Start print statement
        leaq form(%rip), %rdi                   # Passing string address (1. argument)
        movq %rax, %rsi                 # Passing %rax (2. argument)
        movq $0, %rax                   # No floating point registers used
        testq $15, %rsp                 # Test for 16 byte alignment
        jz print_align_0                        # Jump if aligned
        addq $-8, %rsp                  # 16 byte aligning
        callq printf@plt                        # Call printf
        addq $8, %rsp                   # Reverting alignment
        jmp end_print_0
        print_align_0:
        callq printf@plt                        # Call printf
        end_print_0:
                                # End print statement
        movq $87, %rax                  # Put a number in %rax
        movq %rax, -16(%rbp)            # Move initialized value into space on stack
        movq %rbp, %rax                 # Prepare static link
        pushq %rax                      # Push static link
        call one                        # Call the one function 
        addq $8, %rsp                   # Deallocate space on stack for static link
        addq $0, %rsp                   # Pop the arguments pushed to the stack
        addq $16, %rsp                  # Deallocate space for variables on the stack
        popq %rbp                       # Restore base pointer
        movq $0, %rax                   # End with error code 0
        ret                     # Return from main
