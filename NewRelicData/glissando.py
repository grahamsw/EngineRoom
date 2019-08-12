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

# load synth
s('loadCode', root + r"synths\glissando.scd")

#| from = 200, to = 2000, len = 10, amp = 0.6, out = 0|


def start_glissando(sender, from_gen, to_gen, lens_gen, amps_gen, durs_gen):
    froms = makeSafeKeyedSetterGetter(from_gen)
    tos = makeSafeKeyedSetterGetter(to_gen)
    lens = makeSafeKeyedSetterGetter(lens_gen)
    amps = makeSafeKeyedSetterGetter(amps_gen)
    outs = makeSafeKeyedSetterGetter(const_gen(0))
    dur_setter, dur_getter = makeSafeKeyedSetterGetter(durs_gen)
        
    params = [const_gen('playSynth'), const_gen('glissando'),
              const_gen('from'),      gen_proxy(froms[1]),
              const_gen('to'),        gen_proxy(tos[1]),
              const_gen('len'),       gen_proxy(lens[1]),
              const_gen('amp'),       gen_proxy(amps[1]),
              const_gen('out'),       gen_proxy(outs[1])]    
    # run and save stopper event
    s, _ = run_in_thread(sender, zip_gen(*params),
                          gen_proxy(dur_getter))   
    return s, {'froms':froms[0], 'tos':tos[0], 'lens':lens[0], 'amps':amps[0], 'durs':dur_setter}







s1, setters = start_glissando(s,
                             rand_gen([200, 300, 400, 500, 600]),
                             rand_gen([1200, 1300, 1400, 1500, 1600]),
                             rand_gen([0.1, 0.2, 0.3, 0.4]),
                             const_gen(0.01),
                             rand_gen([0.1, 0.5, 0.1, 1.5,0.2]))


s1.set()



s2, setters2 = start_glissando(s,
                             rand_gen([2200, 2300, 2400, 2500, 2600]),
                             rand_gen([200, 300, 400, 500, 600]),
                             rand_gen([0.6, 0.5, 0.3, 0.4]),
                             rand_gen([0.01, 0.015, 0.02]),
                             rand_gen([0.5,  1]))

setters2['durs'](rand_gen([0.1, 0.2, 0.4]))
s2.set()