# A class to represent Assembly instructions and code
class Instruction:
    def __init__(self, upcode: str, operand1: str, operand2: str, label: str, tabOffset: int, comment: str):
        self.upcode = upcode
        self.operand1 = operand1
        self.operand2 = operand2
        self.label = label
        self.tabOffset = tabOffset
        self.comment = comment      # It needs to include the "#"
    

def prettyPrintAssembly(line: Instruction):    
    instruction = ""
        
    # In case it is a label
    if line.label != None:
        instruction += f"{line.label}:"
    # In case it is an instruction
    elif line.upcode != None:
        instruction += f"\t{line.upcode}"
        if line.operand1 != None:
            instruction += f" {line.operand1}"
            if line.operand2 != None:
                instruction += f", {line.operand2}"
    # In case it has a comment
    if line.comment != None:
        if line.tabOffset != None:
            tabs = '\t' * line.tabOffset
        else:
            tabs = ""
        instruction += f"{tabs}{line.comment}"
    return instruction
    