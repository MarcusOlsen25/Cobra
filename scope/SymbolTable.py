from ASTstatements import *


class SymbolTable:
    """Implements a classic symbol table for static nested
    scope. Names for each scope are collected in a
    Python dictionary. The parent scope can be accessed
    via the parent reference.
    """
    def __init__(self, parent):
        self.paramCounter = 16
        self.varCounter = 0
        self._tab = {}
        self.parent = parent
        if parent != None:
            self.level = parent.level + 1
        else:
            self.level = 0
            
    def insert(self, stmt: Stmt, type: str, newTable: 'SymbolTable'):
        if isinstance(stmt, VarDeclaration):
            self._tab[stmt.var] = SymbolTable.VariableValue(type, self.decrementVarCounter(), self.level)
        elif isinstance(stmt, ParameterStatement):
            self._tab[stmt.var] = SymbolTable.VariableValue(type, self.incrementParamCounter(), self.level)
        else:
            self._tab[stmt.var] = SymbolTable.FunctionValue(stmt, self, newTable)

    def lookup(self, name: str):
        if name in self._tab:
            return self._tab[name]
        elif self.parent:
            return self.parent.lookup(name)
        else:
            return None
    
    def findStaticLink(self, name: str):
        current_table = self
        while current_table: 
            if name in current_table._tab: 
                return current_table 
            current_table = current_table.parent 
        return None 
        
    def findScope(self, name: str):
        if self.name == name:
            print("ASD")
            return self
        else:
            return self.findScope(self.parent.name)
        
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
