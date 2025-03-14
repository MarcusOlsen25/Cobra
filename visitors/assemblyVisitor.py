from .visitor import Visitor
from ASTexpressions import *
from scope.SymbolTable import *
from ASTstatements import *

class AssemblyVisitor(Visitor):

    def __init__(self, table: SymbolTable):
        self.table = table
        self.main = [".globl main", "main:", "pushq %rbp", "movq %rsp, %rbp"]
        self.functions = {"text": [".text"]}
        self.functionStack = []

    def generateCode(self, output: str):
        if len(self.functionStack) == 0:
            self.main.append(output)
        else:
            current_function = self.functionStack[-1]
            self.functions[current_function].append("\t" + output)
    
    def visitBinaryExpression(self, expr: BinaryExpression):
        expr.right.accept(self)
        self.generateCode("pushq %rax")
        expr.left.accept(self)
        self.generateCode("popq %rbx")

        match expr.operator:
            case "+":
                self.generateCode("addq %rbx, %rax")
            case "-":
                self.generateCode("subq %rbx, %rax")
            case "*":
                self.generateCode("imulq %rbx, %rax")
            case "/":
                self.generateCode("movq $0, %rdx")
                self.generateCode("idivq %rbx")

    def visitNumberExpression(self, expr: NumberExpression):
        output = f"movq ${expr.value}, %rax"
        self.generateCode(output)
    
    def visitVarExpression(self, expr: VarExpression):
        entry = self.table.lookup(expr.var)
        if isinstance(entry, SymbolTable.FunctionValue):
            return entry
        else:
            self.generateCode(f"movq {entry.offset}(%rbp), %rax")
    
    def visitAssignExpression(self, expr: AssignExpression):
        pass
    
    def visitVarDeclaration(self, stmt: VarDeclaration):
        if stmt.initializer != None:
            entry = self.table.lookup(stmt.var)
            stmt.initializer.accept(self)
            self.generateCode(f"movq %rax, {-entry.offset}(%rbp)")
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
            self.generateCode("pushq %rax")

        self.generateCode(f"call {entry.name}")
        self.generateCode(self.popArgs(len(expr.arguments)))

    def visitParameterStatement(self, stmt: ParameterStatement):
        pass

    def startFunction(self, varSpace: int):
        self.generateCode("pushq %rbp\n\tmovq %rsp, %rbp")

        self.generateCode(f"subq ${varSpace}, %rsp")

    def endFunction(self, args: int, varSpace: int):
        self.generateCode(f"addq ${varSpace}, %rsp")
        self.generateCode("popq %rbp")
        self.generateCode("ret")

    def popArgs(self, args: int):
        argsToPop = 8 * args
        return f"addq ${argsToPop}, %rsp"