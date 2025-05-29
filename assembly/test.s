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
theCompilerWorks_descriptor:
	.quad celebrate_theCompilerWorks
ExtraTest_descriptor:
anotherTest_descriptor:
otherTest_descriptor:
	.quad one_otherTest
.text
print:			# Default procedure
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi				# Passing %rax (2. argument)
	movq $0, %rax				# No floating point registers used
	testq $15, %rsp				# Test for 16 byte alignment
	jz print_align				# Jump if aligned
	addq $-8, %rsp				# 16 byte aligning
	callq printf@plt			# Call printf
	addq $8, %rsp				# Reverting alignment
	jmp end_print
print_align:
	callq printf@plt			# Call printf
end_print:
	ret							# Return from the procedure
gulerod:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	movq $17, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)		# Move initialized value into space on heap
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -72(%rax), %rax		# Move value into %rax
	movq %rax, 16(%rcx)		# Move initialized value into space on heap
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
melon:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	movq $14, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -72(%rax), %rax		# Move value into %rax
	popq %rbx				# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	movq %rax, 8(%rcx)		# Move initialized value into space on heap
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $24, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq gulerod_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	pushq %rcx				# Push heap pointer
	call gulerod			# Call gulerod constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $16, %rsp			# Deallocate heap pointer and static link
	movq %rax, 16(%rcx)		# Move initialized value into space on heap
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
sko:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -80(%rax), %rax		# Move value into %rax
	movq %rax, 8(%rcx)		# Move initialized value into space on heap
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -88(%rax), %rax		# Move value into %rax
	movq %rax, 16(%rcx)		# Move initialized value into space on heap
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
test33:			# Function
	subq $8, %rsp			# Add dummy base pointer
				# Start if statement 27
	movq $20, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq $6, %rax			# Put a number in %rax
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jge comp_skip_21			# Skip if right side is greater or equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_21			# Skip the alternative branch
comp_skip_21:
	movq $0, %rax			# Put false in %rax
comp_end_21:
	cmp $0, %rax			# Check the condition
	je else_part_27			# Skip to the else if the condition is false
	movq $-1, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_27				# Skip the else
else_part_27:
	movq $33, %rax			# Put a number in %rax
	call print				# Call the print procedure
end_27:
end_test33:			# End function
	addq $8, %rsp			# Remove dummy base pointer
	ret						# Return from the function
test34:			# Function
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
				# Start if statement 28
	movq 32(%rbp), %rax		# Access variable from another scope
	cmp $0, %rax			# Check the condition
	je else_part_28			# Skip to the else if the condition is false
	movq $34, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_28				# Skip the else
else_part_28:
	movq $-1, %rax			# Put a number in %rax
	call print				# Call the print procedure
end_28:
end_test34:			# End function
	popq %rbp				# Restore base pointer
	ret						# Return from the function
test35:			# Function
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
				# Start if statement 29
	movq 32(%rbp), %rax		# Access variable from another scope
	cmp $0, %rax			# Check the condition
	je else_part_29			# Skip to the else if the condition is false
	movq $-1, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_29				# Skip the else
else_part_29:
	movq $35, %rax			# Put a number in %rax
	call print				# Call the print procedure
end_29:
end_test35:			# End function
	popq %rbp				# Restore base pointer
	ret						# Return from the function
test36three:			# Function
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -104(%rax), %rax		# Move value into %rax
	call print				# Call the print procedure
end_test36three:			# End function
	popq %rbp				# Restore base pointer
	ret						# Return from the function
test36one:			# Function
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	pushq %rbp				# Push simple static link
	subq $8, %rsp			# Add dummy space
	call test36one_test36two			# Call the test36one_test36two function
	addq $16, %rsp			# Deallocate dummy space and static link
end_test36one:			# End function
	popq %rbp				# Restore base pointer
	ret						# Return from the function
test36one_test36two:			# Function
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	subq $8, %rsp			# Add dummy space
	call test36three			# Call the test36three function
	addq $16, %rsp			# Deallocate dummy space and static link
end_test36one_test36two:			# End function
	popq %rbp				# Restore base pointer
	ret						# Return from the function
f1:			# Function
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -112(%rax), %rax		# Move value into %rax
	jmp end_f1
end_f1:			# End function
	popq %rbp				# Restore base pointer
	ret						# Return from the function
f2:			# Function
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $8, %rsp			# Allocate space for local variables on the stack
	movq $3, %rax			# Put a number in %rax
	movq %rax, -8(%rbp)		# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	subq $8, %rsp			# Add dummy space
	call f1			# Call the f1 function
	addq $16, %rsp			# Deallocate dummy space and static link
end_f2:			# End function
	addq $8, %rsp			# Deallocate space for local variables on the stack
	popq %rbp				# Restore base pointer
	ret						# Return from the function
c4:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	movq $3, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)		# Move initialized value into space on heap
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
c1:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	movq $38, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)		# Move initialized value into space on heap
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
m1_c1:			# Method
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 32(%rbp), %rax		# Access variable from another scope
	movq 8(%rax), %rax		# Move value into %rax
	jmp end_m1_c1
end_m1_c1:
	popq %rbp				# Restore base pointer
	ret						# Return from the method
c2:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	pushq %rbp				# Push simple static link
	pushq %rcx				# Push heap pointer
	call c1					# Call c2 constructor
	addq $16, %rsp			# Deallocate heap pointer and static link
	movq $39, %rax			# Put a number in %rax
	movq %rax, 16(%rcx)		# Move initialized value into space on heap
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
m2_c2:			# Method
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 32(%rbp), %rax		# Access variable from another scope
	movq 16(%rax), %rax		# Move value into %rax
	jmp end_m2_c2
end_m2_c2:
	popq %rbp				# Restore base pointer
	ret						# Return from the method
c3:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	pushq %rbp				# Push simple static link
	pushq %rcx				# Push heap pointer
	call c2					# Call c3 constructor
	addq $16, %rsp			# Deallocate heap pointer and static link
	movq $17, %rax			# Put a number in %rax
	movq %rax, 24(%rcx)		# Move initialized value into space on heap
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $16, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq c4_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	pushq %rcx				# Push heap pointer
	call c4			# Call c4 constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $16, %rsp			# Deallocate heap pointer and static link
	movq %rax, 32(%rcx)		# Move initialized value into space on heap
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
m3_c3:			# Method
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq $20, %rax			# Put a number in %rax
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq 32(%rbp), %rax		# Access variable from another scope
	movq %rdx, 16(%rax)		# Move right side into location of left side of assign
	movq 32(%rbp), %rax		# Access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
	pushq %rax				# Push right side to stack
	movq 32(%rbp), %rax		# Access variable from another scope
	movq 16(%rax), %rax		# Move value into %rax
	pushq %rax				# Push right side to stack
	movq 32(%rbp), %rax		# Access variable from another scope
	movq 24(%rax), %rax		# Move value into %rax
	popq %rbx				# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	popq %rbx				# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	jmp end_m3_c3
