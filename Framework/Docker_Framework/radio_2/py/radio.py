import sys
sys.path.append('./lib')

from send2framework import sender
from threadrunners import rlocker
import time
from datetime import datetime
from random import uniform

# a threadsafe senderpa
host = '172.17.0.2'
host = '127.0.0.1'
s = rlocker(sender('/implOsc', ip=host, port=57120))


#    \se:{ |inote| ~synth.set(\inote, inote)},
#    \setRate: {|rate| ~synth.set(\rate, rate)},

iNote = 25

minInote = 25
maxInote = 60
incNote = 1
rate = 0.5
minRate = 0.25
maxRate = 4
incRate = 0.2

doRate = False

while True:
    if doRate:
       rate = incRate + rate
       if (rate > maxRate) or (rate < minRate):
           incRate = incRate * -1
     #  s('setRate', rate)
     #  print(f'setRate, {rate}')
    else: 
        iNote = iNote +incNote
        if (iNote > maxInote) or (iNote < minInote):
            incNote = -1 * incNote
        s('setInote', iNote)
        print(f'setInote, {iNote}')
    doRate = not doRate
 #   s('setRate', int(rtd['activeUsers']), 60)
 #   s('playNumSignups', )
    wait = uniform(0.5, 5)
    print(f'wait: {wait}')
    time.sleep(wait)

