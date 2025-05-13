import ply.yacc as yacc
from ASTexpressions import *
from ASTstatements import *

# Program
def p_program(p):
    '''program : declaration_list'''
    p[0] = p[1]

# Declaration list
def p_declaration_list(p):
    '''declaration_list : declaration
                        | declaration_list declaration'''
    if len(p) == 2:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]

# Declaration
def p_declaration(p):
    '''declaration : varDeclaration
                   | statement
                   | funcDeclaration
                   | class'''
    p[0] = p[1]

def p_class(p):
    '''class : CLASS ID extends LBRACE classDeclarationList RBRACE'''
    for declaration in p[5]:
        if isinstance(declaration, MethodDeclaration):
            declaration.className = p[2].capitalize()
    p[0] = ClassDeclaration(p[2], p[5], p[3], p.lineno(1))

def p_extends(p):
    '''extends : EXTENDS ID
               | empty'''
    if len(p) == 3:
        p[0] = p[2]
    else:
        p[0] = None


def p_classDeclarationList_multiple(p):
    '''classDeclarationList : classDeclarationList classDeclaration'''
    p[0] = p[1] + [p[2]]

def p_classDeclarationList_single(p):
    '''classDeclarationList : classDeclaration'''
    p[0] = [p[1]]

def p_classDeclaration(p):
    '''classDeclaration : varDeclaration
                        | methodDeclaration'''
    p[0] = p[1]

def p_methodDeclaration(p): 
    '''methodDeclaration : FUNC ID LPAREN parameter_list RPAREN type LBRACE declaration_list RBRACE'''
    p[0] = MethodDeclaration(p[2], p[4], p[8], p[6], p.lineno(1))

# Statements
# Statement -> expression
def p_statement(p):
    '''statement : expression
                 | ifStatement
                 | whileStatement
                 | printStatement
                 | returnStatement''' 
    p[0] = p[1]

def p_returnStatement(p):
    '''returnStatement : RETURN expression'''
    p[0] = ReturnStatement(p[2], p.lineno(1))
    
def p_returnStatement_empty(p):     
    '''returnStatement : RETURN'''
    p[0] = ReturnStatement(None, p.lineno(1))
    
# If statements
def p_ifStatement_single(p):
    '''ifStatement : IF expression THEN LBRACE declaration_list RBRACE'''
    p[0] = IfStatement(p[2], p[5], None, None, None, p.lineno(1))
    
def p_ifStatement_else(p):
    '''ifStatement : IF expression THEN LBRACE declaration_list RBRACE ELSE LBRACE declaration_list RBRACE'''
    p[0] = IfStatement(p[2], p[5], p[9], None, None, p.lineno(1))   
    
# While statement
def p_whileStatement(p):
    '''whileStatement : WHILE expression THEN LBRACE declaration_list RBRACE'''
    p[0] = WhileStatement(p[2], p[5], None, p.lineno(1))

# Print statement
def p_printStatement(p):
    '''printStatement : PRINT expression'''
    p[0] = PrintStatement(p[2], p.lineno(1))

# Variable declaration uninitialized
def p_varDeclaration_uninitialized(p):
    '''varDeclaration : type ID'''
    p[0] = VarDeclaration(p[2], None, p[1], p.lineno(2))

# Variable declaration initialized
# Add multiple assignment
def p_varDeclaration_initialized(p):
    '''varDeclaration : type ID ASSIGN expression'''
    p[0] = VarDeclaration(p[2], p[4], p[1], p.lineno(2))
    
# Types
def p_type(p):
    '''type : INT
            | BOOL
            | VOID
            | ID'''
    p[0] = p[1]

# Expression -> assignment
def p_expression_assignment(p):
    '''expression : assignment'''
    p[0] = p[1]

# Expression - assignment
# Add multiple assignment
def p_assignment(p):
    '''assignment : property ASSIGN logical'''
    p[1].isAssign = True
    p[0] = AssignExpression(p[1], p[3], p.lineno(2))

# Assignment -> logical
def p_assignment_logical(p):
    '''assignment : logical'''
    p[0] = p[1]
    
# Logical - or
def p_logical_or(p):
    '''logical : logical OR equality'''
    p[0] = BinaryExpression(p[1], p[2], p[3], p.lineno(2))
    
# Logical - and
def p_logical_and(p):
    '''logical : logical AND equality'''
    p[0] = BinaryExpression(p[1], p[2], p[3], p.lineno(2))
    
# LogicAnd -> equality
def p_logical_equality(p):
    '''logical : equality'''
    p[0] = p[1]
    
# Equality - equals
def p_equality_equals(p):
    '''equality : equality EQUALS comparison'''
    p[0] = BinaryExpression(p[1], p[2], p[3], p.lineno(2))

# Equality - not equals
def p_equality_not_equals(p):
    '''equality : equality NOTEQUALS comparison'''
    p[0] = BinaryExpression(p[1], p[2], p[3], p.lineno(2))
    
# Equality -> comparison
def p_equality_comparison(p):
    '''equality : comparison'''
    p[0] = p[1]
    
# Comparison - greater 
def p_comparison_greater(p):
    '''comparison : comparison GREATER term'''
    p[0] = BinaryExpression(p[1], p[2], p[3], p.lineno(2))

