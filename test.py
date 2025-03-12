def add(x,y):
    u = x+y
    def mult(a):
        return a*u
    return mult(4)
v = add(2,3) 
print(v)