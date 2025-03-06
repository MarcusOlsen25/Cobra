from .visitor import Visitor
from ASTexpressions import *
from ASTstatements import *
from scope.SymbolTable import *

class ScopeVisitor(Visitor):

    def __init__(self, table: SymbolTable):
        self.table = table

    def visitBinaryExpression(self, expr: BinaryExpression):
        expr.left.accept(self)
        expr.right.accept(self)
    
    def visitNumberExpression(self, expr: NumberExpression):
        return expr.value
    
    def visitVarExpression(self, expr: VarExpression):
        return self.table.lookup(expr.var)
    
    def visitAssignExpression(self, expr: AssignExpression):
        value = expr.value.accept(self)
        self.table.insertExisting(expr.var, value)
        print(str(expr.var) + " : " + str(self.table.lookup(expr.var).value) + " : " + str(self.table.lookup(expr.var).position))
    
    def visitVarDeclaration(self, stmt: VarDeclaration):
        if stmt.initializer != None:
            initializer = stmt.initializer.accept(self)
            self.table.insert(stmt.var, Value(initializer, self.table.decrementCounter()))
            print("var " + str(stmt.var) + " : " + str(self.table.lookup(stmt.var).position))
        else:
            self.table.insert(stmt.var, Value(None, self.table.decrementCounter()))
            print("var " + str(stmt.var) + " : " + "uninitialized")


    

    