from Lexer import *
from Parser import *
from visitors import visitor
from visitors.assemblyVisitor import AssemblyVisitor
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
func one(int x) int {
    return x
}

int b 
b = 7 + c
bool c = false


'''

with open("test.co", "r") as file:
    test = file.read()

result = parser.parse(data)

table = SymbolTable(None, "Function")

scopeVisitor = ScopeVisitor(table)
assemblyVisitor = AssemblyVisitor(table)
#Scope check
for statement in result:
    statement.accept(scopeVisitor)

if scopeVisitor.scopeErrors != []:
    for error in scopeVisitor.scopeErrors:
        print(error.message)
elif scopeVisitor.typeErrors != []:
    for error in scopeVisitor.typeErrors:
        print(error.message)
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