end_m3_c3:
	popq %rbp				# Restore base pointer
	ret						# Return from the method
increment:			# Function
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq $1, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -128(%rax), %rax		# Move value into %rax
	popq %rbx				# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -128(%rax), %rax		# Move value into %rax
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq %rdx, -128(%rax)		# Move right side into location of left side of assign
end_increment:			# End function
	popq %rbp				# Restore base pointer
	ret						# Return from the function
runIncrements:			# Function
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	subq $8, %rsp			# Add dummy space
	call increment			# Call the increment function
	addq $16, %rsp			# Deallocate dummy space and static link
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	subq $8, %rsp			# Add dummy space
	call increment			# Call the increment function
	addq $16, %rsp			# Deallocate dummy space and static link
end_runIncrements:			# End function
	popq %rbp				# Restore base pointer
	ret						# Return from the function
Calculator:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	movq $18, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)		# Move initialized value into space on heap
	movq $3, %rax			# Put a number in %rax
	movq %rax, 16(%rcx)		# Move initialized value into space on heap
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
add_Calculator:			# Method
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 32(%rbp), %rax		# Access variable from another scope
	movq 16(%rax), %rax		# Move value into %rax
	pushq %rax				# Push right side to stack
	movq 32(%rbp), %rax		# Access variable from another scope
	movq 8(%rax), %rax		# Move value into %rax
	popq %rbx				# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	jmp end_add_Calculator
end_add_Calculator:
	popq %rbp				# Restore base pointer
	ret						# Return from the method
doubleAdd_Calculator:			# Method
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq $2, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq 32(%rbp), %rax		# Access variable from another scope
	pushq %rax				# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 0(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax				# Call method
	addq $24, %rsp			# Deallocate dummy space, static link and arguments
	popq %rbx				# Pop right side into %rbx
	imulq %rbx, %rax		# Perform multiplication
	jmp end_doubleAdd_Calculator
end_doubleAdd_Calculator:
	popq %rbp				# Restore base pointer
	ret						# Return from the method
Box:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	movq $10, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)		# Move initialized value into space on heap
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
set_Box:			# Method
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 32(%rbp), %rax		# Access variable from another scope
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq 40(%rbp), %rax		# Access variable from another scope
	movq %rdx, 8(%rax)		# Move right side into location of left side of assign
end_set_Box:
	popq %rbp				# Restore base pointer
	ret						# Return from the method
get_Box:			# Method
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 32(%rbp), %rax		# Access variable from another scope
	movq 8(%rax), %rax		# Move value into %rax
	jmp end_get_Box
end_get_Box:
	popq %rbp				# Restore base pointer
	ret						# Return from the method
Inner:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	movq $44, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)		# Move initialized value into space on heap
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
Outer:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $16, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq Inner_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	pushq %rcx				# Push heap pointer
	call Inner			# Call Inner constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $16, %rsp			# Deallocate heap pointer and static link
	movq %rax, 8(%rcx)		# Move initialized value into space on heap
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
getZ_Outer:			# Method
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 32(%rbp), %rax		# Access variable from another scope
	movq 8(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
	jmp end_getZ_Outer
end_getZ_Outer:
	popq %rbp				# Restore base pointer
	ret						# Return from the method
Accumulator:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	movq $0, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)		# Move initialized value into space on heap
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
add_Accumulator:			# Method
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 32(%rbp), %rax		# Access variable from another scope
	pushq %rax				# Push right side to stack
	movq 40(%rbp), %rax		# Access variable from another scope
	movq 8(%rax), %rax		# Move value into %rax
	popq %rbx				# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq 40(%rbp), %rax		# Access variable from another scope
	movq %rdx, 8(%rax)		# Move right side into location of left side of assign
end_add_Accumulator:
	popq %rbp				# Restore base pointer
	ret						# Return from the method
getTotal_Accumulator:			# Method
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 32(%rbp), %rax		# Access variable from another scope
	movq 8(%rax), %rax		# Move value into %rax
	jmp end_getTotal_Accumulator
end_getTotal_Accumulator:
	popq %rbp				# Restore base pointer
	ret						# Return from the method
theCompilerWorks:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	movq $50, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)		# Move initialized value into space on heap
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
celebrate_theCompilerWorks:			# Method
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 32(%rbp), %rax		# Access variable from another scope
	movq 8(%rax), %rax		# Move value into %rax
	call print				# Call the print procedure
end_celebrate_theCompilerWorks:
	popq %rbp				# Restore base pointer
	ret						# Return from the method
ExtraTest:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	movq $51, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)		# Move initialized value into space on heap
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
anotherTest:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	movq $52, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)		# Move initialized value into space on heap
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
otherTest:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
one_otherTest:			# Method
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $16, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq anotherTest_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	pushq %rcx				# Push heap pointer
	call anotherTest			# Call anotherTest constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $16, %rsp			# Deallocate heap pointer and static link
	jmp end_one_otherTest
end_one_otherTest:
	popq %rbp				# Restore base pointer
	ret						# Return from the method
funnyFunc:			# Function
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $16, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq anotherTest_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	pushq %rcx				# Push heap pointer
	call anotherTest			# Call anotherTest constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $16, %rsp			# Deallocate heap pointer and static link
	jmp end_funnyFunc
end_funnyFunc:			# End function
	popq %rbp				# Restore base pointer
	ret						# Return from the function
factorial:			# Function
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
				# Start if statement 41
	movq $1, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq 32(%rbp), %rax		# Access variable from another scope
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jne comp_skip_36			# Skip if they are not equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_36			# Skip the alternative branch
comp_skip_36:
	movq $0, %rax			# Put false in %rax
comp_end_36:
	pushq %rax				# Push right side to stack
	movq $0, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq 32(%rbp), %rax		# Access variable from another scope
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jne comp_skip_37			# Skip if they are not equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_37			# Skip the alternative branch
comp_skip_37:
	movq $0, %rax			# Put false in %rax
comp_end_37:
	popq %rbx				# Pop right side into %rbx
	movq $0, %rdx			# Put FALSE in %rdx
	cmp %rax, %rdx			# Check if the left side is false
	jne logical_true_38		# Skip to the true
	cmp %rbx, %rdx			# Check if the right side is false
	jne logical_true_38		# Skip to the true
	movq $0, %rax			# Put false in %rax
	jmp logical_end_38		# Skip to the end
logical_true_38:
	movq $1, %rax			# Put true in %rax
logical_end_38:
	cmp $0, %rax			# Check the condition
	je end_41				# Skip if the condition is false
	movq $1, %rax			# Put a number in %rax
	jmp end_factorial
	jmp end_41				# Skip the else
