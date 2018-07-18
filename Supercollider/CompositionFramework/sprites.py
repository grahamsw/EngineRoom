from send2framework import sender
import numpy as np
import matplotlib.pyplot as plt
import time
 

def rangeKeys(obj):
    return [k.replace('Range', '') for k in obj.keys() if k.endswith('Range')]
        
def spriteValueGenerator(sprite, steps = 10):
    def nextRandom(mn, mx, cur, steps=10 ):
        r = np.random.uniform(-0.5, 0.5)
        new = cur + (mx - mn)/steps * r
        if new < mn:
            new = mn + (mn - new)
        elif new > mx:
            new = mx - (new - mx)
        return new    
    rangekeys = rangeKeys(sprite)
    keyVals = { k :sprite[k + 'Range'][0] + (sprite[k + 'Range'][1]-sprite[k +'Range'][0])/2.0 for k in rangekeys}
    def newVal(val):
        nonlocal keyVals
        if val in keyVals:
            keyVals[val] = nextRandom(sprite[val + 'Range'][0], sprite[val + 'Range'][1], keyVals[val], steps)
            return keyVals[val]
        else:
            print ('bad property')
    return newVal

 
sndr = sender('/sprite_Osc')
def sendMsg(name, prop, val):
    print(name + ' ' + prop + ' ' + str( val) )
    sndr(name, prop, val)
    


sprite1 = {'name':'one',
           'posRange':[-1, -0.7],
           'freqRange':[400, 500],
           'ampRange':[0.1, 0.2],
           'rateRange':[4, 10],
           'texture': 1
           }

sprite2 = {'name':'two',
           'posRange':[0, 0.7],
           'freqRange':[2400, 3000],
           'ampRange':[0.1, 0.2],
           'rateRange':[4, 10],
           'textureRange':[0, 2]
           }

sprites = [
            {'sprite':sprite1, 'generator':spriteValueGenerator(sprite1, 10)},
            {'sprite':sprite2, 'generator':spriteValueGenerator(sprite2, 5)}
           ]

    
cont = True
for r in range(10):
    s = np.random.choice(sprites)
    p = np.random.choice(rangeKeys(s['sprite']))
    n = s['sprite']['name']
    v = s['generator'](p)
    sendMsg(n, p, v)
    time.sleep(np.random.uniform(0.01, 1))
    
    
    
    
    
def demo(sprite, granularity, steps=1000):
    generator = spriteValueGenerator(sprite, granularity)
    
    a = [generator('amp') for _ in range(steps)]
  #  f = [generator('freq') for _ in range(1000)]
    r = [generator('rate') for _ in range(steps)]
    p = [generator('pos') for _ in range(steps)]
    
    plt.plot(a)
   # plt.plot(f)
    plt.plot(r)
    plt.plot(p)

