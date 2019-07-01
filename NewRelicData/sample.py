from send2framework import sender

s = sender('/implOsc')

s('loadCode', r"C:\Users\graha\Documents\dev\EngineRoom\CompositionFramework\examples\sitemonitor\loadme.scd")
#\name:\sonifier, \key:\sonifier1,\killEventName:\killsonifier1),
#		              \controls: [(\controlName:\freq,
#					               \eventName:\freq1,
#								   \initialValue:300),
#								  (\controlName:\amp,
#								   \eventName:\amp1,
#								   \initialValue:0.1),
#								  (\controlName:\rate,
#								   \eventName:\rate1,
#								   \initialValue:10)
s('initSynth', 'sonifier', 'sonifier1', 'killsonifier1',
               'freq', 'freq1', 400,
               'amp', 'amp1', 0.2,
               'rate', 'rate1', 0.4)
               
s('amp1', 0.015)
s('rate1', 0.1)
s('killsonifier1')

#\sonifier2, {|freq=500, amp=0.4, bwr=0.5, tremoloFreq=0.1, tremoloDepth=0.95|

s('initSynth', 'sonifier2', 'synth2', 'killsynth2',
               'freq', 'freq2', 400,
               'amp', 'amp2', 0.2,
               'bwr', 'bwr2', 0.1,
               'tremoloFreq', 'tremoloFreq2', 1,
               'tremoloDepth', 'tremoloDepth2', 0.3)
s('tremoloFreq2', 0.1)
s('bwr2', 0.4)
s('amp2', 0.2)
s('freq2', 800)
s('killsynth2')


import time
from ValueMappers import makeConstrainMapper
import numpy as np  
freqMapper = makeConstrainMapper(1, 100, 100, 5000, logmap = True)
bwrMapper = makeConstrainMapper(1,100, 1, 0.1)
for i in np.linspace(0, 100, 100, False):
    time.sleep(0.01)
    val = freqMapper(i)
    print(i, val)
    s('freq2',  freqMapper(i))
    s('bwr2', bwrMapper(i))