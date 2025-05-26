from .visitor import Visitor
from ASTexpressions import *
from ASTstatements import *
from scope.SymbolTable import *
from .exception import *

class ScopeVisitor(Visitor):
    
    def __init__(self, table: SymbolTable, scopeErrors):
        self.table = table
        self.scopeErrors = scopeErrors
        self.functionStack = []
        
    def addScopeError(self, message: str, lineno: int):
        exception = ScopeException(message, lineno)
        self.scopeErrors.append(exception)
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
                self.addScopeError(f"Undeclared variable {expr.var} in line {expr.lineno}.", expr.lineno)
            elif not (isinstance(lookup, SymbolTable.VariableValue) or isinstance(lookup, SymbolTable.FieldValue) 
                      or isinstance(lookup, SymbolTable.ClassValue)):
                self.addScopeError(f"The ID {expr.var} in line {expr.lineno} is neither a variable nor a field.", expr.lineno)
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
        expr.var.accept(self) 
        expr.value.accept(self)
                    
    def visitVarDeclaration(self, stmt: VarDeclaration):
        try:
            if self.table.lookupLocal(stmt.var):
                self.addScopeError(f"The variable {stmt.var} in line {stmt.lineno} is already defined in this scope.", stmt.lineno)
            else:
                if stmt.type != "int" and stmt.type != "bool":
                    classEntry = self.table.lookup(stmt.type)
                    if not classEntry:
                        self.addScopeError(f"The class {stmt.type} referenced in line {stmt.lineno} is not defined.", stmt.lineno)
                self.table.insertVar(stmt)
                if stmt.initializer:
                    stmt.initializer.accept(self)     
        except ScopeException:
            return
    
    #Using func as a type
    def visitFunctionDeclaration(self, stmt: FunctionDeclaration):
        try:
            if self.table.lookup(stmt.var):
                self.addScopeError(f"The variable {stmt.var} in line {stmt.lineno} is already defined.", stmt.lineno)
            else:
                functionName = self.getFunctionName(stmt.var)
                self.functionStack.append(functionName)
                newTable = SymbolTable(self.table, "Function")
                self.table.insertFunction(stmt, functionName, newTable)
                self.table = newTable

                for param in stmt.params:
                    param.accept(self)

                for s in stmt.body:
                    s.accept(self)
                    
                self.table = self.table.parent
                self.functionStack.pop()
        except ScopeException:
            return
    
    def visitCallExpression(self, expr: CallExpression):
        try:
            lookup = self.table.lookup(expr.var.var)
            if not lookup:
                self.addScopeError(f"The function {expr.var.var} from line {expr.lineno} is not defined.", expr.lineno)
            elif not isinstance(lookup, SymbolTable.FunctionValue):
                self.addScopeError(f"The ID {expr.var.var} in line {expr.lineno} is not a function.", expr.lineno)
            else:
                for i in range(len(expr.arguments) - 1, -1, -1):
                    expr.arguments[i].accept(self)
        except ScopeException:
            return

    def visitParameterStatement(self, stmt: ParameterStatement):
        try:
            lookup = self.table.lookupLocal(stmt.var)
            if lookup:
                self.addScopeError(f"The variable {stmt.var} in line {stmt.lineno} is already defined in this scope.", stmt.lineno)
            else:
                self.table.insertParameter(stmt)
        except ScopeException:
            return

    def visitIfStatement(self, stmt: IfStatement):
        stmt.condition.accept(self)
        
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
        if stmt.value:
            stmt.value.accept(self)
            
    def visitClassDeclaration(self, stmt: ClassDeclaration):
        try:
            # This lookup is not local. This is because of class descriptors. Do you agree, Marcus?
            lookup = self.table.lookup(stmt.var)
            if lookup:
                self.addScopeError(f"The variable {stmt.var} in line {stmt.lineno} is already defined.", stmt.lineno)
            else:
                newTable = SymbolTable(self.table, "Class")
                self.table.insertClass(stmt, newTable)
                superEntry = None
                if stmt.super:
                    superEntry = self.table.lookup(stmt.super)
                    if not superEntry:
                        self.addScopeError(f"Scope error for {stmt.var} in line {stmt.lineno}.", stmt.lineno)
                    else:
                        newTable.setFieldCounter(superEntry.table.fieldCounter)
                        newTable.setMethodCounter(superEntry.table.methodCounter)

                self.table = newTable

                for s in stmt.body:
                    s.accept(self)
            
                self.table = self.table.parent
        except ScopeException:
            return
    
    def visitConstructorExpression(self, expr: ConstructorExpression):
        return expr.var.accept(self)
        
    def visitPropertyAccessExpression(self, expr: PropertyAccessExpression):
        try:
            # Traverse each property call until you come to the end
            varEntry = expr.property.accept(self)
            if not varEntry:
                self.addScopeError(f"Error accessing a property in line {expr.lineno}.", expr.lineno) 
            elif not (isinstance(varEntry, SymbolTable.VariableValue) or isinstance(varEntry, SymbolTable.FieldValue) or isinstance(varEntry, SymbolTable.ClassValue)):
                self.addScopeError(f"Error: {expr.property.var} in line {expr.lineno} has no properties, since it is neither a variable nor a field.", expr.lineno)
            else:
                if not isinstance(varEntry, SymbolTable.ClassValue):
                    classEntry = self.table.lookup(varEntry.type)
                else:
                    classEntry = varEntry
                    
                if not classEntry:
                    self.addScopeError(f"Couldn't find class {varEntry.type} in line {expr.lineno}\n", expr.lineno)
                else:
                    propertyEntry = classEntry.table.lookupLocal(expr.var)
                    while not propertyEntry and classEntry.super:
                        classEntry = self.table.lookup(classEntry.super)
                        propertyEntry = classEntry.table.lookupLocal(expr.var)
                    if not propertyEntry:
                        self.addScopeError(f"The property {expr.var} from line {expr.lineno} could not be found.", expr.lineno)
                    else:
                        return propertyEntry
        except ScopeException:
            return

    def visitMethodCallExpression(self, expr: MethodCallExpression):  
        try:
            methodEntry = expr.property.accept(self)
            if not methodEntry:
                pass
                # self.addScopeError(f"The method {expr.property.var} from line {expr.lineno} is not defined.", expr.lineno)
            elif not isinstance(methodEntry, SymbolTable.MethodValue):
                self.addScopeError(f"The ID {methodEntry.name} in line {expr.lineno} is not a method.", expr.lineno)
            else:
                for arg in expr.arguments:
                    arg.accept(self)
            return methodEntry

        except ScopeException:
            return

    def visitMethodDeclaration(self, stmt: MethodDeclaration):
        try:
            lookup = self.table.lookupLocal(stmt.var)
            if lookup:
                self.addScopeError(f"The method {stmt.var} in line {stmt.lineno} is already defined in this scope.", stmt.lineno)
            else:
                newTable = SymbolTable(self.table, "Method")
                self.table.insertMethod(stmt, newTable)
                self.table = newTable

                stmt.params.append(ParameterStatement(stmt.className, "this", stmt.lineno))

                for param in stmt.params:
                    param.accept(self)

                for s in stmt.body:
                    s.accept(self)
                
                self.table = self.table.parent
        except ScopeException:
            return
        
    def visitNullExpression(self, expr: NullExpression):
        pass

    def getFunctionName(self, function: str):
        if len(self.functionStack) == 0:
            return function
        else: 
            return self.functionStack[-1] + "_" + function