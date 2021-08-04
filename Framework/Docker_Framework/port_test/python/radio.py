import sys
sys.path.append('./lib')

from send2framework import sender
from threadrunners import rlocker
import time
import os

# a threadsafe sender
host =  os.getenv('SC_IP') or '172.20.0.2'
port =  57120 if not os.getenv('SC_PORT') else int(os.getenv('SC_PORT'))
osc_chan = os.getenv('SC_OSC_CHAN') or '/implOsc'

s = rlocker(sender('/implOsc', ip=host, port=port))


inc = 1
def next_note(note):
    global inc
    if note + inc > 7 or note + inc < 0: 
        inc = -1 * inc
    return note + inc

note = 0
while True:
    note = next_note(note)
    print(note, host, port)
    s('setNote', note)
    time.sleep(1)

