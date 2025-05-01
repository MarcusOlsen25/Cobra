from ASTstatements import *


class SymbolTable:
    """Implements a classic symbol table for static nested
    scope. Names for each scope are collected in a
    Python dictionary. The parent scope can be accessed
    via the parent reference.
    """
    def __init__(self, parent, scopeType: str):
        self.paramCounter = 16
        self.varCounter = 0
        self.fieldCounter = 0
        self._tab = {}
        self.parent = parent
        if parent != None:
            self.level = parent.level + 1
        else:
            self.level = 0
        self.scopeType = scopeType
            
    def insert(self, stmt: Stmt, type: str, newTable: 'SymbolTable'):
        if isinstance(stmt, VarDeclaration):
            if self.scopeType == "Class":
                self._tab[stmt.var] = SymbolTable.FieldValue(stmt, self.level, self.incrementFieldCounter())
            else:
                self._tab[stmt.var] = SymbolTable.VariableValue(stmt.type, self.decrementVarCounter(), self.level)
        elif isinstance(stmt, ParameterStatement):
            self._tab[stmt.var] = SymbolTable.VariableValue(type, self.incrementParamCounter(), self.level)
        elif isinstance(stmt, ClassDeclaration):
            self._tab[stmt.var.capitalize()] = SymbolTable.ClassValue(stmt, self, newTable)
        else:
            self._tab[stmt.var] = SymbolTable.FunctionValue(stmt, self, newTable)

    def lookup(self, name: str):
        if name in self._tab:
            return self._tab[name]
        elif self.parent:
            return self.parent.lookup(name)
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
        
    class VariableValue:
        def __init__(self, type: str, offset: int, level: int):
            self.type = type
            self.offset = offset
            self.level = level

    class FunctionValue:
        def __init__(self, stmt: FunctionDeclaration, currentTable: 'SymbolTable', newTable: 'SymbolTable'):
            self.name = stmt.var
            self.params = stmt.params
            self.body = stmt.body
            #int by default
            self.returnType = "int"
            self.level = currentTable.level
            self.table = newTable
            self.offset = None
            self.isMethod = False

    class ClassValue:
        def __init__(self, stmt: ClassDeclaration, currentTable: 'SymbolTable', newTable: 'SymbolTable'):
            self.name = stmt.var
            self.table = newTable
            self.level = currentTable.level

    class FieldValue:
        def __init__(self, stmt: VarDeclaration, level: int, offset: int):
            self.level = level
            self.offset = offset
            self.type = stmt.type
