from Lexer import *
from Parser import *
from visitors.typeVisitor import TypeVisitor
from visitors.scopeVisitor import ScopeVisitor
from scope.SymbolTable import *
from visitors.instruction import *

# This program defines tests to ensure the correctness of the Cobra compiler. 

def testAllErrors():
    testLexicalErrors()         
    testSyntacticErrors()
    testScopeErrors()
    testTypeErrors()
    testFunctionErrors()

def testLexicalErrors():
    
    print("Testing lexical errors now:")
    
    expectedErrorMessages = [
        "Illegal character 'Æ' in line 2", 
        "Illegal character 'Ø' in line 2", 
        "Illegal character 'Å' in line 2", 
        "Illegal character '?' in line 3", 
        "Illegal character '¤' in line 4", 
        "Illegal character '#' in line 5", 
        "Illegal character '½' in line 8", 
        "Illegal character '&' in line 10", 
        "Illegal character '%' in line 10", 
        "Illegal character '[' in line 11", 
        "Illegal character ']' in line 11", 
        "Illegal character '@' in line 12", 
        "Illegal character '~' in line 14", 
        "Illegal character '~' in line 14", 
        "Illegal character '|' in line 15"]
    
    with open("testLexErrors.co", "r") as file:
        cobraCode = file.read()
    
    lexer = Lexer()
    lexer.tokenize(cobraCode)   
    
    success = True

    if len(lexer.lexicalErrors) == len(expectedErrorMessages):
        i = 0
        for error in lexer.lexicalErrors:
            if error != expectedErrorMessages[i]:
                success = False
                print(f"Expected: {expectedErrorMessages[i]}, got: {error}.\n")
            i += 1
    else: 
        print("Failure: not all the lexical errors in the file were detected.\n")
        success = False
    
    if success:
        print("Lexical Error Detection: Success!\n")
    else:
        print("Lexical Error Detection: Failure!\n")
        
        
        
        
# Apparently, testing syntactic errors is not as easy. One error at a time. 
def testSyntacticErrors():
    print("Testing syntactic errors now:")
    
    success = True
    
    test1Code = '''
        int num = 33

        if then {
            print num
        }
        '''
    test1ExpectedErrors = ["Syntax error at line 4: Unexpected token 'then'"]
    test1 = auxTestSyntacticErrors(test1Code, test1ExpectedErrors, 1)
    
    test2Code = '''
        func one() void {
            int var = 0
        }

        func(35)
        '''
    test2ExpectedErrors = ["Syntax error at line 6: Unexpected token '('"]
    test2 = auxTestSyntacticErrors(test2Code, test2ExpectedErrors, 2)
    
    test3Code = '''
        func two {
            print 3
        }
        '''
    test3ExpectedErrors = ["Syntax error at line 2: Unexpected token '{'"]
    test3 = auxTestSyntacticErrors(test3Code, test3ExpectedErrors, 3)
    
    test4Code = '''
        func two {
            print 3
        }
        '''
    test4ExpectedErrors = ["Syntax error at line 2: Unexpected token '{'"]
    test4 = auxTestSyntacticErrors(test4Code, test4ExpectedErrors, 4)
    
    if not (test1 and test2 and test3):
        success = False
    
    if success:
        print("Syntactic Error Detection: Success!\n")
    else:
        print("Syntactic Error Detection: Failure!\n")
        

def auxTestSyntacticErrors(cobraCode: str, expectedErrors: list[str], testNr: int):
    success = True
    parseLex = Lexer()  
    parser = Parser([])    
    parser.parser.parse(cobraCode, lexer=parseLex.lexer)
    
    if len(parser.syntacticErrors) != len(expectedErrors):
        print(f"\tTest {testNr} does not catch all errors.")
        success = False
    else:
        i = 0
        for error in parser.syntacticErrors:
            if error != expectedErrors[i]:
                success = False
                print(f"\tTest {testNr}; Expected: {expectedErrors[i]}, got: {error}.\n")
            i += 1
    
    if success:
        print(f"\tTest {testNr} succeeded!")
        return True
    else:
        print(f"\tTest {testNr} fails! :(")
        return False

        
