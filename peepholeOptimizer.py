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
                        
            # Remove the instructions marked as garbage using list comprehension (safe)            
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
                    