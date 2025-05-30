import ply.yacc as yacc
from ASTexpressions import *
from ASTstatements import *
from Lexer import tokens

class Parser:
        
    def __init__(self, syntacticErrors):
        self.tokens = tokens
        self.parser = yacc.yacc(module=self)
        self.syntacticErrors = syntacticErrors

    # Program
    def p_program(self, p):
        '''program : declaration_list'''
        p[0] = p[1]

    # Declaration list
    def p_declaration_list(self, p):
        '''declaration_list : declaration
                            | declaration_list declaration'''
        if len(p) == 2:
            p[0] = [p[1]]
        else:
            p[0] = p[1] + [p[2]]

    # Declaration
    def p_declaration(self, p):
        '''declaration : varDeclaration SEMICOLON
                    | statement
                    | funcDeclaration
                    | class'''
        p[0] = p[1]

    # Class declaration
    def p_class(self, p):
        '''class : CLASS ID extends LBRACE classDeclarationList RBRACE'''
        for declaration in p[5]:
            if isinstance(declaration, MethodDeclaration):
                declaration.className = p[2]
        p[0] = ClassDeclaration(p[2], p[5], p[3], p.lineno(1))

    # Extensions for inheritance
    def p_extends(self, p):
        '''extends : EXTENDS ID
                | empty'''
        if len(p) == 3:
            p[0] = p[2]
        else:
            p[0] = None

    # Contents of a class

    def p_classDeclarationList_multiple(self, p):
        '''classDeclarationList : classDeclarationList classDeclaration'''
        p[0] = p[1] + [p[2]]

    def p_classDeclarationList_single(self, p):
        '''classDeclarationList : classDeclaration'''
        p[0] = [p[1]]

    def p_classDeclaration(self, p):
        '''classDeclaration : varDeclaration SEMICOLON
                            | methodDeclaration'''
        p[0] = p[1]

    # Method declaration
    def p_methodDeclaration(self, p): 
        '''methodDeclaration : FUNC ID LPAREN parameter_list RPAREN type LBRACE declaration_list RBRACE'''
        p[0] = MethodDeclaration(p[2], p[4], p[8], p[6], p.lineno(1))

    # Statements
    def p_statement(self, p):
        '''statement : expression SEMICOLON
                    | ifStatement
                    | whileStatement
                    | printStatement SEMICOLON
                    | returnStatement SEMICOLON''' 
        p[0] = p[1]

    # Return statement
    def p_returnStatement(self, p):
        '''returnStatement : RETURN expression'''
        p[0] = ReturnStatement(p[2], p.lineno(1))
        
    # Empty return statement
    def p_returnStatement_empty(self, p):     
        '''returnStatement : RETURN'''
        p[0] = ReturnStatement(None, p.lineno(1))
        
    # If statement
    def p_ifStatement_single(self, p):
        '''ifStatement : IF expression THEN LBRACE declaration_list RBRACE'''
        p[0] = IfStatement(p[2], p[5], None, None, None, p.lineno(1))
    
    # If/else statement
    def p_ifStatement_else(self, p):
        '''ifStatement : IF expression THEN LBRACE declaration_list RBRACE ELSE LBRACE declaration_list RBRACE'''
        p[0] = IfStatement(p[2], p[5], p[9], None, None, p.lineno(1))   
        
    # While statement
    def p_whileStatement(self, p):
        '''whileStatement : WHILE expression THEN LBRACE declaration_list RBRACE'''
        p[0] = WhileStatement(p[2], p[5], None, p.lineno(1))

    # Print statement
    def p_printStatement(self, p):
        '''printStatement : PRINT expression'''
        p[0] = PrintStatement(p[2], p.lineno(1))

    # Variable declaration uninitialized
    def p_varDeclaration_uninitialized(self, p):
        '''varDeclaration : type ID'''
        p[0] = VarDeclaration(p[2], None, p[1], p.lineno(2))

    # Variable declaration initialized
    def p_varDeclaration_initialized(self, p):
        '''varDeclaration : type ID ASSIGN expression'''
        p[0] = VarDeclaration(p[2], p[4], p[1], p.lineno(2))
        
    # Types
    def p_type(self, p):
        '''type : INT
                | BOOL
                | VOID
                | ID'''
        p[0] = p[1]

    # Expression -> assignment
    def p_expression_assignment(self, p):
        '''expression : assignment'''
        p[0] = p[1]

    # Assignment
    def p_assignment(self, p):
        '''assignment : property ASSIGN logical'''
        p[1].isAssign = True
        p[0] = AssignExpression(p[1], p[3], p.lineno(2))

    # Assignment -> logical
    def p_assignment_logical(self, p):
        '''assignment : logical'''
        p[0] = p[1]
        
    # Logical - or
    def p_logical_or(self, p):
        '''logical : logical OR equality'''
        p[0] = BinaryExpression(p[1], p[2], p[3], p.lineno(2))
        
    # Logical - and
    def p_logical_and(self, p):
        '''logical : logical AND equality'''
        p[0] = BinaryExpression(p[1], p[2], p[3], p.lineno(2))
        
    # Logical -> equality
    def p_logical_equality(self, p):
        '''logical : equality'''
        p[0] = p[1]
        
    # Equality - equals
    def p_equality_equals(self, p):
        '''equality : equality EQUALS comparison'''
        p[0] = BinaryExpression(p[1], p[2], p[3], p.lineno(2))

    # Equality - not equals
    def p_equality_not_equals(self, p):
        '''equality : equality NOTEQUALS comparison'''
        p[0] = BinaryExpression(p[1], p[2], p[3], p.lineno(2))
        
    # Equality -> comparison
    def p_equality_comparison(self, p):
        '''equality : comparison'''
        p[0] = p[1]
        
    # Comparison - greater 
    def p_comparison_greater(self, p):
        '''comparison : comparison GREATER term'''
        p[0] = BinaryExpression(p[1], p[2], p[3], p.lineno(2))

    # Comparison - less
    def p_comparison_less(self, p):
        '''comparison : comparison LESS term'''
        p[0] = BinaryExpression(p[1], p[2], p[3], p.lineno(2))

    # Comparison - greater or equal
    def p_comparison_greater_or_equal(self, p):
        '''comparison : comparison GREATEROREQUAL term'''
        p[0] = BinaryExpression(p[1], p[2], p[3], p.lineno(2))

    # Comparison - less or equal
    def p_comparison_less_or_equal(self, p):
        '''comparison : comparison LESSOREQUAL term'''
        p[0] = BinaryExpression(p[1], p[2], p[3], p.lineno(2))
        
    # Comparison -> term
    def p_comparison_term(self, p):
        '''comparison : term'''
        p[0] = p[1]

    # Term - plus
    def p_term_plus(self, p):
        '''term : term PLUS factor'''
        p[0] = BinaryExpression(p[1], p[2], p[3], p.lineno(2))

    # Term - minus
    def p_term_minus(self, p):
        '''term : term MINUS factor'''
        p[0] = BinaryExpression(p[1], p[2], p[3], p.lineno(2))

    # Term -> factor
    def p_term_factor(self, p):
        '''term : factor'''
        p[0] = p[1]

    # Factor - multiplication
    def p_factor_times(self, p):
        '''factor : factor TIMES unary'''
        p[0] = BinaryExpression(p[1], p[2], p[3], p.lineno(2))

    # Factor - division
    def p_factor_div(self, p):
        '''factor : factor DIVIDE unary'''
        p[0] = BinaryExpression(p[1], p[2], p[3], p.lineno(2))
        
    # Factor -> unary
    def p_factor_unary(self, p):
        '''factor : unary'''
        p[0] = p[1]
        
    # Unary - not
    def p_unary(self, p):
        '''unary : NOT unary'''
        p[0] = UnaryExpression(p[1], p[2], p.lineno(1))

    # Unary - minus
    def p_unary_minus(self, p):
        '''unary : MINUS unary'''
        p[0] = UnaryExpression(p[1], p[2], p.lineno(1))

    # Unary -> call
    def p_unary_num(self, p):
        '''unary : property'''
        p[0] = p[1]

    # Expression - call function

    def p_call_constructor(self, p):
        '''property : NEW primary LPAREN RPAREN'''
        p[0] = ConstructorExpression(p[2], p.lineno(1))

    def p_property_dot(self, p):
        '''property : property DOT ID'''
        p[0] = PropertyAccessExpression(p[1], p[3], p.lineno(3))

    def p_property_call(self, p):
        '''property : property LPAREN arguments RPAREN'''
        p[1].isMethod = True
        p[0] = MethodCallExpression(p[1], p[3], p.lineno(2))

    def p_property(self, p):
        '''property : call'''
        p[0] = p[1]

    def p_call_func(self, p):
        '''call : primary LPAREN arguments RPAREN'''
        p[0] = CallExpression(p[1], p[3], p.lineno(2))

    def p_call(self, p):
        '''call : primary'''
        p[0] = p[1]

    # Primary -> number
    def p_primary_number(self, p):
        '''primary : NUMBER'''
        p[0] = NumberExpression(p[1], p.lineno(1))

    # Primary -> ID
    def p_primary_ID(self, p):
        '''primary : ID'''
        p[0] = VarExpression(p[1], p.lineno(1))
        
    # Primary -> boolean
    def p_primary_bool(self, p):
        '''primary : TRUE
                | FALSE'''
        p[0] = BoolExpression(p[1], p.lineno(1))

    # Primary -> null
    def p_primary_null(self, p):
        '''primary : NULL'''
        p[0] = NullExpression()

    # Expression - parenthesized expression
    def p_primary(self, p):
        '''primary : LPAREN expression RPAREN'''
        p[0] = p[2]


    # Arguments

    def p_arguments_multiple(self, p):
        '''arguments : arguments COMMA expression'''
        p[0] = p[1] + [p[3]]

    def p_arguments_single(self, p):
        '''arguments : expression'''
        p[0] = [p[1]]

    def p_arguments_empty(self, p):
        '''arguments : '''
        p[0] = []   

    # Function declarations 
    def p_funcDeclaration_statement(self, p):
        '''funcDeclaration : FUNC ID LPAREN parameter_list RPAREN type LBRACE declaration_list RBRACE'''
        p[0] = FunctionDeclaration(p[2], p[4], p[8], p[6], p.lineno(1)) 
        
    # Parameters
        
    def p_parameter_list_multiple(self, p):
        '''parameter_list : parameter_list COMMA type ID'''
        p[0] = p[1] + [ParameterStatement(p[3], p[4], p.lineno(3))]

    def p_parameter_list_single(self, p):
        '''parameter_list : type ID'''
        p[0] = [ParameterStatement(p[1], p[2], p.lineno(1))]

    def p_parameter_list_empty(self, p):
        '''parameter_list :'''
        p[0] = []

    # Empty
    def p_empty(self, p):
        'empty :'
        p[0] = None
    
    # Syntax errors
    def p_error(self, p):
        if p:
            self.syntacticErrors.append(f"Syntax error at line {p.lineno}: Unexpected token '{p.value}'")
        else:
            self.syntacticErrors.append("Syntax error at EOF")
