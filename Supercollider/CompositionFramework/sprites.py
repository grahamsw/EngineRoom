from send2framework import sender
import numpy as np
import matplotlib.pyplot as plt
import time
 

def spriteValueGenerator(sprite, steps = 10):
    def nextRandom(mn, mx, cur, steps=10 ):
        r = np.random.uniform(-0.5, 0.5)
        new = cur + (mx - mn)/steps * r
        if new < mn:
            new = mn + (mn - new)
        elif new > mx:
            new = mx - (new - mx)
        return new    
    pos = sprite['posRange'][0] + (sprite['posRange'][1]-sprite['posRange'][0])/2.0
    freq = sprite['freqRange'][0] + (sprite['freqRange'][1]-sprite['freqRange'][0])/2.0
    amp = sprite['ampRange'][0] + (sprite['ampRange'][1]-sprite['ampRange'][0])/2.0
    rate = sprite['rateRange'][0] + (sprite['rateRange'][1]-sprite['rateRange'][0])/2.0
    def newVal(val):
        if val == 'pos':
            nonlocal pos
            pos = nextRandom(sprite['posRange'][0], sprite['posRange'][1], pos, steps)
            return pos
        elif val == 'freq':
            nonlocal freq
            freq = nextRandom(sprite['freqRange'][0], sprite['freqRange'][1], freq, steps)
            return freq
        elif val == 'amp':
            nonlocal amp
            amp = nextRandom(sprite['ampRange'][0], sprite['ampRange'][1], amp, steps)
            return amp
        elif val == 'rate':
            nonlocal rate
            rate = nextRandom(sprite['rateRange'][0], sprite['rateRange'][1], rate, steps)
            return rate
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
   
        
sprites = np.array([{'name':sprite1['name'], 'generator':spriteValueGenerator(sprite1, 10)}])
properties = np.array( ['amp', 'freq', 'rate', 'pos'])
    
cont = True
for r in range(100):
    s = np.random.choice(sprites)
    p = np.random.choice(properties)
    n = s['name']
    v = s['generator'](p)
    sendMsg(n, p, v)
    time.sleep(np.random.uniform(0.01, 1))
    
    
def demo():
    generator = spriteValueGenerator(sprite1, 4)
    
    a = [generator('amp') for _ in range(1000)]
    f = [generator('freq') for _ in range(1000)]
    r = [generator('rate') for _ in range(1000)]
    p = [generator('pos') for _ in range(1000)]
    
    plt.plot(a)
    plt.plot(f)
    plt.plot(r)
    plt.plot(p)

