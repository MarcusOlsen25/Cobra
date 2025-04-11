from .visitor import Visitor
from ASTexpressions import *
from ASTstatements import *
from scope.SymbolTable import *

class ScopeVisitor(Visitor):

    def __init__(self, table: SymbolTable):
        self.table = table

    def visitUnaryExpression(self, expr: UnaryExpression):
        expr.value.accept(self)

    def visitBinaryExpression(self, expr: BinaryExpression):
        expr.left.accept(self)
        expr.right.accept(self)
    
    def visitNumberExpression(self, expr: NumberExpression):
        return expr.value
    
    def visitVarExpression(self, expr: VarExpression):
        return self.table.lookup(expr.var)
    
    def visitAssignExpression(self, expr: AssignExpression):
        pass
    
    def visitVarDeclaration(self, stmt: VarDeclaration):
        #int by default
        self.table.insert(stmt, "int", None)

    #Using func as a type
    def visitFunctionDeclaration(self, stmt: FunctionDeclaration):
        newTable = SymbolTable(self.table)
        self.table.insert(stmt, "func", newTable)
        self.table = newTable

        for param in stmt.params:
            param.accept(self)

        for s in stmt.body:
            s.accept(self)
        
        self.table = self.table.parent


    def visitCallExpression(self, expr: CallExpression):
        entry = expr.var.accept(self)
        
        correctParams = len(entry.params) == len(expr.arguments)

        for arg in expr.arguments:
            arg.accept(self)

        
    def visitParameterStatement(self, stmt: ParameterStatement):

        self.table.insert(stmt, "int", None)


    def visitIfStatement(self, stmt: IfStatement):
        stmt.condition.accept(self)
        
        # Create a new symbol table and visit the statements in the thenStatement
        newTable = SymbolTable(self.table)
        stmt.thenTable = newTable
        self.table = stmt.thenTable

        for s in stmt.thenStatement:
            s.accept(self)
            
        self.table = self.table.parent

        if stmt.elseStatement != None:
            
            # Create a new symbol table and visit the statements in the elseStatement 
            newTable = SymbolTable(self.table)
            stmt.elseTable = newTable
            self.table = stmt.elseTable

            for s in stmt.elseStatement:
                s.accept(self)
                
            self.table = self.table.parent
        
            
    def visitWhileStatement(self, stmt: WhileStatement):
        stmt.condition.accept(self)
        
        # Create a new symbol table and visit the statements in the thenStatement
        newTable = SymbolTable(self.table)
        stmt.table = newTable
        self.table = stmt.table

        for s in stmt.thenStatement:
            s.accept(self)
            
        self.table = self.table.parent
           
    def visitPrintStatement(self, stmt: PrintStatement):
        stmt.value.accept(self)

    def visitReturnStatement(self, stmt: ReturnStatement):
        stmt.value.accept(self)