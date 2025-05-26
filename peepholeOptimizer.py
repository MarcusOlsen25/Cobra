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
            
            if current.upcode == "addq" and (current.operand1 == "$8" or current.operand1 == "$16") and current.operand2 == "%rsp":
                if next.upcode == "addq" and next.operand1 == "$8" and next.operand2 == "%rsp":
                    
                    if next.comment == "# Deallocate space on stack for static link":
                        
                        if current.comment == "# Deallocate space on stack for heap pointer":
                            self.indexesToRemove.append(index)
                            self.instructions[index+1] = heapAndStatic
                        elif current.comment == "# Remove dummy space":
                            self.indexesToRemove.append(index)
                            self.instructions[index+1] = oneDummyAndStatic
                        elif current.comment == "# Remove dummy spaces":
                            self.indexesToRemove.append(index)
                            self.instructions[index+1] = twoDummyAndStatic
            
            
    