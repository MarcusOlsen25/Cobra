.data

form:
        .string	"%d\n"

.text
add:
        pushq %rbp
        movq %rsp, %rbp
        movq 24(%rbp), %rax
        pushq %rax
        movq 16(%rbp), %rax
        popq %rbx
        addq %rbx, %rax
        popq %rbp
        ret
.globl main
main:
movq $3, %rax
pushq %rax
movq $2, %rax
pushq %rax
call add
addq $16, %rsp

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

				# Callee epilogue
        movq $0, %rax           # Return "no error" exit code
	ret		# Return from call