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
    
class MethodCallExpression(Expr):
    def __init__(self, property: Expr, arguments: list[Expr], lineno: int):
        self.property = property
        self.arguments = arguments
        self.lineno = lineno

    def accept(self, visitor):
        return visitor.visitMethodCallExpression(self)
    
class PropertyAccessExpression(Expr):
    def __init__(self, property: Expr, var: str, lineno: int):
        self.property = property
        self.var = var
        self.isAssign = False   
        self.isMethod = False
        self.lineno = lineno

    def accept(self, visitor):
        return visitor.visitPropertyAccessExpression(self)
    
class NullExpression(Expr):
    def __init__(self):
        self.type = NullType()

    def accept(self, visitor):
        return visitor.visitNullExpression(self)

class NullType():
    pass