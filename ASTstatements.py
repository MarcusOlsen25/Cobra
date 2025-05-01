from ASTexpressions import *
# from scope.SymbolTable import SymbolTable     # This causes a circular import problem

class Stmt:
    pass

class VarDeclaration(Stmt):
    #Add type
    def __init__(self, var: str, initializer: Expr, type: str):
        self.var = var
        self.initializer = initializer
        self.type = type

    def accept(self, visitor):
        return visitor.visitVarDeclaration(self)
    
class FunctionDeclaration(Stmt):
    def __init__(self, var: str, params: list[VarDeclaration], body: list[Stmt], returnValue: Expr):
        self.var = var
        self.params = params
        self.body = body
        self.returnValue = returnValue 

    def accept(self, visitor):
        return visitor.visitFunctionDeclaration(self)
    
class ParameterStatement(Stmt):
    def __init__(self, var: str, type: str):
        self.var = var
        self.type = type

    def accept(self, visitor):
        return visitor.visitParameterStatement(self)
        
class IfStatement(Stmt):
    def __init__(self, condition: Expr, thenStatement: list[Stmt], elseStatement: list[Stmt], thenTable, elseTable):
        self.condition = condition
        self.thenStatement = thenStatement
        self.elseStatement = elseStatement
        self.thenTable = None
        self.elseTable = None
        
    def accept(self, visitor):
        return visitor.visitIfStatement(self)
     
class WhileStatement(Stmt):
    def __init__(self, condition: Expr, thenStatement: list[Stmt], table):
        self.condition = condition
        self.thenStatement = thenStatement
        self.table = None
    
    def accept(self, visitor):
        return visitor.visitWhileStatement(self)

class PrintStatement(Stmt):
    def __init__(self, value: Expr):
        self.value = value
    
    def accept(self, visitor):
        return visitor.visitPrintStatement(self)
    
class ReturnStatement(Stmt):
    def __init__(self, value: Expr):
        self.value = value

    def accept(self, visitor):
        return visitor.visitReturnStatement(self)
    
class ClassDeclaration(Stmt):
    def __init__(self, var: str, body: list[Stmt]):
        self.var = var
        self.body = body

    def accept(self, visitor):
        return visitor.visitClassDeclaration(self)