from .visitor import Visitor
from ASTexpressions import *
from ASTstatements import *

class PrintVisitor(Visitor):

    def visitBinaryExpression(self, expr: BinaryExpression):
        left = expr.left.accept(self)
        right = expr.right.accept(self)
        return f"({left} {expr.operator} {right})"
    
    def visitNumberExpression(self, expr: NumberExpression):
        return str(expr.value)
    
    def visitVarExpression(self, expr: VarExpression):
        return str(expr.var)
    
    def visitAssignExpression(self, expr: AssignExpression):
        value = expr.value.accept(self)
        return f"({expr.var} = {value})"
    
    def visitVarDeclaration(self, stmt: VarDeclaration):
        if stmt.initializer == None:
            return f"var {stmt.var} = " + str(None)
        else:
            return f"var {stmt.var} = {stmt.initializer.accept(self)}"
        
    def visitFunctionDeclaration(self, stmt: FunctionDeclaration):
        body = []
        for s in stmt.body:
            body.append(s.accept(self))
        return f"({stmt.var}, {stmt.params}, {body})"
    
    def visitCallExpression(self, expr: CallExpression):
        var = expr.var.accept(self)
        args = []
        for a in expr.arguments:
            args.append(a.accept(self))
        return f"{var}, {args}"