from multiprocessing import Pool
from multiprocessing.dummy import Pool as ThreadPool

import numpy as np

pool = ThreadPool(10)
import time

def doSomething(msg,val):
    print(msg, ' ', val)
 
 
def mirrorRange(rg):
    rg ++ rg[2:0:-1]    

def cycle(fn, rg, duration, repeat=False):
    wait = duration / len(rg)
    cont = True
    while cont:
        for v in rg:
            fn(*v)
            time.sleep(wait)
        cont = repeat




def repeat(fn, fr, to, steps, duration, repeat=False, reverse=False):
    rg = np.linspace(fr, to, steps) 
    stepsize = (to - fr)/steps
    revrg = np.linspace(to - stepsize, fr + stepsize, steps)
    interval = duration / steps
    cont = True
    passes = 0
    rng = rg
    while cont:
        for v in rng:
            fn(v)
            time.sleep(interval)
        cont = repeat
        passes += 1
        if reverse:
            if passes % 2 == 0:
                rng = rg
            else:
                rng = revrg
       # print(f"cont: {cont}, rng: {rng}")    
            
def fn(n):
    repeat(lambda v: doSomething(n, v),1,10,8, n, False, True)      



results = pool.map(fn, [1,2,3,4])
#close the pool and wait for the work to finish
pool.close()
pool.join()

a = [1,2,3,4,5,6,7,8,9]
a[-2:0:-1]
      