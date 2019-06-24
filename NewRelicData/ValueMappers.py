


def constrainValue(val, minVal, maxVal):
    return max(min(val, maxVal), minVal)
    
# TODO 
def mapValue(val, a, b, c, d, logmap = False):
    fval, fa, fb, fc, fd = float (val), float (a), float (b), float (c), float (d)
    if logmap:
        pass
    else:
        return fc + (fval - fa) * (fd - fc)/(fb - fa)
    
def mapConstrainValue(val, a, b, c, d):
    return mapValue(constrainValue(val, a, b), a, b, c, d)    

def makeMapper(a,b,c,d):
    return lambda val: mapValue(val,a,b,c,d)

def makeConstrainMapper(a,b,c,d):
    return lambda val: mapConstrainValue(val, a, b, c, d)