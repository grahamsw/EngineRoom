import sys
sys.path.append('./lib')

from send2framework import sender
from threadrunners import rlocker
import time
from datetime import datetime

# a threadsafe sender
s = rlocker(sender('/implOsc', ip='172.17.0.3', port=57120))



while True:
    rtd = read_data()
    print(datetime.now(), rtd)
    s('setRate', int(rtd['activeUsers']), 60)
    time.sleep(60)

