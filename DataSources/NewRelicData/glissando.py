import os

root = r"C:\Users\graha\Documents\dev\EngineRoom\\"
#root = r"C:\Users\g.stalker-wilde\Google Drive\Documents\dev\repos\EngineRoom\\"
os.chdir(root + r"NewRelicData")

from send2framework import sender
from threadrunners import rlocker, play_synth_pattern
from generators import const_gen, rng_gen, rng_gen2, zip_gen, rand_gen, seq_gen, gen_proxy, AtEnd, \
                                    makeSafeKeyedSetterGetter, keyed_gen                                   

# a threadsafe sender
s = rlocker(sender('/implOsc'))
s('loadCode', root + r"synths\glissando.scd")

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



setters['from'](rand_gen([2200, 2300, 2400, 2500, 2600]))
setters['to'](rand_gen([200, 300, 400, 500, 600]))
setters['len'](rand_gen([0.6, 0.5, 0.3, 0.4]))
setters['durs'](rand_gen([0.1, 0.2, 0.4]))
ss.set()


