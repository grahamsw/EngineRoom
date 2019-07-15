import os
os.chdir(r"C:\Users\graha\Documents\dev\EngineRoom\NewRelicData")
#os.chdir(r"C:\Users\g.stalker-wilde\Google Drive\Documents\dev\repos\EngineRoom\NewRelicData")



from send2framework import sender
from threadrunners import rlocker, run_in_thread
from generators import const_gen, rng_gen, rng_gen2, zip_gen, rand_gen, seq_gen, gen_proxy, AtEnd, \
                                    makeSafeKeyedSetterGetter, keyed_gen
from scales import  midi2freq, n2f                                   
from osc_receiver import readSupercolliderVal

# a threadsafe sender
s = rlocker(sender('/implOsc'))

# |freq = 400, attack = 0.1, decay = 0.1, sustain = 0.8, release = 0.1,    
#  mul = 0.5, harmonics=#[1, 1.5], 
# amps = #[0.5, 0.5], gate = 1, out = 0|
	
s('loadCode', r"C:\Users\graha\Documents\dev\EngineRoom\synths\sonifier_sustain.scd")


s('initSynth', 'sonifier_sustain', 'sonifier_sustain1', 'kilsonifier_sustain1',
               'freq', 'freq1', 500,
               'amp', 'amp1', 0.2,
              # 'harmonics', 'haronics1', '[1,2,5],
               
               'gate', 'gate1', 1)    
s('harmonics1', [2, 3])
s('gate1', 0)
s('kilsonifier_sustain1')