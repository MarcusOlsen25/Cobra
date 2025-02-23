from Lexer import *
from Parser import *
from visitors import visitor
from visitors.printVisitor import PrintVisitor
from visitors.evalVisitor import EvalVisitor
from visitors.assemblyVisitor import AssemblyVisitor

lexer = lex.lex()

lexerData = "if then func add(x, y) x + y"

lexer.input(lexerData)

while True:
    tok = lexer.token()
    if not tok: break 
    print(tok)

parser = yacc.yacc()

parserData = "var a"

result = parser.parse(parserData)

printVisitor = PrintVisitor()
assemblyVisitor = AssemblyVisitor()
evalVisitor = EvalVisitor()

res = result.accept(printVisitor)

print(res)