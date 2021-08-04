import sys
sys.path.append('./lib')

from send2framework import sender
from threadrunners import rlocker, run_in_thread
from gart import read_live_data
from generators import const_gen, keyed_gen
import time
from datetime import datetime

# a threadsafe senderpa
s = rlocker(sender('/implOsc', ip='172.17.0.3', port=57120))


def start_():
  #  s('start')
    
    def next_val():
        rtd = read_live_data()
        print(rtd)
        return ['setRate', int(rtd['activeUsers']), 60] # 60 is max rate - can reset dynamically if necessary
    print('nob') 
    stopper, _ = run_in_thread(s, keyed_gen(next_val), const_gen(15)) 
    return stopper

def stop():
    stopper.set()
    s('stop')


#stopper = start_()


while True:
    rtd = read_live_data()
    print(datetime.now(), rtd)
    s('setRate', int(rtd['activeUsers']), 60)
    s('playNumSignups', )
    time.sleep(60)

