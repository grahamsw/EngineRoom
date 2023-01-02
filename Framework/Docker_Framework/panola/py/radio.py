import sys
sys.path.append('./lib')

from send2framework import sender
from threadrunners import rlocker
import time
import os


print("hello")
print("making rlocker")

# a threadsafe sender
host =  os.getenv('SC_IP') or '172.70.0.2'
port =  57120 if not os.getenv('SC_PORT') else int(os.getenv('SC_PORT'))
osc_chan = os.getenv('SC_OSC_CHANNEL') or '/implOsc'
print(host, port, osc_chan)

s = rlocker(sender(osc_chan, ip=host, port=port))
#s = rlocker(sender(osc_chan, port=port))
print("made rlocker")

time.sleep(10)

print('clock set')
s('set_clock', 160, 'default')
s('start', 'first', '<c4_4@vol[0.2] e- g> <c4_4@vol[0.1] e- g> <c4_4@vol[0.1] e- g> <c4_4@vol[0.1] e- g>')

while True:
    s('change', 'first', '<b3_4@vol[0.2] f4 g> <b3_4@vol[0.1] f4 g> <b3_4@vol[0.1] f4 g> <f3_4@vol[0.1] f4 g>')
    time.sleep(6)
    s('change', 'first', '<c4_4@vol[0.2] e- g> <c4_4@vol[0.1] e- g> <c4_4@vol[0.1] e- g> <c4_4@vol[0.1] e- g>')
    time.sleep(6)

s('stop', 'first')


e-4_3@vol[0.2] b-3@vol[0.1] g b- e-4 f g@vol[0.2] e-@vol[0.1] b-3 e-4 g a- b-4@vol[0.2] g@vol[0.1] e- g b- e-5 g@vol[0.2] e-@vol[0.1] b-4 g e- b-3
<e-4_4@vol[0.05] g3> <g4_4@vol[0.05] e- > <b-_4@vol[0.05] g> <g5_4@vol[0.05] e- >