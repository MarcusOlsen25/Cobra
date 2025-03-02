from ASTexpressions import Expr

class Stmt:
    pass

class VarDeclaration(Stmt):
    #Add type
    def __init__(self, var: str, initializer: str ):
        self.var = var
        self.initializer = initializer

    def accept(self, visitor):
        return visitor.visitVarDeclaration(self)
    
class FunctionDeclaration(Stmt):
    def __init__(self, var: str, params: list[str], body: list[Stmt], returnValue: Expr):
        self.var = var
        self.params = params
        self.body = body
        self.returnValue = returnValue

    def accept(self, visitor):
        return visitor.visitFunctionDeclaration(self)

    