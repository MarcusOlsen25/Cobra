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
func add(x,y) {
    func div(a,b) {
        func three(e,r) {
            add(1,2)
            div(1,2)
            three(1,2)
        }
    }
}
func four(f,g) {
    f + g
}
four(1,2)


'''

result = parser.parse(data)


printVisitor = PrintVisitor()
evalVisitor = EvalVisitor()
nodeVisitor = NodeVisitor()

table = SymbolTable(None)

scopeVisitor = ScopeVisitor(table)

assemblyVisitor = AssemblyVisitor(table)

for statement in result:
    res = statement.accept(scopeVisitor)
