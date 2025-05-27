from Lexer import *
from Parser import *
from visitors.typeVisitor import TypeVisitor
from visitors.scopeVisitor import ScopeVisitor
from scope.SymbolTable import *
from visitors.instruction import *

# This program defines tests to ensure the correctness of the Cobra compiler. 

def testAllErrors():
    
    lex = testLexicalErrors()         
    syn = testSyntacticErrors()
    scope = testScopeErrors()
    type = testTypeErrors()
    func = testFunctionErrors()
    
    if lex and syn and scope and type and func:
        print("Overall result: Success!")
        print("All the tests have passed.")
    else:
        print("Overall result: Failure!")
        print("Some tests have failed.")





def testLexicalErrors():
    
    print("Testing lexical errors now:")
        
    test1Code = '''
        Æ Ø Å
        ?
        ¤ 
        # 
        !
        int 
        intolpi
        55mor 
        '''
    test1ExpectedErrors = [
        "Illegal character 'Æ' in line 2", 
        "Illegal character 'Ø' in line 2", 
        "Illegal character 'Å' in line 2", 
        "Illegal character '?' in line 3", 
        "Illegal character '¤' in line 4", 
        "Illegal character '#' in line 5",
        "Illegal character '!' in line 6",
        "Invalid identifier '55mor' in line 9"
    ]
    test1 = auxTestLexicalErrors(test1Code, test1ExpectedErrors, 1)
    
    test2Code = '''
        ...........
        ½
        banan
        & % 
        []
        mal77
        mi878lo
        9Jumba
        '''
    test2ExpectedErrors = [
        "Illegal character '½' in line 3",
        "Illegal character '&' in line 5",
        "Illegal character '%' in line 5",
        "Illegal character '[' in line 6",
        "Illegal character ']' in line 6",
        "Invalid identifier '9Jumba' in line 9"
    ]
    test2 = auxTestLexicalErrors(test2Code, test2ExpectedErrors, 2)
    
    test3Code = '''
        @
        {}
        ~~
        | 
        /
        bool
        return
        102ceam
        '''
    test3ExpectedErrors = [
        "Illegal character '@' in line 2",
        "Illegal character '~' in line 4",
        "Illegal character '~' in line 4",
        "Illegal character '|' in line 5",
        "Invalid identifier '102ceam' in line 9"
    ]
    test3 = auxTestLexicalErrors(test3Code, test3ExpectedErrors, 3)
    
    success = test1 and test2 and test3 
    
    if success:
        print("Lexical Error Detection: Success!\n")
    else:
        print("Lexical Error Detection: Failure!\n")
        
    return success
        
def auxTestLexicalErrors(cobraCode: str, expectedErrors: list[str], testNr: int):
    success = True
    lexer = Lexer()
    lexer.tokenize(cobraCode)  
    
    if len(lexer.lexicalErrors) != len(expectedErrors):
        print(f"\tTest {testNr} does not catch all errors.")
        success = False
    else:
        i = 0
        for error in lexer.lexicalErrors:
            if error != expectedErrors[i]:
                success = False
                print(f"\tTest {testNr}; Expected: {expectedErrors[i]}, Got: {error}.\n")
            i += 1
    
        if success:
            print(f"\tTest {testNr} succeeded!")
        else:
            print(f"\tTest {testNr} fails! :(")
        
    return success
        
        
        
# Apparently, testing syntactic errors is not as easy. One error at a time. 
def testSyntacticErrors():
    print("Testing syntactic errors now:")
        
    test1Code = '''
        int num = 33;

        if then {
            print num;
        }
        '''
    test1ExpectedErrors = ["Syntax error at line 4: Unexpected token 'then'", "Syntax error at line 6: Unexpected token '}'"]
    test1 = auxTestSyntacticErrors(test1Code, test1ExpectedErrors, 1)
    
    test2Code = '''
        func one() void {
            int var = 0;
        }

        func(35);
        '''
    test2ExpectedErrors = ["Syntax error at line 6: Unexpected token '('"]
    test2 = auxTestSyntacticErrors(test2Code, test2ExpectedErrors, 2)
    
    test3Code = '''
        func two {
            print 3;
        }
        '''
    test3ExpectedErrors = ["Syntax error at line 2: Unexpected token '{'", "Syntax error at line 4: Unexpected token '}'"]
    test3 = auxTestSyntacticErrors(test3Code, test3ExpectedErrors, 3)
    
    test4Code = '''
        if x then {
            print hello;
        } else if y then {
            print goodbye;
        }
        '''
    test4ExpectedErrors = ["Syntax error at line 4: Unexpected token 'if'", "Syntax error at line 6: Unexpected token '}'"]
    test4 = auxTestSyntacticErrors(test4Code, test4ExpectedErrors, 4)
    
    test5Code = '''
        class shoe {
        }
        shoe converse = new shoe();
        '''
    test5ExpectedErrors = ["Syntax error at line 3: Unexpected token '}'"]
    test5 = auxTestSyntacticErrors(test5Code, test5ExpectedErrors, 5)
    
    test6Code = '''
        print int x = 6;
        '''
    test6ExpectedErrors = ["Syntax error at line 2: Unexpected token 'int'"]
    test6 = auxTestSyntacticErrors(test6Code, test6ExpectedErrors, 6)
    
    test7Code = '''
        int x = 3
        print x
        '''
    test7ExpectedErrors = ["Syntax error at line 3: Unexpected token 'print'"]
    test7 = auxTestSyntacticErrors(test7Code, test7ExpectedErrors, 7)
    
    success = test1 and test2 and test3 and test4 and test5 and test6
    
    if success:
        print("Syntactic Error Detection: Success!\n")
    else:
        print("Syntactic Error Detection: Failure!\n")
        
    return success
        

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
    else:
        print(f"\tTest {testNr} fails! :(")
    return success

        
def testScopeErrors():
    
    print("Testing scope errors now:")
    
    expectedErrorMessages = [
        "Undeclared variable c in line 4.",
        "Undeclared variable y in line 7.",
        "The variable b in line 10 is already defined in this scope.",
        "The function two from line 12 is not defined.",
        "Undeclared variable z in line 15.",
        "The variable one in line 18 is already defined.",
        "The property c from line 48 could not be found.",
        "The property ba from line 49 could not be found.",
        "The property b from line 50 could not be found.",
        "Undeclared variable fup in line 68.",
        "The ID a in line 81 is not a method.",
        "The property b from line 82 could not be found.",
        "The method b from line 82 is not defined.",
        "Error: banan in line 84 cannot be used as a variable name, since it is a class."
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
    
    print(len(scopeVisitor.scopeErrors))
    print(len(expectedErrorMessages))

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
        
    return success



def testTypeErrors():
    
    print("Testing type errors now:")
    
    expectedErrorMessages = [
        "Type mismatch for b in line 4: expected int, got bool.",
        "Type mismatch for c in line 6: expected bool, got int.",
        "Type mismatch for a in line 8: expected int, got bool.",
        "Type mismatch for d in line 12: expected bool, got int.",
        "Illegal type in binary operation in line 23.",
        "Illegal type in binary operation in line 26.",
        "Type mismatch for t in line 28: expected int, got tiger."
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
        
    return success




def testFunctionErrors():
    
    print("Testing function errors now:")
    
    expectedErrorMessages = [
        "The arguments given in line 12 do not match the types of the parameters for one.",
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
        
    return success
