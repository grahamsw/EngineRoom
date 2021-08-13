import sys
sys.path.append('./lib')

from send2framework import sender
from threadrunners import rlocker
import time
import os


print("hello")

# a threadsafe sender
host =  os.getenv('SC_IP') or '172.20.0.2'
port =  57120 if not os.getenv('SC_PORT') else int(os.getenv('SC_PORT'))
osc_chan = os.getenv('SC_OSC_CHANNEL') or '/implOsc'


s = rlocker(sender(osc_chan, ip=host, port=port))


inc = 1
def next_note(note):
    global inc
    if note + inc > 17 or note + inc < 4: 
        inc = -1 * inc
    return note + inc

note = 5
while True:
    note = next_note(note)
    print(note, host, port, flush=True)
    s('setNote', note)
    time.sleep(0.25)

