import os

root = r"C:\Users\graha\Documents\dev\EngineRoom\Framework\PythonLib"
#root = r"C:\Users\g.stalker-wilde\Google Drive\Documents\dev\repos\EngineRoom\\"
os.chdir(root)

from send2framework import sender
from threadrunners import rlocker, play_synth_pattern
from generators import const_gen, rng_gen, rng_gen2, zip_gen, rand_gen, seq_gen, gen_proxy, AtEnd, \
                                    makeSafeKeyedSetterGetter, keyed_gen       
from scales import  midi2freq, n2f          
                         
#from osc_receiver import osc_receiver

# a threadsafe sender
s = rlocker(sender('/implOsc', ip='127.0.0.1', port=57120))

#r = osc_receiver(ip='127.0.0.1', port=5771, oscChannel='/fromSC')

triples = [63, 58, 55, 58, 63, 65] + \
          [67, 63, 58, 63, 67, 68] + \
          [70, 67, 63, 67, 70, 75] + \
          [79, 75, 70, 67, 63, 58]


amp_basis = 0.3
dur_basis = 0.1

triple_fs = [midi2freq(t) for t in triples]
triple_amps = [amp_basis * a for a in [1, 0.7, 0.7, 0.8, 0.7, 0.7]]




#	| midinote=60, dur=1, amp=0.25 |
.

setters['dur'](1)
setters['durs'](1)

ss.set()