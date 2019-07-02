from send2framework import sender
from threadrunners import rlocker, run_in_thread, const_gen, rng_gen, zip_gen



# a threadsafe sender
s = rlocker(sender('/implOsc'))


s('loadCode', r"C:\Users\graha\Documents\dev\EngineRoom\CompositionFramework\examples\sitemonitor\loadme.scd")        



# create an instance of sonfier and set up some controls for it
s('initSynth', 'sonifier', 'sonifier1', 'killsonifier1',
               'freq', 'freq1', 400,
               'amp', 'amp1', 0.1,
               'rate', 'rate1', 0.4)



# now run some threads playing with the controls
s1 = run_in_thread(s, zip_gen(const_gen("rate1"), rng_gen(0.1, 10, 20, 'rev')), 
                    const_gen(0.1))
s2 = run_in_thread(s, zip_gen(const_gen("freq1"), rng_gen(200, 1000, 20, 'rev')), 
                    const_gen(0.2))



# tear down this instance of sonifier 1
s1.set()
s2.set()
s('killsonifier1')



# create an instance of sonfier2 and set up some controls for it
s('initSynth', 'sonifier2', 'synth2', 'killsynth2',
               'freq', 'freq2', 400,
               'amp', 'amp2', 0.2,
               'bwr', 'bwr2', 0.1,
               'tremoloFreq', 'tremoloFreq2', 1,
               'tremoloDepth', 'tremoloDepth2', 0.3)


# play with its controls
s3 = run_in_thread(s, zip_gen(const_gen("freq2"), rng_gen(200, 1000,20, 'rev')), const_gen(0.2))
s4 = run_in_thread(s, zip_gen(const_gen("bwr2"), rng_gen(0.1, 1, 30, 'rev')), const_gen(0.3))

# tear it down
s3.set()
s4.set()
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