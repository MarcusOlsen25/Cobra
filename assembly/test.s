.data

form:
        .string	"%d\n"

# Paste after this line

.text
.globl main
main:
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $40, %rsp                  # Allocate space for local variables on the stack
        movq $1, %rax                   # Put a number in %rax
        movq %rax, -8(%rbp)             # Move initialized value into space on stack
        movq $2, %rax                   # Put a number in %rax
        movq %rax, -16(%rbp)            # Move initialized value into space on stack
        movq $3, %rax                   # Put a number in %rax
        movq %rax, -24(%rbp)            # Move initialized value into space on stack
        movq $4, %rax                   # Put a number in %rax
        movq %rax, -32(%rbp)            # Move initialized value into space on stack
        movq $5, %rax                   # Put a number in %rax
        movq %rax, -40(%rbp)            # Move initialized value into space on stack
        movq %rbp, %rax                 # Prepare static link
        pushq %rax                      # Push static link
        subq $8, %rsp
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $0, %rsp                   # Allocate space for local variables on the stack
        movq $3, %rax                   # Put a number in %rax
        cmp $0, %rax                    # Check the condition
        je end_if_0                     # Skip if the condition is false
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq 16(%rax), %rax                     # Traverse static link once
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
        movq %rbp, %rax                 # Prepare static link
        pushq %rax                      # Push static link
        subq $8, %rsp
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $0, %rsp                   # Allocate space for local variables on the stack
        movq $3, %rax                   # Put a number in %rax
        cmp $0, %rax                    # Check the condition
        je end_if_1                     # Skip if the condition is false
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq 16(%rax), %rax                     # Traverse static link once
        movq 16(%rax), %rax                     # Traverse static link once
        movq -16(%rax), %rax            # Assign value to %rax
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
        movq %rbp, %rax                 # Prepare static link
        pushq %rax                      # Push static link
        subq $8, %rsp
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $0, %rsp                   # Allocate space for local variables on the stack
        movq $0, %rax                   # Put a number in %rax
        cmp $0, %rax                    # Check the condition
        je end_if_2                     # Skip if the condition is false
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq 16(%rax), %rax                     # Traverse static link once
        movq 16(%rax), %rax                     # Traverse static link once
        movq 16(%rax), %rax                     # Traverse static link once
        movq -24(%rax), %rax            # Assign value to %rax
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
        pushq %rax                      # Push static link
        subq $8, %rsp
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $0, %rsp                   # Allocate space for local variables on the stack
        movq $0, %rax                   # Put a number in %rax
        cmp $0, %rax                    # Check the condition
        je end_if_3                     # Skip if the condition is false
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq 16(%rax), %rax                     # Traverse static link once
        movq 16(%rax), %rax                     # Traverse static link once
        movq 16(%rax), %rax                     # Traverse static link once
        movq 16(%rax), %rax                     # Traverse static link once
        movq -32(%rax), %rax            # Assign value to %rax
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
        end_if_3:
        addq $8, %rsp                   # Deallocate space on stack for static link
        addq $8, %rsp
        addq $0, %rsp                   # Deallocate space for variables on the stack
        popq %rbp                       # Restore base pointer
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq 16(%rax), %rax                     # Traverse static link once
        movq 16(%rax), %rax                     # Traverse static link once
        movq 16(%rax), %rax                     # Traverse static link once
        movq -24(%rax), %rax            # Assign value to %rax
                                # Start print statement
        leaq form(%rip), %rdi                   # Passing string address (1. argument)
        movq %rax, %rsi                 # Passing %rax (2. argument)
        movq $0, %rax                   # No floating point registers used
        testq $15, %rsp                 # Test for 16 byte alignment
        jz print_align_4                        # Jump if aligned
        addq $-8, %rsp                  # 16 byte aligning
        callq printf@plt                        # Call printf
        addq $8, %rsp                   # Reverting alignment
        jmp end_print_4
        print_align_4:
        callq printf@plt                        # Call printf
        end_print_4:
                                # End print statement
        end_if_2:
        addq $8, %rsp                   # Deallocate space on stack for static link
        addq $8, %rsp
        addq $0, %rsp                   # Deallocate space for variables on the stack
        popq %rbp                       # Restore base pointer
        movq %rbp, %rax                 # Prepare static link
        pushq %rax                      # Push static link
        subq $8, %rsp
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $0, %rsp                   # Allocate space for local variables on the stack
        movq $3, %rax                   # Put a number in %rax
        cmp $0, %rax                    # Check the condition
        je end_if_4                     # Skip if the condition is false
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq 16(%rax), %rax                     # Traverse static link once
        movq 16(%rax), %rax                     # Traverse static link once
        movq 16(%rax), %rax                     # Traverse static link once
        movq -40(%rax), %rax            # Assign value to %rax
                                # Start print statement
        leaq form(%rip), %rdi                   # Passing string address (1. argument)
        movq %rax, %rsi                 # Passing %rax (2. argument)
        movq $0, %rax                   # No floating point registers used
        testq $15, %rsp                 # Test for 16 byte alignment
        jz print_align_5                        # Jump if aligned
        addq $-8, %rsp                  # 16 byte aligning
        callq printf@plt                        # Call printf
        addq $8, %rsp                   # Reverting alignment
        jmp end_print_5
        print_align_5:
        callq printf@plt                        # Call printf
        end_print_5:
                                # End print statement
        end_if_4:
        addq $8, %rsp                   # Deallocate space on stack for static link
        addq $8, %rsp
        addq $0, %rsp                   # Deallocate space for variables on the stack
        popq %rbp                       # Restore base pointer
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq 16(%rax), %rax                     # Traverse static link once
        movq 16(%rax), %rax                     # Traverse static link once
        movq -16(%rax), %rax            # Assign value to %rax
                                # Start print statement
        leaq form(%rip), %rdi                   # Passing string address (1. argument)
        movq %rax, %rsi                 # Passing %rax (2. argument)
        movq $0, %rax                   # No floating point registers used
        testq $15, %rsp                 # Test for 16 byte alignment
        jz print_align_6                        # Jump if aligned
        addq $-8, %rsp                  # 16 byte aligning
        callq printf@plt                        # Call printf
        addq $8, %rsp                   # Reverting alignment
        jmp end_print_6
        print_align_6:
        callq printf@plt                        # Call printf
        end_print_6:
                                # End print statement
        end_if_1:
        addq $8, %rsp                   # Deallocate space on stack for static link
        addq $8, %rsp
        addq $0, %rsp                   # Deallocate space for variables on the stack
        popq %rbp                       # Restore base pointer
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq 16(%rax), %rax                     # Traverse static link once
        movq -8(%rax), %rax             # Assign value to %rax
                                # Start print statement
        leaq form(%rip), %rdi                   # Passing string address (1. argument)
        movq %rax, %rsi                 # Passing %rax (2. argument)
        movq $0, %rax                   # No floating point registers used
        testq $15, %rsp                 # Test for 16 byte alignment
        jz print_align_7                        # Jump if aligned
        addq $-8, %rsp                  # 16 byte aligning
        callq printf@plt                        # Call printf
        addq $8, %rsp                   # Reverting alignment
        jmp end_print_7
        print_align_7:
        callq printf@plt                        # Call printf
        end_print_7:
                                # End print statement
        end_if_0:
        addq $8, %rsp                   # Deallocate space on stack for static link
        addq $8, %rsp
        addq $0, %rsp                   # Deallocate space for variables on the stack
        popq %rbp                       # Restore base pointer
        addq $40, %rsp                  # Deallocate space for variables on the stack
        popq %rbp                       # Restore base pointer
        movq $0, %rax                   # End with error code 0
        ret                     # Return from main




        