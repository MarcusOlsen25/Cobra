from .visitor import Visitor
from ASTexpressions import *
from ASTstatements import *
from scope.SymbolTable import *

class ScopeVisitor(Visitor):

    table = SymbolTable(None)

    def visitBinaryExpression(self, expr: BinaryExpression):
        expr.left.accept(self)
        expr.right.accept(self)
    
    def visitNumberExpression(self, expr: NumberExpression):
        return expr.value
    
    def visitVarExpression(self, expr: VarExpression):
        return self.table.lookup(expr.var)
    
    def visitAssignExpression(self, expr: AssignExpression):
        value = expr.value.accept(self)
        self.table.insert(expr.var, value)
        print(str(expr.var) + " : " + str(self.table.lookup(expr.var)))
    
    def visitVarDeclaration(self, stmt: VarDeclaration):
        if stmt.initializer != None:
            initializer = stmt.initializer.accept(self)
            self.table.insert(stmt.var, initializer)
            print("var " + str(stmt.var) + " : " + str(initializer))
        else:
            self.table.insert(stmt.var, None)
            print("var " + str(stmt.var) + " : " + "uninitialized")

    