.data
heap:
        .space 1000
heap_pointer:
        .quad heap
form:
        .string "%d\n"
banan_descriptor:
        .quad one
        .quad two
Pear_descriptor:
        .quad pear_one
.text
banan:                  # Class
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        movq 16(%rbp), %rcx                     # Move heap pointer into %rcx
        pushq %rcx                      # Push heap pointer
        leaq banan_descriptor(%rip), %rax       # Move class descriptor into %rax
        movq %rax, (%rcx)               # Move class descriptor into object
        addq $16, heap_pointer(%rip)                    # Add size of object to heap pointer
        movq $2, %rax                   # Put a number in %rax
        movq %rax, 8(%rcx)                      # Move initialized value into space on heap
        popq %rax                       # Pop current heap pointer into %rax
        popq %rbp                       # Restore base pointer
        ret                             # End class
one:                    # Function
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $0, %rsp                   # Allocate space for local variables on the stack
        movq $1, %rax                   # Put a number in %rax
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
end_one:                        # End function
        addq $0, %rsp                   # Deallocate space for variables on the stack
        popq %rbp                       # Restore base pointer
        ret                             # Return from the function
two:                    # Function
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $0, %rsp                   # Allocate space for local variables on the stack
        movq $2, %rax                   # Put a number in %rax
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
end_two:                        # End function
        addq $0, %rsp                   # Deallocate space for variables on the stack
        popq %rbp                       # Restore base pointer
        ret                             # Return from the function
Pear:                   # Class
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        movq 16(%rbp), %rcx                     # Move heap pointer into %rcx
        pushq %rcx                      # Push heap pointer
        leaq Pear_descriptor(%rip), %rax        # Move class descriptor into %rax
        movq %rax, (%rcx)               # Move class descriptor into object
        addq $16, heap_pointer(%rip)                    # Add size of object to heap pointer
        movq $7, %rax                   # Put a number in %rax
        movq %rax, 8(%rcx)                      # Move initialized value into space on heap
        popq %rax                       # Pop current heap pointer into %rax
        popq %rbp                       # Restore base pointer
        ret                             # End class
pear_one:                       # Function
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $0, %rsp                   # Allocate space for local variables on the stack
        movq $8, %rax                   # Put a number in %rax
        jmp end_pear_one
end_pear_one:                   # End function
        addq $0, %rsp                   # Deallocate space for variables on the stack
        popq %rbp                       # Restore base pointer
        ret                             # Return from the function
.globl main
main:
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $24, %rsp                  # Allocate space for local variables on the stack
        movq %rbp, %rax                 # Prepare static link
        pushq %rax                      # Push static link
        movq heap_pointer(%rip), %rax                   # Move heap pointer into %rax
        pushq %rax                      # Push heap pointer
        call banan                      # Call banan constructor
        movq 16(%rbp), %rcx                     # Move potential heap pointer into %rcx
        addq $8, %rsp                   # Deallocate space on stack for heap pointer
        addq $8, %rsp                   # Deallocate space on stack for static link
        movq %rax, -8(%rbp)                     # Move initialized value into space on stack
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq -8(%rax), %rax             # Move value into %rax
        movq %rax, %r9
        movq %rbp, %rax                 # Prepare static link
        pushq %rax                      # Push static link
        subq $8, %rsp                   # Dummy space
        movq %r9, %rax
        movq (%rax), %rax                       # Move class descriptor into %rax
        movq 0(%rax), %rax                      # Move function address into %rax
        call *%rax
        addq $8, %rsp                   # Dummy space
        addq $8, %rsp                   # Deallocate space on stack for static link
        addq $0, %rsp                   # Pop the arguments pushed to the stack
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq -8(%rax), %rax             # Move value into %rax
        movq %rax, %r9
        movq %rbp, %rax                 # Prepare static link
        pushq %rax                      # Push static link
        subq $8, %rsp                   # Dummy space
        movq %r9, %rax
        movq (%rax), %rax                       # Move class descriptor into %rax
        movq 8(%rax), %rax                      # Move function address into %rax
        call *%rax
        addq $8, %rsp                   # Dummy space
        addq $8, %rsp                   # Deallocate space on stack for static link
        addq $0, %rsp                   # Pop the arguments pushed to the stack
        movq %rbp, %rax                 # Prepare static link
        pushq %rax                      # Push static link
        movq heap_pointer(%rip), %rax                   # Move heap pointer into %rax
        pushq %rax                      # Push heap pointer
        call Pear                       # Call Pear constructor
        movq 16(%rbp), %rcx                     # Move potential heap pointer into %rcx
        addq $8, %rsp                   # Deallocate space on stack for heap pointer
        addq $8, %rsp                   # Deallocate space on stack for static link
        movq %rax, -16(%rbp)                    # Move initialized value into space on stack
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq -16(%rax), %rax            # Move value into %rax
        movq %rax, %r9
        movq %rbp, %rax                 # Prepare static link
        pushq %rax                      # Push static link
        subq $8, %rsp                   # Dummy space
        movq %r9, %rax
        movq (%rax), %rax                       # Move class descriptor into %rax
        movq 0(%rax), %rax                      # Move function address into %rax
        call *%rax
        addq $8, %rsp                   # Dummy space
        addq $8, %rsp                   # Deallocate space on stack for static link
        addq $0, %rsp                   # Pop the arguments pushed to the stack
        movq %rax, -24(%rbp)                    # Move initialized value into space on stack
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq -24(%rax), %rax            # Move value into %rax
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
        addq $24, %rsp                  # Deallocate space for variables on the stack
        popq %rbp                       # Restore base pointer
        movq $0, %rax                   # End with error code 0
        ret                     # Return from main
        