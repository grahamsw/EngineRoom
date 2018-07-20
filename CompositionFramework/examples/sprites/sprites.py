import sys
sys.path.append('../../')

from  boilerplate.send2framework import send, sender

import numpy as np
import matplotlib.pyplot as plt
from threading import Event
import time



def rangeKeys(obj):
    return [k.replace('Range', '') for k in obj.keys() if k.endswith('Range')]
 

def mid(rg):
    return rg[0] + (rg[1] - rg[0])/2
 
# should probably be
# def spriteValueGenerator(sprite initialVals = [...], steps = [...])      
def spriteValueGenerator(sprite, steps = 10):
    def nextRandom(mn, mx, cur, steps=10 ):
        if mn > mx:
            temp = mx
            mx = mn
            mn = temp
       # print("mn: {0}, mx: {1}, cur: {2}".format(mn, mx, cur))
        r = np.random.uniform(-0.5, 0.5)
        new = cur + (mx - mn)/steps * r
        if new < mn:
            new = mn + (mn - new)
        elif new > mx:
            new = mx - (new - mx)
      #  print("mn: {0}, mx: {1}, cur: {2}, new: {3}".format(mn, mx, cur, new)) 
        return new
    rangekeys = rangeKeys(sprite)
    # initialize everything half-way between the max and min
    # this 
    keyVals = { k : mid(sprite[k + 'Range']) for k in rangekeys}
    print(keyVals)
    def newVal(val):
        nonlocal keyVals
        if val in keyVals:
            rg = sprite[val + 'Range']
            keyVals[val] = nextRandom(rg[0], rg[1], keyVals[val], steps)
            return keyVals[val]
        else:
            print ('bad property')
    return newVal

 
 
sprite1 = {'name':'one',
           'posRange':[-0.9, -0.7],
           'freqRange':[800, 1000],
           'ampRange':[0.05, 0.2],
           'rateRange':[10, 20],
           'attackRange':[0.0001, 0.1]
           }

sprite2 = {'name':'two',
           'posRange':[0.7, 0.9],
           'freqRange':[250, 400],
           'ampRange':[0.05, 0.2],
           'rateRange':[6, 15],
           'attackRange':[0.001, 0.1]
           }

sprites = [
            {'sprite':sprite1, 'generator':spriteValueGenerator(sprite1, 10)},
            {'sprite':sprite2, 'generator':spriteValueGenerator(sprite2, 15)}
          ]


def createSprites(sprites):
    for sprite in sprites:
        print(sprite)
        #freq, amp, rate, attack, pos;
        send('/sprite_Osc', ['addSprite', sprite['sprite']['name'], 
                                         mid(sprite['sprite']['freqRange']),
                                         mid(sprite['sprite']['ampRange']),
                                         mid(sprite['sprite']['rateRange']),
                                         mid(sprite['sprite']['attackRange']),
                                         mid(sprite['sprite']['posRange'])                                         
                            ])


ex = Event()
    
def makeWander(intervalMin = 0.01, intervalMax=1, trace=True):
    sndr = sender('/sprite_Osc')
    while True:
        s = np.random.choice(sprites)
        p = np.random.choice(rangeKeys(s['sprite']))
        n = s['sprite']['name']
        v = s['generator'](p)
        sndr('setProp', n, p, v)
        if trace:
            print ("name: {0}, prop: {1}, val: {2}".format(n, p, v))
        time.sleep(np.random.uniform(intervalMin, intervalMax))

def interruptWander():
    print ("exiting")
    ex.set()

#interruptWander()
    
def clearSprites():
    send('/sprite_Osc', ['clearAll'])   


createSprites(sprites)    
makeWander()
#clearSprites()
 
def demoWander(sprite, granularity, steps=1000):
    generator = spriteValueGenerator(sprite, granularity)
    
    a = [generator('amp') for _ in range(steps)]
   # f = [generator('freq') for _ in range(steps)]
    r = [generator('rate') for _ in range(steps)]
    p = [generator('pos') for _ in range(steps)]
    
    plt.plot(a)
 #   plt.plot(f)
    plt.plot(r)
    plt.plot(p)


demoWander(sprite1, 150, 1000)

