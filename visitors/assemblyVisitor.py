from .visitor import Visitor
from ASTexpressions import *
from scope.SymbolTable import *
from ASTstatements import *
from .instruction import * 

class AssemblyVisitor(Visitor):

    def __init__(self, table: SymbolTable):
        self.table = table
        self.main: list[Instruction] = [
            Instruction(None, None, None, None, None, ".globl main"), 
            Instruction(None, None, None, "main", None, None)]
        self.classDescriptors = "cd\n"
        self.functions = {"text": [Instruction(None, None, None, None, None, ".text")]}
        self.init: list[Instruction] = [
            Instruction(None, None, None, None, None, ".data"), 
            Instruction(None, None, None, "heap", None, None),
            Instruction(None, None, None, None, 1, ".space 1000"), 
            Instruction(None, None, None, "heap_pointer", None, None),
            Instruction(None, None, None, None, 1, ".quad heap"), 
            Instruction(None, None, None, "form", None, None),
            Instruction(None, None, None, None, 1, ".string \"%d\\n\"")]
        self.functionStack = []
        self.ifLabelCounter = 0
        self.whileLabelCounter = 0
        self.binaryLabelCounter = 0
        self.printLabelCounter = 0
        self.labelStack = []

    def generateCode(self, upcode: str, operand1: str, operand2: str, tabOffset: int, comment: str):
        instruction = Instruction(upcode, operand1, operand2, None, tabOffset, comment)
        if len(self.functionStack) == 0:
            self.main.append(instruction)
        else:
            current_function = self.functionStack[-1]
            self.functions[current_function].append(instruction)

    def addLabel(self, label: str, tabOffset: int, comment: str):
        instruction = Instruction(None, None, None, label, tabOffset, comment)
        if len(self.functionStack) == 0:
            self.main.append(instruction)
        else:
            current_function = self.functionStack[-1]
            self.functions[current_function].append(instruction)
            
    def addComment(self, tabOffset: int, comment: str):
        instruction = Instruction(None, None, None, None, tabOffset, comment)
        if len(self.functionStack) == 0:
            self.main.append(instruction)
        else:
            current_function = self.functionStack[-1]
            self.functions[current_function].append(instruction)
    
    def visitBinaryExpression(self, expr: BinaryExpression):
        expr.right.accept(self)
        self.generateCode("pushq", "%rax", None, 3, "# Push right side to stack")
        expr.left.accept(self)
        self.generateCode("popq", "%rbx", None, 3, "# Pop right side into %rbx")

        match expr.operator:
            case "+":
                self.generateCode("addq", "%rbx", "%rax", 3, "# Perform addition")
            case "-":
                self.generateCode("subq", "%rbx", "%rax", 3, "# Perform subtraction")
            case "*":
                self.generateCode("imulq", "%rbx", "%rax", 2, "# Perform multiplication")
            case "/":
                self.generateCode("movq", "$0", "%rdx", 3, "# Put a 0 in %rdx to prepare for the division")
                self.generateCode("idivq", "%rbx", None, 3, "# Perform division")
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
        self.generateCode("cmp", "%rax", "%rbx", 3, "# Compare both sides")
        self.generateCode("jne", f"comp_skip_{label}", None, 3, "# Skip if they are not equal")
        self.generateCode("movq", "$1", "%rax", 3, "# Put true in %rax")
        self.generateCode("jmp", f"comp_end_{label}", None, 3, "# Skip the alternative branch")
        self.addLabel(f"comp_skip_{label}", None, None)
        self.generateCode("movq", "$0", "%rax", 3, "# Put false in %rax")
        self.addLabel(f"comp_end_{label}", None, None)
        
    def inequalityComparison(self):
        # Save label counter and update it
        label = self.binaryLabelCounter
        self.binaryLabelCounter += 1
        self.generateCode("cmp", "%rax", "%rbx", 3, "# Compare both sides")
        self.generateCode("je", f"comp_skip_{label}", None, 3, "# Skip if they are  equal")
        self.generateCode("movq", "$1", "%rax", 3, "# Put true in %rax")
        self.generateCode("jmp", f"comp_end_{label}", None, 3, "# Skip the alternative branch")
        self.addLabel(f"comp_skip_{label}", None, None)
        self.generateCode("movq", "$0", "%rax", 3, "# Put false in %rax")
        self.addLabel(f"comp_end_{label}", None, None)
        
    def greaterComparison(self):
        # Save label counter and update it
        label = self.binaryLabelCounter
        self.binaryLabelCounter += 1
        self.generateCode("cmp", "%rax", "%rbx", 3, "# Compare both sides")
        self.generateCode("jge", f"comp_skip_{label}", None, 3, "# Skip if right side is greater or equal")
        self.generateCode("movq", "$1", "%rax", 3, "# Put true in %rax")
        self.generateCode("jmp", f"comp_end_{label}", None, 3, "# Skip the alternative branch")
        self.addLabel(f"comp_skip_{label}", None, None)
        self.generateCode("movq", "$0", "%rax", 3, "# Put false in %rax")
        self.addLabel(f"comp_end_{label}", None, None)
        
    def lessComparison(self):
        # Save label counter and update it
        label = self.binaryLabelCounter
        self.binaryLabelCounter += 1
        self.generateCode("cmp", "%rax", "%rbx", 3, "# Compare both sides")
        self.generateCode("jle", f"comp_skip_{label}", None, 3, "# Skip if right side is less or equal")
        self.generateCode("movq", "$1", "%rax", 3, "# Put true in %rax")
        self.generateCode("jmp", f"comp_end_{label}", None, 3, "# Skip the alternative branch")
        self.addLabel(f"comp_skip_{label}", None, None)
        self.generateCode("movq", "$0", "%rax", 3, "# Put false in %rax")
        self.addLabel(f"comp_end_{label}", None, None)
        
    def greaterOrEqualComparison(self):
        # Save label counter and update it
        label = self.binaryLabelCounter
        self.binaryLabelCounter += 1
        self.generateCode("cmp", "%rax", "%rbx", 3, "# Compare both sides")
        self.generateCode("jg", f"comp_skip_{label}", None, 3, "# Skip if right side is greater")
        self.generateCode("movq", "$1", "%rax", 3, "# Put true in %rax")
        self.generateCode("jmp", f"comp_end_{label}", None, 3, "# Skip the alternative branch")
        self.addLabel(f"comp_skip_{label}", None, None)
        self.generateCode("movq", "$0", "%rax", 3, "# Put false in %rax")
        self.addLabel(f"comp_end_{label}", None, None)
        
    def lessOrEqualComparison(self):
        # Save label counter and update it
        label = self.binaryLabelCounter
        self.binaryLabelCounter += 1
        self.generateCode("cmp", "%rax", "%rbx", 3, "# Compare both sides")
        self.generateCode("jl", f"comp_skip_{label}", None, 3, "# Skip if right side is less")
        self.generateCode("movq", "$1", "%rax", 3, "# Put true in %rax")
        self.generateCode("jmp", f"comp_end_{label}", None, 3, "# Skip the alternative branch")
        self.addLabel(f"comp_skip_{label}", None, None)
        self.generateCode("movq", "$0", "%rax", 3, "# Put false in %rax")
        self.addLabel(f"comp_end_{label}", None, None)
        
    def andLogical(self):
        # Save label counter and update it
        label = self.binaryLabelCounter
        self.binaryLabelCounter += 1
        self.generateCode("movq", "$0", "%rdx", 3, "# Put FALSE in %rdx")
        self.generateCode("cmp", "%rax", "%rdx", 3, "# Check if the left side is false")
        self.generateCode("je", f"logical_false_{label}", None, 2, "# Skip to the false")
        self.generateCode("cmp", "%rbx", "%rdx", 3, "# Check if the right side is false")
        self.generateCode("je", f"logical_false_{label}", None, 2, "# Skip to the false")
        self.generateCode("movq", "$1", "%rax", 3, "# Put true in %rax")
        self.generateCode("jmp", f"logical_end_{label}", None, 2, "# Skip to the end")
        self.addLabel(f"logical_false_{label}", None, None)
        self.generateCode("movq", "$0", "%rax", 3, "# Put false in %rax")
        self.addLabel(f"logical_end_{label}", None, None)
        
    def orLogical(self):
        # Save label counter and update it
        label = self.binaryLabelCounter
        self.binaryLabelCounter += 1
        self.generateCode("movq", "$0", "%rdx", 3, "# Put FALSE in %rdx")
        self.generateCode("cmp", "%rax", "%rdx", 3, "# Check if the left side is false")
        self.generateCode("jne", f"logical_true_{label}", None, 2, "# Skip to the true")
        self.generateCode("cmp", "%rbx", "%rdx", 3, "# Check if the right side is false")
        self.generateCode("jne", f"logical_true_{label}", None, 2, "# Skip to the true")
        self.generateCode("movq", "$0", "%rax", 3, "# Put false in %rax")
        self.generateCode("jmp", f"logical_end_{label}", None, 2, "# Skip to the end")
        self.addLabel(f"logical_true_{label}", None, None)
        self.generateCode("movq", "$1", "%rax", 3, "# Put true in %rax")
        self.addLabel(f"logical_end_{label}", None, None)

    def visitNumberExpression(self, expr: NumberExpression):
        self.generateCode("movq", f"${expr.value}", "%rax", 3, "# Put a number in %rax")

    def visitUnaryExpression(self, expr: UnaryExpression):
        expr.value.accept(self)
        if expr.operator == "-":
            self.generateCode("negq", "%rax", None, 3, "# Negate value")
        else:
            self.generateCode("cmpq", "$0", "%rax", 3, "# Invert flag")
            self.generateCode("sete", "%al", None, 3, "# Invert flag")
            self.generateCode("movzbl", "%al", "%eax", 3, "# Invert flag")
            
    def visitBoolExpression(self, expr: BoolExpression):
        if expr.value == "true":
            self.generateCode("movq", "$1", "%rax", 3, "# Put true in %rax")
        elif expr.value == "false":
            self.generateCode("movq", "$0", "%rax", 3, "# Put false in %rax")
        # Everything other than 0 is still true 
        else:
            self.generateCode("movq", f"${expr.value}", "%rax", 3, "# Put a non-binary boolean value in %rax")
    
    def visitVarExpression(self, expr: VarExpression):
        entry = self.table.lookup(expr.var)
        if isinstance(entry, SymbolTable.VariableValue):
            self.accessVar(entry)
            self.generateCode("movq", f"{entry.offset}(%rax)", "%rax", 2, "# Move value into %rax")
            return entry
        elif isinstance(entry, SymbolTable.FieldValue):
            self.accessField(entry)
            return entry
        else:
            return entry
    
    def visitAssignExpression(self, expr: AssignExpression):
        expr.value.accept(self)
        self.generateCode("movq", "%rax", "%rdx", 3, "# Move right side of assignment into %rdx")
        entry = expr.var.accept(self)
        if not isinstance(expr.var, PropertyAccessExpression):
            self.accessVar(entry)
        self.generateCode("movq", "%rdx", f"{entry.offset}(%rax)", 2, "# Move right side into location of left side of assign")
    
    def visitVarDeclaration(self, stmt: VarDeclaration):
        if stmt.initializer != None:
            entry = self.table.lookup(stmt.var)
            stmt.initializer.accept(self)
            if self.table.scopeType in ("While", "If", "Function", "Else"):
                self.generateCode("movq", "%rax", f"{entry.offset}(%rbp)", 3, "# Move initialized value into space on stack")
            else:
                self.generateCode("movq", "%rax", f"{entry.offset}(%rcx)", 3, "# Move initialized value into space on heap")
        else:
            pass
        
    def visitFunctionDeclaration(self, stmt: FunctionDeclaration):
        functionName = self.functionName(stmt.var)
        self.functionStack.append(functionName)
        self.functions[functionName] = [Instruction(None, None, None, f"{functionName}", 3, "# Function")]

        entry = self.table.lookup(stmt.var)
        self.table = entry.table

        self.startScope()

        for s in stmt.body:
            s.accept(self)

        self.addLabel(f"end_{functionName}", 3, "# End function")
        self.endScope()

        self.generateCode("ret", None, None, 4, "# Return from the function")

        self.table = self.table.parent
        self.functionStack.pop()

    def visitCallExpression(self, expr: CallExpression):
        entry = expr.var.accept(self)

        for i in range(len(expr.arguments)-1, -1, -1):
            expr.arguments[i].accept(self)
            self.generateCode("pushq", "%rax", None, 2, f"# Push argument number {i+1} to stack")

        self.setStaticLink(self.table.level - entry.level)
        self.generateCode("subq", "$8", "%rsp", 3, "# Add dummy space") # Why did we need a dummy space?

        self.generateCode("call", f"{entry.functionName}", None, 3, f"# Call the {entry.functionName} function")

        self.generateCode("addq", "$8", "%rsp", 3, "# Remove dummy space")  # Why did we need a dummy space?
        self.generateCode("addq", "$8", "%rsp", 3, "# Deallocate space on stack for static link")
        self.popArgs(len(expr.arguments))
        
        return entry

    def visitParameterStatement(self, stmt: ParameterStatement):
        pass

    def accessVar(self, entry: SymbolTable.VariableValue):
        self.generateCode("movq", "%rbp", "%rax", 3, "# Prepare to access variable from another scope")
        for i in range(self.table.level - entry.level):
            self.generateCode("movq", "24(%rax)", "%rax", 2, "# Traverse static link once")
        
    def accessField(self, entry: SymbolTable.FieldValue):
        self.generateCode("movq", f"{entry.offset}(%rax)", "%rax", 2, "# Move value into %rax")

    def setStaticLink(self, levelDifference):
        self.generateCode("movq", "%rbp", "%rax", 3, "# Prepare static link")
        for i in range(levelDifference):
            self.generateCode("movq", "24(%rax)", "%rax", 2, "# Traverse static link once")
        self.generateCode("pushq", "%rax", None, 3, "# Push static link")

    def startScope(self):
        self.generateCode("pushq", "%rbp", None, 3, "# Save base pointer")
        self.generateCode("movq", "%rsp", "%rbp", 3, "# Make stack pointer new base pointer")
        self.generateCode("subq", f"${abs(self.table.varCounter)}", "%rsp", 3, "# Allocate space for local variables on the stack")

    def endScope(self):
        self.generateCode("addq", f"${abs(self.table.varCounter)}", "%rsp", 3, "# Deallocate space for local variables on the stack")
        self.generateCode("popq", "%rbp", None, 3, "# Restore base pointer")

    def popArgs(self, args: int):
        argsToPop = 8 * args
        self.generateCode("addq", f"${argsToPop}", "%rsp", 3, "# Pop the arguments pushed to the stack")
    
    def visitIfStatement(self, stmt: IfStatement):
        # Save label counter and update it
        label = self.ifLabelCounter
        self.ifLabelCounter += 1
        
        # For now 0 is false and everything else is true
        stmt.condition.accept(self)
        self.generateCode("cmp", "$0", "%rax", 3, "# Check the condition")

        if stmt.elseStatement:
            self.generateCode("je", f"else_part_{label}", None, 3, "# Skip to the else if the condition is false")
        else:
            self.generateCode("je", f"end_{label}", None, 3, "# Skip if the condition is false")
        
        self.table = stmt.thenTable

        #Prologue for then block
        self.setStaticLink(0)
        self.generateCode("subq", "$16", "%rsp", 3, "# Add dummy spaces")
        self.startScope()

        for s in stmt.thenStatement:
            s.accept(self)

        #Epilogue for then block
        self.addLabel(f"end_then_{label}", 3, "# Clean up then block stack frame")
        self.endScope()
        self.generateCode("addq", "$16", "%rsp", 3, "# Remove dummy spaces")
        self.generateCode("addq", "$8", "%rsp", 3, "# Deallocate space on stack for static link")
        self.generateCode("jmp", f"end_{label}", None, 3, "# Skip the else")

        if stmt.elseStatement:
            self.addLabel(f"else_part_{label}", None, None)

            self.table = stmt.elseTable

            #Prologue for else block
            self.setStaticLink(0)
            self.generateCode("subq", "$16", "%rsp", 3, "# Add dummy spaces")
            self.startScope()

            for s in stmt.elseStatement:
                s.accept(self)
            
            #Epilogue for else block
            self.addLabel(f"end_else_{label}", None, None)
            self.endScope()
            self.generateCode("addq", "$16", "%rsp", 3, "# Remove dummy spaces")
            self.generateCode("addq", "$8", "%rsp", 3, "# Deallocate space on stack for static link")

        self.addLabel(f"end_{label}", None, None)

        self.table = self.table.parent
    
        
    def visitWhileStatement(self, stmt: WhileStatement):
        # Save label counter and update it
        label = self.whileLabelCounter
        self.whileLabelCounter += 1
        
        # Enter a new scope
        self.table = stmt.table
        self.setStaticLink(0)
        self.generateCode("subq", "$16", "%rsp", 3, "# Add dummy spaces")
        self.startScope()

        self.addLabel(f"while_loop_{label}", None, None)
        
        # For now 0 is false and everything else is true
        stmt.condition.accept(self)
        self.generateCode("cmp", "$0", "%rax", 3, "# Check the condition")
        self.generateCode("je", f"end_while_{label}", None, 3, "# Skip if the condition is false")
        
        for s in stmt.thenStatement:
                s.accept(self)

        self.generateCode("jmp", f"while_loop_{label}", None, 2, "# Restart the loop")
        self.addLabel(f"end_while_{label}", None, None)

        # Exit the scope
        self.endScope()
        self.generateCode("addq", "$16", "%rsp", 3, "# Remove dummy spaces")
        self.generateCode("addq", "$8", "%rsp", 3, "# Deallocate space on stack for static link")
        self.table = self.table.parent

    def visitPrintStatement(self, stmt: PrintStatement):
        # Save label counter and update it
        label = self.printLabelCounter
        self.printLabelCounter += 1
        
        stmt.value.accept(self)
        self.addComment(3, "# Start print statement")
        self.generateCode("leaq", "form(%rip)", "%rdi", 2, "# Passing string address (1. argument)")
        self.generateCode("movq", "%rax", "%rsi", 3, "# Passing %rax (2. argument)")
        self.generateCode("movq", "$0", "%rax", 3, "# No floating point registers used")
        self.generateCode("testq", "$15", "%rsp", 3, "# Test for 16 byte alignment")
        self.generateCode("jz", f"print_align_{label}", None, 2, "# Jump if aligned")
        self.generateCode("addq", "$-8", "%rsp", 3, "# 16 byte aligning")
        self.generateCode("callq", "printf@plt", None, 2, "# Call printf")
        self.generateCode("addq", "$8", "%rsp", 3, "# Reverting alignment")
        self.generateCode("jmp", f"end_print_{label}", None, None, None)
        self.addLabel(f"print_align_{label}", None, None)
        self.generateCode("callq", "printf@plt", None, 2, "# Call printf")
        self.addLabel(f"end_print_{label}", None, None)
        self.addComment(3, "# End print statement")

    def visitReturnStatement(self, stmt: ReturnStatement):
        stmt.value.accept(self)

        match self.table.scopeType:
            case "If":
                self.generateCode("jmp", f"end_{self.ifLabelCounter}", None, None, None)
            case "Else":
                self.generateCode("jmp", f"end_else_{self.ifLabelCounter}", None, None, None)
            case "While":
                self.generateCode("jmp", f"end_while_{self.whileLabelCounter}", None, None, None)
            case "Function":
                self.generateCode("jmp", f"end_{self.functionStack[-1]}", None, None, None)

    def visitClassDeclaration(self, stmt: ClassDeclaration):
        self.functionStack.append(stmt.var)
        self.functions[stmt.var] = [Instruction(None, None, None, f"{stmt.var}", 3, "# Class")]

        entry = self.table.lookup(stmt.var)
        
        self.generateCode("pushq", "%rbp", None, 3, "# Save base pointer")
        self.generateCode("movq", "%rsp", "%rbp", 3, "# Make stack pointer new base pointer")
        self.generateCode("movq", "16(%rbp)", "%rcx", 3, "# Push heap pointer")
        self.generateCode("pushq", "%rcx", None, 3, "# Push heap pointer")

        
        if stmt.super:
            superEntry = self.table.lookup(stmt.super)
            self.setStaticLink(self.table.level - superEntry.level)
            self.generateCode("pushq", "%rcx", None, 3, "# Push heap pointer")

            self.generateCode("call", f"{superEntry.name}", None, 3, f"# Call {entry.name} constructor")

            self.generateCode("addq", "$8", "%rsp", 3, "# Deallocate space on stack for heap pointer")
            self.generateCode("addq", "$8", "%rsp", 3, "# Deallocate space on stack for static link")

        self.table = entry.table

        for s in stmt.body:
            s.accept(self)
            
        self.init.append(Instruction(None, None, None, f"{stmt.var}_descriptor", None, None))
        super = stmt.super
        super_classes = []
        while super:
            superEntry = self.table.lookup(super)
            super_classes.append(superEntry)
            super = superEntry.super

        super_classes.reverse()

        for superEntry in super_classes:
            for entry in superEntry.table.getMethods():
                self.init.append(Instruction(None, None, None, None, None, f"\t.quad {entry.name}"))

        for entry in self.table.getMethods():
            self.init.append(Instruction(None, None, None, None, None, f"\t.quad {entry.name}"))

        self.generateCode("popq", "%rax", None, 3, "# Pop current heap pointer into %rax")
        self.generateCode("popq", "%rbp", None, 3, "# Restore base pointer")
        self.generateCode("ret", None, None, 4, "# End class")

        self.table = self.table.parent
        self.functionStack.pop()
           
    def visitConstructorExpression(self, expr: ConstructorExpression):
        entry = expr.var.accept(self)

        self.generateCode("movq", "heap_pointer(%rip)", "%rcx", 3, "# Move heap pointer into %rcx")
        self.generateCode("addq", f"${entry.table.fieldCounter + 8}", "heap_pointer(%rip)", 1, "# Add size of object to heap pointer")
        self.generateCode("leaq", f"{entry.name}_descriptor(%rip)", "%rax", 1, "# Move class descriptor into %rax")
        self.generateCode("movq", "%rax", "(%rcx)", 3, "# Move class descriptor into object")

        self.setStaticLink(self.table.level - entry.level)
        self.generateCode("pushq", "%rcx", None, 3, "# Push heap pointer")

        self.generateCode("call", f"{entry.name}", None, 3, f"# Call {entry.name} constructor")
        self.generateCode("movq", "16(%rbp)", "%rcx", 3, "# Move potential heap pointer into %rcx")
        self.generateCode("addq", "$8", "%rsp", 3, "# Deallocate space on stack for heap pointer")
        self.generateCode("addq", "$8", "%rsp", 3, "# Deallocate space on stack for static link")

    def visitPropertyAccessExpression(self, expr: PropertyAccessExpression):
        # Traverse each property call until you come to the end
        varEntry = expr.property.accept(self)
        classEntry = self.table.lookup(varEntry.type)
        propertyEntry = classEntry.table.lookupLocal(expr.var)
        while not propertyEntry and classEntry.super:
            classEntry = self.table.lookup(classEntry.super)
            propertyEntry = classEntry.table.lookupLocal(expr.var)

        if expr.isMethod:
            self.generateCode("pushq", "%rax", None, 3, "# Push heap pointer to be used as argument")
            self.generateCode("movq", "(%rax)", "%rax", 2, "# Move value into %rax")

        if not expr.isAssign and not expr.isMethod:
            self.generateCode("movq", f"{propertyEntry.offset}(%rax)", "%rax", 2, "# Move value into %rax")

        return propertyEntry
    
    def visitMethodCallExpression(self, expr: MethodCallExpression):
        methodEntry = expr.property.accept(self)
        self.generateCode("movq", f"{methodEntry.offset}(%rax)", "%rax", 3, "# Move method address into %rax")
        self.generateCode("movq", "%rax", "%r9", 3, "# Move method address into r9")


        for i in range(len(expr.arguments)-1, -1, -1):
            expr.arguments[i].accept(self)
            self.generateCode(f"pushq", "%rax", None, 3, f"# Push argument number {i+1} to stack")

        self.setStaticLink(self.table.level - methodEntry.level)

        self.generateCode("subq", "$8", "%rsp", 3, "# Add dummy space")
        self.generateCode("movq", "%r9", "%rax", 3, "# Move heap pointer into r9")
        self.generateCode("call", "*%rax", None, 2, "# Call method")

        self.generateCode("addq", "$8", "%rsp", 3, "# Remove dummy space")
        self.generateCode("addq", "$8", "%rsp", 3, "# Deallocate space on stack for static link")
        self.popArgs(len(expr.arguments) + 1)

        return methodEntry
    
    def visitMethodDeclaration(self, stmt: MethodDeclaration):
        self.functionStack.append(stmt.var + "_" + stmt.className)
        self.functions[stmt.var + "_" + stmt.className] = [Instruction(None, None, None, f"{stmt.var + "_" + stmt.className}", 3, "# Method")]

        entry = self.table.lookup(stmt.var)
        self.table = entry.table

        self.startScope()

        for s in stmt.body:
            s.accept(self)

        self.addLabel(f"end_{entry.name}", None, None)
        self.endScope()

        self.generateCode("ret", None, None, 4, "# Return from the method")

        self.table = self.table.parent
        self.functionStack.pop()
        
    def visitNullExpression(self, expr: NullExpression):
        self.generateCode("movq", "$0", "%rax", 3, "# Put a number in %rax")

    def functionName(self, functionName: str):
        if len(self.functionStack) == 0:
            return functionName
        else: 
            return self.functionStack[-1] + "_" + functionName