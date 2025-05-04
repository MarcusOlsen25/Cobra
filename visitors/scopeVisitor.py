from .visitor import Visitor
from ASTexpressions import *
from ASTstatements import *
from scope.SymbolTable import *

class ScopeVisitor(Visitor):
    
    semanticErrors = ""

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
    
    def visitBoolExpression(self, expr: BoolExpression):
        if expr.value == "true":
            return 1
        elif expr.value == "false":
            return 0
        # Everything other than 0 is still true 
        else:
            return expr.value 
    
    def visitAssignExpression(self, expr: AssignExpression):
        troubleMaker = expr.var.accept(self)    
        if troubleMaker == None:
            self.semanticErrors += f"Undeclared variable {expr.var} in line {expr.lineno}\n"
            return
        declaredType = troubleMaker.type
        inferredType = self.evaluateExpressionType(expr.value)
        if declaredType != inferredType:
            self.semanticErrors += f"Type mismatch for {expr.var.var} in line {expr.lineno}: expected {declaredType}, got {inferredType}\n"
        
    def visitVarDeclaration(self, stmt: VarDeclaration):
        if stmt.initializer != None:
            inferredType = self.evaluateExpressionType(stmt.initializer)
            if inferredType != stmt.type:
                self.semanticErrors += f"Type mismatch for {stmt.var} in line {stmt.lineno}: expected {stmt.type}, got {inferredType}\n"
        self.table.insert(stmt, stmt.type, None)
        
    def evaluateExpressionType(self, expr: Expr) -> str:
        if isinstance(expr, NumberExpression):
            return "int"
        elif isinstance(expr, BoolExpression):
            return "bool"
        elif isinstance(expr, VarExpression):
            entry = self.table.lookup(expr.var)
            return entry.type if entry else "unknown"
        elif isinstance(expr, BinaryExpression):
            left_type = self.evaluateExpressionType(expr.left)
            right_type = self.evaluateExpressionType(expr.right)
            if left_type == right_type:
                return left_type
            else:
                return "type_error"
        elif isinstance(expr, UnaryExpression):
            return self.evaluateExpressionType(expr.value)
        elif isinstance(expr, ConstructorExpression):
            return expr.var.var
        else:
            return "unknown"


    #Using func as a type
    def visitFunctionDeclaration(self, stmt: FunctionDeclaration):
        newTable = SymbolTable(self.table, "Function")
        self.table.insert(stmt, "func", newTable)
        self.table = newTable

        for param in stmt.params:
            param.accept(self)

        for s in stmt.body:
            s.accept(self)
        
        self.table = self.table.parent

    def visitCallExpression(self, expr: CallExpression):
        entry = expr.var.accept(self)
        
        incorrectNrOfParams = len(entry.params) != len(expr.arguments)
        if incorrectNrOfParams:
            self.semanticErrors = self.semanticErrors + f"Incorrect number of parameters for {expr.var.var} in line {expr.lineno}\n"

        for arg in expr.arguments:
            arg.accept(self)
        
    def visitParameterStatement(self, stmt: ParameterStatement):
        if stmt.type != None:
            self.table.insert(stmt, stmt.type, None)
        else:
            self.table.insert(stmt, "int", None)

    def visitIfStatement(self, stmt: IfStatement):
        stmt.condition.accept(self)
        
        # Create a new symbol table and visit the statements in the thenStatement
        newTable = SymbolTable(self.table, "If")
        stmt.thenTable = newTable
        self.table = stmt.thenTable

        for s in stmt.thenStatement:
            s.accept(self)
            
        self.table = self.table.parent

        if stmt.elseStatement != None:
            
            # Create a new symbol table and visit the statements in the elseStatement 
            newTable = SymbolTable(self.table, "Else")
            stmt.elseTable = newTable
            self.table = stmt.elseTable

            for s in stmt.elseStatement:
                s.accept(self)
                
            self.table = self.table.parent
        
    def visitWhileStatement(self, stmt: WhileStatement):
        stmt.condition.accept(self)
        
        # Create a new symbol table and visit the statements in the thenStatement
        newTable = SymbolTable(self.table, "While")
        stmt.table = newTable
        self.table = stmt.table

        for s in stmt.thenStatement:
            s.accept(self)
            
        self.table = self.table.parent
           
    def visitPrintStatement(self, stmt: PrintStatement):
        stmt.value.accept(self)

    def visitReturnStatement(self, stmt: ReturnStatement):
        stmt.value.accept(self)

    def visitClassDeclaration(self, stmt: ClassDeclaration):
        newTable = SymbolTable(self.table, "Class")
        self.table.insert(stmt, "class", newTable)

        self.table = newTable
        methodCounter = -8

        for s in stmt.body:
            s.accept(self)
            
        for entry in self.table._tab.values():
            if isinstance(entry, SymbolTable.FunctionValue):
                methodCounter += 8
                entry.offset = methodCounter
                entry.isMethod = True

        self.table = self.table.parent
    
    def visitConstructorExpression(self, expr: ConstructorExpression):
        entry = expr.var.accept(self)
        
    def visitObjectExpression(self, expr: ObjectExpression):
        currentTable = self.table
        # Traverse each property call until you come to the end
        for o in expr.object:
            objectEntry = o.accept(self)
            classEntry = self.table.lookup(objectEntry.type)
            self.table = classEntry.table
        varEntry = self.table.lookup(expr.var)
        self.table = currentTable
        return varEntry

    def visitPropertyCallExpression(self, expr: PropertyCallExpression):
        currentTable = self.table
        for o in expr.object:
            objectEntry = o.accept(self)
            classEntry = self.table.lookup(objectEntry.type)
            self.table = classEntry.table
        self.table = currentTable
        return