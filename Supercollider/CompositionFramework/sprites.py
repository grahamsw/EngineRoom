from send2framework import sender
import numpy as np


s = sender('/sprite_Osc')

sprite1 = {'name':'one',
           'posRange':[-1, -0.7],
           'freqRange':[400, 500],
           'ampRange':[0.1, 0.2],
           'rateRange':[4, 10],
           'texture': 1
           }

def nextRandom(mn, mx, cur, steps=10 ):
    r = np.random.uniform(-0.5, 0.5)
    new = cur + (mx - mn)/steps * r
    if new < mn:
        new = mn + (mn - new)
    elif new > mx:
        new = mx - (new - mx)
    return new
    


def spriteValueGenerator(sprite, steps = 10):
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
    
    
        


generator = spriteValueGenerator(sprite1, 4)

r = [generator('pos') for _ in range(10)]




(sprite1['posRange'][1]-sprite1['posRange'][0])/2.0

