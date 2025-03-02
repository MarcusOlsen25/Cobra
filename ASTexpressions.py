class Expr:
    def accept(self, visitor):
        pass

class BinaryExpression(Expr):
    def __init__(self, left: Expr, operator: str, right: Expr):
        self.left = left
        self.right = right
        self.operator = operator
        
    def accept(self, visitor):
        return visitor.visitBinaryExpression(self)

class NumberExpression(Expr):
    def __init__(self, value: int):
        self.value = value
    
    def accept(self, visitor):
        return visitor.visitNumberExpression(self)
    
class VarExpression(Expr):
    #Add type
    def __init__(self, var: str):
        self.var = var
    
    def accept(self, visitor):
        return visitor.visitVarExpression(self)
    
class AssignExpression(Expr):
    def __init__(self, var: str, value: str):
        self.var = var
        self.value = value

    def accept(self, visitor):
        return visitor.visitAssignExpression(self)

class CallExpression(Expr):
    def __init__(self, var: str, arguments: list[str]):
        self.var = var
        self.arguments = arguments

    def accept(self, visitor):
        return visitor.visitCallExpression(self)