end_41:
	movq $1, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq 32(%rbp), %rax		# Access variable from another scope
	popq %rbx				# Pop right side into %rbx
	subq %rbx, %rax			# Perform subtraction
	pushq %rax		# Push argument number 1 to stack
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	subq $8, %rsp			# Add dummy space
	call factorial			# Call the factorial function
	addq $24, %rsp			# Deallocate dummy space, static link and arguments
	pushq %rax				# Push right side to stack
	movq 32(%rbp), %rax		# Access variable from another scope
	popq %rbx				# Pop right side into %rbx
	imulq %rbx, %rax		# Perform multiplication
	jmp end_factorial
end_factorial:			# End function
	popq %rbp				# Restore base pointer
	ret						# Return from the function
.globl main
main:
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $216, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	movq %rax, -8(%rbp)		# Move initialized value into space on stack
	movq -8(%rbp), %rax		# Access variable from another scope
	call print				# Call the print procedure
	movq $1, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq -8(%rbp), %rax		# Access variable from another scope
	popq %rbx				# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	movq %rax, -16(%rbp)		# Move initialized value into space on stack
	movq -16(%rbp), %rax		# Access variable from another scope
	call print				# Call the print procedure
	movq $3, %rax			# Put a number in %rax
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq -8(%rbp), %rax		# Access variable from another scope
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq %rdx, -8(%rax)		# Move right side into location of left side of assign
	movq -8(%rbp), %rax		# Access variable from another scope
	call print				# Call the print procedure
	movq $7, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq $3, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq -16(%rbp), %rax		# Access variable from another scope
	popq %rbx				# Pop right side into %rbx
	imulq %rbx, %rax		# Perform multiplication
	pushq %rax				# Push right side to stack
	movq -8(%rbp), %rax		# Access variable from another scope
	popq %rbx				# Pop right side into %rbx
	subq %rbx, %rax			# Perform subtraction
	popq %rbx				# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	movq %rax, -24(%rbp)		# Move initialized value into space on stack
	movq -24(%rbp), %rax		# Access variable from another scope
	call print				# Call the print procedure
	movq -8(%rbp), %rax		# Access variable from another scope
	pushq %rax				# Push right side to stack
	movq -16(%rbp), %rax		# Access variable from another scope
	popq %rbx				# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	pushq %rax				# Push right side to stack
	movq $3, %rax			# Put a number in %rax
	popq %rbx				# Pop right side into %rbx
	imulq %rbx, %rax		# Perform multiplication
	pushq %rax				# Push right side to stack
	movq $9, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq -24(%rbp), %rax		# Access variable from another scope
	popq %rbx				# Pop right side into %rbx
	movq $0, %rdx			# Put a 0 in %rdx to prepare for the division
	idivq %rbx			# Perform division
	popq %rbx				# Pop right side into %rbx
	subq %rbx, %rax			# Perform subtraction
	movq %rax, -32(%rbp)		# Move initialized value into space on stack
				# Start if statement 0
	movq $-15, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq -32(%rbp), %rax		# Access variable from another scope
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jne comp_skip_0			# Skip if they are not equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_0			# Skip the alternative branch
comp_skip_0:
	movq $0, %rax			# Put false in %rax
comp_end_0:
	cmp $0, %rax			# Check the condition
	je end_0				# Skip if the condition is false
	movq $5, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_0				# Skip the else
end_0:
				# Start if statement 1
	movq $0, %rax			# Put a number in %rax
	cmp $0, %rax			# Check the condition
	je end_1				# Skip if the condition is false
	movq $-1, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_1				# Skip the else
end_1:
				# Start if statement 2
	movq $1, %rax			# Put a number in %rax
	cmp $0, %rax			# Check the condition
	je end_2				# Skip if the condition is false
	movq $6, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_2				# Skip the else
end_2:
	movq $0, %rax			# Put a number in %rax
	movq %rax, -40(%rbp)		# Move initialized value into space on stack
	movq $1, %rax			# Put a number in %rax
	movq %rax, -48(%rbp)		# Move initialized value into space on stack
				# Start if statement 3
	movq -40(%rbp), %rax		# Access variable from another scope
	cmp $0, %rax			# Check the condition
	je end_3				# Skip if the condition is false
	movq $-1, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_3				# Skip the else
end_3:
				# Start if statement 4
	movq -48(%rbp), %rax		# Access variable from another scope
	cmp $0, %rax			# Check the condition
	je end_4				# Skip if the condition is false
	movq $7, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_4				# Skip the else
end_4:
				# Start if statement 5
	movq -40(%rbp), %rax		# Access variable from another scope
	cmp $0, %rax			# Check the condition
	je else_part_5			# Skip to the else if the condition is false
	movq $-1, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_5				# Skip the else
else_part_5:
	movq $8, %rax			# Put a number in %rax
	call print				# Call the print procedure
end_5:
				# Start if statement 6
	movq -48(%rbp), %rax		# Access variable from another scope
	cmp $0, %rax			# Check the condition
	je else_part_6			# Skip to the else if the condition is false
	movq $9, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_6				# Skip the else
else_part_6:
	movq $-1, %rax			# Put a number in %rax
	call print				# Call the print procedure
end_6:
				# Start if statement 7
	movq $1, %rax			# Put a number in %rax
	cmp $0, %rax			# Check the condition
	je else_part_7			# Skip to the else if the condition is false
	movq $9, %rax			# Put a number in %rax
	movq %rax, -56(%rbp)		# Move initialized value into space on stack
	movq $10, %rax			# Put a number in %rax
	movq %rax, -64(%rbp)		# Move initialized value into space on stack
	movq -64(%rbp), %rax		# Access variable from another scope
	call print				# Call the print procedure
	jmp end_7				# Skip the else
else_part_7:
	movq $78, %rax			# Put a number in %rax
	movq %rax, -56(%rbp)		# Move initialized value into space on stack
	movq -56(%rbp), %rax		# Access variable from another scope
	call print				# Call the print procedure
end_7:
				# Start if statement 8
	movq $0, %rax			# Put a number in %rax
	cmp $0, %rax			# Check the condition
	je else_part_8			# Skip to the else if the condition is false
	movq $6, %rax			# Put a number in %rax
	movq %rax, -56(%rbp)		# Move initialized value into space on stack
	movq $0, %rax			# Put a number in %rax
	movq %rax, -64(%rbp)		# Move initialized value into space on stack
	movq -56(%rbp), %rax		# Access variable from another scope
	call print				# Call the print procedure
	jmp end_8				# Skip the else
else_part_8:
	movq $11, %rax			# Put a number in %rax
	movq %rax, -56(%rbp)		# Move initialized value into space on stack
	movq -56(%rbp), %rax		# Access variable from another scope
	call print				# Call the print procedure