# Comparison - less
def p_comparison_less(p):
    '''comparison : comparison LESS term'''
    p[0] = BinaryExpression(p[1], p[2], p[3], p.lineno(2))

# Comparison - greater or equal
def p_comparison_greater_or_equal(p):
    '''comparison : comparison GREATEROREQUAL term'''
    p[0] = BinaryExpression(p[1], p[2], p[3], p.lineno(2))

# Comparison - less or equal
def p_comparison_less_or_equal(p):
    '''comparison : comparison LESSOREQUAL term'''
    p[0] = BinaryExpression(p[1], p[2], p[3], p.lineno(2))
    
# Comparison -> term
def p_comparison_term(p):
    '''comparison : term'''
    p[0] = p[1]

# Term - plus
def p_term_plus(p):
    '''term : term PLUS factor'''
    p[0] = BinaryExpression(p[1], p[2], p[3], p.lineno(2))

# Term - minus
def p_term_minus(p):
    '''term : term MINUS factor'''
    p[0] = BinaryExpression(p[1], p[2], p[3], p.lineno(2))

# Term -> factor
def p_term_factor(p):
    '''term : factor'''
    p[0] = p[1]

# Factor - multiplication
def p_factor_times(p):
    '''factor : factor TIMES unary'''
    p[0] = BinaryExpression(p[1], p[2], p[3], p.lineno(2))

# Factor - division
def p_factor_div(p):
    '''factor : factor DIVIDE unary'''
    p[0] = BinaryExpression(p[1], p[2], p[3], p.lineno(2))
    
# Factor -> unary
def p_factor_unary(p):
    '''factor : unary'''
    p[0] = p[1]
    
# Factor -> unary
def p_unary(p):
    '''unary : NOT unary'''
    p[0] = UnaryExpression(p[1], p[2], p.lineno(1))

def p_unary_minus(p):
    '''unary : MINUS unary'''
    p[0] = UnaryExpression(p[1], p[2], p.lineno(1))

# Unary -> call
def p_unary_num(p):
    '''unary : property'''
    p[0] = p[1]

# Expression - call function

def p_call_constructor(p):
    '''property : NEW primary LPAREN RPAREN'''
    p[0] = ConstructorExpression(p[2], p.lineno(1))

def p_property_dot(p):
    '''property : property DOT ID'''
    p[0] = PropertyAccessExpression(p[1], p[3], p.lineno(3))

def p_property_call(p):
    '''property : property LPAREN arguments RPAREN'''
    p[1].isMethod = True
    p[0] = MethodCallExpression(p[1], p[3], p.lineno(1))

def p_property_list(p):
    '''property_list : property_list DOT primary'''
    p[0] = p[1] + [p[3]]

def p_property_single(p):
    '''property_list : primary'''
    p[0] = [p[1]]

def p_property(p):
    '''property : call'''
    p[0] = p[1]

def p_call_func(p):
    '''call : primary LPAREN arguments RPAREN'''
    p[0] = CallExpression(p[1], p[3], p.lineno(1))

def p_call(p):
    '''call : primary'''
    p[0] = p[1]

# Primary -> number
def p_primary_number(p):
    '''primary : NUMBER'''
    p[0] = NumberExpression(p[1], p.lineno(1))

# Primary -> ID
def p_primary_ID(p):
    '''primary : ID'''
    p[0] = VarExpression(p[1], p.lineno(1))
    
# Primary -> boolean
def p_primary_bool(p):
    '''primary : TRUE
               | FALSE'''
    p[0] = BoolExpression(p[1], p.lineno(1))

# Expression - parenthesized expression
def p_primary(p):
    '''primary : LPAREN expression RPAREN'''
    p[0] = p[2]


# Arguments

def p_arguments_multiple(p):
    '''arguments : arguments COMMA expression'''
    p[0] = p[1] + [p[3]]

def p_arguments_single(p):
    '''arguments : expression'''
    p[0] = [p[1]]

def p_arguments_empty(p):
    '''arguments : '''
    p[0] = []   

# Function declarations 
# Add return statements
def p_funcDeclaration_statement(p):
    '''funcDeclaration : FUNC ID LPAREN parameter_list RPAREN type LBRACE declaration_list RBRACE'''
    p[0] = FunctionDeclaration(p[2], p[4], p[8], p[6], p.lineno(1)) 
    
def p_parameter_list_multiple(p):
    '''parameter_list : parameter_list COMMA ID'''
    p[0] = p[1] + [ParameterStatement(p[3], None, p.lineno(3))]

def p_parameter_list_single(p):
    '''parameter_list : ID'''
    p[0] = [ParameterStatement(p[1], None, p.lineno(1))]
    
def p_parameter_list_multiple_typed(p):
    '''parameter_list : parameter_list COMMA type ID'''
    p[0] = p[1] + [ParameterStatement(p[3], p[4], p.lineno(3))]

def p_parameter_list_single_typed(p):
    '''parameter_list : type ID'''
    p[0] = [ParameterStatement(p[1], p[2], p.lineno(1))]

def p_parameter_list_empty(p):
    '''parameter_list :'''
    p[0] = []
    
def p_error(p):
    if p:
        print(f"Syntax error at line {p.lineno}: Unexpected token '{p.value}'")
    else:
        print("Syntax error at EOF")

def p_empty(p):
    'empty :'
    pass