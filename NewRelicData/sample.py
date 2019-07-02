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

lsender = rlocker(sender)

from send2framework import sender

s = lsender('/implOsc')


        
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
    cycle(lambda val: s(msg, val), args, durs, stopper)

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
       
s('amp1', 0.1)        
        
s1 = threading.Event()
t  = threading.Thread(target = pc, args=("rate1", rng_gen(0.1, 10, 20, 'rev'), const_gen(0.1),  s1))

t.start()
 
s1.set()

s('killsonifier1')

s2 = threading.Event()
t2  = threading.Thread(target = pc, args=("freq1", rng_gen(200, 1000, 20, 'rev'), const_gen(0.2),  s1))

t2.start()
s2.set()



s('loadCode', r"C:\Users\graha\Documents\dev\EngineRoom\CompositionFramework\examples\sitemonitor\loadme.scd")
#\name:\sonifier, \key:\sonifier1,\killEventName:\killsonifier1),
#		              \controls: [(\controlName:\freq,
#					               \eventName:\freq1,
#								   \initialValue:300),
#								  (\controlName:\amp,
#								   \eventName:\amp1,
#								   \initialValue:0.1),
#								  (\controlName:\rate,
#								   \eventName:\rate1,
#								   \initialValue:10)
s('initSynth', 'sonifier', 'sonifier1', 'killsonifier1',
               'freq', 'freq1', 400,
               'amp', 'amp1', 0.2,
               'rate', 'rate1', 0.4)


s('amp2', 0.5)
s3 = threading.Event()
t3  = threading.Thread(target = pc, args=("freq2", rng_gen(200, 1000, 20, 'rev'), const_gen(0.2),  s3))

t3.start()
s3.set()
               
s('amp2', 0.5)
s('bwr2', 1)
s('killsynth2')


s4= threading.Event()
t4  = threading.Thread(target = pc, args=("bwr2", rng_gen(0.1, 1, 30, 'rev'), const_gen(0.1),  s4))

t4.start()
s4.set()

#\sonifier2, {|freq=500, amp=0.4, bwr=0.5, tremoloFreq=0.1, tremoloDepth=0.95|

s('initSynth', 'sonifier2', 'synth2', 'killsynth2',
               'freq', 'freq2', 400,
               'amp', 'amp2', 0.2,
               'bwr', 'bwr2', 0.1,
               'tremoloFreq', 'tremoloFreq2', 1,
               'tremoloDepth', 'tremoloDepth2', 0.3)
s('tremoloFreq2', 0.1)
s('bwr2', 0.4)
s('amp2', 0.4)
s('freq2', 800)
s('killsynth2')



import time
from ValueMappers import makeConstrainMapper
import numpy as np  
freqMapper = makeConstrainMapper(1, 100, 100, 5000, logmap = True)
bwrMapper = makeConstrainMapper(1,100, 1, 0.1)
for i in np.linspace(0, 100, 100, False):
    time.sleep(0.01)
    val = freqMapper(i)
    print(i, val)
    s('freq2',  freqMapper(i))
    s('bwr2', bwrMapper(i))