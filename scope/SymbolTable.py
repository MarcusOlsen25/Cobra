from ASTstatements import *


class SymbolTable:
    """Implements a classic symbol table for static nested
    scope. Names for each scope are collected in a
    Python dictionary. The parent scope can be accessed
    via the parent reference.
    """
    def __init__(self, parent):
        self.counter = 8
        self._tab = {}
        self.parent = parent
        if parent != None:
            self.level = parent.level + 1
        else:
            self.level = 0
            
    def insert(self, stmt: Stmt, type: str, newTable: 'SymbolTable'):
        if isinstance(stmt, VarDeclaration):
            self._tab[stmt.var] = SymbolTable.VariableValue(type, self.decrementCounter())
        else:
            self._tab[stmt.var] = SymbolTable.FunctionValue(stmt, self, newTable)

    def lookup(self, name: str):
        if name in self._tab:
            return self._tab[name]
        elif self.parent:
            return self.parent.lookup(name)
        else:
            return None
        
    def decrementCounter(self):
        self.counter += 8
        return self.counter
        
    class VariableValue:
        def __init__(self, type: str, offset: int):
            self.type = type
            self.offset = offset

    class FunctionValue:
        def __init__(self, stmt: FunctionDeclaration, currentTable: 'SymbolTable', newTable: 'SymbolTable'):
            self.name = stmt.var
            self.params = stmt.params
            self.body = stmt.body
            #int by default
            self.returnType = "int"
            self.level = currentTable.level
            self.table = newTable



