from Lexer import *
from Parser import *
from visitors import visitor
from visitors.printVisitor import PrintVisitor
from visitors.evalVisitor import EvalVisitor
from visitors.assemblyVisitor import AssemblyVisitor
from visitors.nodeVisitor import NodeVisitor
from visitors.scopeVisitor import ScopeVisitor

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
var a = 4
var b = 3
var c = 2
a+b*c
'''

result = parser.parse(data)

printVisitor = PrintVisitor()
assemblyVisitor = AssemblyVisitor()
evalVisitor = EvalVisitor()
nodeVisitor = NodeVisitor()
scopeVisitor = ScopeVisitor()
for statement in result:
    res = statement.accept(evalVisitor)
    print(res) 