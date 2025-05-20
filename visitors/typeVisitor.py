from visitors.visitor import Visitor
from ASTexpressions import *
from ASTstatements import *
from scope.SymbolTable import *
from .exception import *

class TypeVisitor(Visitor):

    def __init__(self, table: SymbolTable, typeErrors, functionErrors):
        self.table = table
        self.typeErrors = typeErrors
        self.functionErrors = functionErrors
    
    def addTypeError(self, message: str, lineno: int):
        exception = TypeException(message, lineno)
        self.typeErrors.append(exception)
        raise exception
    
    def addFunctionError(self, message: str, lineno: int):
        exception = FunctionException(message, lineno)
        self.functionErrors.append(exception)
        raise exception
    
    def visitUnaryExpression(self, expr: UnaryExpression):
        try:
            expr.value.accept(self)
            valueType = self.evaluateExpressionType(expr.value)
            if valueType != "int" and expr.operator == "-":
                self.addTypeError(f"Type error in line {expr.lineno}: The operand '-' is only compatible with integer expressions, got {valueType} instead.", expr.lineno)

        except TypeException:
            return

    def visitBinaryExpression(self, expr: BinaryExpression):
        expr.left.accept(self)
        expr.right.accept(self)
        # Check that it has no illegal types
        self.evaluateExpressionType(expr)
    
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
        try:
            var = expr.var.accept(self) 
            declaredType = var.type
            inferredType = self.evaluateExpressionType(expr.value)
            if not self.compareTypes(inferredType, declaredType):
                self.addTypeError(f"Type mismatch for {expr.var.var} in line {expr.lineno}: expected {declaredType}, got {inferredType}.", expr.lineno)           
        except TypeException:
            return
                    
    def visitVarDeclaration(self, stmt: VarDeclaration):
        try:
            if stmt.initializer:
                inferredType = self.evaluateExpressionType(stmt.initializer)
                if not self.compareTypes(inferredType, stmt.type):
                    self.addTypeError(f"Type mismatch for {stmt.var} in line {stmt.lineno}: expected {stmt.type}, got {inferredType}.", stmt.lineno)
            
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
            elif isinstance(expr, PropertyAccessExpression):
                return expr.accept(self).type
            elif isinstance(expr, CallExpression):
                entry = expr.var.accept(self)
                return entry.returnType
            elif isinstance(expr, MethodCallExpression):
                entry = expr.property.accept(self)
                return entry.returnType
            elif isinstance(expr, NullExpression):
                return expr.type
            else:
                # We do not want to get here
                return "unknown"
        except TypeException:
            return 


    #Using func as a type
    def visitFunctionDeclaration(self, stmt: FunctionDeclaration):   
        try:
            # Find the correct symbol table
            func = self.table.lookup(stmt.var)
            self.table = func.table

            for param in stmt.params:
                param.accept(self)

            for s in stmt.body:
                s.accept(self)
            
            # Check that the return types match the function definition
            returnTypes = self.findReturnStatements(stmt.body)
            if returnTypes == [] and stmt.returnType != "void":
                self.addFunctionError(f"Type mismatch in line {stmt.lineno}: {stmt.var} returns {stmt.returnType}, not void.", stmt.lineno)
            elif returnTypes != []:
                for type in returnTypes:
                    if type[0] != stmt.returnType:
                        self.addFunctionError(f"Type mismatch in line {type[1]}: {stmt.var} returns {stmt.returnType}, not {type[0]}.", stmt.lineno)
            self.table = self.table.parent
        except FunctionException:
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
            incorrectNrOfArgs = len(entry.params) != len(expr.arguments)
            if incorrectNrOfArgs:
                self.addFunctionError(f"Incorrect number of arguments for {expr.var.var} in line {expr.lineno}.", expr.lineno)
            
            # Type check
            i = 0
            while i < len(expr.arguments):
                inferredType = self.evaluateExpressionType(expr.arguments[i])
                declaredType = entry.params[i].type
                if not self.compareTypes(inferredType, declaredType):
                    self.addFunctionError(f"The arguments given in line {expr.lineno} do not match the types of the parameters for {entry.name}.", expr.lineno)
                expr.arguments[i].accept(self)
                i += 1
            
        except FunctionException:
            return
        
    def visitParameterStatement(self, stmt: ParameterStatement):
        pass

    def visitIfStatement(self, stmt: IfStatement):
        try:
            stmt.condition.accept(self)
            
            self.table = stmt.thenTable

            for s in stmt.thenStatement:
                s.accept(self)
                
            self.table = self.table.parent

            if stmt.elseStatement:
                
                self.table = stmt.elseTable

                for s in stmt.elseStatement:
                    s.accept(self)
                    
                self.table = self.table.parent
                
        except TypeException:
            return
    
    def visitWhileStatement(self, stmt: WhileStatement):
        try:
            stmt.condition.accept(self)
            
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
        classEntry = self.table.lookup(stmt.var)
        self.table = classEntry.table

        for s in stmt.body:
            s.accept(self)
    
        self.table = self.table.parent
    
    def visitConstructorExpression(self, expr: ConstructorExpression):
        expr.var.accept(self)
        
    def visitPropertyAccessExpression(self, expr: PropertyAccessExpression):
        # Traverse each property call until you come to the end
        varEntry = expr.property.accept(self)
        classEntry = self.table.lookup(varEntry.type)
        propertyEntry = classEntry.table.lookupLocal(expr.var)
        while not propertyEntry and classEntry.super:
            classEntry = self.table.lookup(classEntry.super)
            propertyEntry = classEntry.table.lookupLocal(expr.var)

        return propertyEntry

    def visitMethodCallExpression(self, expr: MethodCallExpression):
        try:
            methodEntry = expr.property.accept(self)
            
            incorrectNrOfArgs = len(methodEntry.params) - 1 != len(expr.arguments)
            if incorrectNrOfArgs:
                self.addFunctionError(f"Incorrect number of arguments for {methodEntry.name} in line {expr.lineno}, expected {len(methodEntry.params)}, got {len(expr.arguments)}.", expr.lineno)

            # Type check
            i = 0
            while i < len(expr.arguments):
                inferredType = self.evaluateExpressionType(expr.arguments[i])
                declaredType = methodEntry.params[i].type
                if inferredType != declaredType:
                    self.addFunctionError(f"The arguments given in line {expr.lineno} do not match the types of the parameters for {methodEntry.name}.", expr.lineno)
                expr.arguments[i].accept(self)
                i += 1

            return methodEntry
        except FunctionException:
            return
    
    def visitMethodDeclaration(self, stmt: MethodDeclaration):
        method = self.table.lookupLocal(stmt.var)
        self.table = method.table

        for param in stmt.params:
            param.accept(self)

        for s in stmt.body:
            s.accept(self)
        
        self.table = self.table.parent
        
    def compareTypes(self, inferred, declared):
        return declared == inferred or isinstance(inferred, NullType)
    
    def visitNullExpression(self, expr: NullExpression):
        return expr.type