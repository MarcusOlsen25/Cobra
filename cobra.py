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
func red(x,y) {
    var a = 0
    while x then {
        var gogo = x + y
        x = x - y
        a = gogo
        }
    a = a
}
red(20,5)

'''

result = parser.parse(data)

printVisitor = PrintVisitor()
evalVisitor = EvalVisitor()
nodeVisitor = NodeVisitor()

table = SymbolTable(None)

scopeVisitor = ScopeVisitor(table)
assemblyVisitor = AssemblyVisitor(table)

#Scope check
for statement in result:
    statement.accept(scopeVisitor)

#Code generation

assemblyVisitor = AssemblyVisitor(table)

#Function prologue for main
assemblyVisitor.startScope(table.varCounter)

for s in result:
    s.accept(assemblyVisitor)

#Function epilogue for main
#To be changed with
#assemblyVisitor.endScope(assemblyVisitor.table.varCounter)
assemblyVisitor.generateCode(f"addq ${assemblyVisitor.table.varCounter}, %rsp\t\t\t# Deallocate global variables")

#Append functions and main
program = []

for function in assemblyVisitor.functions.values():
    program.extend(function)

program += assemblyVisitor.main

for p in program:
    print(p)