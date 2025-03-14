.data

form:
        .string	"%d\n"

.text
add:
        pushq %rbp
        movq %rsp, %rbp
        subq $8, %rsp
        movq 24(%rbp), %rax
        pushq %rax
        movq 16(%rbp), %rax
        popq %rbx
        addq %rbx, %rax
        movq $5, %rax
        movq %rax, -8(%rbp)
        movq $1, %rax
        pushq %rax
        movq $5, %rax
        pushq %rax
        call sub
        addq $16, %rsp
        addq $8, %rsp
        popq %rbp
        ret
sub:
        pushq %rbp
        movq %rsp, %rbp
        subq $0, %rsp
        movq 24(%rbp), %rax
        pushq %rax
        movq 16(%rbp), %rax
        popq %rbx
        subq %rbx, %rax
        addq $0, %rsp
        popq %rbp
        ret
.globl main
main:
pushq %rbp
movq %rsp, %rbp
movq $3, %rax
pushq %rax
movq $2, %rax
pushq %rax
call add
addq $16, %rsp
addq $0, %rsp

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
