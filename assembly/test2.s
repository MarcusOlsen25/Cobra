.data
heap:
	.space 1000
heap_pointer:
	.quad heap
form:
	.string "%d\n"
gulerod_descriptor:
melon_descriptor:
sko_descriptor:
c4_descriptor:
c1_descriptor:
	.quad m1_c1
c2_descriptor:
	.quad m1_c1
	.quad m2_c2
c3_descriptor:
	.quad m1_c1
	.quad m2_c2
	.quad m3_c3
Calculator_descriptor:
	.quad add_Calculator
	.quad doubleAdd_Calculator
Box_descriptor:
	.quad set_Box
	.quad get_Box
Inner_descriptor:
Outer_descriptor:
	.quad getZ_Outer
Accumulator_descriptor:
	.quad add_Accumulator
	.quad getTotal_Accumulator
.text
gulerod:			# Class
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx			# Push heap pointer
	movq $17, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)			# Move initialized value into space on heap
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -232(%rax), %rax		# Move value into %rax
	movq %rax, 16(%rcx)			# Move initialized value into space on heap
	popq %rax			# Pop current heap pointer into %rax
	popq %rbp			# Restore base pointer
	ret				# End class
melon:			# Class
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx			# Push heap pointer
	movq $14, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -232(%rax), %rax		# Move value into %rax
	popq %rbx			# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	movq %rax, 8(%rcx)			# Move initialized value into space on heap
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $24, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq gulerod_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax			# Push static link
	pushq %rcx			# Push heap pointer
	call gulerod			# Call gulerod constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, 16(%rcx)			# Move initialized value into space on heap
	popq %rax			# Pop current heap pointer into %rax
	popq %rbp			# Restore base pointer
	ret				# End class
sko:			# Class
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx			# Push heap pointer
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -240(%rax), %rax		# Move value into %rax
	movq %rax, 8(%rcx)			# Move initialized value into space on heap
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -248(%rax), %rax		# Move value into %rax
	movq %rax, 16(%rcx)			# Move initialized value into space on heap
	popq %rax			# Pop current heap pointer into %rax
	popq %rbp			# Restore base pointer
	ret				# End class
test33:			# Function
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $20, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $6, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jge comp_skip_21			# Skip if right side is greater or equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_21			# Skip the alternative branch
comp_skip_21:
	movq $0, %rax			# Put false in %rax
comp_end_21:
	cmp $0, %rax			# Check the condition
	je else_part_27			# Skip to the else if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_41		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_41
print_align_41:
	callq printf@plt		# Call printf
end_print_41:
			# End print statement
end_then_27:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_27			# Skip the else
else_part_27:
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $33, %rax			# Put a number in %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_42		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_42
print_align_42:
	callq printf@plt		# Call printf
end_print_42:
			# End print statement
end_else_27:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
end_27:
end_test33:			# End function
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	ret				# Return from the function
test34:			# Function
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	cmp $0, %rax			# Check the condition
	je else_part_28			# Skip to the else if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $34, %rax			# Put a number in %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_43		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_43
print_align_43:
	callq printf@plt		# Call printf
end_print_43:
			# End print statement
end_then_28:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_28			# Skip the else
else_part_28:
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_44		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_44
print_align_44:
	callq printf@plt		# Call printf
end_print_44:
			# End print statement
end_else_28:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
end_28:
end_test34:			# End function
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	ret				# Return from the function
test35:			# Function
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	cmp $0, %rax			# Check the condition
	je else_part_29			# Skip to the else if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_45		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_45
print_align_45:
	callq printf@plt		# Call printf
end_print_45:
			# End print statement
end_then_29:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_29			# Skip the else
else_part_29:
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $35, %rax			# Put a number in %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_46		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_46
print_align_46:
	callq printf@plt		# Call printf
end_print_46:
			# End print statement
end_else_29:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
end_29:
end_test35:			# End function
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	ret				# Return from the function
test36three:			# Function
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq 24(%rax), %rax		# Traverse static link once
	movq -264(%rax), %rax		# Move value into %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_47		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_47
print_align_47:
	callq printf@plt		# Call printf
end_print_47:
			# End print statement
end_test36three:			# End function
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	ret				# Return from the function
test36one:			# Function
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Add dummy space
	call test36two			# Call the test36two function
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $0, %rsp			# Pop the arguments pushed to the stack
end_test36one:			# End function
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	ret				# Return from the function
test36two:			# Function
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax			# Push static link
	subq $8, %rsp			# Add dummy space
	call test36three			# Call the test36three function
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $0, %rsp			# Pop the arguments pushed to the stack
end_test36two:			# End function
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	ret				# Return from the function
f1:			# Function
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -272(%rax), %rax		# Move value into %rax
	jmp end_f1
