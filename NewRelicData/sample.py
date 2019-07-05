import os
os.chdir(r"C:\Users\graha\Documents\dev\EngineRoom\NewRelicData")


from send2framework import sender
from threadrunners import rlocker, run_in_thread, const_gen, rng_gen, zip_gen, seq_gen, AtEnd



# a threadsafe sender
s = rlocker(sender('/implOsc'))


s('loadCinitSynthode', r"C:\Users\graha\Documents\dev\EngineRoom\CompositionFramework\examples\sitemonitor\loadme.scd")        



s('loadCode', r"C:\Users\graha\Documents\dev\EngineRoom\CompositionFramework\examples\sprites\whistle.scd")        

 #|freq = 440, focus = 4, rq = 0.03, pulseFreq = 5, amp = 0.5, out = 0|
# create an instance of sonfier and set up some controls for it
s('playSynth', 'whistle', 
               'freq', 400,
               'timeScale', 0.9,
               'amp', 1,
               'focus', 3,
               'pulseFreq', 5,
               'rq', 0.03) 


# create an instance of sonfier and set up some controls for it
s('initSynth', 'sonifier', 'sonifier1', 'killsonifier1',
               'freq', 'freq1', 400,
               'amp', 'amp1', 0.1,
               'rate', 'rate1', 0.4)

params_zip = [const_gen(arg) for arg in ['playSynth', 'whistle', 'amp', 1, 'focus', 1, 'pulseFreq', 4, 'rq', 0.3, 'freq']]
params_zip.append(seq_gen([300, 600, 900, 1200], AtEnd.MIRROR))
params_zip.append(const_gen('timeScale'))
params_zip.append(rng_gen(0.1, 4, 20, AtEnd.REPEAT))

s1, _ = run_in_thread(s, zip_gen(*params_zip),
                    const_gen(0.1))
s1.set()

# now run some threads playing with the controls
s1 = run_in_thread(s, zip_gen(const_gen("rate1"), rng_gen(0.1, 10, 20, 'rev')), 
                    const_gen(0.1))
s2 = run_in_thread(s, zip_gen(const_gen("freq1"), (200, 1000, 20, 'rev')), 
                    const_gen(0.2))



# tear down this instance of sonifier 1
s1[0].set()
s2[0].set()

s('killsonifier1')


# create an instance of sonfier2 and set up some controls for it
s('initSynth', 'sonifier2', 'synth2', 'killsynth2',
               'freq', 'freq2', 400,
               'amp', 'amp2', 0.2,
               'bwr', 'bwr2', 0.1,
               'tremoloFreq', 'tremoloFreq2', 1,
               'tremoloDepth', 'tremoloDepth2', 0.3)


# play with its controls
s3, _ = run_in_thread(s, zip_gen(const_gen("freq2"), rng_gen(200, 1000,20, 'rev')), const_gen(0.2))
s4,_ = run_in_thread(s, zip_gen(const_gen("bwr2"), rng_gen(0.1, 1, 30, 'rev')), const_gen(0.3))
s5, _ = run_in_thread(s, zip_gen(const_gen("tremoloFreq2"), rng_gen(0.2, 5, 20, 'rev')), const_gen(0.1))
s6, _ = run_in_thread(s, zip_gen(const_gen("tremoloDepth2"), rng_gen(0.1, 1, 30, 'rev')), const_gen(0.05))

# tear it down
s3.set()
s4.set()
s5.set()
s6.set()
s('killsynth2')

#
#from ValueMappers import makeConstrainMapper
#
#freqMapper = makeConstrainMapper(1, 100, 100, 5000, logmap = True)
#bwrMapper = makeConstrainMapper(1,100, 1, 0.1)
#for i in np.linspace(0, 100, 100, False):
#    time.sleep(0.01)
#    val = freqMapper(i)
#    print(i, val)
#    s('freq2',  freqMapper(i))
#    s('bwr2', bwrMapper(i))