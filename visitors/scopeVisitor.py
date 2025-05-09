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
                self.semanticErrors += f"(V) Type mismatch for {stmt.var} in line {stmt.lineno}: expected {stmt.type}, got {inferredType}\n"
        self.table.insert(stmt, stmt.type, None)
        
    # Auxiliary function for type checking
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
            match expr.operator:
                case "+" | "-" | "/" | "*":
                    if left_type == "int" and right_type == "int":
                        return "int"
                    else:
                        return "illegal type in binary operation"
                case "<" | ">" | "<=" | ">=":
                    if left_type == "int" and right_type == "int":
                        return "bool"
                    else:
                        return "illegal type in binary operation"
                case "and" | "or":
                    if left_type == "bool" and right_type == "bool":
                        return "bool"
                    else:
                        return "illegal type in binary operation"
                case "==" | "!=":
                    return "bool"
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
        self.table.insert(stmt, stmt.type, None)

    def visitIfStatement(self, stmt: IfStatement):
        stmt.condition.accept(self)
        
        # Check the type of the condition
        inferredType = self.evaluateExpressionType(stmt.condition)
        if inferredType != "bool" and inferredType != "int":
                self.semanticErrors += f"Type mismatch for the condition in line {stmt.lineno}: expected bool or int, got {inferredType}\n"
        
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
        
        # Check the type of the condition
        inferredType = self.evaluateExpressionType(stmt.condition)
        if inferredType != "bool" and inferredType != "int":
                self.semanticErrors += f"Type mismatch for the condition in line {stmt.lineno}: expected bool or int, got {inferredType}\n"
        
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

        for s in stmt.body:
            s.accept(self)
       
        self.table = self.table.parent
    
    def visitConstructorExpression(self, expr: ConstructorExpression):
        expr.var.accept(self)
        
    def visitPropertyAccessExpression(self, expr: PropertyAccessExpression):
        # Traverse each property call until you come to the end
        varEntry = expr.property.accept(self)
        classEntry = self.table.lookup(varEntry.type)
        propertyEntry = classEntry.table.lookup(expr.var)

        return propertyEntry

    def visitMethodCallExpression(self, expr: MethodCallExpression):
        methodEntry = expr.property.accept(self)
        
        incorrectNrOfParams = len(methodEntry.params) - 1 != len(expr.arguments)
        if incorrectNrOfParams:
            self.semanticErrors = self.semanticErrors + f"Incorrect number of parameters for {methodEntry.name} in line {expr.lineno}\n"

        for arg in expr.arguments:
            arg.accept(self)

        return methodEntry
    
    def visitMethodDeclaration(self, stmt: MethodDeclaration):
        newTable = SymbolTable(self.table, "Method")
        self.table.insert(stmt, "method", newTable)
        self.table = newTable

        stmt.params.append(ParameterStatement(stmt.className, "this", stmt.lineno))

        for param in stmt.params:
            param.accept(self)

        for s in stmt.body:
            s.accept(self)
        
        self.table = self.table.parent