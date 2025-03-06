class SymbolTable:
    """Implements a classic symbol table for static nested
    scope. Names for each scope are collected in a
    Python dictionary. The parent scope can be accessed
    via the parent reference.
    """
    def __init__(self, parent):
        self.counter = 0
        self._tab = {}
        self.parent = parent

    def insert(self, name, value):
        self._tab[name] = value

    def insertExisting(self, name, value):
        entry = self.lookup(name)
        self._tab[name] = Value(value, entry.position)

    def lookup(self, name):
        if name in self._tab:
            return self._tab[name]
        elif self.parent:
            return self.parent.lookup(name)
        else:
            return None
        
    def decrementCounter(self):
        self.counter -= 8
        return self.counter
        
class Value:
    def __init__(self, value, position):
        self.value = value
        self.position = position