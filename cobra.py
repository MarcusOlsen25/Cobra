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
func one() {
    var a = 2
    func two() {
        b
    }
    func three() {
        var a = 3
        two()
    }
    three()
}
one()
'''

data = '''
var a = 2
if 3 then {
    a
}


'''

result = parser.parse(data)

printVisitor = PrintVisitor()
evalVisitor = EvalVisitor()
nodeVisitor = NodeVisitor()

table = SymbolTable(None, "main")

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
assemblyVisitor.generateCode(f"addq ${abs(assemblyVisitor.table.varCounter)}, %rsp\t\t\t# Deallocate global variables")

#Append functions and main
program = []

for function in assemblyVisitor.functions.values():
    program.extend(function)

program += assemblyVisitor.main

for p in program:
    print(p)