end_8:
				# Start if statement 9
	movq $3, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq $6, %rax			# Put a number in %rax
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jle comp_skip_1			# Skip if right side is less or equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_1			# Skip the alternative branch
comp_skip_1:
	movq $0, %rax			# Put false in %rax
comp_end_1:
	cmp $0, %rax			# Check the condition
	je end_9				# Skip if the condition is false
	movq $-1, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_9				# Skip the else
end_9:
				# Start if statement 10
	movq $6, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq $3, %rax			# Put a number in %rax
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jle comp_skip_2			# Skip if right side is less or equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_2			# Skip the alternative branch
comp_skip_2:
	movq $0, %rax			# Put false in %rax
comp_end_2:
	cmp $0, %rax			# Check the condition
	je end_10				# Skip if the condition is false
	movq $12, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_10				# Skip the else
end_10:
				# Start if statement 11
	movq $3, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq $6, %rax			# Put a number in %rax
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jge comp_skip_3			# Skip if right side is greater or equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_3			# Skip the alternative branch
comp_skip_3:
	movq $0, %rax			# Put false in %rax
comp_end_3:
	cmp $0, %rax			# Check the condition
	je end_11				# Skip if the condition is false
	movq $13, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_11				# Skip the else
end_11:
				# Start if statement 12
	movq $8, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq $3, %rax			# Put a number in %rax
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jge comp_skip_4			# Skip if right side is greater or equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_4			# Skip the alternative branch
comp_skip_4:
	movq $0, %rax			# Put false in %rax
comp_end_4:
	cmp $0, %rax			# Check the condition
	je end_12				# Skip if the condition is false
	movq $-1, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_12				# Skip the else
end_12:
				# Start if statement 13
	movq $9, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq $7, %rax			# Put a number in %rax
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jg comp_skip_5			# Skip if right side is greater
	movq $1, %rax			# Put true in %rax
	jmp comp_end_5			# Skip the alternative branch
comp_skip_5:
	movq $0, %rax			# Put false in %rax
comp_end_5:
	cmp $0, %rax			# Check the condition
	je end_13				# Skip if the condition is false
	movq $-1, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_13				# Skip the else
end_13:
				# Start if statement 14
	movq $2, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq $9, %rax			# Put a number in %rax
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jg comp_skip_6			# Skip if right side is greater
	movq $1, %rax			# Put true in %rax
	jmp comp_end_6			# Skip the alternative branch
comp_skip_6:
	movq $0, %rax			# Put false in %rax
comp_end_6:
	cmp $0, %rax			# Check the condition
	je end_14				# Skip if the condition is false
	movq $14, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_14				# Skip the else
end_14:
				# Start if statement 15
	movq $6, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq $6, %rax			# Put a number in %rax
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jg comp_skip_7			# Skip if right side is greater
	movq $1, %rax			# Put true in %rax
	jmp comp_end_7			# Skip the alternative branch
comp_skip_7:
	movq $0, %rax			# Put false in %rax
comp_end_7:
	cmp $0, %rax			# Check the condition
	je end_15				# Skip if the condition is false
	movq $15, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_15				# Skip the else
end_15:
				# Start if statement 16
	movq $2, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq $4, %rax			# Put a number in %rax
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jl comp_skip_8			# Skip if right side is less
	movq $1, %rax			# Put true in %rax
	jmp comp_end_8			# Skip the alternative branch
comp_skip_8:
	movq $0, %rax			# Put false in %rax
comp_end_8:
	cmp $0, %rax			# Check the condition
	je end_16				# Skip if the condition is false
	movq $-1, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_16				# Skip the else
end_16:
				# Start if statement 17
	movq $4, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq $2, %rax			# Put a number in %rax
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jl comp_skip_9			# Skip if right side is less
	movq $1, %rax			# Put true in %rax
	jmp comp_end_9			# Skip the alternative branch
comp_skip_9:
	movq $0, %rax			# Put false in %rax
comp_end_9:
	cmp $0, %rax			# Check the condition
	je end_17				# Skip if the condition is false
	movq $16, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_17				# Skip the else
end_17:
				# Start if statement 18
	movq $2, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq $2, %rax			# Put a number in %rax
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jl comp_skip_10			# Skip if right side is less
	movq $1, %rax			# Put true in %rax
	jmp comp_end_10			# Skip the alternative branch
comp_skip_10:
	movq $0, %rax			# Put false in %rax
comp_end_10:
	cmp $0, %rax			# Check the condition
	je end_18				# Skip if the condition is false
	movq $17, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_18				# Skip the else
end_18:
				# Start if statement 19
	movq $8, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq $8, %rax			# Put a number in %rax
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jne comp_skip_11			# Skip if they are not equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_11			# Skip the alternative branch
comp_skip_11:
	movq $0, %rax			# Put false in %rax
comp_end_11:
	cmp $0, %rax			# Check the condition
	je end_19				# Skip if the condition is false
	movq $18, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_19				# Skip the else
end_19:
				# Start if statement 20
	movq $9, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq $8, %rax			# Put a number in %rax
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jne comp_skip_12			# Skip if they are not equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_12			# Skip the alternative branch
comp_skip_12:
	movq $0, %rax			# Put false in %rax
comp_end_12:
	cmp $0, %rax			# Check the condition
	je end_20				# Skip if the condition is false
	movq $-1, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_20				# Skip the else
end_20:
				# Start if statement 21
	movq $5, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq $8, %rax			# Put a number in %rax
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	je comp_skip_13			# Skip if they are equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_13			# Skip the alternative branch
comp_skip_13:
	movq $0, %rax			# Put false in %rax
comp_end_13:
	cmp $0, %rax			# Check the condition
	je end_21				# Skip if the condition is false
	movq $19, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_21				# Skip the else
end_21:
				# Start if statement 22
	movq $8, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq $8, %rax			# Put a number in %rax
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	je comp_skip_14			# Skip if they are equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_14			# Skip the alternative branch
comp_skip_14:
	movq $0, %rax			# Put false in %rax
comp_end_14:
	cmp $0, %rax			# Check the condition
	je end_22				# Skip if the condition is false
	movq $-1, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_22				# Skip the else
end_22:
	movq $20, %rax			# Put a number in %rax
	movq %rax, -56(%rbp)		# Move initialized value into space on stack
# Start while statement 0
while_loop_0:
	movq $25, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq -56(%rbp), %rax		# Access variable from another scope
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jl comp_skip_15			# Skip if right side is less
	movq $1, %rax			# Put true in %rax
	jmp comp_end_15			# Skip the alternative branch
comp_skip_15:
	movq $0, %rax			# Put false in %rax
comp_end_15:
	cmp $0, %rax			# Check the condition
	je end_while_0			# Skip if the condition is false
	movq -56(%rbp), %rax		# Access variable from another scope
	call print				# Call the print procedure
	movq $1, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq -56(%rbp), %rax		# Access variable from another scope
	popq %rbx				# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq -56(%rbp), %rax		# Access variable from another scope
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq %rdx, -56(%rax)		# Move right side into location of left side of assign
	jmp while_loop_0		# Restart the loop
