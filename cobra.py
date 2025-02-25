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

parserData = "var c = 3 var b = 4 c = 3 var d d = 4"

result = parser.parse(parserData)

printVisitor = PrintVisitor()
assemblyVisitor = AssemblyVisitor()
evalVisitor = EvalVisitor()
nodeVisitor = NodeVisitor()

scopeVisitor = ScopeVisitor()

for statement in result:
    res = statement.accept(scopeVisitor)