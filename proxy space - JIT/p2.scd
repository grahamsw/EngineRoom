p.clear
p
p.pop

CurrentEnvironment


p = ProxySpace.push

(
~sin1 = {|freq = 440, amp = 0.1|
    Saw.ar(freq, mul:amp);
}
)

(
~bpf = {BPF.ar(\in.ar, \freq.kr(440), \rq.kr(1.0))}
)
~bpf.set(\in, ~sin1)
(
~reverb = {
    FreeVerb.ar(\in.ar([0,0]), \mix.kr(0.33), \room.kr(0.5), \damp.kr(0.5))
}
)



(
~panner = {Pan2.ar(\in.ar, \pan.kr(0),\amp.kr(1))}
)
~bpf.set(\rq, 0.1)
~bpf.set(\freq, ~x2)

~sin1.set(\freq, ~x2)
~sin1.play
~sin1.stop
~reverb.play
~reverb.set(\in, ~panner)
~panner.stop
~panner.set(\in, ~bpf)

~panner.set(\pan, {~x.kr.range(-1.0, 1.0)})

~panner.set(\amp, 1)
(
//
~x = {MouseX.kr};
~y = {MouseY.kr};
~x2 = ~x.exp * 1000 + 100;
)


~out = { arg rate = 2; Pan2.ar(PinkNoise.ar(0.1), LFClipNoise.kr(rate)) };
~out.set(\rate, 1);
~out = { arg rate = 2; Pan2.ar(Dust.ar(2000, 0.2), LFClipNoise.kr(rate)) };
~out.set(\rate, 1);
