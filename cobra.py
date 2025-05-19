from Lexer import *
from Parser import *
from visitors.assemblyVisitor import AssemblyVisitor
from visitors.typeVisitor import TypeVisitor
from visitors.scopeVisitor import ScopeVisitor
from scope.SymbolTable import *
from visitors.instruction import *
from errorTester import *

# The line numbers match the error messages + 10.  
data = '''
class Node {
    int value
    Node left = null
    Node right = null
}
Node root = new Node()
Node firstLeft = new Node()
firstLeft.value = 3
Node secondLeft = new Node()
secondLeft.value = 4
Node firstRight = new Node()
firstRight.value = 5
Node secondRight = new Node()
secondRight.value = 6
Node firstRightLeft = new Node()
firstRightLeft.value = 7
root.left = firstLeft
root.left.left = secondLeft
root.right = firstRight
root.right.right = secondRight
root.left.right = firstRightLeft
Node n = root
if !root.left.right.left then {
    print 123
}


func inorder_traversal(Node root) void {
    if root then {
        inorder_traversal(root.left)
        print(root.value)
        inorder_traversal(root.right)
    }
}
inorder_traversal(root)
'''
    

with open("test.co", "r") as file:
    test = file.read()


# Change this line from 'test' to 'data' and vice versa
cobraCode = data

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
                    assemblyVisitor = AssemblyVisitor(table)

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