import os

root = r"C:\Users\graha\Documents\dev\EngineRoom\\"
os.chdir(root + r"NewRelicData")



from send2framework import sender
from threadrunners import rlocker, run_in_thread
from generators import const_gen, rng_gen, rng_gen2, zip_gen, rand_gen, seq_gen, gen_proxy, AtEnd, \
                                    makeSafeKeyedSetterGetter, keyed_gen
from scales import  midi2freq, n2f                                   
from osc_receiver import readSupercolliderVal, startServer


startServer(ip='192.168.1.18')
# a threadsafe sender
s = rlocker(sender('/implOsc','192.168.1.18'))




# create bus
s('createBus', 'lpfBus')
lpfBusNum = None
while lpfBusNum == None:
    lpfBusNum = readSupercolliderVal('lpfBus')
    
print(f'bus: {lpfBusNum}')    
    


#############
#
# Wind Chimes
#
#############

# this is actually quite pretty

# load synth
s('loadCode', "~/Engineroom/synths/bell.scd")
lpfBusNum = 0
# create proxies for synth controls
# these are the params
# |fs=1000, t60=1, pitchy=1, amp=0.25, gate=1|
freq_setter, freq_getter = makeSafeKeyedSetterGetter(rand_gen([300, 450, 600, 750, 900, 1000]))
t60_setter, t60_getter = makeSafeKeyedSetterGetter(seq_gen([3,5,6], AtEnd.REPEAT))
amp_setter, amp_getter = makeSafeKeyedSetterGetter(seq_gen([0.01, 0.02, 0.01, 0.01, 0.04], AtEnd.REPEAT))
pitchy_setter, pitchy_getter = makeSafeKeyedSetterGetter(const_gen(3))
out_setter, out_getter = makeSafeKeyedSetterGetter(const_gen(lpfBusNum))


# create proxy for durations
dur_setter, dur_getter = makeSafeKeyedSetterGetter(rand_gen([0.1, 0.5, 1, 1.5,2]))
amp_setter(seq_gen([0.01, 0.02, 0.005,0.01], AtEnd.REPEAT))

params = [const_gen('playSynth'), const_gen('bell'),
          const_gen('fs'),        gen_proxy(freq_getter),
          const_gen('t60'),       gen_proxy(t60_getter),
          const_gen('amp'),       gen_proxy(amp_getter),
          const_gen('pitchy'),    gen_proxy(pitchy_getter),
          const_gen('out'),       gen_proxy(out_getter)]
 
# run and save stopper event
s1, _ = run_in_thread(s, zip_gen(*params),
                      gen_proxy(dur_getter))

t60_setter(const_gen(4))
t60_setter(seq_gen([3,5,6], AtEnd.MIRROR))

out_setter(const_gen(4))

freq_setter(seq_gen([midi2freq(n, refNote=1, refFreq=300) for n in [0,2, 4, 5, 7, 9, 11, 12]], AtEnd.REPEAT))
dur_setter(const_gen(0.5))

# this is low wind
dur_setter(rand_gen([0.1, 0.5, 1, 1.5,2], allowRepeats=False))
freq_setter(rand_gen([300, 450, 600, 750], allowRepeats=False))

# slightly more agitated
dur_setter(rand_gen([0.5, 0.1, 1], allowRepeats=False))
freq_setter(rand_gen([750, 900, 1000, 1150, 1270], allowRepeats=False))

# even more agitated
dur_setter(rand_gen([0.5, 0.1, 0.2, 0.05], allowRepeats=False))
freq_setter(rand_gen([1000, 1150, 1270, 1500, 800], allowRepeats=False))

# stop the chimes
s1.set()







s('loadCode', r"C:\Users\graha\Documents\dev\EngineRoom\Archive\Supercollider\Lpf.scd")


# another synth
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

# play an endless sequence
params_zip = [const_gen(arg) for arg in ['playSynth', 'whistle', 'amp', 1, 'focus', 1, 'pulseFreq', 4, 'rq', 0.3, 'freq']]
params_zip.append(seq_gen([300, 600, 900, 1200], AtEnd.MIRROR))
params_zip.append(const_gen('timeScale'))
params_zip.append(rng_gen(0.1, 4, 20, AtEnd.REPEAT))

params = [const_gen('playSynth'), const_gen('whistle'),
          const_gen('amp'), const_gen(0.1),
          const_gen('focus'), rng_gen(0, 0.1, 10, AtEnd.MIRROR),
          const_gen('pulseFreq'), rng_gen(0.1, 5, 10, AtEnd.REPEAT),
          const_gen('rq'), const_gen(0.9),
          const_gen('timeScale'), seq_gen([0.5, 1, 2], AtEnd.REPEAT),
          const_gen('freq'), seq_gen([300, 450, 600, 750, 900, 1000], AtEnd.MIRROR)]

s1, _ = run_in_thread(s, zip_gen(*params),
                      const_gen(0.5))
# stop the sequence
s1.set()




s('loadCode', r"C:\Users\graha\Documents\dev\EngineRoom\Archive\Supercollider\supercollider\PMCrotale.scd")

s('loadCode', r"C:\Users\graha\Documents\dev\EngineRoom\Archive\Supercollider\Sonifiers.scd")

# a continuous synth that keeps playing

# create an instance of sonfier2 and set up some controls for it
s('initSynth', 'sonifier2', 'synth2', 'killsynth2',
               'freq', 'freq2', 400,
               'amp', 'amp2', 0.2,
               'bwr', 'bwr2', 0.1,
               'tremoloFreq', 'tremoloFreq2', 1,
               'tremoloDepth', 'tremoloDepth2', 0.3)


# play with its controls
s3, _ = run_in_thread(s, zip_gen(const_gen("freq2"), rng_gen(200, 1000,20, 'rev')), const_gen(0.2))
s4, _ = run_in_thread(s, zip_gen(const_gen("bwr2"), rng_gen(0.1, 1, 30, 'rev')), const_gen(0.3))
s5, _ = run_in_thread(s, zip_gen(const_gen("tremoloFreq2"), rng_gen(0.2, 5, 20, 'rev')), const_gen(0.1))
s6, _ = run_in_thread(s, zip_gen(const_gen("tremoloDepth2"), rng_gen(0.1, 1, 30, 'rev')), const_gen(0.05))

# tear it down
s3.set()
s4.set()
s5.set()
s6.set()
s('killsynth2')
