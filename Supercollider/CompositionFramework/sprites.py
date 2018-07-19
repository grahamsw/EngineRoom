from send2framework import sender
import numpy as np
import matplotlib.pyplot as plt
import time
 

def rangeKeys(obj):
    return [k.replace('Range', '') for k in obj.keys() if k.endswith('Range')]
        
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
    keyVals = { k :sprite[k + 'Range'][0] + (sprite[k + 'Range'][1]-sprite[k +'Range'][0])/2.0 for k in rangekeys}
    print(keyVals)
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
    send('/sprite_Osc', ['setProp', name, prop, val])
    


sprite1 = {'name':'one',
           'posRange':[-1.0, -1.0],
           'freqRange':[800, 1000],
           'ampRange':[0.1, 0.2],
           'rateRange':[4, 10],
           'attackRange':[0.0001, 0.1]
           }

sprite2 = {'name':'two',
           'posRange':[1.0, 1.0],
           'freqRange':[400, 300],
           'ampRange':[0.05, 0.1],
           'rateRange':[2, 5],
           'attackRange':[0.001, 0.1]
           }

sprites = [
            {'sprite':sprite1, 'generator':spriteValueGenerator(sprite1, 10)},
            {'sprite':sprite2, 'generator':spriteValueGenerator(sprite2, 5)}
          ]

def mid(rg):
    return rg[0] + (rg[1] - rg[0])/2

def createSprites(sprites):
    for sprite in sprites:
        print(sprite)
        #freq, amp, rate, attack, pos;
        send('/sprite_Osc', ['addSynth', sprite['sprite']['name'], 
                                         mid(sprite['sprite']['freqRange']),
                                         mid(sprite['sprite']['ampRange']),
                                         mid(sprite['sprite']['rateRange']),
                                         mid(sprite['sprite']['attackRange']),
                                         mid(sprite['sprite']['posRange'])                                         
                            ])
    
def makeWander():
    for r in range(1000):
        s = np.random.choice(sprites)
        p = np.random.choice(rangeKeys(s['sprite']))
        n = s['sprite']['name']
        v = s['generator'](p)
        sendMsg(n, p, v)
        time.sleep(np.random.uniform(0.01, 1))


createSprites(sprites)    
makeWander()
send('/sprite_Osc', ['clearAll'])   
 
def demo(sprite, granularity, steps=1000):
    generator = spriteValueGenerator(sprite, granularity)
    
   # a = [generator('amp') for _ in range(steps)]
    f = [generator('freq') for _ in range(steps)]
   # r = [generator('rate') for _ in range(steps)]
   # p = [generator('pos') for _ in range(steps)]
    
    #plt.plot(a)
    plt.plot(f)
    #plt.plot(r)
    #plt.plot(p)


demo(sprite2, 10, 1000)

