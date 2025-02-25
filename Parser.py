import ply.yacc as yacc
from ASTexpressions import *
from ASTstatements import *

def p_program(p):
    '''program : declaration_list'''
    p[0] = p[1]

def p_declaration_list(p):
    '''declaration_list : declaration
                        | declaration_list declaration'''
    if len(p) == 2:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]

def p_declaration(p):
    '''declaration : varDeclaration
                   | statement'''
    p[0] = p[1]

def p_statement(p):
    '''statement : expression'''
    p[0] = p[1]

def p_varDeclaration_uninitialized(p):
    'varDeclaration : VAR ID'
    p[0] = VarDeclaration(p[2], None)
#Add multiple assignment
def p_varDeclaration_initialized(p):
    'varDeclaration : VAR ID ASSIGN expression'
    p[0] = VarDeclaration(p[2], p[4])
#Add multiple assignment
def p_expression_assign(p):
    'expression : ID ASSIGN expression'
    p[0] = AssignExpression(p[1], p[3])

def p_expression_plus(p):
    'expression : expression PLUS term'
    p[0] = BinaryExpression(p[1], p[2], p[3])

def p_expression_minus(p):
    'expression : expression MINUS term'
    p[0] = BinaryExpression(p[1], p[2], p[3])

def p_expression_term(p):
    'expression : term'
    p[0] = p[1]

def p_term_times(p):
    'term : term TIMES factor'
    p[0] = BinaryExpression(p[1], p[2], p[3])

def p_term_div(p):
    'term : term DIVIDE factor'
    p[0] = p[1] / p[3]

def p_term_factor(p):
    'term : factor'
    p[0] = p[1]

def p_factor_num(p):
    'factor : NUMBER'
    p[0] = NumberExpression(p[1])

def p_factor_var(p):
    'factor : ID'
    p[0] = VarExpression(p[1])

def p_factor_expr(p):
    'factor : LPAREN expression RPAREN'
    p[0] = p[2]

def p_error(p):
    print("Syntax error at '%s'" % p.value if p else "Syntax error at EOF")

""" def p_function_call(p):
    '''expression : ID LPAREN arguments RPAREN expression'''
    p[0] = ('function-call', p[1], p[3], p[5])

def p_arguments_multiple(p):
    '''arguments : arguments COMMA expression'''
    p[0] = p[1] + [p[3]]

def p_arguments_single(p):
    '''arguments : expression'''
    p[0] = [p[1]]

def p_arguments_empty(p):
    '''arguments : '''
    p[0] = []    

def p_statement(p):
    '''statement : function
                 | expression'''
    p[0] = p[1]

def p_function_definition(p):
    '''function : FUNC ID LPAREN parameter_list RPAREN expression'''
    p[0] = ('function-definition', p[2], p[4], p[6])

def p_parameter_list_multiple(p):
    '''parameter_list : parameter_list COMMA ID'''
    p[0] = p[1] + [p[3]]

def p_parameter_list_single(p):
    '''parameter_list : ID'''
    p[0] = [p[1]]

def p_parameter_list_empty(p):
    '''parameter_list :'''
    p[0] = []  """