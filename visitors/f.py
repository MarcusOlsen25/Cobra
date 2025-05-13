class one:
    x = 2

class two:
    y = 3
    a = one()
    def f(self):
        print(self.a.x)

t = two()

t.f()