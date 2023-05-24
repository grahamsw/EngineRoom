import sys
sys.path.append('./lib')

from send2framework import sender
from threadrunners import rlocker
import time
import os
import random

# a threadsafe sender
host =  os.getenv('SC_IP') or '172.20.0.2'
port =  57120 if not os.getenv('SC_PORT') else int(os.getenv('SC_PORT'))
osc_chan = os.getenv('SC_OSC_CHANNEL') or '/implOsc'


s = rlocker(sender(osc_chan, ip=host, port=port))


inc = 2

def next_note(note):
    global inc

    if note + inc > 67 or note + inc < 40: 
        inc = -1 * inc
    return note + inc

def next_rate(rate):
    global count
    count = count + 1
    if count % 5 == 0:
        return random.uniform(0.1, 1)
    else:
        return rate

count = 0
note = 53
rate = 0.25

while True:
    note = next_note(note)
    rate = next_rate(rate)
    print(note, rate, host, port, flush=True)
    s('setNote', note)
    s('setRate', rate)
    time.sleep(2.1)

