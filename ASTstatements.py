from ASTexpressions import *
# from scope.SymbolTable import SymbolTable     # This causes a circular import problem

class Stmt:
    pass

class VarDeclaration(Stmt):
    #Add type
    def __init__(self, var: str, initializer: Expr, type: str, lineno: int):
        self.var = var
        self.initializer = initializer
        self.type = type
        self.lineno = lineno

    def accept(self, visitor):
        return visitor.visitVarDeclaration(self)
    
class FunctionDeclaration(Stmt):
    def __init__(self, var: str, params: list[VarDeclaration], body: list[Stmt], returnValue: Expr, lineno: int):
        self.var = var
        self.params = params
        self.body = body
        self.returnValue = returnValue 
        self.isMethod = False
        self.lineno = lineno

    def accept(self, visitor):
        return visitor.visitFunctionDeclaration(self)
    
class ParameterStatement(Stmt):
    def __init__(self, type: str, var: str, lineno: int):
        self.type = type
        self.var = var
        self.lineno = lineno

    def accept(self, visitor):
        return visitor.visitParameterStatement(self)
        
class IfStatement(Stmt):
    def __init__(self, condition: Expr, thenStatement: list[Stmt], elseStatement: list[Stmt], thenTable, elseTable, lineno: int):
        self.condition = condition
        self.thenStatement = thenStatement
        self.elseStatement = elseStatement
        self.thenTable = None
        self.elseTable = None
        self.lineno = lineno
        
    def accept(self, visitor):
        return visitor.visitIfStatement(self)
     
class WhileStatement(Stmt):
    def __init__(self, condition: Expr, thenStatement: list[Stmt], table, lineno: int):
        self.condition = condition
        self.thenStatement = thenStatement
        self.table = None
        self.lineno = lineno
    
    def accept(self, visitor):
        return visitor.visitWhileStatement(self)

class PrintStatement(Stmt):
    def __init__(self, value: Expr, lineno: int):
        self.value = value
        self.lineno = lineno
    
    def accept(self, visitor):
        return visitor.visitPrintStatement(self)
    
class ReturnStatement(Stmt):
    def __init__(self, value: Expr, lineno: int):
        self.value = value
        self.lineno = lineno

    def accept(self, visitor):
        return visitor.visitReturnStatement(self)
    
class ClassDeclaration(Stmt):
    def __init__(self, var: str, body: list[Stmt], lineno: int):
        self.var = var
        self.body = body
        self.lineno = lineno

    def accept(self, visitor):
        return visitor.visitClassDeclaration(self)
    
class MethodDeclaration(Stmt):
    def __init__(self, var: str, params: list[VarDeclaration], body: list[Stmt], returnValue: Expr, lineno: int):
        self.var = var
        self.params = params
        self.body = body
        self.returnValue = returnValue 
        self.className = None
        self.lineno = lineno

    def accept(self, visitor):
        return visitor.visitMethodDeclaration(self)