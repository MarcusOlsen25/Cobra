from .visitor import Visitor
from ASTexpressions import *

class ScopeVisitor(Visitor):

    def visitBinaryExpression(self, expr: BinaryExpression):
        left = expr.left.accept(self)
        right = expr.right.accept(self)
        return f"({left} + {right})"
    
    def visitNumberExpression(self, expr: NumberExpression):
        return str(expr.value)
    
    def visitVarExpression(self, expr: VarExpression):
        return str(expr.var)
    
    def visitAssignExpression(self, expr: AssignExpression):
        return expr.var + " = " + expr.value.accept(self)