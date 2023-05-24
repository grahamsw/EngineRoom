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
s('loadCode', r"..\Synths\default.scd")

s('loadCode', r"..\Patterns\the_rhine_016.scd")
s('loadCode', r"..\Patterns\play.scd")
