import os
import pandas as pd
from datetime import datetime
import time

root = r"C:\Users\graha\Documents\dev\github\EngineRoom\Framework\PythonLib"
#root = r"C:\Users\g.stalker-wilde\Google Drive\Documents\dev\repos\EngineRoom\\"
os.chdir(root)

from send2framework import sender
from threadrunners import rlocker, run_in_thread
from gart import get_new_data, sections
from generators import const_gen, keyed_gen

# a threadsafe senderpa
s = rlocker(sender('/implOsc', ip='45.76.4.163', port=57120))




while True:
    rtd = get_new_data(sections)
    print(datetime.now(), rtd)
    s('setRate', int(rtd['activeUsers']), 60)
    s('playNumSignups', )
    time.sleep(60)

