.data

form:
        .string	"%d\n"

# Paste after this line

.text
.globl main
main:
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $32, %rsp                  # Allocate space for local variables on the stack
        movq $1, %rax                   # Put a number in %rax
        movq %rax, -8(%rbp)             # Move initialized value into space on stack
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq -8(%rax), %rax             # Assign value to %rax
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
        movq $1, %rax                   # Put a number in %rax
        pushq %rax                      # Push right side to stack
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq -8(%rax), %rax             # Assign value to %rax
        popq %rbx                       # Pop right side into %rbx
        addq %rbx, %rax                 # Add both sides
        movq %rax, -16(%rbp)            # Move initialized value into space on stack
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq -16(%rax), %rax            # Assign value to %rax
                                # Start print statement
        leaq form(%rip), %rdi           # Passing string address (1. argument)
        movq %rax, %rsi                 # Passing %rax (2. argument)
        movq $0, %rax                   # No floating point registers used
        testq $15, %rsp                 # Test for 16 byte alignment
        jz print_align_1                # Jump if aligned
        addq $-8, %rsp                  # 16 byte aligning
        callq printf@plt                # Call printf
        addq $8, %rsp                   # Reverting alignment
        jmp end_print_1
        print_align_1:
        callq printf@plt                # Call printf
        end_print_1:
                                # End print statement
        movq $3, %rax                   # Put a number in %rax
        movq %rax, %rdx
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq %rdx, -8(%rax)
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq -8(%rax), %rax             # Assign value to %rax
                                # Start print statement
        leaq form(%rip), %rdi           # Passing string address (1. argument)
        movq %rax, %rsi                 # Passing %rax (2. argument)
        movq $0, %rax                   # No floating point registers used
        testq $15, %rsp                 # Test for 16 byte alignment
        jz print_align_2                # Jump if aligned
        addq $-8, %rsp                  # 16 byte aligning
        callq printf@plt                # Call printf
        addq $8, %rsp                   # Reverting alignment
        jmp end_print_2
        print_align_2:
        callq printf@plt                # Call printf
        end_print_2:
                                # End print statement
        movq $7, %rax                   # Put a number in %rax
        pushq %rax                      # Push right side to stack
        movq $3, %rax                   # Put a number in %rax
        pushq %rax                      # Push right side to stack
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq -16(%rax), %rax            # Assign value to %rax
        popq %rbx                       # Pop right side into %rbx
        imulq %rbx, %rax                # Multiply both sides
        pushq %rax                      # Push right side to stack
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq -8(%rax), %rax             # Assign value to %rax
        popq %rbx                       # Pop right side into %rbx
        subq %rbx, %rax                 # Subtract both sides
        popq %rbx                       # Pop right side into %rbx
        addq %rbx, %rax                 # Add both sides
        movq %rax, -24(%rbp)            # Move initialized value into space on stack
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq -24(%rax), %rax            # Assign value to %rax
                                # Start print statement
        leaq form(%rip), %rdi           # Passing string address (1. argument)
        movq %rax, %rsi                 # Passing %rax (2. argument)
        movq $0, %rax                   # No floating point registers used
        testq $15, %rsp                 # Test for 16 byte alignment
        jz print_align_3                # Jump if aligned
        addq $-8, %rsp                  # 16 byte aligning
        callq printf@plt                # Call printf
        addq $8, %rsp                   # Reverting alignment
        jmp end_print_3
        print_align_3:
        callq printf@plt                # Call printf
        end_print_3:
                                # End print statement
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq -8(%rax), %rax             # Assign value to %rax
        pushq %rax                      # Push right side to stack
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq -16(%rax), %rax            # Assign value to %rax
        popq %rbx                       # Pop right side into %rbx
        addq %rbx, %rax                 # Add both sides
        pushq %rax                      # Push right side to stack
        movq $3, %rax                   # Put a number in %rax
        popq %rbx                       # Pop right side into %rbx
        imulq %rbx, %rax                # Multiply both sides
        pushq %rax                      # Push right side to stack
        movq $9, %rax                   # Put a number in %rax
        pushq %rax                      # Push right side to stack
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq -24(%rax), %rax            # Assign value to %rax
        popq %rbx                       # Pop right side into %rbx
        movq $0, %rdx                   # Put a 0 in %rdx to prepare for the division
        idivq %rbx                      # Divide both sides
        popq %rbx                       # Pop right side into %rbx
        subq %rbx, %rax                 # Subtract both sides
        movq %rax, -32(%rbp)            # Move initialized value into space on stack
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq -32(%rax), %rax            # Assign value to %rax
                                # Start print statement
        leaq form(%rip), %rdi           # Passing string address (1. argument)
        movq %rax, %rsi                 # Passing %rax (2. argument)
        movq $0, %rax                   # No floating point registers used
        testq $15, %rsp                 # Test for 16 byte alignment
        jz print_align_4                # Jump if aligned
        addq $-8, %rsp                  # 16 byte aligning
        callq printf@plt                # Call printf
        addq $8, %rsp                   # Reverting alignment
        jmp end_print_4
        print_align_4:
        callq printf@plt                # Call printf
        end_print_4:
                                # End print statement
        addq $32, %rsp                  # Deallocate space for variables on the stack
        popq %rbp                       # Restore base pointer
        movq $0, %rax                   # End with error code 0
        ret                     # Return from main

