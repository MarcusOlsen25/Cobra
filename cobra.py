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
var a = 1
while a < 10 then {
    print a
    a = a + 1
}
'''

data = '''
var a = 1
var b = 2
var c = 3
var d = 4
var e = 5
if 3 then {
    print a
    if 3 then {
        print b
        if 0 then {
            print c
            if 0 then {
                print d
            }
            print c
        }
        if 3 then {
            print e
        }
        print b
    }
    print a
}
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