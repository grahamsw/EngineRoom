import os
import pandas as pd

root = r"C:\Users\graha\Documents\dev\github\EngineRoom\Framework\PythonLib"
#root = r"C:\Users\g.stalker-wilde\Google Drive\Documents\dev\repos\EngineRoom\\"
os.chdir(root)

from send2framework import sender
from threadrunners import rlocker, run_in_thread
from gart import read_live_data
from generators import const_gen, keyed_gen

# a threadsafe senderpa
s = rlocker(sender('/implOsc', ip='45.76.4.163', port=57120))


def start():
  #  s('start')
    
    def next_val():
        rtd = read_live_data()
        print(rtd)
        return ['setRate', int(rtd['activeUsers']), 60] # 60 is max rate - can reset dynamically if necessary
     
    stopper, _ = run_in_thread(s, keyed_gen(next_val), const_gen(15)) 
    return stopper

def stop():
    stopper.set()
    s('stop')


stopper = start()


