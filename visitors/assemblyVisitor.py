from .visitor import Visitor
from ASTexpressions import *
from scope.SymbolTable import *
from ASTstatements import *

class AssemblyVisitor(Visitor):

    def __init__(self, table: SymbolTable):
        self.table = table
        self.main = [".globl main", "main:", "pushq %rbp\t\t\t# Save base pointer", "movq %rsp, %rbp\t\t\t# Make stack pointer new base pointer"]
        self.functions = {"text": [".text"]}
        self.functionStack = []
        self.ifLabelCounter = 0
        self.whileLabelCounter = 0

    def generateCode(self, output: str):
        if len(self.functionStack) == 0:
            self.main.append(output)
        else:
            current_function = self.functionStack[-1]
            self.functions[current_function].append("\t" + output)
    
    def visitBinaryExpression(self, expr: BinaryExpression):
        expr.right.accept(self)
        self.generateCode("pushq %rax\t\t\t# Push right side to stack")
        expr.left.accept(self)
        self.generateCode("popq %rbx\t\t\t# Pop right side into %rbx")

        match expr.operator:
            case "+":
                self.generateCode("addq %rbx, %rax\t\t\t# Add both sides")
            case "-":
                self.generateCode("subq %rbx, %rax\t\t\t# Subtract both sides")
            case "*":
                self.generateCode("imulq %rbx, %rax\t\t# Multiply both sides")
            case "/":
                self.generateCode("movq $0, %rdx\t\t\t# Put a 0 in %rdx to prepare for the division")
                self.generateCode("idivq %rbx\t\t\t# Divide both sides")

    def visitNumberExpression(self, expr: NumberExpression):
        self.generateCode(f"movq ${expr.value}, %rax\t\t\t# Put a number in %rax")
    
    def visitVarExpression(self, expr: VarExpression):
        entry = self.table.lookup(expr.var)
        if isinstance(entry, SymbolTable.FunctionValue):
            return entry
        else:
            self.generateCode(f"movq {entry.offset}(%rbp), %rax\t\t# Assign an argument to %rax")
    
    def visitAssignExpression(self, expr: AssignExpression):
        pass
    
    def visitVarDeclaration(self, stmt: VarDeclaration):
        if stmt.initializer != None:
            entry = self.table.lookup(stmt.var)
            stmt.initializer.accept(self)
            self.generateCode(f"movq %rax, {-entry.offset}(%rbp)\t\t# Move initialized value into space on stack")
        else:
            pass
        
    def visitFunctionDeclaration(self, stmt: FunctionDeclaration):
        self.functionStack.append(stmt.var)

        self.functions[stmt.var] = [f"{stmt.var}:"]

        entry = self.table.lookup(stmt.var)
        self.table = entry.table

        self.startFunction(self.table.varCounter)

        for s in stmt.body:
            s.accept(self)

        self.endFunction(len(stmt.params), self.table.varCounter)

        self.table = self.table.parent

        self.functionStack.pop()

    def visitCallExpression(self, expr: CallExpression):
        entry = expr.var.accept(self)

        for i in range(len(expr.arguments)-1, -1, -1):
            expr.arguments[i].accept(self)
            self.generateCode(f"pushq %rax\t\t\t# Push argument number {i+1} to stack")

        self.generateCode(f"call {entry.name}\t\t\t# Call the {entry.name} function ")
        self.generateCode(self.popArgs(len(expr.arguments)))

    def visitParameterStatement(self, stmt: ParameterStatement):
        pass

    def startFunction(self, varSpace: int):
        self.generateCode("pushq %rbp\t\t\t# Save base pointer\n\tmovq %rsp, %rbp\t\t\t# Make stack pointer new base pointer")

        self.generateCode(f"subq ${varSpace}, %rsp\t\t\t# Allocate space for local variables on the stack")

    def endFunction(self, args: int, varSpace: int):
        self.generateCode(f"addq ${varSpace}, %rsp\t\t\t# Deallocate space for local variables on the stack")
        self.generateCode("popq %rbp\t\t\t# Restore base pointer")
        self.generateCode("ret\t\t\t\t# Return from the function")

    def popArgs(self, args: int):
        argsToPop = 8 * args
        return f"addq ${argsToPop}, %rsp\t\t\t# Pop the arguments pushed to the stack"
    
    def visitIfStatement(self, stmt: IfStatement):
        # For now 0 is false and everything else is true
        stmt.condition.accept(self)
        self.generateCode("cmp $0, %rax\t\t\t# Check the condition")
        
        if stmt.elseStatement == None:

            self.generateCode(f"je end_if_{self.ifLabelCounter}\t\t\t# Skip if the condition is false")
            
            for s in stmt.thenStatement:
                s.accept(self)
            
            self.generateCode(f"end_if_{self.ifLabelCounter}:")
        
        else:
        
            self.generateCode(f"je else_part_{self.ifLabelCounter}\t\t\t# Skip to the else if the condition is false")
            
            for s in stmt.thenStatement:
                s.accept(self)
            self.generateCode(f"jmp end_if_{self.ifLabelCounter}\t\t\t# Skip the else")
                
            self.generateCode(f"else_part_{self.ifLabelCounter}:")
            
            for s in stmt.elseStatement:
                s.accept(self)
                
            self.generateCode(f"end_if_{self.ifLabelCounter}:")
        
        self.ifLabelCounter += 1
        
    def visitWhileStatement(self, stmt: WhileStatement):
        self.generateCode(f"while_loop_{self.whileLabelCounter}:")
        
        # For now 0 is false and everything else is true
        stmt.condition.accept(self)
        self.generateCode("cmp $0, %rax\t\t\t# Check the condition")
        self.generateCode(f"je end_while_{self.whileLabelCounter}\t\t\t# Skip if the condition is false")
        
        for s in stmt.thenStatement:
                s.accept(self)
        
        self.generateCode(f"jmp while_loop_{self.whileLabelCounter}\t\t# Restart the loop")
        self.generateCode(f"end_while_{self.whileLabelCounter}:")
        self.whileLabelCounter += 1