end_f1:			# End function
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	ret				# Return from the function
f2:			# Function
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $8, %rsp			# Allocate space for local variables on the stack
	movq $3, %rax			# Put a number in %rax
	movq %rax, -8(%rbp)			# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax			# Push static link
	subq $8, %rsp			# Add dummy space
	call f1			# Call the f1 function
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $0, %rsp			# Pop the arguments pushed to the stack
end_f2:			# End function
	addq $8, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	ret				# Return from the function
c4:			# Class
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx			# Push heap pointer
	movq $3, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)			# Move initialized value into space on heap
	popq %rax			# Pop current heap pointer into %rax
	popq %rbp			# Restore base pointer
	ret				# End class
c1:			# Class
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx			# Push heap pointer
	movq $38, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)			# Move initialized value into space on heap
	popq %rax			# Pop current heap pointer into %rax
	popq %rbp			# Restore base pointer
	ret				# End class
m1_c1:			# Method
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
end_m1_c1:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	ret				# Return from the method
c2:			# Class
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx			# Push heap pointer
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	pushq %rcx			# Push heap pointer
	call c1			# Call c2 constructor
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq $39, %rax			# Put a number in %rax
	movq %rax, 16(%rcx)			# Move initialized value into space on heap
	popq %rax			# Pop current heap pointer into %rax
	popq %rbp			# Restore base pointer
	ret				# End class
m2_c2:			# Method
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	movq 16(%rax), %rax		# Move value into %rax
end_m2_c2:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	ret				# Return from the method
c3:			# Class
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx			# Push heap pointer
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	pushq %rcx			# Push heap pointer
	call c2			# Call c3 constructor
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq $17, %rax			# Put a number in %rax
	movq %rax, 24(%rcx)			# Move initialized value into space on heap
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $16, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq c4_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax			# Push static link
	pushq %rcx			# Push heap pointer
	call c4			# Call c4 constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, 32(%rcx)			# Move initialized value into space on heap
	popq %rax			# Pop current heap pointer into %rax
	popq %rbp			# Restore base pointer
	ret				# End class
m3_c3:			# Method
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $20, %rax			# Put a number in %rax
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	movq %rdx, 16(%rax)		# Move right side into location of left side of assign
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	movq 32(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	movq 16(%rax), %rax		# Move value into %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	movq 24(%rax), %rax		# Move value into %rax
	popq %rbx			# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	popq %rbx			# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
end_m3_c3:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	ret				# Return from the method
increment:			# Function
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -288(%rax), %rax		# Move value into %rax
	popq %rbx			# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -288(%rax), %rax		# Move value into %rax
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq %rdx, -288(%rax)		# Move right side into location of left side of assign
end_increment:			# End function
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	ret				# Return from the function
runIncrements:			# Function
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax			# Push static link
	subq $8, %rsp			# Add dummy space
	call increment			# Call the increment function
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $0, %rsp			# Pop the arguments pushed to the stack
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax			# Push static link
	subq $8, %rsp			# Add dummy space
	call increment			# Call the increment function
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $0, %rsp			# Pop the arguments pushed to the stack
end_runIncrements:			# End function
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	ret				# Return from the function
Calculator:			# Class
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx			# Push heap pointer
	movq $18, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)			# Move initialized value into space on heap
	movq $3, %rax			# Put a number in %rax
	movq %rax, 16(%rcx)			# Move initialized value into space on heap
	popq %rax			# Pop current heap pointer into %rax
	popq %rbp			# Restore base pointer
	ret				# End class
add_Calculator:			# Method
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	movq 16(%rax), %rax		# Move value into %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
	popq %rbx			# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
end_add_Calculator:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	ret				# Return from the method
doubleAdd_Calculator:			# Method
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $2, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	pushq %rax			# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 0(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax			# Push static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax		# Call method
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $8, %rsp			# Pop the arguments pushed to the stack
	popq %rbx			# Pop right side into %rbx
	imulq %rbx, %rax		# Perform multiplication
end_doubleAdd_Calculator:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	ret				# Return from the method
Box:			# Class
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx			# Push heap pointer
	movq $10, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)			# Move initialized value into space on heap
	popq %rax			# Pop current heap pointer into %rax
	popq %rbp			# Restore base pointer
	ret				# End class
