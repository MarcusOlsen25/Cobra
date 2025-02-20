from .visitor import Visitor
from ASTnode import *

class EvalVisitor(Visitor):

    def visitBinaryExpression(self, expr: BinaryExpression):
        left = expr.left.accept(self)
        right = expr.right.accept(self)

        match expr.operator:
            case "+":
                return left + right
        return 0
    
    def visitNumberExpression(self, expr: NumberExpression):
        return expr.value