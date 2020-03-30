import os

root = r"C:\Users\graha\Documents\dev\EngineRoom\\"
os.chdir(root + r"NewRelicData")



from send2framework import sender
from threadrunners import rlocker, run_in_thread
from generators import const_gen, rng_gen, rng_gen2, zip_gen, rand_gen, seq_gen, gen_proxy, AtEnd, \
                                    makeSafeKeyedSetterGetter, keyed_gen
from scales import  midi2freq, n2f                                   
from osc_receiver import readSupercolliderVal

# a threadsafe sender
s = rlocker(sender('/implOsc'))



#############
#
# Wind Chimes
#
#############

# this is actually quite pretty

# load synth
s('loadCode', root + r"synth\PMCrotale.scd")
# midi = 60, tone = 3, art = 1, amp = 0.8, pan = 0;
lpfBusNum = 0
midi_setter, midi_getter = makeSafeKeyedSetterGetter(rand_gen([60,64,65,66,67]))
tone_setter, tone_getter = makeSafeKeyedSetterGetter(seq_gen([3,5,6], AtEnd.REPEAT))
amp_setter, amp_getter = makeSafeKeyedSetterGetter(seq_gen([0.01, 0.02, 0.01, 0.01, 0.04], AtEnd.REPEAT))
pan_setter, pan_getter = makeSafeKeyedSetterGetter(const_gen(0))
art_setter, art_getter = makeSafeKeyedSetterGetter(const_gen(1))


# create proxy for durations
dur_setter, dur_getter = makeSafeKeyedSetterGetter(rand_gen([0.1, 0.5, 1, 1.5,2]))


params = [const_gen('playSynth'), const_gen('PMCrotale'),
          const_gen('midi'),        gen_proxy(midi_getter),
          const_gen('tone'),       gen_proxy(tone_getter),
          const_gen('amp'),       gen_proxy(amp_getter),
          const_gen('pan'),    gen_proxy(pan_getter),
          const_gen('art'),    gen_proxy(art_getter)]
 
# run and save stopper event
s1, _ = run_in_thread(s, zip_gen(*params),
                      gen_proxy(dur_getter))

art_setter(const_gen(1.8))


midi_setter(rand_gen([70,74,75,76,77]))
tone_setter(const_gen(3))
tone_setter(seq_gen([3,5,6], AtEnd.MIRROR))


s1.set()