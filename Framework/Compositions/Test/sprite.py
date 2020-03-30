import os

root = r"C:\Users\graha\Documents\dev\EngineRoom\Framework\PythonLib"
#root = r"C:\Users\g.stalker-wilde\Google Drive\Documents\dev\repos\EngineRoom\\"
os.chdir(root)

from send2framework import sender
from threadrunners import rlocker, play_synth_pattern, run_in_thread
from generators import const_gen, rng_gen, rng_gen2, zip_gen, rand_gen, seq_gen, gen_proxy, AtEnd, \
                                    makeSafeKeyedSetterGetter, keyed_gen       
from scales import  midi2freq, n2f          
                         
#from osc_receiver import osc_receiver

# a threadsafe sender
s = rlocker(sender('/implOsc', ip='127.0.0.1', port=57120))

# |freq = 440, amp = 0.2, rate = 4, attack = 0.01, pos = 0, out = 1|

s('loadCode', r"..\Synths\sprite.scd")

# create an instance of sprite and set up some controls for it
s('initSynth', 'sprite', 'sprite1', 'killsprite1',
               'freq', 'freq1', 400,
               'amp', 'amp1', 0.2,
               'rate', 'rate1', 4,
               'attack', 'attack1', 0.01,
               'pos', 'pos1', 0)


# play with its controls
s3, _ = run_in_thread(s, zip_gen(const_gen("freq1"), rng_gen(390, 410,200, AtEnd.MIRROR)), const_gen(0.02))
s4, _ = run_in_thread(s, zip_gen(const_gen("amp1"), seq_gen([0.4, 0.3, 0.4], AtEnd.MIRROR)), const_gen(0.1))
s5, _ = run_in_thread(s, zip_gen(const_gen("rate1"), rng_gen(0.2, 5, 20, AtEnd.REPEAT)), const_gen(0.1))
s6, _ = run_in_thread(s, zip_gen(const_gen("attack1"), rng_gen(0.01, 0.1, 30, AtEnd.REPEAT)), const_gen(0.1))

# tear it down
s3.set()
s4.set()
s5.set()
s6.set()
s('killsprite1')
s('killsprite2')
s('killsprite3')
