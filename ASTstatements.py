from ASTexpressions import *

class Stmt:
    pass

class VarDeclaration(Stmt):
    #Add type
    def __init__(self, var: str, initializer: Expr):
        self.var = var
        self.initializer = initializer

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
    def __init__(self, var: str):
        self.var = var

    def accept(self, visitor):
        return visitor.visitParameterStatement(self)
        
class IfStatement(Stmt):
    def __init__(self, condition: Expr, thenStatement: list[Stmt], elseStatement: list[Stmt]):
        self.condition = condition
        self.thenStatement = thenStatement
        self.elseStatement = elseStatement
        
    def accept(self, visitor):
        return visitor.visitIfStatement(self)
     
class WhileStatement(Stmt):
    def __init__(self, condition: Expr, thenStatement: list[Stmt]):
        self.condition = condition
        self.thenStatement = thenStatement
    
    def accept(self, visitor):
        return visitor.visitWhileStatement(self)
