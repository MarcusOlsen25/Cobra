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
print -2
'''

data = '''
var a = 1
print a

var b = a + 1
print b

a = 3
print a

var c = a - b * 3 + 7
print c

var d = c / 9 - 3 * (b + a)
print d
'''

with open("test.co", "r") as file:
    test = file.read()

result = parser.parse(test)

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
assemblyVisitor.startFunctionScope()

for s in result:
    s.accept(assemblyVisitor)

#Function epilogue for main
#To be changed with
assemblyVisitor.endFunctionScope()
assemblyVisitor.generateCode("movq $0, %rax\t\t\t# End with error code 0")
assemblyVisitor.generateCode("ret\t\t\t# Return from main")

#Append functions and main
program = []

for function in assemblyVisitor.functions.values():
    program.extend(function)

program += assemblyVisitor.main

for p in program:
     print(p)

with open("assembly/test2.s", "w") as file:
        file.write(".data\nform:\n\t.string \"%d\\n\"\n")
        for p in program:
            file.write(p)
            file.write("\n")

