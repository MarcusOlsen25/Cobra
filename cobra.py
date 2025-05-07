from Lexer import *
from Parser import *
from visitors import visitor
from visitors.printVisitor import PrintVisitor
from visitors.evalVisitor import EvalVisitor
from visitors.assemblyVisitor import AssemblyVisitor
from visitors.nodeVisitor import NodeVisitor
from visitors.scopeVisitor import ScopeVisitor
from scope.SymbolTable import *
from visitors.instruction import *

lexer = lex.lex()

lexerData = "if then func add(x, y) x + y"

lexer.input(lexerData)

""" while True:
    tok = lexer.token()
    if not tok: break 
    print(tok) """

parser = yacc.yacc()

parserData = '''
func one() {
    if 0 then {
        print -1
    } else {
        print 200
    }
}

one()
'''

data = '''
int x = 7
if x then {
    print 2
}

bool y = true
if y then {
    print 3
}

class banan {
    int peel = 3
}
Banan z = new Banan()

'''

with open("test.co", "r") as file:
    test = file.read()

result = parser.parse(test)

printVisitor = PrintVisitor()
evalVisitor = EvalVisitor()
nodeVisitor = NodeVisitor()

table = SymbolTable(None, "Function")

scopeVisitor = ScopeVisitor(table)
assemblyVisitor = AssemblyVisitor(table)

#Scope check
for statement in result:
    statement.accept(scopeVisitor)
    
if scopeVisitor.semanticErrors != "":
    print(scopeVisitor.semanticErrors)
else:
    #Code generation

    assemblyVisitor = AssemblyVisitor(table)

    #Function prologue for main
    assemblyVisitor.startScope()

    for s in result:
        s.accept(assemblyVisitor)

    #Function epilogue for main
    #To be changed with
    assemblyVisitor.endScope()
    assemblyVisitor.generateCode("movq", "$0", "%rax", 3, "# End with error code 0")
    assemblyVisitor.generateCode("ret", None, None, 3, "# Return from main")

    #Append functions and main
    program = []

    program = assemblyVisitor.init.copy()

    for function in assemblyVisitor.functions.values():
        program.extend(function)

    program += assemblyVisitor.main

    for p in program:
        line = prettyPrintAssembly(p)
        print(line)

    with open("assembly/test2.s", "w") as file:
            for p in program:
                file.write(prettyPrintAssembly(p))
                file.write("\n")

