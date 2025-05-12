from .visitor import Visitor
from ASTexpressions import *
from ASTstatements import *
from scope.SymbolTable import *
from .exception import *

class ScopeVisitor(Visitor):
    
    scopeErrors = []
    typeErrors = []

    def __init__(self, table: SymbolTable):
        self.table = table
        
    def addScopeError(self, message: str, lineno: int):
        exception = ScopeException(message, lineno)
        self.scopeErrors.append(exception)
        raise exception
    
    def addTypeError(self, message: str, lineno: int):
        exception = TypeException(message, lineno)
        self.typeErrors.append(exception)
        raise exception
    
    def visitUnaryExpression(self, expr: UnaryExpression):
        expr.value.accept(self)

    def visitBinaryExpression(self, expr: BinaryExpression):
        expr.left.accept(self)
        expr.right.accept(self)
    
    def visitNumberExpression(self, expr: NumberExpression):
        return expr.value
    
    def visitVarExpression(self, expr: VarExpression):
        try:
            lookup = self.table.lookup(expr.var)
            if not lookup:
                self.addScopeError(f"The variable {expr.var} is not defined.\n", expr.lineno)
            else:
                return lookup
        except ScopeException:
            return
    
    def visitBoolExpression(self, expr: BoolExpression):
        if expr.value == "true":
            return 1
        elif expr.value == "false":
            return 0
        # Everything other than 0 is still true 
        else:
            return expr.value 
    
    def visitAssignExpression(self, expr: AssignExpression):
        try:   
            var = expr.var.accept(self) 
            if not var:
                self.addScopeError(f"Undeclared variable {expr.var.var} in line {expr.lineno}.\n", expr.lineno)
            
            try:
                declaredType = var.type
                inferredType = self.evaluateExpressionType(expr.value)
                if declaredType != inferredType:
                    self.addTypeError(f"Type mismatch for {expr.var.var} in line {expr.lineno}: expected {declaredType}, got {inferredType}.\n", expr.lineno)           
            except TypeException:
                return
        except ScopeException:
            return
                    
    def visitVarDeclaration(self, stmt: VarDeclaration):
        try:
            if stmt.initializer:
                inferredType = self.evaluateExpressionType(stmt.initializer)
                if inferredType != stmt.type:
                    self.addTypeError(f"Type mismatch for {stmt.var} in line {stmt.lineno}: expected {stmt.type}, got {inferredType}.\n", stmt.lineno)
            
            try:
                if self.table.lookup(stmt.var):
                    self.addScopeError(f"The variable {stmt.var} is already defined.\n", stmt.lineno)
                else:
                    self.table.insert(stmt, stmt.type, None)
            except ScopeException:
                return
        except TypeException:
            return
        
        
    # Auxiliary function for type checking
    def evaluateExpressionType(self, expr: Expr) -> str:
        try: 
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
                            self.addTypeError(f"Illegal type in binary operation in line {expr.lineno}.", expr.lineno)
                    case "<" | ">" | "<=" | ">=":
                        if left_type == "int" and right_type == "int":
                            return "bool"
                        else:
                            self.addTypeError(f"Illegal type in binary operation in line {expr.lineno}.", expr.lineno)
                    case "and" | "or":
                        if left_type == "bool" and right_type == "bool":
                            return "bool"
                        else:
                            self.addTypeError(f"Illegal type in binary operation in line {expr.lineno}.", expr.lineno)
                    case "==" | "!=":
                        return "bool"
            elif isinstance(expr, UnaryExpression):
                return self.evaluateExpressionType(expr.value)
            elif isinstance(expr, ConstructorExpression):
                return expr.var.var
            else:
                # We do not want to get here
                return "unknown"
        except TypeException:
            return 


    #Using func as a type
    def visitFunctionDeclaration(self, stmt: FunctionDeclaration):
        try:
            if self.table.lookup(stmt.var):
                self.addScopeError(f"The variable {stmt.var} is already defined.\n", stmt.lineno)
            else:
                newTable = SymbolTable(self.table, "Function")
                self.table.insert(stmt, "func", newTable)
                self.table = newTable

                for param in stmt.params:
                    param.accept(self)

                for s in stmt.body:
                    s.accept(self)
                
                try:
                    # Check that the return types match the function definition
                    returnTypes = self.findReturnStatements(stmt.body)
                    if returnTypes == [] and stmt.returnType != "void":
                        self.addTypeError(f"Type mismatch in line {stmt.lineno}: {stmt.var} returns {stmt.returnType}, not void.\n", stmt.lineno)
                    elif returnTypes != []:
                        for type in returnTypes:
                            if type[0] != stmt.returnType:
                                self.addTypeError(f"Type mismatch in line {type[1]}: {stmt.var} returns {stmt.returnType}, not {type[0]}.\n", stmt.lineno)
                    self.table = self.table.parent
                except TypeException:
                    return
        except ScopeException:
            return

    # Auxiliary recursive function for type-checking return statements 
    def findReturnStatements(self, list: list[Stmt]):
        # A list of all the return types found 
        types = []
        
        for s in list:
            if isinstance(s, ReturnStatement):
                if s.value:
                    types = types + [(self.evaluateExpressionType(s.value), s.lineno)]
                else:
                    types = types + [("void", s.lineno)]
            elif isinstance(s, IfStatement):
                types += self.findReturnStatements(s.thenStatement)
                if s.elseStatement:
                    types += self.findReturnStatements(s.elseStatement)
            elif isinstance(s, WhileStatement):
                types += self.findReturnStatements(s.thenStatement)
        
        return types
    
    def visitCallExpression(self, expr: CallExpression):
        try:
            entry = expr.var.accept(self)
            incorrectNrOfParams = len(entry.params) != len(expr.arguments)
            if incorrectNrOfParams:
                self.addScopeError(f"Incorrect number of parameters for {expr.var.var} in line {expr.lineno}.\n", expr.lineno)
            for arg in expr.arguments:
                arg.accept(self)
        except ScopeException:
            return
        
    def visitParameterStatement(self, stmt: ParameterStatement):
        self.table.insert(stmt, stmt.type, None)

    def visitIfStatement(self, stmt: IfStatement):
        try:
            stmt.condition.accept(self)
            
            # Check the type of the condition
            inferredType = self.evaluateExpressionType(stmt.condition)
            if inferredType != "bool" and inferredType != "int":
                self.addTypeError(f"Type mismatch for the condition in line {stmt.lineno}: expected bool or int, got {inferredType}.\n", stmt.lineno)    
            
            # Create a new symbol table and visit the statements in the thenStatement
            newTable = SymbolTable(self.table, "If")
            stmt.thenTable = newTable
            self.table = stmt.thenTable

            for s in stmt.thenStatement:
                s.accept(self)
                
            self.table = self.table.parent

            if stmt.elseStatement:
                
                # Create a new symbol table and visit the statements in the elseStatement 
                newTable = SymbolTable(self.table, "Else")
                stmt.elseTable = newTable
                self.table = stmt.elseTable

                for s in stmt.elseStatement:
                    s.accept(self)
                    
                self.table = self.table.parent
                
        except TypeException:
            return
    
    def visitWhileStatement(self, stmt: WhileStatement):
        try:
            stmt.condition.accept(self)
            
            # Check the type of the condition
            inferredType = self.evaluateExpressionType(stmt.condition)
            if inferredType != "bool" and inferredType != "int":
                self.addTypeError(f"Type mismatch for the condition in line {stmt.lineno}: expected bool or int, got {inferredType}.\n", stmt.lineno)
            
            # Create a new symbol table and visit the statements in the thenStatement
            newTable = SymbolTable(self.table, "While")
            stmt.table = newTable
            self.table = stmt.table

            for s in stmt.thenStatement:
                s.accept(self)
                
            self.table = self.table.parent
            
        except TypeException:
            return
               
    def visitPrintStatement(self, stmt: PrintStatement):
        stmt.value.accept(self)

    def visitReturnStatement(self, stmt: ReturnStatement):
        if stmt.value:
            stmt.value.accept(self)
            
    def visitClassDeclaration(self, stmt: ClassDeclaration):
        try:
            lookup = self.table.lookup(stmt.var)
            if lookup:
                self.addScopeError(f"The variable {stmt.var} is already defined.\n", stmt.lineno)
            else:
                newTable = SymbolTable(self.table, "Class")
                self.table.insert(stmt, "class", newTable)
                self.table = newTable

                for s in stmt.body:
                    s.accept(self)
            
                self.table = self.table.parent
        except ScopeException:
            return
    
    def visitConstructorExpression(self, expr: ConstructorExpression):
        expr.var.accept(self)
        
    def visitPropertyAccessExpression(self, expr: PropertyAccessExpression):
        # Traverse each property call until you come to the end
        varEntry = expr.property.accept(self)
        classEntry = self.table.lookup(varEntry.type)
        propertyEntry = classEntry.table.lookup(expr.var)

        return propertyEntry

    def visitMethodCallExpression(self, expr: MethodCallExpression):
        try:
            methodEntry = expr.property.accept(self)
            
            incorrectNrOfParams = len(methodEntry.params) - 1 != len(expr.arguments)
            if incorrectNrOfParams:
                self.addScopeError(f"Incorrect number of parameters for {methodEntry.name} in line {expr.lineno}.\n", expr.lineno)

            for arg in expr.arguments:
                arg.accept(self)

            return methodEntry
        except ScopeException:
            return
    
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