import ply.lex as lex
import Lexer
import sys

reserved = {"if": "IF",
            "then": "THEN",
            "else": "ELSE",
            "while": "WHILE",
            "func": "FUNC",
            "int": "INT",
            "bool": "BOOL",
            "true": "TRUE",
            "false": "FALSE",
            "return": "RETURN",
            "void": "VOID",
            "or": "OR",
            "and": "AND",
            "print": "PRINT",
            "class": "CLASS",
            "new": "NEW",
            "extends": "EXTENDS",
            "null": "NULL",
            "not": "NOT"
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
# 'NOT',
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
# t_NOT               = r'!'
t_EQUALS            = r'=='
t_NOTEQUALS         = r'!='
t_GREATER           = r'>'
t_LESS              = r'<'
t_GREATEROREQUAL    = r'>='
t_LESSOREQUAL       = r'<='
t_DOT               = r'\.'


def t_INVALID_ID(t):
    r'\d+[a-zA-Z_]+[a-zA-Z_0-9]*'
    Lexer.lexicalErrors.append(f"Invalid identifier '{t.value}' in line {t.lineno}")
    t.lexer.skip(len(t.value))

def t_NUMBER(t):
    r'\d+'
    t.value = int(t.value)    
    return t

def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

def t_ID(t):
    r'[a-zA-Z_][a-zA-Z_0-9]*'
    t.type = reserved.get(t.value,'ID')   
    return t

t_ignore  = ' \t'

def t_error(t):
    Lexer.lexicalErrors.append(f"Illegal character '%s' in line {t.lineno}" % t.value[0])
    t.lexer.skip(1)


class Lexer:

    lexicalErrors = []
    
    def __init__(self):
        self.lexer = lex.lex(module=sys.modules[__name__])
        
    def tokenize(self, data):
        self.lexicalErrors.clear()
        self.lexer.input(data)
        tokens = []
        while True:
            tok = self.lexer.token()  
            if not tok:
                break
            tokens.append(tok)
        return tokens
