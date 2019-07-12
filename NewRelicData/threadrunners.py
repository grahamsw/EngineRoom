import threading
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


        
def cycle(fn, vals, durs, stopEvent = None):
    ''' 
    vals and durs are generators, they may end or may 
    go on forever (in which case the stopEvent can end things)
    '''
    while not(stopEvent and stopEvent.isSet()):
        v = next(vals)
        d = next(durs)
        if v == None or d == None:
            break
        if isinstance(v, list) or isinstance(v, tuple):
            if None in v:
                break
            fn(*v)
        else:
            fn(v)
        time.sleep(d)
        
        
# vals is a generator creating tuples (or lists, or individual values) of arguments for fn
# durs is a generator creating a sequence of intervals between calls to fn
# if neither of these generators is finite the thread can be stopped
# by calling s.set()    
def run_in_thread(fn, vals, durs, startImmediately=True):
    s = threading.Event()
    t  = threading.Thread(target = cycle, args=(fn, vals, durs,  s))   
    if startImmediately:
        t.start()
    return s,t


            
