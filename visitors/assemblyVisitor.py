from .visitor import Visitor
from ASTexpressions import *
from scope.SymbolTable import *
from ASTstatements import *

class AssemblyVisitor(Visitor):

    def __init__(self, table: SymbolTable):
        self.table = table
        self.main = [".globl main", "main:"]
        self.functions = {"text": [".text"]}
        self.functionStack = []
        self.ifLabelCounter = 0
        self.whileLabelCounter = 0
        self.binaryLabelCounter = 0
        self.printLabelCounter = 0
        self.labelStack = []

    def generateCode(self, output: str):
        if len(self.functionStack) == 0:
            self.main.append("\t" + output)
        else:
            current_function = self.functionStack[-1]
            self.functions[current_function].append("\t" + output)

    def addLabel(self, output: str):
        if len(self.functionStack) == 0:
            self.main.append(output)
        else:
            current_function = self.functionStack[-1]
            self.functions[current_function].append(output)
    
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
            case "==":
                self.equalityComparison()
            case "!=":
                self.inequalityComparison()
            case ">":
                self.greaterComparison()
            case "<":
                self.lessComparison()
            case ">=":
                self.greaterOrEqualComparison()
            case "<=":
                self.lessOrEqualComparison()
            case "and":
                self.andLogical()
            case "or":
                self.orLogical()
    
    def equalityComparison(self):
        # Save label counter and update it
        label = self.binaryLabelCounter
        self.binaryLabelCounter += 1
        self.generateCode("cmp %rax, %rbx\t\t\t# Compare both sides")
        self.generateCode(f"jne comp_skip_{label}\t\t\t# Skip if they are not equal")
        self.generateCode("movq $1, %rax\t\t\t# Put TRUE in %rax")
        self.generateCode(f"jmp comp_end_{label}\t\t\t# Skip the alternative branch")
        self.generateCode(f"comp_skip_{label}:")
        self.generateCode("movq $0, %rax\t\t\t# Put FALSE in %rax")
        self.generateCode(f"comp_end_{label}:")
        
    def inequalityComparison(self):
        # Save label counter and update it
        label = self.binaryLabelCounter
        self.binaryLabelCounter += 1
        self.generateCode("cmp %rax, %rbx\t\t\t# Compare both sides")
        self.generateCode(f"je comp_skip_{label}\t\t\t# Skip if they are equal")
        self.generateCode("movq $1, %rax\t\t\t# Put TRUE in %rax")
        self.generateCode(f"jmp comp_end_{label}\t\t\t# Skip the alternative branch")
        self.generateCode(f"comp_skip_{label}:")
        self.generateCode("movq $0, %rax\t\t\t# Put FALSE in %rax")
        self.generateCode(f"comp_end_{label}:")
        
    def greaterComparison(self):
        # Save label counter and update it
        label = self.binaryLabelCounter
        self.binaryLabelCounter += 1
        self.generateCode("cmp %rax, %rbx\t\t\t# Compare both sides")
        self.generateCode(f"jge comp_skip_{label}\t\t\t# Skip if right side is greater or equal")
        self.generateCode("movq $1, %rax\t\t\t# Put TRUE in %rax")
        self.generateCode(f"jmp comp_end_{label}\t\t\t# Skip the alternative branch")
        self.generateCode(f"comp_skip_{label}:")
        self.generateCode("movq $0, %rax\t\t\t# Put FALSE in %rax")
        self.generateCode(f"comp_end_{label}:")
        
    def lessComparison(self):
        # Save label counter and update it
        label = self.binaryLabelCounter
        self.binaryLabelCounter += 1
        self.generateCode("cmp %rax, %rbx\t\t\t# Compare both sides")
        self.generateCode(f"jle comp_skip_{label}\t\t\t# Skip if right side is less or equal")
        self.generateCode("movq $1, %rax\t\t\t# Put TRUE in %rax")
        self.generateCode(f"jmp comp_end_{label}\t\t\t# Skip the alternative branch")
        self.generateCode(f"comp_skip_{label}:")
        self.generateCode("movq $0, %rax\t\t\t# Put FALSE in %rax")
        self.generateCode(f"comp_end_{label}:")
        
    def greaterOrEqualComparison(self):
        # Save label counter and update it
        label = self.binaryLabelCounter
        self.binaryLabelCounter += 1
        self.generateCode("cmp %rax, %rbx\t\t\t# Compare both sides")
        self.generateCode(f"jg comp_skip_{label}\t\t\t# Skip if right side is greater")
        self.generateCode("movq $1, %rax\t\t\t# Put TRUE in %rax")
        self.generateCode(f"jmp comp_end_{label}\t\t\t# Skip the alternative branch")
        self.generateCode(f"comp_skip_{label}:")
        self.generateCode("movq $0, %rax\t\t\t# Put FALSE in %rax")
        self.generateCode(f"comp_end_{label}:")
        
    def lessOrEqualComparison(self):
        # Save label counter and update it
        label = self.binaryLabelCounter
        self.binaryLabelCounter += 1
        self.generateCode("cmp %rax, %rbx\t\t\t# Compare both sides")
        self.generateCode(f"jl comp_skip_{label}\t\t\t# Skip if right side is less")
        self.generateCode("movq $1, %rax\t\t\t# Put TRUE in %rax")
        self.generateCode(f"jmp comp_end_{label}\t\t\t# Skip the alternative branch")
        self.generateCode(f"comp_skip_{label}:")
        self.generateCode("movq $0, %rax\t\t\t# Put FALSE in %rax")
        self.generateCode(f"comp_end_{label}:")
        
    def andLogical(self):
        # Save label counter and update it
        label = self.binaryLabelCounter
        self.binaryLabelCounter += 1
        self.generateCode("movq $0, %rdx\t\t\t# Put FALSE in %rdx")
        self.generateCode("cmp %rax, %rdx\t\t\t# Check if the left side is false")
        self.generateCode(f"je logical_false_{label}\t\t# Skip to the false")
        self.generateCode("cmp %rbx, %rdx\t\t\t# Check if the right side is false")
        self.generateCode(f"je logical_false_{label}\t\t# Skip to the false")
        self.generateCode("movq $1, %rax\t\t\t# Put TRUE in %rax")
        self.generateCode(f"jmp logical_end_{label}\t\t# Skip to the end")
        self.generateCode(f"logical_false_{label}:")
        self.generateCode("movq $0, %rax\t\t\t# Put FALSE in %rax")
        self.generateCode(f"logical_end_{label}:")
        
    def orLogical(self):
        # Save label counter and update it
        label = self.binaryLabelCounter
        self.binaryLabelCounter += 1
        self.generateCode("movq $0, %rdx\t\t\t# Put FALSE in %rdx")
        self.generateCode("cmp %rax, %rdx\t\t\t# Check if the left side is false")
        self.generateCode(f"jne logical_true_{label}\t\t# Skip to the true") 
        self.generateCode("cmp %rbx, %rdx\t\t\t# Check if the right side is false")
        self.generateCode(f"jne logical_true_{label}\t\t# Skip to the true") 
        self.generateCode("movq $0, %rax\t\t\t# Put FALSE in %rax")
        self.generateCode(f"jmp logical_end_{label}\t\t# Skip to the end")
        self.generateCode(f"logical_true_{label}:")
        self.generateCode("movq $1, %rax\t\t\t# Put TRUE in %rax")
        self.generateCode(f"logical_end_{label}:")

    def visitNumberExpression(self, expr: NumberExpression):
        self.generateCode(f"movq ${expr.value}, %rax\t\t\t# Put a number in %rax")

    def visitUnaryExpression(self, expr: UnaryExpression):
        expr.value.accept(self)
        if expr.operator == "-":
            self.generateCode("negq %rax\t\t\t# Negate value")

    
    def visitVarExpression(self, expr: VarExpression):
        entry = self.table.lookup(expr.var)
        if isinstance(entry, SymbolTable.FunctionValue):
            return entry
        else:
            self.accessVar(entry)
            self.generateCode(f"movq {entry.offset}(%rax), %rax\t\t# Assign value to %rax")  
    
    def visitAssignExpression(self, expr: AssignExpression):
        expr.value.accept(self)
        self.generateCode(f"movq %rax, %rdx")
        entry = self.table.lookup(expr.var)
        self.accessVar(entry)
        self.generateCode(f"movq %rdx, {entry.offset}(%rax)")
    
    def visitVarDeclaration(self, stmt: VarDeclaration):
        if stmt.initializer != None:
            entry = self.table.lookup(stmt.var)
            stmt.initializer.accept(self)
            self.generateCode(f"movq %rax, {entry.offset}(%rbp)\t\t# Move initialized value into space on stack")
        else:
            pass
        
    def visitFunctionDeclaration(self, stmt: FunctionDeclaration):
        self.functionStack.append(stmt.var)
        self.functions[stmt.var] = [f"{stmt.var}:"]

        entry = self.table.lookup(stmt.var)
        self.table = entry.table

        self.startScope()

        for s in stmt.body:
            s.accept(self)

        self.addLabel(f"end_{entry.name}:\t\t\t# End function")
        self.endScope()

        self.generateCode("ret\t\t\t\t# Return from the function")

        self.table = self.table.parent
        self.functionStack.pop()

    def visitCallExpression(self, expr: CallExpression):
        entry = expr.var.accept(self)

        for i in range(len(expr.arguments)-1, -1, -1):
            expr.arguments[i].accept(self)
            self.generateCode(f"pushq %rax\t\t\t# Push argument number {i+1} to stack")

        self.setStaticLink(entry.level - self.table.level)

        self.generateCode(f"call {entry.name}\t\t\t# Call the {entry.name} function ")

        self.generateCode("addq $8, %rsp\t\t\t# Deallocate space on stack for static link")

        self.generateCode(self.popArgs(len(expr.arguments)))

    def visitParameterStatement(self, stmt: ParameterStatement):
        pass

    def accessVar(self, entry: SymbolTable.VariableValue):
        if self.table.scopeType == "Function":
            offset = 16
        else:
            offset = 8
        self.generateCode("movq %rbp, %rax\t\t\t# Prepare to access variable from another scope")
        for i in range(self.table.level - entry.level):
            self.generateCode(f"movq {offset}(%rax), %rax\t\t# Traverse static link once")   

    def setStaticLink(self, levelDifference):
        self.generateCode("movq %rbp, %rax\t\t\t# Prepare static link")
        for i in range(levelDifference):
            self.generateCode(f"movq 16(%rax), %rax\t\t# Traverse static link once")
        self.generateCode("pushq %rax\t\t\t# Push static link")       

    def startScope(self):
        self.generateCode("pushq %rbp\t\t\t# Save base pointer")
        self.generateCode("movq %rsp, %rbp\t\t\t# Make stack pointer new base pointer")
        self.generateCode(f"subq ${abs(self.table.varCounter)}, %rsp\t\t\t# Allocate space for local variables on the stack")

    def endScope(self):
        self.generateCode(f"addq ${abs(self.table.varCounter)}, %rsp\t\t\t# Deallocate space for variables on the stack")
        self.generateCode("popq %rbp\t\t\t# Restore base pointer")

    def popArgs(self, args: int):
        argsToPop = 8 * args
        return f"addq ${argsToPop}, %rsp\t\t\t# Pop the arguments pushed to the stack"
    
    def visitIfStatement(self, stmt: IfStatement):
        # Save label counter and update it
        label = self.ifLabelCounter
        self.ifLabelCounter += 1
        
        # For now 0 is false and everything else is true
        stmt.condition.accept(self)
        self.generateCode("cmp $0, %rax\t\t\t# Check the condition")

        if stmt.elseStatement:
            self.generateCode(f"je else_part_{label}\t\t\t# Skip to the else if the condition is false")
        else:
            self.generateCode(f"je end_{label}\t\t\t# Skip if the condition is false")
        
        self.table = stmt.thenTable

        #Prologue for then block
        self.setStaticLink(0)
        self.startScope()

        for s in stmt.thenStatement:
            s.accept(self)

        #Epilogue for then block
        self.addLabel(f"end_then_{label}:\t\t\t# Clean up then block stack frame")
        self.endScope()
        self.generateCode("addq $8, %rsp\t\t\t# Deallocate space on stack for static link")

        self.generateCode(f"jmp end_{label}\t\t\t# Skip the else")

        if stmt.elseStatement:
            self.addLabel(f"else_part_{label}:")

            self.table = stmt.elseTable

            #Prologue for else block
            self.setStaticLink(0)
            self.startScope()

            for s in stmt.elseStatement:
                s.accept(self)
            
            #Epilogue for else block
            self.addLabel(f"end_else_{label}:")
            self.endScope()
            self.generateCode("addq $8, %rsp\t\t\t# Deallocate space on stack for static link")
            
        self.addLabel(f"end_{label}:")

        self.table = self.table.parent
    
        
    def visitWhileStatement(self, stmt: WhileStatement):
        # Save label counter and update it
        label = self.whileLabelCounter
        self.whileLabelCounter += 1
        
        # Enter a new scope
        self.table = stmt.table
        self.setStaticLink(0)
        self.startScope()

        self.generateCode(f"while_loop_{label}:")
        
        # For now 0 is false and everything else is true
        stmt.condition.accept(self)
        self.generateCode("cmp $0, %rax\t\t\t# Check the condition")
        self.generateCode(f"je end_while_{label}\t\t\t# Skip if the condition is false")
        
        for s in stmt.thenStatement:
                s.accept(self)

        self.generateCode(f"jmp while_loop_{label}\t\t# Restart the loop")
        self.generateCode(f"end_while_{label}:")

        # Exit the scope
        self.endScope()
        self.generateCode("addq $8, %rsp\t\t\t# Deallocate space on stack for static link")
        self.table = self.table.parent

    def visitPrintStatement(self, stmt: PrintStatement):
        # Save label counter and update it
        label = self.printLabelCounter
        self.printLabelCounter += 1
        
        stmt.value.accept(self)
        self.generateCode("\t\t\t# Start print statement")
        self.generateCode("leaq form(%rip), %rdi\t\t# Passing string address (1. argument)")
        self.generateCode("movq %rax, %rsi\t\t\t# Passing %rax (2. argument)")
        self.generateCode("movq $0, %rax\t\t\t# No floating point registers used")
        self.generateCode("testq $15, %rsp\t\t\t# Test for 16 byte alignment")
        self.generateCode(f"jz print_align_{label}\t\t# Jump if aligned")
        self.generateCode("addq $-8, %rsp\t\t\t# 16 byte aligning")
        self.generateCode("callq printf@plt\t\t# Call printf")
        self.generateCode("addq $8, %rsp\t\t\t# Reverting alignment")
        self.generateCode(f"jmp end_print_{label}")
        self.generateCode(f"print_align_{label}:")
        self.generateCode("callq printf@plt\t\t# Call printf")
        self.generateCode(f"end_print_{label}:")
        self.generateCode("\t\t\t# End print statement")

    def visitReturnStatement(self, stmt: ReturnStatement):
        stmt.value.accept(self)

        match self.table.scopeType:
            case "If":
                self.generateCode(f"jmp end_{self.ifLabelCounter}")
            case "Else":
                self.generateCode(f"jmp end_else_{self.ifLabelCounter}")
            case "While":
                self.generateCode(f"jmp end_while_{self.whileLabelCounter}")
            case "Function":
                self.generateCode(f"jmp end_{self.functionStack[-1]}")
           