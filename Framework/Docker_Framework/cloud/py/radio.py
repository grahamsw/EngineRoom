import sys
sys.path.append('./lib')

from send2framework import sender
from threadrunners import rlocker
import time
import os


print("hello")

# a threadsafe sender
host =  os.getenv('SC_IP') or '172.115.0.2'
port =  57120 if not os.getenv('SC_PORT') else int(os.getenv('SC_PORT'))
osc_chan = os.getenv('SC_OSC_CHANNEL') or '/implOsc'

print([host, port, osc_chan ], flush=True)

s = rlocker(sender(osc_chan, ip=host, port=port))
time.sleep(10)
s('start')

time.sleep(10)



