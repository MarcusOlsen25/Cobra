from ASTstatements import *

class SymbolTable:
    """Implements a classic symbol table for static nested
    scope. The parent scope can be accessed
    via the parent reference.
    """
    def __init__(self, parent, scopeType: str):
        self.paramCounter = 24
        self.varCounter = 0
        self.fieldCounter = 0
        self.methodCounter = -8
        self._tab = {}
        self.parent = parent
        if scopeType == "If" or scopeType == "Else" or scopeType == "While":
            self.level = parent.level
        elif parent:
            self.level = parent.level + 1
        else:
            self.level = 0
        self.scopeType = scopeType

    def insertFunction(self, stmt: FunctionDeclaration, functionLabel: str, newTable: 'SymbolTable'):
        self._tab[stmt.var] = SymbolTable.FunctionValue(stmt, functionLabel, self.level, newTable)

    def insertVar(self, stmt: VarDeclaration):
        if self.scopeType == "Class":
            self._tab[stmt.var] = SymbolTable.FieldValue(stmt, self.level, self.incrementFieldCounter())
        else:
            self._tab[stmt.var] = SymbolTable.VariableValue(stmt, self.decrementVarCounter(), self.level)

    def insertParameter(self, stmt: ParameterStatement):
        self._tab[stmt.var] = SymbolTable.VariableValue(stmt, self.incrementParamCounter(), self.level)

    def insertClass(self, stmt: ClassDeclaration, newTable: 'SymbolTable'):
        self._tab[stmt.var] = SymbolTable.ClassValue(stmt, self.level, newTable)

    def insertMethod(self, stmt: MethodDeclaration, newTable):
        self._tab[stmt.var] = SymbolTable.MethodValue(stmt, self.level, newTable, self.incrementMethodCounter())
        
    # Performs a lookup of a symbol in the whole scope hierarchy
    def lookup(self, name: str):
        if name in self._tab:
            return self._tab[name]
        elif self.parent:
            return self.parent.lookup(name)
        else:
            return None
        
    # Performs a local lookup of a symbol 
    def lookupLocal(self, name: str):
        if name in self._tab:
            return self._tab[name]
        else:
            return None
    
    def incrementFieldCounter(self):
        self.fieldCounter += 8
        return self.fieldCounter
   
    def decrementVarCounter(self):
        self.varCounter -= 8
        return self.varCounter
    
    def incrementParamCounter(self):
        self.paramCounter += 8
        return self.paramCounter
    
    def incrementMethodCounter(self):
        self.methodCounter += 8
        return self.methodCounter
    
    # Used for initialising a class that inherits from another
    def setFieldCounter(self, counter: int):
        self.fieldCounter = counter

    # Used for initialising a class that inherits from another
    def setMethodCounter(self, counter: int):
        self.methodCounter = counter
    
    # Used for initialising symbol tables for conditional statements
    def setVarCounter(self, counter: int):
        self.varCounter = counter

    def getMethods(self):
        return [method for method in self._tab.values() if isinstance(method, SymbolTable.MethodValue)]
        
    class VariableValue:
        def __init__(self, stmt: VarDeclaration, offset: int, level: int):
            self.name = stmt.var
            self.type = stmt.type
            self.offset = offset
            self.level = level
            self.lineNo = stmt.lineno

    class FunctionValue:
        def __init__(self, stmt: FunctionDeclaration, functionName: str, level: int, newTable: 'SymbolTable'):
            self.functionName = functionName
            self.params = stmt.params
            self.body = stmt.body
            self.returnType = stmt.returnType
            self.level = level
            self.table = newTable

    class ClassValue:
        def __init__(self, stmt: ClassDeclaration, level: int, newTable: 'SymbolTable'):
            self.name = stmt.var
            self.table = newTable
            self.level = level
            self.super = stmt.super

    class FieldValue:
        def __init__(self, stmt: VarDeclaration, level: int, offset: int):
            self.name = stmt.var
            self.level = level
            self.offset = offset
            self.type = stmt.type

    class MethodValue:
        def __init__(self, stmt: MethodDeclaration, level: int, table: 'SymbolTable', offset: int):
            self.name = stmt.var + "_" + stmt.className
            self.className = stmt.className
            self.level = level
            self.table = table
            self.offset = offset
            self.returnType = stmt.returnType
            self.params = stmt.params
