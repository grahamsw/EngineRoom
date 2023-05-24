import sys
sys.path.append('./lib')

from send2framework import sender
from threadrunners import rlocker
from gart import read_live_data
from datetime import datetime
import random
import time
import os


print("hello")

# a threadsafe sender
host =  os.getenv('SC_IP') or '172.30.0.2'
port =  57120 if not os.getenv('SC_PORT') else int(os.getenv('SC_PORT'))
osc_chan = os.getenv('SC_OSC_CHANNEL') or '/implOsc'

print(host, port, osc_chan)

s = rlocker(sender(osc_chan, ip=host, port=port))



while True:
    rtd = read_live_data()
    print(datetime.now(), int(rtd['activeUsers']), flush=True)
    s('setRate', int(rtd['activeUsers']), 60)
  #  s('playNumSignups', )
    time.sleep(60)

