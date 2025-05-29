from Lexer import *
from Parser import *
from visitors.assemblyVisitor import AssemblyVisitor
from visitors.typeVisitor import TypeVisitor
from visitors.scopeVisitor import ScopeVisitor
from scope.SymbolTable import *
from visitors.instruction import *
from errorTester import *
from peepholeOptimizer import *
# The line numbers match the error messages + 10.  
data = '''

class tiger {
    int x = 3;
    func one() int {
        return this.x;
    }
}

tiger tigger = new tiger();
print tigger.one();
'''
    

# with open("test.co", "r") as file:
#     test = file.read()
    
with open("longProgram.co", "r") as file:
    test = file.read()

# Change this line from 'test' to 'data' and vice versa
cobraCode = test

# Runs the main program
def compileCobra(cobraCode: str):

    table = SymbolTable(None, "Function")

    lexer = Lexer()
    parseLex = Lexer()  
    parser = Parser([])
    scopeVisitor = ScopeVisitor(table, [])
    typeVisitor = TypeVisitor(table, [], [])
    assemblyVisitor = AssemblyVisitor(table)

    # Lexical analysis
    lexer.tokenize(cobraCode) 

    if lexer.lexicalErrors != []:
        for error in lexer.lexicalErrors:
                print(error)
    else: 
        
        # Syntactic analysis
        result = parser.parser.parse(cobraCode, lexer=parseLex.lexer)
        
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
                
                # Type and function check
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

                    #Function prologue for main
                    assemblyVisitor.startScope()

                    for s in result:
                        s.accept(assemblyVisitor)

                    #Function epilogue for main
                    assemblyVisitor.endScope()
                    assemblyVisitor.generateCode("movq", "$0", "%rax", 3, "# End with error code 0")
                    assemblyVisitor.generateCode("ret", None, None, 3, "# Return from main")

                    #Append functions and main
                    program = []

                    program = assemblyVisitor.init.copy()

                    for function in assemblyVisitor.functions.values():
                        program.extend(function)

                    program += assemblyVisitor.main
                    
                    # Optimise the program
                    peepholeOptimizer = PeepholeOptimizer(program)
                    peepholeOptimizer.optimise()
                    program = peepholeOptimizer.instructions
                    
                    print("Program compiled successfully into test.s")

                    with open("assembly/test.s", "w") as file:
                            for p in program:
                                file.write(prettyPrintAssembly(p))
                                file.write("\n")


# Runs the program as normal
compileCobra(cobraCode)  

# Test programs for error handling
# testAllErrors()
# testLexicalErrors()         
# testSyntacticErrors()
# testScopeErrors()
# testTypeErrors()
# testFunctionErrors()