def testScopeErrors():
    
    print("Testing scope errors now:")
    
    expectedErrorMessages = [
        "Undeclared variable c in line 4.",
        "Undeclared variable y in line 7.",
        "The variable b in line 10 is already defined in this scope.",
        "The function two from line 12 is not defined.",
        "Undeclared variable z in line 15."
    ]
    
    with open("testScopeErrors.co", "r") as file:
        cobraCode = file.read()

    table = SymbolTable(None, "Function")

    parseLex = Lexer() 
    parser = Parser([])
    scopeVisitor = ScopeVisitor(table, [])
    result = parser.parser.parse(cobraCode, lexer=parseLex.lexer)
    
    for statement in result:
        statement.accept(scopeVisitor)
    
    success = True

    if len(scopeVisitor.scopeErrors) == len(expectedErrorMessages):
        i = 0
        for error in scopeVisitor.scopeErrors:
            if error.message != expectedErrorMessages[i]:
                success = False
                print(f"Expected: {expectedErrorMessages[i]}, got: {error.message}.\n")
            i += 1
    else: 
        print("Failure: not all the scope errors in the file were detected.\n")
        success = False
    
    if success:
        print("Scope Error Detection: Success!\n")
    else:
        print("Scope Error Detection: Failure!\n")




def testTypeErrors():
    
    print("Testing type errors now:")
    
    expectedErrorMessages = [
        "Type mismatch for b in line 4: expected int, got bool.",
        "Type mismatch for c in line 6: expected bool, got int.",
        "Type mismatch for a in line 8: expected int, got bool.",
        "Type mismatch for d in line 12: expected bool, got int."
    ]
    
    with open("testTypeErrors.co", "r") as file:
        cobraCode = file.read()

    table = SymbolTable(None, "Function")

    parseLex = Lexer() 
    parser = Parser([])
    scopeVisitor = ScopeVisitor(table, [])
    typeVisitor = TypeVisitor(table, [], [])
    result = parser.parser.parse(cobraCode, lexer=parseLex.lexer)
    
    for statement in result:
        statement.accept(scopeVisitor)
    for statement in result:
        statement.accept(typeVisitor)
    
    success = True

    if len(typeVisitor.typeErrors) == len(expectedErrorMessages):
        i = 0
        for error in typeVisitor.typeErrors:
            if error.message != expectedErrorMessages[i]:
                success = False
                print(f"Expected: {expectedErrorMessages[i]}, got: {error.message}.\n")
            i += 1
    else: 
        print("Failure: not all the type errors in the file were detected.\n")
        success = False
    
    if success:
        print("Type Error Detection: Success!\n")
    else:
        print("Type Error Detection: Failure!\n")




def testFunctionErrors():
    
    print("Testing function errors now:")
    
    expectedErrorMessages = [
        "The arguments given in line 11 do not match the types of the parameters for one.",
        "The arguments given in line 13 do not match the types of the parameters for one.",
        "Type mismatch in line 16: two returns int, not bool.",
        "Type mismatch in line 24: three returns int, not bool.",
        "Incorrect number of arguments for three in line 29.",
        "Incorrect number of arguments for four in line 35.",
        "Incorrect number of arguments for four in line 37."
    ]
    
    with open("testFunctionErrors.co", "r") as file:
        cobraCode = file.read()

    table = SymbolTable(None, "Function")

    parseLex = Lexer() 
    parser = Parser([])
    scopeVisitor = ScopeVisitor(table, [])
    typeVisitor = TypeVisitor(table, [], [])
    result = parser.parser.parse(cobraCode, lexer=parseLex.lexer)
    
    for statement in result:
        statement.accept(scopeVisitor)
    for statement in result:
        statement.accept(typeVisitor)
    
    success = True

    if len(typeVisitor.functionErrors) == len(expectedErrorMessages):
        i = 0
        for error in typeVisitor.functionErrors:
            if error.message != expectedErrorMessages[i]:
                success = False
                print(f"Expected: {expectedErrorMessages[i]}, got: {error.message}.\n")
            i += 1
    else: 
        print("Failure: not all the functionErrors errors in the file were detected.\n")
        success = False
    
    if success:
        print("Function Error Detection: Success!\n")
    else:
        print("Function Error Detection: Failure!\n")
