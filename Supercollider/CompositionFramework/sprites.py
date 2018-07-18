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
    


def spriteValueGenerator(sprite):
    pos = (sprite['posRange'][1]-sprite['posRange'][0])/2.0
    freq = (sprite['freqRange'][1]-sprite['freqRange'][0])/2.0
    amp = (sprite['ampRange'][1]-sprite['ampRange'][0])/2.0
    rate = (sprite['rateRange'][1]-sprite['rateRange'][0])/2.0
    







