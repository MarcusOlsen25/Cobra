from Lexer import *
from Parser import *
from visitors import visitor
from visitors.printVisitor import PrintVisitor
from visitors.evalVisitor import EvalVisitor
from visitors.assemblyVisitor import AssemblyVisitor
from visitors.nodeVisitor import NodeVisitor
from visitors.scopeVisitor import ScopeVisitor
from scope.SymbolTable import *

lexer = lex.lex()

lexerData = "if then func add(x, y) x + y"

lexer.input(lexerData)

""" while True:
    tok = lexer.token()
    if not tok: break 
    print(tok) """

parser = yacc.yacc()

parserData = '''
var a = 4
var b = 5
c = 2
d = 3
var e = (4+5)-5*6
var f = a + b
'''

data = '''
var a = 3+4
a = 1+2
'''

result = parser.parse(data)

table = SymbolTable(None)

printVisitor = PrintVisitor()
evalVisitor = EvalVisitor()
nodeVisitor = NodeVisitor()

scopeVisitor = ScopeVisitor(table)
assemblyVisitor = AssemblyVisitor(table)

for statement in result:
    res = statement.accept(scopeVisitor)

for s in result:
    res2 = s.accept(assemblyVisitor)
    print(res2)