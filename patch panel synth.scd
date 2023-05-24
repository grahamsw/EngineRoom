// a patch panel synth in Supercollider
(
~x = {MouseX.kr};
~y = {MouseY.kr(-1,1)};
~lfsin = {SinOsc.kr(\freq.kr(1))};
~lfsaw = {Saw.kr(\freq.kr(1))};
~lfpulse = {Pulse.kr(\freq.kr(1), \width.kr(0.1))};
)

~lfpulse.set(\width, 0.1, \freq, ~lfsin.kr.lin)

~lfsaw.set(\freq, 10)

~snd = {LFSaw.ar(freq: ~x.kr.linexp(0.0, 1, 200, 2000).round(50), mul:1 - (~lfpulse.kr * 0.5))}

~panner = {Pan2.ar(\in.ar(0), pos:\pos.kr(0), level:\amp.kr(0.1))}

~snd.play
~panner.set(\in, ~snd)
~panner.play
~panner.set(\pos, ~y)

p = ProxySpace.push
ProxyMixer(p)
