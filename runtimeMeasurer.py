import subprocess
import time

from Lexer import *
from Parser import *
from visitors.assemblyVisitor import AssemblyVisitor
from visitors.typeVisitor import TypeVisitor
from visitors.scopeVisitor import ScopeVisitor
from scope.SymbolTable import *
from visitors.instruction import *
from errorTester import *
from peepholeOptimizer import *



def measureRuntime():
    
    with open("longProgram.co", "r") as file:
        cobraCode = file.read()
    
    # Compile from Cobra to Assembly
    compileOriginal(cobraCode)
    compileOptimised(cobraCode)
    
    # Compile from Assembly to executable
    subprocess.run(["gcc", "assembly/testTime1.s", "-o", "assembly/testTime1"], check=True)
    subprocess.run(["gcc", "assembly/testTime2.s", "-o", "assembly/testTime2"], check=True)
    
    times = 100
    
    # Measure original
    originalAverage = 0
    for i in range(times):
        start_time = time.perf_counter()
        subprocess.run(["assembly/testTime1"], check=True)
        end_time = time.perf_counter()
        originalAverage += end_time - start_time
    
    originalRuntime = originalAverage/times    
    print(f"Execution time of original code: {originalRuntime:.6f} seconds")
        
    # Measure optimised
    optimisedAverage = 0
    for i in range(times):
        start_time = time.perf_counter()
        subprocess.run(["assembly/testTime2"], check=True)
        end_time = time.perf_counter()
        optimisedAverage += end_time - start_time
        
    optimisedRuntime = optimisedAverage/times
    print(f"Execution time of optimised code: {optimisedRuntime:.6f} seconds")
    
    print(f"The optimised code was {originalRuntime - optimisedRuntime:.6f} seconds better.")



def compileOriginal(cobraCode: str):

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
                    assemblyVisitor.addComment(0, ".section .note.GNU-stack")   # This line removes error messages

                    #Append functions and main
                    program = []

                    program = assemblyVisitor.init.copy()

                    for function in assemblyVisitor.functions.values():
                        program.extend(function)

                    program += assemblyVisitor.main
                    
                    # No optimisation
                    
                    with open("assembly/testTime1.s", "w") as file:
                            for p in program:
                                file.write(prettyPrintAssembly(p))
                                file.write("\n")





def compileOptimised(cobraCode: str):

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
                    assemblyVisitor.addComment(0, ".section .note.GNU-stack")   # This line removes error messages

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
                    
                    with open("assembly/testTime2.s", "w") as file:
                            for p in program:
                                file.write(prettyPrintAssembly(p))
                                file.write("\n")
                                
                                
measureRuntime()
