from Lexer import *
from Parser import *
from visitors.assemblyVisitor import AssemblyVisitor
from visitors.typeVisitor import TypeVisitor
from visitors.scopeVisitor import ScopeVisitor
from scope.SymbolTable import *
from visitors.instruction import *


# The line numbers match the error messages + 10.  
data = '''

int z = 67

class carrot {
    int z = 8
    func four() void {
        print this.z
    }
}

class pineapple {
    int z = 23
    carrot carr = new carrot()
    func three() void {
        print this.z 
        this.carr.four()
    }
    func one() int {
        return 333
    }
    
}

class avocado {
    int z = 37
    pineapple pine = new pineapple()
    func two() void {
        print this.z
        this.pine.three()
    }
}

avocado avoc = new avocado()

func one(avocado avoc) void {
    print z
    avoc.two()
}

one(avoc)
'''
    

with open("test.co", "r") as file:
    test = file.read()

# Change this line from 'test' to 'data' and vice versa
cobraCode = test

table = SymbolTable(None, "Function")

lexer = Lexer()
parser = Parser()
scopeVisitor = ScopeVisitor(table)
typeVisitor = TypeVisitor(table)
assemblyVisitor = AssemblyVisitor(table)

# Lexical analysis
tokens = lexer.tokenize(cobraCode)   
if lexer.lexicalErrors != []:
    for error in lexer.lexicalErrors:
            print(error)
else: 
    
    # Syntactic analysis
    result = parser.parser.parse(cobraCode, lexer=lexer.lexer)
    
    if parser.syntacticErrors != []:
        for error in parser.syntacticErrors:
            print(error)
    else:
    
        #Scope check
        for statement in result:
            statement.accept(scopeVisitor)

        if scopeVisitor.scopeErrors != []:
            for error in scopeVisitor.scopeErrors:
                print(error.message)
        else:
            
            # Type check
            for statement in result:
                statement.accept(typeVisitor)
            if typeVisitor.typeErrors != []:
                for error in typeVisitor.typeErrors:
                    print(error.message)
            elif typeVisitor.functionErrors != []:
                for error in typeVisitor.functionErrors:
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

