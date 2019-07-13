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

# |f1, f2, fund = 70, amp =0.25|
	
s('loadCode', r"C:\Users\graha\Documents\dev\EngineRoom\Archive\Supercollider\Formants.scd")



vowels = {	'i': [2300, 300], 'e': [2150,440], 'E': [1830, 580],
	'a': [1620, 780], 'O': [900, 580], 'o': [730, 440],
	'u': [780, 290], 'y': [1750, 300], 'oe': [1600, 440],
	'OE': [1400, 580]}

def sendVowel(v):
    f1 = vowels[v][1]
    f2 = vowels[v][0]
    s('f11', f1)
    s('f21', f2)
    
    
# create an instance of sonfier2 and set up some controls for it
s('initSynth', 'vocali', 'vocali1', 'killvolcali1',
               'fund', 'fund1', 70,
               'amp', 'amp1', 0.2,
               
               'f1', 'f11', 400,
               'f2', 'f21', 1)    
s2, _ = run_in_thread(sendVowel, rand_gen(list(vowels.keys()), allowRepeats=False), const_gen(0.5))    
s3, _ = run_in_thread(s, zip_gen(const_gen("fund1"), rand_gen([70, 80, 60])), const_gen(0.51))
s4, _ = run_in_thread(s, zip_gen(const_gen("amp1"), rand_gen([0.85, 0.1, 0.15,0.2,  0.25], [5, 10, 10, 5, 1])), const_gen(0.49))

# tear it down
s2.set()
s3.set()
s4.set()

s('killvolcali1')

.