end_while_0:
	movq $26, %rax			# Put a number in %rax
	movq %rax, -64(%rbp)		# Move initialized value into space on stack
# Start while statement 1
while_loop_1:
	movq $55, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq -56(%rbp), %rax		# Access variable from another scope
	pushq %rax				# Push right side to stack
	movq -64(%rbp), %rax		# Access variable from another scope
	popq %rbx				# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	je comp_skip_16			# Skip if they are equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_16			# Skip the alternative branch
comp_skip_16:
	movq $0, %rax			# Put false in %rax
comp_end_16:
	cmp $0, %rax			# Check the condition
	je end_while_1			# Skip if the condition is false
	movq -64(%rbp), %rax		# Access variable from another scope
	call print				# Call the print procedure
	movq $1, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq -64(%rbp), %rax		# Access variable from another scope
	popq %rbx				# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq -64(%rbp), %rax		# Access variable from another scope
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq %rdx, -64(%rax)		# Move right side into location of left side of assign
	jmp while_loop_1		# Restart the loop
end_while_1:
	movq $12, %rax			# Put a number in %rax
	movq %rax, -72(%rbp)		# Move initialized value into space on stack
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $24, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq gulerod_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	pushq %rbp				# Push simple static link
	pushq %rcx				# Push heap pointer
	call gulerod			# Call gulerod constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $16, %rsp			# Deallocate heap pointer and static link
	movq %rax, -80(%rbp)		# Move initialized value into space on stack
				# Start if statement 23
	movq $29, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq -80(%rbp), %rax		# Access variable from another scope
	movq 16(%rax), %rax		# Move value into %rax
	pushq %rax				# Push right side to stack
	movq -80(%rbp), %rax		# Access variable from another scope
	movq 8(%rax), %rax		# Move value into %rax
	popq %rbx				# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	je comp_skip_17			# Skip if they are equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_17			# Skip the alternative branch
comp_skip_17:
	movq $0, %rax			# Put false in %rax
comp_end_17:
	cmp $0, %rax			# Check the condition
	je else_part_23			# Skip to the else if the condition is false
	movq $-1, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_23				# Skip the else
else_part_23:
	movq -80(%rbp), %rax		# Access variable from another scope
	movq 16(%rax), %rax		# Move value into %rax
	pushq %rax				# Push right side to stack
	movq -80(%rbp), %rax		# Access variable from another scope
	movq 8(%rax), %rax		# Move value into %rax
	popq %rbx				# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	call print				# Call the print procedure
end_23:
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $24, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq melon_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	pushq %rbp				# Push simple static link
	pushq %rcx				# Push heap pointer
	call melon			# Call melon constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $16, %rsp			# Deallocate heap pointer and static link
	movq %rax, -88(%rbp)		# Move initialized value into space on stack
				# Start if statement 24
	movq $38, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq -88(%rbp), %rax		# Access variable from another scope
	movq 16(%rax), %rax		# Move value into %rax
	movq 16(%rax), %rax		# Move value into %rax
	pushq %rax				# Push right side to stack
	movq -88(%rbp), %rax		# Access variable from another scope
	movq 8(%rax), %rax		# Move value into %rax
	popq %rbx				# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	je comp_skip_18			# Skip if they are equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_18			# Skip the alternative branch
comp_skip_18:
	movq $0, %rax			# Put false in %rax
comp_end_18:
	cmp $0, %rax			# Check the condition
	je else_part_24			# Skip to the else if the condition is false
	movq $-1, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_24				# Skip the else
else_part_24:
	movq $30, %rax			# Put a number in %rax
	call print				# Call the print procedure
