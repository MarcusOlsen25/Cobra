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
                # self.optimiseDirectInitialization(i)
                # self.optimiseSaveBasePointer(i)
                        
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
        instruction = self.instructions[index]
        if (instruction.upcode == "addq" or instruction.upcode == "subq"):
            if instruction.operand1 == "$0":
                if instruction.operand2 == "%rsp":
                    self.indexesToRemove.append(index)
    
    
    
    # Deallocates multiple things at once
    def optimiseAdditionsToRSP(self, index: int):
        
        # New instructions
        heapAndStatic = Instruction("addq", "$16", "%rsp", None, 3, "# Deallocate heap pointer and static link")
        oneDummyAndStatic = Instruction("addq", "$16", "%rsp", None, 3, "# Deallocate dummy space and static link")
        twoDummyAndStatic = Instruction("addq", "$24", "%rsp", None, 3, "# Deallocate dummy spaces and static link")
        
        # In case we are at the last instruction
        if index >= len(self.instructions) - 1:
            return
        else:
            
            current = self.instructions[index]
            next = self.instructions[index+1]
            
            if (next.upcode == "addq" and next.operand1 == "$8" and next.operand2 == "%rsp" 
                and next.comment == "# Deallocate space on stack for static link"):
                
                if current.upcode == "addq" and current.operand1 == "$8" and current.operand2 == "%rsp":
                        if current.comment == "# Deallocate space on stack for heap pointer":
                            self.indexesToRemove.append(index)
                            self.instructions[index+1] = heapAndStatic
                        elif current.comment == "# Remove dummy space":
                            self.indexesToRemove.append(index)
                            self.instructions[index+1] = oneDummyAndStatic
                            
                elif (current.upcode == "addq" and current.operand1 == "$16" and current.operand2 == "%rsp" 
                      and current.comment == "# Remove dummy spaces"):
                        self.indexesToRemove.append(index)
                        self.instructions[index+1] = twoDummyAndStatic
                            
    # The static link doesn't always need to be prepared
    def optimisePushSimpleSL(self, index: int):
        one = self.instructions[index]
        if (one.upcode == "movq" and one.operand1 == "%rbp" and one.operand2 == "%rax" and one.comment == "# Prepare static link"):
            
            two = self.instructions[index+1]
            
            if (two.upcode == "pushq" and two.operand1 == "%rax" and two.comment == "# Push static link"):
            
                simpleSL = Instruction("pushq", "%rbp", None, None, 4, "# Push simple static link")
                self.indexesToRemove.append(index)
                self.instructions[index+1] = simpleSL
                
    
    # Error: operand type mismatch for `movq'    (Damn it! It was a good idea...)
    # Some initialized values can be put directly where they belong
    def optimiseDirectInitialization(self, index: int):
        two = self.instructions[index]
        
        if (two.upcode == "movq" and two.operand1 == "%rax" and 
            two.comment == "# Move initialized value into space on stack"):
            
            one = self.instructions[index-1]
            
            if (one.upcode == "movq" and one.operand2 == "%rax"):
            
                self.indexesToRemove.append(index-1)
                two.operand2 = one.operand1
                two.comment = "# Move initialized value directly into space on stack"
                
    
    # This function is not ready yet... It proved to be more complex than I thought.
    # Avoids saving base pointer pointlessly                    
    def optimiseSaveBasePointer(self, index: int):
        
        one = self.instructions[index]
        
        if (one.upcode == "pushq" and one.operand1 == "%rbp" and one.comment == "# Save base pointer"
            and self.instructions[index-1].label != "main"):
            
            # print(f"We start with the index {index+1}")
            
            done = False
            i = index + 1
            while not done and i < len(self.instructions):
                two = self.instructions[i]
                
                # Saving the base pointer again or accessing, traversing the static link, or calling anything other than print
                if ((two.upcode == "pushq" and two.operand1 == "%rbp" and two.comment == "# Save base pointer")
                   or (two.upcode == "movq" and two.operand1 == "24(%rax)" and two.operand2 == "%rax" 
                   and two.comment == "# Traverse static link once") 
                   or (two.upcode == "call" and two.operand1 != "print")):
                    done = True
                
                # Restoring it again while in this loop means it is pointless
                elif (two.upcode == "popq" and two.operand1 == "%rbp" and two.comment == "# Restore base pointer"):
                    self.indexesToRemove.append(index)
                    self.indexesToRemove.append(index+1)
                    self.indexesToRemove.append(i)
                    done = True
                    print(index)
                    # print(index+1)
                    # print(i)
                
                i += 1
                    
            