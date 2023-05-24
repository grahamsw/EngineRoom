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

ex1 Hunding
(<c4_4 a-3 f c a-2>)*2 f2_32 g a- b- c3_2  (<c4_32 a-3 f  a-2>)*2 <c4_8*2/3 a-3 f  a-2> <a-3_8*2/3 f  b-1> <c4_8*2/3 a-3 f  a-1>


g4_8@vol[0.3] d@vol[0.1] e- b-3 c4_8@vol[0.3] g3@vol[0.1] a d g4_8@vol[0.3] d@vol[0.1] e- b-3 e-4_8@vol[0.3] b-3@vol[0.1] c4 g3


(<d#5_16*1/3@vol[0.2] a4@vol[0.1] f#> <e5 c# a4> <d#5_16*1/3@vol[0.2] a3 f#3> <e4 c# a3> <d#4_16*1/3@vol[0.2] a3 f#3> <e4 c# a3>)*3