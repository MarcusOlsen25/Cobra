from .visitor import Visitor
from ASTexpressions import *
from scope.SymbolTable import *
from ASTstatements import *

class AssemblyVisitor(Visitor):

    def __init__(self, table: SymbolTable):
        self.table = table
    
    def visitBinaryExpression(self, expr: BinaryExpression):

        if expr.operator == "*" or expr.operator == "/":
            return self.mult_div_operators(expr)
        
        elif expr.operator == "+" or expr.operator == "-":
            return self.add_sub_operators(expr)

    def visitNumberExpression(self, expr: NumberExpression):
        return str(expr.value)
    
    def visitVarExpression(self, expr: VarExpression):
        value = str(self.table.lookup(expr.var))
        return str(value)
    
    def visitAssignExpression(self, expr: AssignExpression):
        pass
    
    def visitVarDeclaration(self, stmt: VarDeclaration):
        if stmt.initializer != None:
            initializer = stmt.initializer.accept(self)
            return f"{initializer}\npushq %rax\n"
        else:
            return f"subq $8, %rsp\n"

    
   
    def popAddSubNumber(self, operator: str):
        if operator == "+":
            operator = "addq"
        else:
            operator = "subq"
        return f"popq %rbx\n{operator} %rax, %rbx\n"
    
    def popMultDivNumber(self, operator: str):
        if operator == "*":
            operator = "imulq"
        else:
            operator = "idivq"
        return f"popq %rdx\n{operator} %rdx, %rax\n"
    
    def pushExpression(self):
        return "pushq %rax\n"
    
    def addSub(self, x: int, operator: str):
        if operator == "+":
            operator = "add"
        else:
            operator = "sub"
        return f"{operator}q ${x}, %rax\n"
    
    def addSubBoth(self, x: int, y: int, operator: str): 
        if operator == "+":
            operator = "addq"
        else:
            operator = "subq"
        return f"movq ${x}, %rax\n{operator} ${y}, %rax\n"
    
    def multDivBoth(self, x: int, y: int, operator: str):
        if operator == "*":
            return f"movq ${x}, %rax\nmovq ${y}, %rdx\nimulq %rdx, %rax\n"
        else:
            return f"movq ${x}, %rax\nmovq ${y}, %rbx\nmovq $0, %rdx\nidivq %rbx\n"
    
    def multDiv(self, x: int, operator: str):
        if operator == "*":    
            return f"movq ${x}, %rdx\nimulq %rdx, %rax\n"
        else:
            return f"movq ${x}, %rbx\nmovq $0, %rdx\nidivq %rbx\n"
    
    def add_sub_operators(self, expr: BinaryExpression):

        left = expr.left.accept(self)
        right = expr.right.accept(self)

        if isinstance(expr.left, NumberExpression) and isinstance(expr.right, NumberExpression):
            return self.addSubBoth(left, right, expr.operator)
        
        elif isinstance(expr.right, NumberExpression):
            return left + self.addSub(right, expr.operator)

        elif isinstance(expr.left, NumberExpression):
            return right + self.addSub(left, expr.operator)
        
        else:
            return left + self.pushExpression() + right + self.popAddSubNumber(expr.operator)
        

    def mult_div_operators(self, expr: BinaryExpression):

        left = expr.left.accept(self)
        right = expr.right.accept(self)

        if isinstance(expr.left, NumberExpression) and isinstance(expr.right, NumberExpression):
            return self.multDivBoth(left, right, expr.operator)
        
        elif isinstance(expr.right, NumberExpression):
            return left + self.multDiv(right, expr.operator)

        elif isinstance(expr.left, NumberExpression):
            return right + self.multDiv(left, expr.operator)
        
        else:
            return left + self.pushExpression() + right + self.popMultDivNumber(expr.operator)