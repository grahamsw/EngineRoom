from math import log2


def constrainValue(val, minVal, maxVal):
    return max(min(val, maxVal), minVal)
    
# TODO 
def mapValue(val, a, b, c, d, logmap = False):
    fval, fa, fb, fc, fd = float (val), float (a), float (b), float (c), float (d)
    if logmap:
        lv = mapValue(val, a, b, log2(c), log2(d), False)
        return 2**lv
    else:
        return fc + (fval - fa) * (fd - fc)/(fb - fa)
    
def mapConstrainValue(val, a, b, c, d, logmap=False):
    return mapValue(constrainValue(val, a, b), a, b, c, d, logmap)    

def makeMapper(a,b,c,d, logmap=False):
    return lambda val: mapValue(val,a,b,c,d, logmap)

def makeConstrainMapper(a,b,c,d, logmap=False):
    return lambda val: mapConstrainValue(val, a, b, c, d, logmap)


#import matplotlib.pyplot as plt
#import numpy as np
#
#
#a = 1
#b = 10
#c = 100
#d = 10000
#
#xs = np.linspace(a, b, 100)
#ys = [mapValue(x, a,b,c,d,True) for x in xs]
#
#plt.plot(xs, ys)
