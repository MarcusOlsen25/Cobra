from abc import ABC, abstractmethod
from ASTexpressions import *

class Visitor:
    @abstractmethod
    def visitBinaryExpression(self, expr: BinaryExpression):
        pass

    @abstractmethod
    def visitNumberExpression(self, expr: NumberExpression):
        pass
    