set_Box:			# Method
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 40(%rax), %rax		# Move value into %rax
	movq %rdx, 8(%rax)		# Move right side into location of left side of assign
end_set_Box:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	ret				# Return from the method
get_Box:			# Method
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
end_get_Box:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	ret				# Return from the method
Inner:			# Class
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx			# Push heap pointer
	movq $44, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)			# Move initialized value into space on heap
	popq %rax			# Pop current heap pointer into %rax
	popq %rbp			# Restore base pointer
	ret				# End class
Outer:			# Class
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx			# Push heap pointer
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $16, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq Inner_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax			# Push static link
	pushq %rcx			# Push heap pointer
	call Inner			# Call Inner constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, 8(%rcx)			# Move initialized value into space on heap
	popq %rax			# Pop current heap pointer into %rax
	popq %rbp			# Restore base pointer
	ret				# End class
getZ_Outer:			# Method
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
end_getZ_Outer:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	ret				# Return from the method
Accumulator:			# Class
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx			# Push heap pointer
	movq $0, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)			# Move initialized value into space on heap
	popq %rax			# Pop current heap pointer into %rax
	popq %rbp			# Restore base pointer
	ret				# End class
add_Accumulator:			# Method
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 40(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
	popq %rbx			# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 40(%rax), %rax		# Move value into %rax
	movq %rdx, 8(%rax)		# Move right side into location of left side of assign
end_add_Accumulator:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	ret				# Return from the method
getTotal_Accumulator:			# Method
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
end_getTotal_Accumulator:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	ret				# Return from the method
.globl main
main:
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $320, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	movq %rax, -168(%rbp)			# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -168(%rax), %rax		# Move value into %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_0		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_0
print_align_0:
	callq printf@plt		# Call printf
end_print_0:
			# End print statement
	movq $1, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -168(%rax), %rax		# Move value into %rax
	popq %rbx			# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	movq %rax, -176(%rbp)			# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -176(%rax), %rax		# Move value into %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_1		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_1
print_align_1:
	callq printf@plt		# Call printf
end_print_1:
			# End print statement
	movq $3, %rax			# Put a number in %rax
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -168(%rax), %rax		# Move value into %rax
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq %rdx, -168(%rax)		# Move right side into location of left side of assign
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -168(%rax), %rax		# Move value into %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_2		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_2
print_align_2:
	callq printf@plt		# Call printf
end_print_2:
			# End print statement
	movq $7, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $3, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -176(%rax), %rax		# Move value into %rax
	popq %rbx			# Pop right side into %rbx
	imulq %rbx, %rax		# Perform multiplication
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -168(%rax), %rax		# Move value into %rax
	popq %rbx			# Pop right side into %rbx
	subq %rbx, %rax			# Perform subtraction
	popq %rbx			# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	movq %rax, -184(%rbp)			# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -184(%rax), %rax		# Move value into %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_3		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_3
print_align_3:
	callq printf@plt		# Call printf
end_print_3:
			# End print statement
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -168(%rax), %rax		# Move value into %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -176(%rax), %rax		# Move value into %rax
	popq %rbx			# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	pushq %rax			# Push right side to stack
	movq $3, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	imulq %rbx, %rax		# Perform multiplication
	pushq %rax			# Push right side to stack
	movq $9, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -184(%rax), %rax		# Move value into %rax
	popq %rbx			# Pop right side into %rbx
	movq $0, %rdx			# Put a 0 in %rdx to prepare for the division
	idivq %rbx			# Perform division
	popq %rbx			# Pop right side into %rbx
	subq %rbx, %rax			# Perform subtraction
	movq %rax, -192(%rbp)			# Move initialized value into space on stack
	movq $15, %rax			# Put a number in %rax
	negq %rax			# Negate value
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -192(%rax), %rax		# Move value into %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jne comp_skip_0			# Skip if they are not equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_0			# Skip the alternative branch
comp_skip_0:
	movq $0, %rax			# Put false in %rax
comp_end_0:
	cmp $0, %rax			# Check the condition
	je end_0			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $5, %rax			# Put a number in %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_4		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_4
print_align_4:
	callq printf@plt		# Call printf
end_print_4:
			# End print statement
end_then_0:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_0			# Skip the else
end_0:
	movq $0, %rax			# Put a number in %rax
	cmp $0, %rax			# Check the condition
	je end_1			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_5		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_5
print_align_5:
	callq printf@plt		# Call printf
end_print_5:
			# End print statement
end_then_1:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_1			# Skip the else
end_1:
	movq $1, %rax			# Put a number in %rax
	cmp $0, %rax			# Check the condition
	je end_2			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $6, %rax			# Put a number in %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_6		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_6
print_align_6:
	callq printf@plt		# Call printf
end_print_6:
			# End print statement
end_then_2:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_2			# Skip the else
end_2:
	movq $0, %rax			# Put a number in %rax
	movq %rax, -200(%rbp)			# Move initialized value into space on stack
	movq $1, %rax			# Put a number in %rax
	movq %rax, -208(%rbp)			# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -200(%rax), %rax		# Move value into %rax
	cmp $0, %rax			# Check the condition
	je end_3			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_7		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_7
print_align_7:
	callq printf@plt		# Call printf
end_print_7:
			# End print statement
end_then_3:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_3			# Skip the else
end_3:
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -208(%rax), %rax		# Move value into %rax
	cmp $0, %rax			# Check the condition
	je end_4			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $7, %rax			# Put a number in %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_8		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_8
print_align_8:
	callq printf@plt		# Call printf
end_print_8:
			# End print statement
end_then_4:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_4			# Skip the else
end_4:
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -200(%rax), %rax		# Move value into %rax
	cmp $0, %rax			# Check the condition
	je else_part_5			# Skip to the else if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_9		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_9
print_align_9:
	callq printf@plt		# Call printf
end_print_9:
			# End print statement
end_then_5:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_5			# Skip the else
else_part_5:
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $8, %rax			# Put a number in %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_10		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_10
print_align_10:
	callq printf@plt		# Call printf
end_print_10:
			# End print statement
end_else_5:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
end_5:
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -208(%rax), %rax		# Move value into %rax
	cmp $0, %rax			# Check the condition
	je else_part_6			# Skip to the else if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $9, %rax			# Put a number in %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_11		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_11
print_align_11:
	callq printf@plt		# Call printf
end_print_11:
			# End print statement
end_then_6:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_6			# Skip the else
else_part_6:
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_12		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_12
print_align_12:
	callq printf@plt		# Call printf
end_print_12:
			# End print statement
end_else_6:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
end_6:
	movq $1, %rax			# Put a number in %rax
	cmp $0, %rax			# Check the condition
	je else_part_7			# Skip to the else if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $16, %rsp			# Allocate space for local variables on the stack
	movq $9, %rax			# Put a number in %rax
	movq %rax, -8(%rbp)			# Move initialized value into space on stack
	movq $10, %rax			# Put a number in %rax
	movq %rax, -16(%rbp)			# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -16(%rax), %rax		# Move value into %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_13		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_13
print_align_13:
	callq printf@plt		# Call printf
end_print_13:
			# End print statement
end_then_7:			# Clean up then block stack frame
	addq $16, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_7			# Skip the else
else_part_7:
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $8, %rsp			# Allocate space for local variables on the stack
	movq $78, %rax			# Put a number in %rax
	movq %rax, -8(%rbp)			# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -8(%rax), %rax		# Move value into %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_14		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_14
print_align_14:
	callq printf@plt		# Call printf
end_print_14:
			# End print statement
end_else_7:
	addq $8, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
end_7:
	movq $0, %rax			# Put a number in %rax
	cmp $0, %rax			# Check the condition
	je else_part_8			# Skip to the else if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $16, %rsp			# Allocate space for local variables on the stack
	movq $6, %rax			# Put a number in %rax
	movq %rax, -8(%rbp)			# Move initialized value into space on stack
	movq $0, %rax			# Put a number in %rax
	movq %rax, -16(%rbp)			# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -8(%rax), %rax		# Move value into %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_15		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_15
print_align_15:
	callq printf@plt		# Call printf
end_print_15:
			# End print statement
end_then_8:			# Clean up then block stack frame
	addq $16, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_8			# Skip the else
else_part_8:
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $8, %rsp			# Allocate space for local variables on the stack
	movq $11, %rax			# Put a number in %rax
	movq %rax, -8(%rbp)			# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -8(%rax), %rax		# Move value into %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_16		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_16
print_align_16:
	callq printf@plt		# Call printf
end_print_16:
			# End print statement
end_else_8:
	addq $8, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
end_8:
	movq $3, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $6, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jle comp_skip_1			# Skip if right side is less or equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_1			# Skip the alternative branch
comp_skip_1:
	movq $0, %rax			# Put false in %rax
comp_end_1:
	cmp $0, %rax			# Check the condition
	je end_9			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_17		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_17
print_align_17:
	callq printf@plt		# Call printf
end_print_17:
			# End print statement
end_then_9:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_9			# Skip the else
end_9:
	movq $6, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $3, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jle comp_skip_2			# Skip if right side is less or equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_2			# Skip the alternative branch
comp_skip_2:
	movq $0, %rax			# Put false in %rax
comp_end_2:
	cmp $0, %rax			# Check the condition
	je end_10			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $12, %rax			# Put a number in %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_18		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_18
print_align_18:
	callq printf@plt		# Call printf
end_print_18:
			# End print statement
end_then_10:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_10			# Skip the else
end_10:
	movq $3, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $6, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jge comp_skip_3			# Skip if right side is greater or equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_3			# Skip the alternative branch
comp_skip_3:
	movq $0, %rax			# Put false in %rax
comp_end_3:
	cmp $0, %rax			# Check the condition
	je end_11			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $13, %rax			# Put a number in %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_19		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_19
print_align_19:
	callq printf@plt		# Call printf
end_print_19:
			# End print statement
end_then_11:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_11			# Skip the else
end_11:
	movq $8, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $3, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jge comp_skip_4			# Skip if right side is greater or equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_4			# Skip the alternative branch
comp_skip_4:
	movq $0, %rax			# Put false in %rax
comp_end_4:
	cmp $0, %rax			# Check the condition
	je end_12			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_20		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_20
print_align_20:
	callq printf@plt		# Call printf
end_print_20:
			# End print statement
end_then_12:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_12			# Skip the else
end_12:
	movq $9, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $7, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jg comp_skip_5			# Skip if right side is greater
	movq $1, %rax			# Put true in %rax
	jmp comp_end_5			# Skip the alternative branch
comp_skip_5:
	movq $0, %rax			# Put false in %rax
comp_end_5:
	cmp $0, %rax			# Check the condition
	je end_13			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_21		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_21
print_align_21:
	callq printf@plt		# Call printf
end_print_21:
			# End print statement
end_then_13:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_13			# Skip the else
end_13:
	movq $2, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $9, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jg comp_skip_6			# Skip if right side is greater
	movq $1, %rax			# Put true in %rax
	jmp comp_end_6			# Skip the alternative branch
comp_skip_6:
	movq $0, %rax			# Put false in %rax
comp_end_6:
	cmp $0, %rax			# Check the condition
	je end_14			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $14, %rax			# Put a number in %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_22		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_22
print_align_22:
	callq printf@plt		# Call printf
end_print_22:
			# End print statement
end_then_14:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_14			# Skip the else
end_14:
	movq $6, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $6, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jg comp_skip_7			# Skip if right side is greater
	movq $1, %rax			# Put true in %rax
	jmp comp_end_7			# Skip the alternative branch
comp_skip_7:
	movq $0, %rax			# Put false in %rax
comp_end_7:
	cmp $0, %rax			# Check the condition
	je end_15			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $15, %rax			# Put a number in %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_23		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_23
print_align_23:
	callq printf@plt		# Call printf
end_print_23:
			# End print statement
end_then_15:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_15			# Skip the else
end_15:
	movq $2, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $4, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jl comp_skip_8			# Skip if right side is less
	movq $1, %rax			# Put true in %rax
	jmp comp_end_8			# Skip the alternative branch
comp_skip_8:
	movq $0, %rax			# Put false in %rax
comp_end_8:
	cmp $0, %rax			# Check the condition
	je end_16			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_24		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_24
print_align_24:
	callq printf@plt		# Call printf
end_print_24:
			# End print statement
end_then_16:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_16			# Skip the else
end_16:
	movq $4, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $2, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jl comp_skip_9			# Skip if right side is less
	movq $1, %rax			# Put true in %rax
	jmp comp_end_9			# Skip the alternative branch
comp_skip_9:
	movq $0, %rax			# Put false in %rax
comp_end_9:
	cmp $0, %rax			# Check the condition
	je end_17			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $16, %rax			# Put a number in %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_25		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_25
print_align_25:
	callq printf@plt		# Call printf
end_print_25:
			# End print statement
end_then_17:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_17			# Skip the else
end_17:
	movq $2, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $2, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jl comp_skip_10			# Skip if right side is less
	movq $1, %rax			# Put true in %rax
	jmp comp_end_10			# Skip the alternative branch
comp_skip_10:
	movq $0, %rax			# Put false in %rax
comp_end_10:
	cmp $0, %rax			# Check the condition
	je end_18			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $17, %rax			# Put a number in %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_26		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_26
print_align_26:
	callq printf@plt		# Call printf
end_print_26:
			# End print statement
end_then_18:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_18			# Skip the else
end_18:
	movq $8, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $8, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jne comp_skip_11			# Skip if they are not equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_11			# Skip the alternative branch
comp_skip_11:
	movq $0, %rax			# Put false in %rax
comp_end_11:
	cmp $0, %rax			# Check the condition
	je end_19			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $18, %rax			# Put a number in %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_27		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_27
print_align_27:
	callq printf@plt		# Call printf
end_print_27:
			# End print statement
end_then_19:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_19			# Skip the else
end_19:
	movq $9, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $8, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jne comp_skip_12			# Skip if they are not equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_12			# Skip the alternative branch
comp_skip_12:
	movq $0, %rax			# Put false in %rax
comp_end_12:
	cmp $0, %rax			# Check the condition
	je end_20			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_28		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_28
print_align_28:
	callq printf@plt		# Call printf
end_print_28:
			# End print statement
end_then_20:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_20			# Skip the else
end_20:
	movq $5, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $8, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	je comp_skip_13			# Skip if they are  equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_13			# Skip the alternative branch
comp_skip_13:
	movq $0, %rax			# Put false in %rax
comp_end_13:
	cmp $0, %rax			# Check the condition
	je end_21			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $19, %rax			# Put a number in %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_29		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_29
print_align_29:
	callq printf@plt		# Call printf
end_print_29:
			# End print statement
end_then_21:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_21			# Skip the else
end_21:
	movq $8, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $8, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	je comp_skip_14			# Skip if they are  equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_14			# Skip the alternative branch
comp_skip_14:
	movq $0, %rax			# Put false in %rax
comp_end_14:
	cmp $0, %rax			# Check the condition
	je end_22			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_30		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_30
print_align_30:
	callq printf@plt		# Call printf
end_print_30:
			# End print statement
end_then_22:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_22			# Skip the else
end_22:
	movq $20, %rax			# Put a number in %rax
	movq %rax, -216(%rbp)			# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
while_loop_0:
	movq $25, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -216(%rax), %rax		# Move value into %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jl comp_skip_15			# Skip if right side is less
	movq $1, %rax			# Put true in %rax
	jmp comp_end_15			# Skip the alternative branch
comp_skip_15:
	movq $0, %rax			# Put false in %rax
comp_end_15:
	cmp $0, %rax			# Check the condition
	je end_while_0			# Skip if the condition is false
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -216(%rax), %rax		# Move value into %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_31		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_31
print_align_31:
	callq printf@plt		# Call printf
end_print_31:
			# End print statement
	movq $1, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -216(%rax), %rax		# Move value into %rax
	popq %rbx			# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -216(%rax), %rax		# Move value into %rax
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq %rdx, -216(%rax)		# Move right side into location of left side of assign
	jmp while_loop_0		# Restart the loop
end_while_0:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	movq $26, %rax			# Put a number in %rax
	movq %rax, -224(%rbp)			# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
while_loop_1:
	movq $55, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -216(%rax), %rax		# Move value into %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -224(%rax), %rax		# Move value into %rax
	popq %rbx			# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	je comp_skip_16			# Skip if they are  equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_16			# Skip the alternative branch
comp_skip_16:
	movq $0, %rax			# Put false in %rax
comp_end_16:
	cmp $0, %rax			# Check the condition
	je end_while_1			# Skip if the condition is false
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -224(%rax), %rax		# Move value into %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_32		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_32
print_align_32:
	callq printf@plt		# Call printf
end_print_32:
			# End print statement
	movq $1, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -224(%rax), %rax		# Move value into %rax
	popq %rbx			# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -224(%rax), %rax		# Move value into %rax
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq %rdx, -224(%rax)		# Move right side into location of left side of assign
	jmp while_loop_1		# Restart the loop
end_while_1:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	movq $12, %rax			# Put a number in %rax
	movq %rax, -232(%rbp)			# Move initialized value into space on stack
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $24, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq gulerod_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	pushq %rcx			# Push heap pointer
	call gulerod			# Call gulerod constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, -240(%rbp)			# Move initialized value into space on stack
	movq $29, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -240(%rax), %rax		# Move value into %rax
	movq 16(%rax), %rax		# Move value into %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -240(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
	popq %rbx			# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	je comp_skip_17			# Skip if they are  equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_17			# Skip the alternative branch
comp_skip_17:
	movq $0, %rax			# Put false in %rax
comp_end_17:
	cmp $0, %rax			# Check the condition
	je else_part_23			# Skip to the else if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_33		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_33
print_align_33:
	callq printf@plt		# Call printf
end_print_33:
			# End print statement
end_then_23:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_23			# Skip the else
else_part_23:
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -240(%rax), %rax		# Move value into %rax
	movq 16(%rax), %rax		# Move value into %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -240(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
	popq %rbx			# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_34		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_34
print_align_34:
	callq printf@plt		# Call printf
end_print_34:
			# End print statement
end_else_23:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
end_23:
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $24, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq melon_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	pushq %rcx			# Push heap pointer
	call melon			# Call melon constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, -248(%rbp)			# Move initialized value into space on stack
	movq $38, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -248(%rax), %rax		# Move value into %rax
	movq 16(%rax), %rax		# Move value into %rax
	movq 16(%rax), %rax		# Move value into %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -248(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
	popq %rbx			# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	je comp_skip_18			# Skip if they are  equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_18			# Skip the alternative branch
comp_skip_18:
	movq $0, %rax			# Put false in %rax
comp_end_18:
	cmp $0, %rax			# Check the condition
	je else_part_24			# Skip to the else if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_35		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_35
print_align_35:
	callq printf@plt		# Call printf
end_print_35:
			# End print statement
end_then_24:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_24			# Skip the else
else_part_24:
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $30, %rax			# Put a number in %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_36		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_36
print_align_36:
	callq printf@plt		# Call printf
end_print_36:
			# End print statement
end_else_24:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
end_24:
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $24, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq sko_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	pushq %rcx			# Push heap pointer
	call sko			# Call sko constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, -256(%rbp)			# Move initialized value into space on stack
	movq $43, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -256(%rax), %rax		# Move value into %rax
	movq 16(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -256(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
	popq %rbx			# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	je comp_skip_19			# Skip if they are  equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_19			# Skip the alternative branch
comp_skip_19:
	movq $0, %rax			# Put false in %rax
comp_end_19:
	cmp $0, %rax			# Check the condition
	je else_part_25			# Skip to the else if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_37		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_37
print_align_37:
	callq printf@plt		# Call printf
end_print_37:
			# End print statement
end_then_25:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_25			# Skip the else
else_part_25:
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $31, %rax			# Put a number in %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_38		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_38
print_align_38:
	callq printf@plt		# Call printf
end_print_38:
			# End print statement
end_else_25:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
end_25:
	movq $13, %rax			# Put a number in %rax
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -256(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
	movq %rdx, 8(%rax)		# Move right side into location of left side of assign
	movq $14, %rax			# Put a number in %rax
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -256(%rax), %rax		# Move value into %rax
	movq 16(%rax), %rax		# Move value into %rax
	movq %rdx, 8(%rax)		# Move right side into location of left side of assign
	movq $27, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -256(%rax), %rax		# Move value into %rax
	movq 16(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -256(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
	popq %rbx			# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	je comp_skip_20			# Skip if they are  equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_20			# Skip the alternative branch
comp_skip_20:
	movq $0, %rax			# Put false in %rax
comp_end_20:
	cmp $0, %rax			# Check the condition
	je else_part_26			# Skip to the else if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_39		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_39
print_align_39:
	callq printf@plt		# Call printf
end_print_39:
			# End print statement
end_then_26:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_26			# Skip the else
else_part_26:
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $32, %rax			# Put a number in %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_40		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_40
print_align_40:
	callq printf@plt		# Call printf
end_print_40:
			# End print statement
end_else_26:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
end_26:
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Add dummy space
	call test33			# Call the test33 function
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $0, %rsp			# Pop the arguments pushed to the stack
	movq $1, %rax			# Put a number in %rax
	pushq %rax		# Push argument number 1 to stack
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Add dummy space
	call test34			# Call the test34 function
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $8, %rsp			# Pop the arguments pushed to the stack
	movq $0, %rax			# Put a number in %rax
	pushq %rax		# Push argument number 1 to stack
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Add dummy space
	call test35			# Call the test35 function
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $8, %rsp			# Pop the arguments pushed to the stack
	movq $36, %rax			# Put a number in %rax
	movq %rax, -264(%rbp)			# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -264(%rax), %rax		# Move value into %rax
	cmp $0, %rax			# Check the condition
	je end_30			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Add dummy space
	call test36one			# Call the test36one function
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $0, %rsp			# Pop the arguments pushed to the stack
end_then_30:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_30			# Skip the else
end_30:
	movq $37, %rax			# Put a number in %rax
	movq %rax, -272(%rbp)			# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Add dummy space
	call f2			# Call the f2 function
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $0, %rsp			# Pop the arguments pushed to the stack
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_48		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_48
print_align_48:
	callq printf@plt		# Call printf
end_print_48:
			# End print statement
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $40, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq c3_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	pushq %rcx			# Push heap pointer
	call c3			# Call c3 constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, -280(%rbp)			# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -280(%rax), %rax		# Move value into %rax
	pushq %rax			# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 0(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax		# Call method
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $8, %rsp			# Pop the arguments pushed to the stack
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_49		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_49
print_align_49:
	callq printf@plt		# Call printf
end_print_49:
			# End print statement
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -280(%rax), %rax		# Move value into %rax
	pushq %rax			# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax		# Call method
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $8, %rsp			# Pop the arguments pushed to the stack
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_50		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_50
print_align_50:
	callq printf@plt		# Call printf
end_print_50:
			# End print statement
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -280(%rax), %rax		# Move value into %rax
	pushq %rax			# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 16(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax		# Call method
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $8, %rsp			# Pop the arguments pushed to the stack
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_51		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_51
print_align_51:
	callq printf@plt		# Call printf
end_print_51:
			# End print statement
	movq $39, %rax			# Put a number in %rax
	movq %rax, -288(%rbp)			# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Add dummy space
	call runIncrements			# Call the runIncrements function
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $0, %rsp			# Pop the arguments pushed to the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -288(%rax), %rax		# Move value into %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_52		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_52
print_align_52:
	callq printf@plt		# Call printf
end_print_52:
			# End print statement
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $24, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq Calculator_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	pushq %rcx			# Push heap pointer
	call Calculator			# Call Calculator constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, -296(%rbp)			# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -296(%rax), %rax		# Move value into %rax
	pushq %rax			# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax		# Call method
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $8, %rsp			# Pop the arguments pushed to the stack
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_53		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_53
print_align_53:
	callq printf@plt		# Call printf
end_print_53:
			# End print statement
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $16, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq Box_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	pushq %rcx			# Push heap pointer
	call Box			# Call Box constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, -304(%rbp)			# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -304(%rax), %rax		# Move value into %rax
	pushq %rax			# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 0(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	movq $43, %rax			# Put a number in %rax
	pushq %rax			# Push argument number 1 to stack
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax		# Call method
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $16, %rsp			# Pop the arguments pushed to the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -304(%rax), %rax		# Move value into %rax
	pushq %rax			# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax		# Call method
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $8, %rsp			# Pop the arguments pushed to the stack
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_54		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_54
print_align_54:
	callq printf@plt		# Call printf
end_print_54:
			# End print statement
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $16, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq Outer_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	pushq %rcx			# Push heap pointer
	call Outer			# Call Outer constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, -312(%rbp)			# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -312(%rax), %rax		# Move value into %rax
	pushq %rax			# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 0(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax		# Call method
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $8, %rsp			# Pop the arguments pushed to the stack
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_55		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_55
print_align_55:
	callq printf@plt		# Call printf
end_print_55:
			# End print statement
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $16, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq Accumulator_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	pushq %rcx			# Push heap pointer
	call Accumulator			# Call Accumulator constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, -320(%rbp)			# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -320(%rax), %rax		# Move value into %rax
	pushq %rax			# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 0(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	movq $20, %rax			# Put a number in %rax
	pushq %rax			# Push argument number 1 to stack
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax		# Call method
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $16, %rsp			# Pop the arguments pushed to the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -320(%rax), %rax		# Move value into %rax
	pushq %rax			# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 0(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	movq $25, %rax			# Put a number in %rax
	pushq %rax			# Push argument number 1 to stack
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax		# Call method
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $16, %rsp			# Pop the arguments pushed to the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -320(%rax), %rax		# Move value into %rax
	pushq %rax			# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax		# Call method
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $8, %rsp			# Pop the arguments pushed to the stack
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_56		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_56
print_align_56:
	callq printf@plt		# Call printf
end_print_56:
			# End print statement
	addq $320, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	movq $0, %rax			# End with error code 0
	ret			# Return from main
