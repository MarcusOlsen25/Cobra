class Expr:
    def accept(self, visitor):
        pass

class BinaryExpression(Expr):
    def __init__(self, left: Expr, operator: str, right: Expr, lineno: int):
        self.left = left
        self.right = right
        self.operator = operator
        self.lineno = lineno
        
    def accept(self, visitor):
        return visitor.visitBinaryExpression(self)
    
class UnaryExpression(Expr):
    def __init__(self, operator: str, value: Expr, lineno: int):
        self.operator = operator
        self.value = value
        self.lineno = lineno
    
    def accept(self, visitor):
        return visitor.visitUnaryExpression(self)        

class NumberExpression(Expr):
    def __init__(self, value: int, lineno: int):
        self.value = value
        self.lineno = lineno
    
    def accept(self, visitor):
        return visitor.visitNumberExpression(self)
    
class VarExpression(Expr):
    #Add type
    def __init__(self, var: str, lineno: int):
        self.var = var
        self.lineno = lineno
    
    def accept(self, visitor):
        return visitor.visitVarExpression(self)
    
class BoolExpression(Expr):
    def __init__(self, value: str, lineno: int):
        self.value = value
        self.lineno = lineno
        
    def accept(self, visitor):
        return visitor.visitBoolExpression(self)
    
class AssignExpression(Expr):
    def __init__(self, var: Expr, value: Expr, lineno: int):
        self.var = var
        self.value = value
        self.lineno = lineno

    def accept(self, visitor):
        return visitor.visitAssignExpression(self)

class CallExpression(Expr):
    def __init__(self, var: VarExpression, arguments: list[Expr], lineno: int):
        self.var = var
        self.arguments = arguments
        self.lineno = lineno

    def accept(self, visitor):
        return visitor.visitCallExpression(self)

class ConstructorExpression(Expr):
    def __init__(self, var: VarExpression, lineno: int):
        self.var = var
        self.lineno = lineno

    def accept(self, visitor):
        return visitor.visitConstructorExpression(self)
    
class ObjectExpression(Expr):
    def __init__(self, object: list[VarExpression], var: str, lineno: int):
        self.object = object
        self.var = var
        self.isAssign = False   # What is this?
        self.lineno = lineno

    def accept(self, visitor):
        return visitor.visitObjectExpression(self)
    
class PropertyCallExpression(Expr):
    def __init__(self, object: list[VarExpression], call: CallExpression, lineno: int):
        self.object = object
        self.call = call
        self.lineno = lineno

    def accept(self, visitor):
        return visitor.visitPropertyCallExpression(self)