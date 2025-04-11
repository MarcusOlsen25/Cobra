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
        movq $0, %rax                   # Put a number in %rax
        cmp $0, %rax                    # Check the condition
        je else_part_0                  # Skip to the else if the condition is false
        movq %rbp, %rax                 # Prepare static link
        pushq %rax                      # Push static link
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $0, %rsp                   # Allocate space for local variables on the stack
        movq $3, %rax                   # Put a number in %rax
        pushq %rax                      # Push right side to stack
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq 8(%rax), %rax              # Traverse static link once
        movq -8(%rax), %rax             # Assign value to %rax
        popq %rbx                       # Pop right side into %rbx
        addq %rbx, %rax                 # Add both sides
        movq %rax, %rdx
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq 8(%rax), %rax              # Traverse static link once
        movq %rdx, -8(%rax)
end_then_0:                     # Clean up then block stack frame
        addq $0, %rsp                   # Deallocate space for variables on the stack
        popq %rbp                       # Restore base pointer
        addq $8, %rsp                   # Deallocate space on stack for static link
        jmp end_0                       # Skip the else
else_part_0:
        movq %rbp, %rax                 # Prepare static link
        pushq %rax                      # Push static link
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $0, %rsp                   # Allocate space for local variables on the stack
        movq %rbp, %rax                 # Prepare to access variable from another scope
        movq 8(%rax), %rax              # Traverse static link once
        movq -8(%rax), %rax             # Assign value to %rax
end_else_0:
        addq $0, %rsp                   # Deallocate space for variables on the stack
        popq %rbp                       # Restore base pointer
        addq $8, %rsp                   # Deallocate space on stack for static link
end_0:
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
        addq $8, %rsp                   # Deallocate space for variables on the stack
        popq %rbp                       # Restore base pointer
        movq $0, %rax                   # End with error code 0
        ret                     # Return from main

