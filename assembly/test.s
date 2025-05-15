.data
heap:
        .space 1000
heap_pointer:
        .quad heap
form:
        .string "%d\n"
.text
.globl main
main:
        pushq %rbp                      # Save base pointer
        movq %rsp, %rbp                 # Make stack pointer new base pointer
        subq $0, %rsp                   # Allocate space for local variables on the stack
        movq $1, %rax                   # Put true in %rax
        pushq %rax                      # Push right side to stack
        movq $7, %rax                   # Put a number in %rax
        popq %rbx                       # Pop right side into %rbx
        addq %rbx, %rax                 # Perform addition
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
        addq $0, %rsp                   # Deallocate space for local variables on the stack
        popq %rbp                       # Restore base pointer
        movq $0, %rax                   # End with error code 0
        ret                     # Return from main
        