from .visitor import Visitor
from ASTexpressions import *

class AssemblyVisitor(Visitor):

    
    def visitBinaryExpression(self, expr: BinaryExpression):

        left = expr.left.accept(self)
        right = expr.right.accept(self)

        if isinstance(expr.left, NumberExpression) and isinstance(expr.right, NumberExpression):
            return self.addBoth(left, right)
        
        elif isinstance(expr.right, NumberExpression):
            return left + self.addRight(right)

        elif isinstance(expr.left, NumberExpression):
            """ return self.pushNumber(left) + right + self.popAddNumber() """
            return right + self.addLeft(left)
        
        else:
            return left + self.pushExpression() + right + self.popAddNumber()

    def visitNumberExpression(self, expr: NumberExpression):
        return str(expr.value)
    
    def popAddNumber(self):
        return "popq %rbx\naddq %rbx, %rax\n"
    
    def pushExpression(self):
        return "pushq %rax\n"
    
    def pushNumber(self, x: int):
        output = f"movq ${x}, %rbx\n"
        output += f"pushq %rbx\n"
        return f"movq ${x}, %rbx\npushq %rbx\n"
    
    def addRight(self, x: int):
        return f"addq ${x}, %rax\n"
    
    def addLeft(self, x: int):
        return f"addq ${x}, %rax\n"
    
    def addBoth(self, x: int, y: int): 
        return f"movq ${x}, %rax\naddq ${y}, %rax\n"