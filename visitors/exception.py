
class ScopeException(Exception):
    def __init__(self, message: str, lineno: int):
        self.message = message
        self.lineno = lineno
        
class TypeException(Exception):
    def __init__(self, message: str, lineno: int):
        self.message = message
        self.lineno = lineno