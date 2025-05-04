import ply.lex as lex

# List of token names.

reserved = {"if": "IF",
            "then": "THEN",
            "else": "ELSE",
            "while": "WHILE",
            "func": "FUNC",
            # "var": "VAR",
            "int": "INT",
            "bool": "BOOL",
            "true": "TRUE",
            "false": "FALSE",
            "return": "RETURN",
            "or": "OR",
            "and": "AND",
            "print": "PRINT",
            "class": "CLASS",
            "new": "NEW"
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
   'COMMA',
   'ASSIGN',
   'LBRACE',
   'RBRACE',
   'NOT',
   'EQUALS',
   'NOTEQUALS',
   'GREATER',
   'LESS',
   'GREATEROREQUAL',
   'LESSOREQUAL',
   'DOT'
] + list(reserved.values())

# Regular expression rules for simple tokens
t_PLUS              = r'\+'
t_MINUS             = r'-'
t_TIMES             = r'\*'
t_DIVIDE            = r'/'
t_LPAREN            = r'\('
t_RPAREN            = r'\)'
t_COMMA             = r','
t_ASSIGN            = r'='
t_LBRACE            = r'{'
t_RBRACE            = r'}'
t_NOT               = r'!'
t_EQUALS            = r'=='
t_NOTEQUALS         = r'!='
t_GREATER           = r'>'
t_LESS              = r'<'
t_GREATEROREQUAL    = r'>='
t_LESSOREQUAL       = r'<='
t_DOT               = r'.'

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
