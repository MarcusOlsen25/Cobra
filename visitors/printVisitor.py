from .visitor import Visitor
from ASTnode import *

class PrintVisitor(Visitor):

    def visitBinaryExpression(self, expr: BinaryExpression):
        left = expr.left.accept(self)
        right = expr.right.accept(self)
        return f"({left} + {right})"
    
    def visitNumberExpression(self, expr: NumberExpression):
        return str(expr.value)
    
    def visitVarExpression(self, expr: VarExpression):
        return str(expr.value)

    """ def visit(self, node):
        if node.type == "binop":
            if node.leaf == "+":
                return self.visit_add(node)
            elif node.leaf == "*":
                return self.visit_mult(node)
        else:
            return self.visit_number(node)

    def visit_add(self, node):
        left = self.visit(node.children[0])
        right = self.visit(node.children[1])
        return f"({left} + {right})"
    
    def visit_mult(self,node):
        left = self.visit(node.children[0])
        right = self.visit(node.children[1])
        return f"({left} * {right})"

    def visit_number(self, node):
        return str(node.leaf) """