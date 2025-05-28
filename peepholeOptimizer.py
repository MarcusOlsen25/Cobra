from visitors.instruction import *

class PeepholeOptimizer:
    
    def __init__(self, instructions: list[Instruction]):
        self.instructions = instructions
        self.indexesToRemove = []
        
    def terminatingFunction(self):
        return len(self.instructions)
    
    def optimise(self):
        done = False
        lengthBefore = self.terminatingFunction()
        
        while not done:
            
            startVal = self.terminatingFunction()
            
            # Examine each instruction
            for i in range(len(self.instructions)):
                self.optimiseNoLocalVariables(i)
                self.optimiseAdditionsToRSP(i)
                self.optimisePushSimpleSL(i)
                self.optimiseSaveBasePointer(i)
                self.optimiseAssembleDummies(i)
                self.optimiseInstantNegation(i)

                # self.optimiseDirectInitialization(i)
                hwllo = 9
                        
            # Remove the instructions marked as garbage     
            # Reverse iteration prevents index problems     
            for i in reversed(range(len(self.instructions))):
                if i in self.indexesToRemove:
                    del self.instructions[i]
            
            endVal = self.terminatingFunction()
            
            # Clear the list so it doesn't affect the next iteration
            self.indexesToRemove = []
            
            # If the code was not optimised during this traversal, then it cannot be further optimised
            done = not endVal < startVal
            
        lengthAfter = self.terminatingFunction()
        print(f"Optimised {lengthBefore - lengthAfter} lines. :)")
    
    
    
    # Finds and removes allocation and deallocation of nothing at all
    def optimiseNoLocalVariables(self, index: int):
        '''
        Remove both:
        addq $0, %rsp   # Allocate space for local variables on the stack
        subq $0, %rsp   # Deallocate space for local variables on the stack
        '''
        one = self.instructions[index]
        if ((one.upcode == "addq" or one.upcode == "subq") and one.operand1 == "$0" 
            and one.operand2 == "%rsp"):
            self.indexesToRemove.append(index)
    
    
    
    # Deallocates multiple things at once
    def optimiseAdditionsToRSP(self, index: int):
        '''
        addq $8, %rsp   # Deallocate space on stack for (heap pointer / dummy space)
        addq $8, %rsp   # Deallocate space on stack for static link
        addq $8, %rsp   # Pop the arguments pushed to the stack
        ->
        addq $24, %rsp  # Deallocate dummy space, static link and arguments
        '''
        # New instructions
        heapAndStatic = Instruction("addq", "$16", "%rsp", None, 3, "# Deallocate heap pointer and static link")
        oneDummyAndStatic = Instruction("addq", "$16", "%rsp", None, 3, "# Deallocate dummy space and static link")
        twoDummyAndStatic = Instruction("addq", "$24", "%rsp", None, 3, "# Deallocate dummy spaces and static link")
        
        # In case we are at the last instruction
        if index >= len(self.instructions) - 1:
            return
        else:
            
            one = self.instructions[index]
            two = self.instructions[index+1]
            
            if (two.upcode == "addq" and two.operand1 == "$8" and two.operand2 == "%rsp" 
                and two.comment == "# Deallocate space on stack for static link"):
                
                if one.upcode == "addq" and one.operand1 == "$8" and one.operand2 == "%rsp":
                        if one.comment == "# Deallocate space on stack for heap pointer":
                            self.indexesToRemove.append(index)
                            self.instructions[index+1] = heapAndStatic
                        elif one.comment == "# Remove dummy space":
                            self.indexesToRemove.append(index)
                            self.instructions[index+1] = oneDummyAndStatic
                            
                elif (one.upcode == "addq" and one.operand1 == "$16" and one.operand2 == "%rsp" 
                      and one.comment == "# Remove dummy spaces"):
                        self.indexesToRemove.append(index)
                        self.instructions[index+1] = twoDummyAndStatic
            
            # In a second round optimise deallocation of arguments after a call
            elif (one.upcode == "addq" and one.operand1 == "$16" and one.operand2 == "%rsp" 
                  and one.comment == "# Deallocate dummy space and static link"):
                if (two.upcode == "addq" and two.operand2 == "%rsp" and two.comment == "# Pop the arguments pushed to the stack"):
                    newValue = int(two.operand1.lstrip("$")) + 16
                    one.operand1 = f"${newValue}"
                    one.comment = "# Deallocate dummy space, static link and arguments"
                    self.indexesToRemove.append(index+1)
                    
                            
    # The static link doesn't always need to be prepared
    def optimisePushSimpleSL(self, index: int):
        '''
        movq %rbp, %rax     # Prepare static link
        pushq %rax          # Push static link
        ->
        pushq %rbp          # Push simple static link
        '''
        one = self.instructions[index]
        if (one.upcode == "movq" and one.operand1 == "%rbp" and one.operand2 == "%rax" and one.comment == "# Prepare static link"):
            
            two = self.instructions[index+1]
            
            if (two.upcode == "pushq" and two.operand1 == "%rax" and two.comment == "# Push static link"):
            
                simpleSL = Instruction("pushq", "%rbp", None, None, 4, "# Push simple static link")
                self.indexesToRemove.append(index)
                self.instructions[index+1] = simpleSL
                
    
    # Can the heap pointer be pushed in one go? 
    # Once put in %rcx it is used in many places...
    def optimisePushHP(self, index: int):
        one = self.instructions[index]
                
                
    

    # Avoids saving base pointer pointlessly                    
    def optimiseSaveBasePointer(self, index: int):
        '''
        We need to maintain the stack frame structure
        pushq %rbp          # Save base pointer
        movq %rsp, %rbp		# Make stack pointer new base pointer
        ...                 (No use of the base pointer)
        popq %rbp			# Restore base pointer
        ->
        subq $8, %rsp       # Add dummy base pointer
        ...
        addq $8, %rsp       # Remove dummy base pointer
        '''
        
        one = self.instructions[index]
        
        if (one.upcode == "pushq" and one.operand1 == "%rbp" and one.comment == "# Save base pointer"
            and self.instructions[index-1].label != "main"):
            
            addDummy = Instruction("subq", "$8", "%rsp", None, 3, "# Add dummy base pointer")
            remDummy = Instruction("addq", "$8", "%rsp", None, 3, "# Remove dummy base pointer")
                        
            done = False
            i = index + 1
            while not done and i < len(self.instructions):
                two = self.instructions[i]
                
                # Saving the base pointer again, accessing another scope, 
                # traversing the static link, pushing the heap pointer, or calling anything other than print
                if (two.comment == "# Save base pointer" or two.comment == "# Prepare to access variable from another scope" 
                    or two.comment == "# Traverse static link once" or (two.upcode == "call" and two.operand1 != "print")
                    or two.comment == "# Push heap pointer"):
                    done = True
                
                # Restoring it again while in this loop means it is pointless
                elif (two.upcode == "popq" and two.operand1 == "%rbp" and two.comment == "# Restore base pointer"):
                    self.indexesToRemove.append(index)
                    self.instructions[index+1] = addDummy
                    self.instructions[i] = remDummy
                    
                    done = True
                
                i += 1
                
                
                
                
    # Add dummy spaces more efficiently
    def optimiseAssembleDummies(self, index: int):
        '''
        subq $16, %rsp			# Add dummy spaces
    	subq $8, %rsp			# Add dummy base pointer
        ->
        subq $24, %rsp          # Add many dummy spaces
        
        addq $8, %rsp			# Remove dummy base pointer
    	addq $24, %rsp			# Deallocate dummy spaces and static link
        ->
        addq $32, %rsp          # Deallocate many dummy spaces and static link
        '''
        two = self.instructions[index]
        
        if two.comment == "# Add dummy base pointer":
            one = self.instructions[index-1]
            if one.comment == "# Add dummy spaces" and one.operand1 == "$16":
                two.operand1 = "$24"
                two.comment =  "# Add many dummy spaces"
                self.indexesToRemove.append(index-1)
        
        elif two.comment == "# Deallocate dummy spaces and static link":
            one = self.instructions[index-1]
            if one.comment == "# Remove dummy base pointer":
                two.operand1 = "$32"
                two.comment = "# Deallocate many dummy spaces and static link"
                self.indexesToRemove.append(index-1)
                
                
                
                
    # Negate numbers in a single step
    def optimiseInstantNegation(self, index: int):
        '''
        movq $1, %rax			# Put a number in %rax
    	negq %rax				# Negate value
        ->
        movq $-1, %rax          # Put a number in %rax
        '''
        two = self.instructions[index]
        if two.comment == "# Negate value":
            one = self.instructions[index-1]
            if one.comment == "# Put a number in %rax":
                # Logic to negate and deal with multiple '-'s
                number = one.operand1.lstrip("$")
                number = "-" + number
                minus_count = number.count('-')
                if minus_count % 2 == 0:
                    number = number.replace('-', '')
                one.operand1 = "$" + number
                self.indexesToRemove.append(index)

           
                
                    
                    
    
    
    
    
    
    # Error: operand type mismatch for `movq'    (Damn it! It was a good idea...)
    # Some initialized values can be put directly where they belong
    def optimiseDirectInitialization(self, index: int):
        '''
        movq $3, %rax           # Put a number in %rax
        movq %rax, -8(%rbp)     # Move initialized value into space on stack
        ->
        movq $3, -8(%rbp)       # Move initialized value directly into space on stack
        '''
        two = self.instructions[index]
        
        if (two.upcode == "movq" and two.operand1 == "%rax" and 
            two.comment == "# Move initialized value into space on stack"):
            
            one = self.instructions[index-1]
            
            if (one.upcode == "movq" and one.operand2 == "%rax"):
            
                self.indexesToRemove.append(index-1)
                two.operand2 = one.operand1
                two.comment = "# Move initialized value directly into space on stack"
            