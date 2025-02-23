class Stmt:
    pass

class VarDeclaration(Stmt):
    #Add type
    def __init__(self, var: str, initializer: str ):
        self.var = var
        self.initializer = initializer

    def accept(self, visitor):
        return visitor.visitVarDeclaration(self)