end_24:
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $24, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq sko_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	pushq %rbp				# Push simple static link
	pushq %rcx				# Push heap pointer
	call sko			# Call sko constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $16, %rsp			# Deallocate heap pointer and static link
	movq %rax, -96(%rbp)		# Move initialized value into space on stack
				# Start if statement 25
	movq $43, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq -96(%rbp), %rax		# Access variable from another scope
	movq 16(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
	pushq %rax				# Push right side to stack
	movq -96(%rbp), %rax		# Access variable from another scope
	movq 8(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
	popq %rbx				# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	je comp_skip_19			# Skip if they are equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_19			# Skip the alternative branch
comp_skip_19:
	movq $0, %rax			# Put false in %rax
comp_end_19:
	cmp $0, %rax			# Check the condition
	je else_part_25			# Skip to the else if the condition is false
	movq $-1, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_25				# Skip the else
else_part_25:
	movq $31, %rax			# Put a number in %rax
	call print				# Call the print procedure
end_25:
	movq $13, %rax			# Put a number in %rax
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq -96(%rbp), %rax		# Access variable from another scope
	movq 8(%rax), %rax		# Move value into %rax
	movq %rdx, 8(%rax)		# Move right side into location of left side of assign
	movq $14, %rax			# Put a number in %rax
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq -96(%rbp), %rax		# Access variable from another scope
	movq 16(%rax), %rax		# Move value into %rax
	movq %rdx, 8(%rax)		# Move right side into location of left side of assign
				# Start if statement 26
	movq $27, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq -96(%rbp), %rax		# Access variable from another scope
	movq 16(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
	pushq %rax				# Push right side to stack
	movq -96(%rbp), %rax		# Access variable from another scope
	movq 8(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
	popq %rbx				# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	je comp_skip_20			# Skip if they are equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_20			# Skip the alternative branch
comp_skip_20:
	movq $0, %rax			# Put false in %rax
comp_end_20:
	cmp $0, %rax			# Check the condition
	je else_part_26			# Skip to the else if the condition is false
	movq $-1, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_26				# Skip the else
else_part_26:
	movq $32, %rax			# Put a number in %rax
	call print				# Call the print procedure
end_26:
	pushq %rbp				# Push simple static link
	subq $8, %rsp			# Add dummy space
	call test33			# Call the test33 function
	addq $16, %rsp			# Deallocate dummy space and static link
	movq $1, %rax			# Put a number in %rax
	pushq %rax		# Push argument number 1 to stack
	pushq %rbp				# Push simple static link
	subq $8, %rsp			# Add dummy space
	call test34			# Call the test34 function
	addq $24, %rsp			# Deallocate dummy space, static link and arguments
	movq $0, %rax			# Put a number in %rax
	pushq %rax		# Push argument number 1 to stack
	pushq %rbp				# Push simple static link
	subq $8, %rsp			# Add dummy space
	call test35			# Call the test35 function
	addq $24, %rsp			# Deallocate dummy space, static link and arguments
	movq $36, %rax			# Put a number in %rax
	movq %rax, -104(%rbp)		# Move initialized value into space on stack
				# Start if statement 30
	movq -104(%rbp), %rax		# Access variable from another scope
	cmp $0, %rax			# Check the condition
	je end_30				# Skip if the condition is false
	pushq %rbp				# Push simple static link
	subq $8, %rsp			# Add dummy space
	call test36one			# Call the test36one function
	addq $16, %rsp			# Deallocate dummy space and static link
	jmp end_30				# Skip the else
end_30:
	movq $37, %rax			# Put a number in %rax
	movq %rax, -112(%rbp)		# Move initialized value into space on stack
	pushq %rbp				# Push simple static link
	subq $8, %rsp			# Add dummy space
	call f2			# Call the f2 function
	addq $16, %rsp			# Deallocate dummy space and static link
	call print				# Call the print procedure
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $40, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq c3_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	pushq %rbp				# Push simple static link
	pushq %rcx				# Push heap pointer
	call c3			# Call c3 constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $16, %rsp			# Deallocate heap pointer and static link
	movq %rax, -120(%rbp)		# Move initialized value into space on stack
	movq -120(%rbp), %rax		# Access variable from another scope
	pushq %rax				# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 0(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	pushq %rbp				# Push simple static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax				# Call method
	addq $24, %rsp			# Deallocate dummy space, static link and arguments
	call print				# Call the print procedure
	movq -120(%rbp), %rax		# Access variable from another scope
	pushq %rax				# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	pushq %rbp				# Push simple static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax				# Call method
	addq $24, %rsp			# Deallocate dummy space, static link and arguments
	call print				# Call the print procedure
	movq -120(%rbp), %rax		# Access variable from another scope
	pushq %rax				# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 16(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	pushq %rbp				# Push simple static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax				# Call method
	addq $24, %rsp			# Deallocate dummy space, static link and arguments
	call print				# Call the print procedure
	movq $39, %rax			# Put a number in %rax
	movq %rax, -128(%rbp)		# Move initialized value into space on stack
	pushq %rbp				# Push simple static link
	subq $8, %rsp			# Add dummy space
	call runIncrements			# Call the runIncrements function
	addq $16, %rsp			# Deallocate dummy space and static link
	movq -128(%rbp), %rax		# Access variable from another scope
	call print				# Call the print procedure
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $24, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq Calculator_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	pushq %rbp				# Push simple static link
	pushq %rcx				# Push heap pointer
	call Calculator			# Call Calculator constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $16, %rsp			# Deallocate heap pointer and static link
	movq %rax, -136(%rbp)		# Move initialized value into space on stack
	movq -136(%rbp), %rax		# Access variable from another scope
	pushq %rax				# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	pushq %rbp				# Push simple static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax				# Call method
	addq $24, %rsp			# Deallocate dummy space, static link and arguments
	call print				# Call the print procedure
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $16, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq Box_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	pushq %rbp				# Push simple static link
	pushq %rcx				# Push heap pointer
	call Box			# Call Box constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $16, %rsp			# Deallocate heap pointer and static link
	movq %rax, -144(%rbp)		# Move initialized value into space on stack
	movq -144(%rbp), %rax		# Access variable from another scope
	pushq %rax				# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 0(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	movq $43, %rax			# Put a number in %rax
	pushq %rax			# Push argument number 1 to stack
	pushq %rbp				# Push simple static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax				# Call method
	addq $32, %rsp			# Deallocate dummy space, static link and arguments
	movq -144(%rbp), %rax		# Access variable from another scope
	pushq %rax				# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	pushq %rbp				# Push simple static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax				# Call method
	addq $24, %rsp			# Deallocate dummy space, static link and arguments
	call print				# Call the print procedure
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $16, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq Outer_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	pushq %rbp				# Push simple static link
	pushq %rcx				# Push heap pointer
	call Outer			# Call Outer constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $16, %rsp			# Deallocate heap pointer and static link
	movq %rax, -152(%rbp)		# Move initialized value into space on stack
	movq -152(%rbp), %rax		# Access variable from another scope
	pushq %rax				# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 0(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	pushq %rbp				# Push simple static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax				# Call method
	addq $24, %rsp			# Deallocate dummy space, static link and arguments
	call print				# Call the print procedure
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $16, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq Accumulator_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	pushq %rbp				# Push simple static link
	pushq %rcx				# Push heap pointer
	call Accumulator			# Call Accumulator constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $16, %rsp			# Deallocate heap pointer and static link
	movq %rax, -160(%rbp)		# Move initialized value into space on stack
	movq -160(%rbp), %rax		# Access variable from another scope
	pushq %rax				# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 0(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	movq $20, %rax			# Put a number in %rax
	pushq %rax			# Push argument number 1 to stack
	pushq %rbp				# Push simple static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax				# Call method
	addq $32, %rsp			# Deallocate dummy space, static link and arguments
	movq -160(%rbp), %rax		# Access variable from another scope
	pushq %rax				# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 0(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	movq $25, %rax			# Put a number in %rax
	pushq %rax			# Push argument number 1 to stack
	pushq %rbp				# Push simple static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax				# Call method
	addq $32, %rsp			# Deallocate dummy space, static link and arguments
	movq -160(%rbp), %rax		# Access variable from another scope
	pushq %rax				# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	pushq %rbp				# Push simple static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax				# Call method
	addq $24, %rsp			# Deallocate dummy space, static link and arguments
	call print				# Call the print procedure
	movq $1, %rax			# Put true in %rax
	movq %rax, -168(%rbp)		# Move initialized value into space on stack
	movq $0, %rax			# Put false in %rax
	movq %rax, -176(%rbp)		# Move initialized value into space on stack
				# Start if statement 31
	movq -176(%rbp), %rax		# Access variable from another scope
	pushq %rax				# Push right side to stack
	movq -176(%rbp), %rax		# Access variable from another scope
	popq %rbx				# Pop right side into %rbx
	movq $0, %rdx			# Put FALSE in %rdx
	cmp %rax, %rdx			# Check if the left side is false
	je logical_false_22		# Skip to the false
	cmp %rbx, %rdx			# Check if the right side is false
	je logical_false_22		# Skip to the false
	movq $1, %rax			# Put true in %rax
	jmp logical_end_22		# Skip to the end
logical_false_22:
	movq $0, %rax			# Put false in %rax
logical_end_22:
	cmp $0, %rax			# Check the condition
	je end_31				# Skip if the condition is false
	movq $-1, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_31				# Skip the else
end_31:
				# Start if statement 32
	movq -168(%rbp), %rax		# Access variable from another scope
	pushq %rax				# Push right side to stack
	movq -176(%rbp), %rax		# Access variable from another scope
	popq %rbx				# Pop right side into %rbx
	movq $0, %rdx			# Put FALSE in %rdx
	cmp %rax, %rdx			# Check if the left side is false
	je logical_false_23		# Skip to the false
	cmp %rbx, %rdx			# Check if the right side is false
	je logical_false_23		# Skip to the false
	movq $1, %rax			# Put true in %rax
	jmp logical_end_23		# Skip to the end
logical_false_23:
	movq $0, %rax			# Put false in %rax
logical_end_23:
	cmp $0, %rax			# Check the condition
	je end_32				# Skip if the condition is false
	movq $-1, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_32				# Skip the else
end_32:
				# Start if statement 33
	movq -176(%rbp), %rax		# Access variable from another scope
	pushq %rax				# Push right side to stack
	movq -176(%rbp), %rax		# Access variable from another scope
	popq %rbx				# Pop right side into %rbx
	movq $0, %rdx			# Put FALSE in %rdx
	cmp %rax, %rdx			# Check if the left side is false
	jne logical_true_24		# Skip to the true
	cmp %rbx, %rdx			# Check if the right side is false
	jne logical_true_24		# Skip to the true
	movq $0, %rax			# Put false in %rax
	jmp logical_end_24		# Skip to the end
logical_true_24:
	movq $1, %rax			# Put true in %rax
logical_end_24:
	cmp $0, %rax			# Check the condition
	je end_33				# Skip if the condition is false
	movq $-1, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_33				# Skip the else
end_33:
				# Start if statement 34
	movq -168(%rbp), %rax		# Access variable from another scope
	pushq %rax				# Push right side to stack
	movq -176(%rbp), %rax		# Access variable from another scope
	popq %rbx				# Pop right side into %rbx
	movq $0, %rdx			# Put FALSE in %rdx
	cmp %rax, %rdx			# Check if the left side is false
	jne logical_true_25		# Skip to the true
	cmp %rbx, %rdx			# Check if the right side is false
	jne logical_true_25		# Skip to the true
	movq $0, %rax			# Put false in %rax
	jmp logical_end_25		# Skip to the end
logical_true_25:
	movq $1, %rax			# Put true in %rax
logical_end_25:
	cmpq $0, %rax			# Invert flag
	sete %al			# Invert flag
	movzbl %al, %eax			# Invert flag
	cmp $0, %rax			# Check the condition
	je end_34				# Skip if the condition is false
	movq $-1, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_34				# Skip the else
end_34:
				# Start if statement 35
	movq -168(%rbp), %rax		# Access variable from another scope
	cmpq $0, %rax			# Invert flag
	sete %al			# Invert flag
	movzbl %al, %eax			# Invert flag
	pushq %rax				# Push right side to stack
	movq -176(%rbp), %rax		# Access variable from another scope
	popq %rbx				# Pop right side into %rbx
	movq $0, %rdx			# Put FALSE in %rdx
	cmp %rax, %rdx			# Check if the left side is false
	jne logical_true_26		# Skip to the true
	cmp %rbx, %rdx			# Check if the right side is false
	jne logical_true_26		# Skip to the true
	movq $0, %rax			# Put false in %rax
	jmp logical_end_26		# Skip to the end
logical_true_26:
	movq $1, %rax			# Put true in %rax
logical_end_26:
	cmp $0, %rax			# Check the condition
	je end_35				# Skip if the condition is false
	movq $-1, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_35				# Skip the else
end_35:
				# Start if statement 36
	movq -168(%rbp), %rax		# Access variable from another scope
	cmpq $0, %rax			# Invert flag
	sete %al			# Invert flag
	movzbl %al, %eax			# Invert flag
	pushq %rax				# Push right side to stack
	movq -168(%rbp), %rax		# Access variable from another scope
	popq %rbx				# Pop right side into %rbx
	movq $0, %rdx			# Put FALSE in %rdx
	cmp %rax, %rdx			# Check if the left side is false
	je logical_false_27		# Skip to the false
	cmp %rbx, %rdx			# Check if the right side is false
	je logical_false_27		# Skip to the false
	movq $1, %rax			# Put true in %rax
	jmp logical_end_27		# Skip to the end
logical_false_27:
	movq $0, %rax			# Put false in %rax
logical_end_27:
	cmp $0, %rax			# Check the condition
	je end_36				# Skip if the condition is false
	movq $-1, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_36				# Skip the else
end_36:
				# Start if statement 37
	movq -168(%rbp), %rax		# Access variable from another scope
	pushq %rax				# Push right side to stack
	movq -168(%rbp), %rax		# Access variable from another scope
	popq %rbx				# Pop right side into %rbx
	movq $0, %rdx			# Put FALSE in %rdx
	cmp %rax, %rdx			# Check if the left side is false
	je logical_false_28		# Skip to the false
	cmp %rbx, %rdx			# Check if the right side is false
	je logical_false_28		# Skip to the false
	movq $1, %rax			# Put true in %rax
	jmp logical_end_28		# Skip to the end
logical_false_28:
	movq $0, %rax			# Put false in %rax
logical_end_28:
	pushq %rax				# Push right side to stack
	movq -168(%rbp), %rax		# Access variable from another scope
	pushq %rax				# Push right side to stack
	movq -176(%rbp), %rax		# Access variable from another scope
	popq %rbx				# Pop right side into %rbx
	movq $0, %rdx			# Put FALSE in %rdx
	cmp %rax, %rdx			# Check if the left side is false
	jne logical_true_29		# Skip to the true
	cmp %rbx, %rdx			# Check if the right side is false
	jne logical_true_29		# Skip to the true
	movq $0, %rax			# Put false in %rax
	jmp logical_end_29		# Skip to the end
logical_true_29:
	movq $1, %rax			# Put true in %rax
logical_end_29:
	popq %rbx				# Pop right side into %rbx
	movq $0, %rdx			# Put FALSE in %rdx
	cmp %rax, %rdx			# Check if the left side is false
	je logical_false_30		# Skip to the false
	cmp %rbx, %rdx			# Check if the right side is false
	je logical_false_30		# Skip to the false
	movq $1, %rax			# Put true in %rax
	jmp logical_end_30		# Skip to the end
logical_false_30:
	movq $0, %rax			# Put false in %rax
logical_end_30:
	pushq %rax				# Push right side to stack
	movq -168(%rbp), %rax		# Access variable from another scope
	pushq %rax				# Push right side to stack
	movq -176(%rbp), %rax		# Access variable from another scope
	popq %rbx				# Pop right side into %rbx
	movq $0, %rdx			# Put FALSE in %rdx
	cmp %rax, %rdx			# Check if the left side is false
	je logical_false_31		# Skip to the false
	cmp %rbx, %rdx			# Check if the right side is false
	je logical_false_31		# Skip to the false
	movq $1, %rax			# Put true in %rax
	jmp logical_end_31		# Skip to the end
logical_false_31:
	movq $0, %rax			# Put false in %rax
logical_end_31:
	popq %rbx				# Pop right side into %rbx
	movq $0, %rdx			# Put FALSE in %rdx
	cmp %rax, %rdx			# Check if the left side is false
	jne logical_true_32		# Skip to the true
	cmp %rbx, %rdx			# Check if the right side is false
	jne logical_true_32		# Skip to the true
	movq $0, %rax			# Put false in %rax
	jmp logical_end_32		# Skip to the end
logical_true_32:
	movq $1, %rax			# Put true in %rax
logical_end_32:
	cmp $0, %rax			# Check the condition
	je end_37				# Skip if the condition is false
	movq $46, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_37				# Skip the else
end_37:
				# Start if statement 38
	movq -184(%rbp), %rax		# Access variable from another scope
	cmp $0, %rax			# Check the condition
	je else_part_38			# Skip to the else if the condition is false
	movq $47, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_38				# Skip the else
else_part_38:
	movq $-1, %rax			# Put a number in %rax
	call print				# Call the print procedure
end_38:
	movq $0, %rax			# Put a number in %rax
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq -184(%rbp), %rax		# Access variable from another scope
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq %rdx, -184(%rax)		# Move right side into location of left side of assign
	movq $0, %rax			# Put a number in %rax
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq -192(%rbp), %rax		# Access variable from another scope
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq %rdx, -192(%rax)		# Move right side into location of left side of assign
	movq $0, %rax			# Put a number in %rax
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq -200(%rbp), %rax		# Access variable from another scope
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq %rdx, -200(%rax)		# Move right side into location of left side of assign
				# Start if statement 39
	movq -200(%rbp), %rax		# Access variable from another scope
	pushq %rax				# Push right side to stack
	movq -192(%rbp), %rax		# Access variable from another scope
	pushq %rax				# Push right side to stack
	movq -184(%rbp), %rax		# Access variable from another scope
	popq %rbx				# Pop right side into %rbx
	movq $0, %rdx			# Put FALSE in %rdx
	cmp %rax, %rdx			# Check if the left side is false
	jne logical_true_33		# Skip to the true
	cmp %rbx, %rdx			# Check if the right side is false
	jne logical_true_33		# Skip to the true
	movq $0, %rax			# Put false in %rax
	jmp logical_end_33		# Skip to the end
logical_true_33:
	movq $1, %rax			# Put true in %rax
logical_end_33:
	popq %rbx				# Pop right side into %rbx
	movq $0, %rdx			# Put FALSE in %rdx
	cmp %rax, %rdx			# Check if the left side is false
	jne logical_true_34		# Skip to the true
	cmp %rbx, %rdx			# Check if the right side is false
	jne logical_true_34		# Skip to the true
	movq $0, %rax			# Put false in %rax
	jmp logical_end_34		# Skip to the end
logical_true_34:
	movq $1, %rax			# Put true in %rax
logical_end_34:
	cmp $0, %rax			# Check the condition
	je else_part_39			# Skip to the else if the condition is false
	movq $-1, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_39				# Skip the else
else_part_39:
	movq $48, %rax			# Put a number in %rax
	call print				# Call the print procedure
end_39:
	movq $5, %rax			# Put a number in %rax
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq -184(%rbp), %rax		# Access variable from another scope
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq %rdx, -184(%rax)		# Move right side into location of left side of assign
	movq $0, %rax			# Put false in %rax
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq -192(%rbp), %rax		# Access variable from another scope
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq %rdx, -192(%rax)		# Move right side into location of left side of assign
				# Start if statement 40
	movq -192(%rbp), %rax		# Access variable from another scope
	pushq %rax				# Push right side to stack
	movq -184(%rbp), %rax		# Access variable from another scope
	popq %rbx				# Pop right side into %rbx
	movq $0, %rdx			# Put FALSE in %rdx
	cmp %rax, %rdx			# Check if the left side is false
	jne logical_true_35		# Skip to the true
	cmp %rbx, %rdx			# Check if the right side is false
	jne logical_true_35		# Skip to the true
	movq $0, %rax			# Put false in %rax
	jmp logical_end_35		# Skip to the end
logical_true_35:
	movq $1, %rax			# Put true in %rax
logical_end_35:
	cmp $0, %rax			# Check the condition
	je else_part_40			# Skip to the else if the condition is false
	movq $49, %rax			# Put a number in %rax
	call print				# Call the print procedure
	jmp end_40				# Skip the else
else_part_40:
	movq $-1, %rax			# Put a number in %rax
	call print				# Call the print procedure
end_40:
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $16, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq theCompilerWorks_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	pushq %rbp				# Push simple static link
	pushq %rcx				# Push heap pointer
	call theCompilerWorks			# Call theCompilerWorks constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $16, %rsp			# Deallocate heap pointer and static link
	movq %rax, -208(%rbp)		# Move initialized value into space on stack
	movq -208(%rbp), %rax		# Access variable from another scope
	pushq %rax				# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 0(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	pushq %rbp				# Push simple static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax				# Call method
	addq $24, %rsp			# Deallocate dummy space, static link and arguments
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $16, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq ExtraTest_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	pushq %rbp				# Push simple static link
	pushq %rcx				# Push heap pointer
	call ExtraTest			# Call ExtraTest constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $16, %rsp			# Deallocate heap pointer and static link
	movq 8(%rax), %rax		# Move value into %rax
	movq %rax, -216(%rbp)		# Move initialized value into space on stack
	movq -216(%rbp), %rax		# Access variable from another scope
	call print				# Call the print procedure
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $8, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq otherTest_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	pushq %rbp				# Push simple static link
	pushq %rcx				# Push heap pointer
	call otherTest			# Call otherTest constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $16, %rsp			# Deallocate heap pointer and static link
	pushq %rax				# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 0(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	pushq %rbp				# Push simple static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax				# Call method
	addq $24, %rsp			# Deallocate dummy space, static link and arguments
	movq 8(%rax), %rax		# Move value into %rax
	call print				# Call the print procedure
	movq $1, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	pushq %rbp				# Push simple static link
	subq $8, %rsp			# Add dummy space
	call funnyFunc			# Call the funnyFunc function
	addq $16, %rsp			# Deallocate dummy space and static link
	movq 8(%rax), %rax		# Move value into %rax
	popq %rbx				# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	call print				# Call the print procedure
	movq $30, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq $4, %rax			# Put a number in %rax
	pushq %rax		# Push argument number 1 to stack
	pushq %rbp				# Push simple static link
	subq $8, %rsp			# Add dummy space
	call factorial			# Call the factorial function
	addq $24, %rsp			# Deallocate dummy space, static link and arguments
	popq %rbx				# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	call print				# Call the print procedure
	addq $216, %rsp			# Deallocate space for local variables on the stack
	popq %rbp				# Restore base pointer
	movq $0, %rax			# End with error code 0
	ret			# Return from main
