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
var b = 4
print b
var c = 87
func one() {
    var a = 2
    func two() {
        print b
    }
    func three() {
        var a = 3
        print a
        two()
    }
    three()
    print c
}
one()
'''

data = '''
var a = 3
var b = 2
print a
print b
'''

result = parser.parse(parserData)

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
assemblyVisitor.endScope(assemblyVisitor.table.varCounter)
assemblyVisitor.generateCode("movq $0, %rax\t\t\t# End with error code 0")
assemblyVisitor.generateCode("ret\t\t\t# Return from main")

#Append functions and main
program = []

for function in assemblyVisitor.functions.values():
    program.extend(function)

program += assemblyVisitor.main

for p in program:
    print(p)