# ------------------------------------------------------------
# calclex.py
#
# tokenizer for a simple expression evaluator for
# numbers and +,-,*,/
# ------------------------------------------------------------
import ply.lex as lex
import ply.yacc as yacc
from visitors import visitor
from visitors.printVisitor import PrintVisitor
from visitors.evalVisitor import EvalVisitor
from visitors.assemblyVisitor import AssemblyVisitor
from ASTnode import *

# List of token names.   This is always required

reserved = {"if": "IF",
            "then": "THEN",
            "func": "FUNC"
            }

tokens = [
   'NUMBER',
   'PLUS',
   'MINUS',
   'TIMES',
   'DIVIDE',
   'LPAREN',
   'RPAREN',
   'ID',
   'COMMA'
] + list(reserved.values())

# Regular expression rules for simple tokens
t_PLUS    = r'\+'
t_MINUS   = r'-'
t_TIMES   = r'\*'
t_DIVIDE  = r'/'
t_LPAREN  = r'\('
t_RPAREN  = r'\)'
t_COMMA   = r','

# A regular expression rule with some action code
def t_NUMBER(t):
    r'\d+'
    t.value = int(t.value)    
    return t

# Define a rule so we can track line numbers
def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

def t_ID(t):
    r'[a-zA-Z_][a-zA-Z_0-9]*'
    t.type = reserved.get(t.value,'ID')   
    return t


t_ignore  = ' \t'


def t_error(t):
    print("Illegal character '%s'" % t.value[0])
    t.lexer.skip(1)


lexer = lex.lex()

data = '''
if then func add(x, y) x + y
'''

lexer.input(data)

while True:
    tok = lexer.token()
    if not tok: break 
    print(tok)

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

def p_arguments_empty(p):
    '''arguments : '''
    p[0] = []

def p_error(p):
    print("Syntax error at '%s'" % p.value if p else "Syntax error at EOF")


parser = yacc.yacc()

dat = "2+4*5+6*7"

result = parser.parse(dat)

printVisitor = PrintVisitor()
visitor = AssemblyVisitor()
eval = EvalVisitor()

res = result.accept(printVisitor)

print(res)







def p_function_call(p):
    '''expression : ID LPAREN arguments RPAREN expression'''
    p[0] = ('function-call', p[1], p[3], p[5])

def p_arguments_multiple(p):
    '''arguments : arguments COMMA expression'''
    p[0] = p[1] + [p[3]]

def p_arguments_single(p):
    '''arguments : expression'''
    p[0] = [p[1]]

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
    p[0] = [] 