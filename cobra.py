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
func one() { 
    func two() {
        return 3
    }
    two()
}
print one()
'''

data = '''
func one(x cat, y dog) {
    return 3
}
one(4, 6, 8)

func two(x, y) {
    return 4
}
two(5)
'''

with open("test.co", "r") as file:
    test = file.read()

result = parser.parse(data)

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
            for p in program:
                file.write(p)
                file.write("\n")

