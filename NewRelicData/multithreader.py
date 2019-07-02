import threading
import numpy as np
import time

import functools
def rlocker(func):
    rlock = threading.RLock()
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        with rlock:
            ret = func(*args, **kwargs)
        return ret
    return wrapper


lockingPrinter = rlocker(print)

def doSomething(msg, val):
    lockingPrinter(msg, ': ', val)

       
        
def cycle(fn, args, durs, stopEvent = None):
    ''' 
    args and durs are generators, they may end or may 
    go on forever (in which case the stopEvent can end things)
    '''
    while not(stopEvent and stopEvent.isSet()):
        v = next(args)
        d = next(durs)
        if v == None or d == None:
            break
        fn(v)
       # print('dur: ',dd)
        time.sleep(d)
        


def pc(msg, args, durs, stopper):
    cycle(lambda val: doSomething(msg, val), args, durs, stopper)

def const_gen(n):
    while True:
        yield n

def rng_gen(fr, to, steps, atEnd =  None):
    '''
    atEnd is None to stop, 'rev' to reverse, and continue
    forever, and 'repeat' (or anything else, for now), to
    repeat the forward sequence indefinitely
    '''
    rg = list(np.linspace(fr, to, steps))
    if atEnd == 'rev':
        revg = rg.copy()[-2:0:-1]
        rg.extend(revg)
    l = len(rg)                
    cur = 0    
    while True:
        if cur < l:
            yield rg[cur]
            cur += 1
            if cur == l:
                if atEnd == None:
                    yield None
                else:
                    cur = 0
        
s = threading.Event()
t  = threading.Thread(target = pc, args=("msg", const_gen(5), const_gen(0.5),  s))

t.start()

s.set()


        