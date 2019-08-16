from random import choices
from enum import Enum
import numpy as np
from threadrunners import rlocker


class AtEnd(Enum):
    STOP = 0
    REPEAT = 1
    MIRROR = 2
 
# return the same thing every time - our cycle functin expects a generator    
def const_gen(n):
    while True:
        yield n

# generates from fr to to (inclusive) in steps steps.
# behavior at end depends on "atEnd"
# note that AtEnd.Mirror does not repeat end values
# 1,2,3,4,5,4,3,2,1,2,3,4, ...
# not
# 1,2,3,4,5,5,4,3,2,1,1,2,3....        
def rng_gen(fr, to, steps, atEnd =  AtEnd.STOP):
    '''
    atEnd is AtEnd.STOP to stop, 'AtEnd.Mirror' to reverse, and continue
    forever, and AtEnd.REPEAT (or anything else, for now), to
    repeat the forward sequence indefi+nitely
    '''
    rg = list(np.linspace(fr, to, steps))
    if atEnd == AtEnd.MIRROR:
        revg = rg.copy()[-2:0:-1]
        rg.extend(revg)
    l = len(rg)                
    cur = 0    
    while True:
        if cur < l:
            yield rg[cur]
            cur += 1
            if cur == l:
                if atEnd == AtEnd.STOP:
                    yield None
                else:
                    cur = 0

                   
def rng_gen2(fr, to, delta, dur, atEnd =  AtEnd.STOP):
    rg = rng_gen(fr, to, int(delta / dur), atEnd)
    while True:
        yield next(rg)

def rand_gen(seq, weights = None, allowRepeats = True ):
    last_choice = None
    choice = None
    while True:       
        if allowRepeats == False:
            while choice == last_choice:
                choice = choices(seq, weights)[0]
           #     print(choice)
            last_choice = choice
            yield choice
        else:
            yield choices(seq, weights)[0]
        
     
       
                    
def seq_gen(sq, atEnd=AtEnd.STOP):
    cursor = rng_gen(0, len(sq)-1, len(sq), atEnd)
    while True:
        c = next(cursor)
        if c == None:
            yield None
        else:
            yield sq[int(c)]
      
def gen_proxy(getter):
    while True:
        yield next(getter())
    
def keyed_gen(getter):
    while True:
        yield getter()
        
def zip_gen(*args):
    while True:
        l = []
        for g in args:
            l.append(next(g))
        yield l
        
        
def makeSafeKeyedSetterGetter(initVal):
    d = {'key':initVal}
    @rlocker
    def setter(val):
        d['key'] = val
    @rlocker
    def getter():
        return d['key']
    return (setter, getter)
    
