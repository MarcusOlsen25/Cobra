from .visitor import Visitor
from ASTexpressions import *
from ASTstatements import *

class NodeVisitor(Visitor):

    def visitBinaryExpression(self, expr):
        left = expr.left.accept(self)
        right = expr.right.accept(self)
        return str(left) + str(right)
    
    def visitNumberExpression(self, expr):
        return expr
    
    def visitVarExpression(self, expr):
        return expr
    
    def visitAssignExpression(self, expr):
        return expr
    
    def visitVarDeclaration(self, stmt: VarDeclaration):
        if stmt.initializer == None:
            return stmt
        else:
            return stmt