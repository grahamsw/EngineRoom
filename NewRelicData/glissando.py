import os

#root = r"C:\Users\graha\Documents\dev\EngineRoom\\"
root = r"C:\Users\g.stalker-wilde\Google Drive\Documents\dev\repos\EngineRoom\\"
os.chdir(root + r"NewRelicData")

from send2framework import sender
from threadrunners import rlocker, run_in_thread
from generators import const_gen, rng_gen, rng_gen2, zip_gen, rand_gen, seq_gen, gen_proxy, AtEnd, \
                                    makeSafeKeyedSetterGetter, keyed_gen
from scales import  midi2freq, n2f                                   
#from osc_receiver import readSupercolliderVal

# a threadsafe sender
s = rlocker(sender('/implOsc'))

# load synth
s('loadCode', root + r"synths\glissando.scd")

import functools
import operator

def play_synth_pattern(sender, synthName, controls, durs):
    setters_getters = {key:makeSafeKeyedSetterGetter(controls[key]) for key in controls}
    ps = [[const_gen(key), gen_proxy(setters_getters[key][1])] for key in setters_getters]
    # flatten
    params = functools.reduce(operator.iconcat, ps, [const_gen('playSynth'), const_gen(synthName)])   
    durs_setter, durs_getter = makeSafeKeyedSetterGetter(durs)   
    s, _ = run_in_thread(sender, zip_gen(*params),
                          gen_proxy(durs_getter))     
    setters = {key:setters_getters[key][0] for key in setters_getters}
    setters['durs'] = durs_setter
    return s, setters
    

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



ss, setters = play_synth_pattern(s, 'glissando',
                                    {
                                         'from':rand_gen([200, 300, 400, 500, 600]),
                                         'to':rand_gen([1200, 1300, 1400, 1500, 1600]),
                                         'len':rand_gen([0.1, 0.2, 0.3, 0.4]),
                                         'amp':const_gen(0.01),
                                         'out':const_gen(0)
                                    },
                                    rand_gen([0.1, 0.5, 0.1, 1.5,0.2]))
    
setters['len'](rand_gen([0.1, 0.2, 0.3, 0.4]))
setters['durs'](const_gen(0.1))
ss.set()


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



r = [[a,a] for a in [1,2,3]]


s = functools.reduce(operator.iconcat, r, [])