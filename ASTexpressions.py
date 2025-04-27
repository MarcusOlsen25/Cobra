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
    
class UnaryExpression(Expr):
    def __init__(self, operator: str, value: Expr):
        self.operator = operator
        self.value = value
    
    def accept(self, visitor):
        return visitor.visitUnaryExpression(self)        

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
    def __init__(self, var: Expr, value: Expr):
        self.var = var
        self.value = value

    def accept(self, visitor):
        return visitor.visitAssignExpression(self)

class CallExpression(Expr):
    def __init__(self, var: VarExpression, arguments: list[Expr]):
        self.var = var
        self.arguments = arguments

    def accept(self, visitor):
        return visitor.visitCallExpression(self)

class ConstructorExpression(Expr):
    def __init__(self, var: VarExpression):
        self.var = var

    def accept(self, visitor):
        return visitor.visitConstructorExpression(self)
    
class ObjectExpression(Expr):
    def __init__(self, object: list[VarExpression], var: str):
        self.object = object
        self.var = var
        self.isAssign = False

    def accept(self, visitor):
        return visitor.visitObjectExpression(self)
    
class PropertyCallExpression(Expr):
    def __init__(self, object: list[VarExpression], call: CallExpression):
        self.object = object
        self.call = call

    def accept(self, visitor):
        return visitor.visitPropertyCallExpression(self)