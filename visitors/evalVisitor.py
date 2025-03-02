from .visitor import Visitor
from ASTexpressions import *
from ASTstatements import *
from scope.SymbolTable import SymbolTable

class EvalVisitor(Visitor):

    table = SymbolTable(None)

    def visitBinaryExpression(self, expr: BinaryExpression):
        left = expr.left.accept(self)
        right = expr.right.accept(self)

        match expr.operator:
            case "+":
                return left + right
            case "-":
                return left - right
            case "*":
                return left * right
            case "/":
                return left / right
        return 0
    
    def visitNumberExpression(self, expr: NumberExpression):
        return expr.value
    
    def visitVarExpression(self, expr: VarExpression):
        return self.table.lookup(expr.var)
    
    def visitVarDeclaration(self, stmt: VarDeclaration):
        if stmt.initializer != None:
            self.table.insert(stmt.var, stmt.initializer.accept(self))
        else:
            self.table.insert(stmt.var, None)
    
    def visitAssignExpression(self, expr: AssignExpression):
        self.table.insert(expr.var, expr.value.accept(self))
    
