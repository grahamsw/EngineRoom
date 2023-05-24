

(

SynthDef(\purr, {
	|freq=120,sawVarFreq= 0.1, sawLowerVal =18, sawUpperVal=22, sawAmp=0.5,pinkAmp=0.8
	 filterVarFreq=0.1, filterLowerVal=40, filterUpperVal=42|
	a = LFSaw.ar(LFNoise1.ar(sawVarFreq).range(sawLowerVal, sawUpperVal), mul:sawAmp);
	a = a + PinkNoise.ar(pinkAmp);
	h = SinOsc.ar(filterVarFreq).range(filterLowerVal,filterUpperVal);
	f = LPF.ar(a, h) * LFPar.ar(freq).unipolar;
	g = f;// + Mix(SinOsc.ar([40, 41], mul:0.1));
	Out.ar(0, g);
}).add
)

x = Synth(\purr)
x.set(\filterUpperVal, 40)

x.set(\sawUpperVal, 20)

x.set(\freq, 80)
x.set(\pinkAmp, 1)
(
b = Bus.control(s, 1);

{Out.kr(b, MouseX.kr(0.01, 10).poll)}.play;

x.map(\sawVarFreq, b)
)

x.set(\sawAmp, 0.7)



(

Ndef(\purr, {
	|freq=120,sawVarFreq= 0.1, sawLowerVal =18, sawUpperVal=22, sawAmp=0.1,pinkAmp=0.8
	 filterVarFreq=0.1, filterLowerVal=40, filterUpperVal=42|
	a = LFSaw.ar(LFNoise1.ar(sawVarFreq).range(sawLowerVal, sawUpperVal), mul:sawAmp);
	a = a + PinkNoise.ar(pinkAmp);
	h = SinOsc.ar(filterVarFreq).range(filterLowerVal,filterUpperVal);
	f = LPF.ar(a, h) * LFPar.ar(freq).unipolar;
	g = f;// + Mix(SinOsc.ar([40, 41], mul:0.1));
	Out.ar(0, g);
});


Ndef(\purr).play;

Ndef(\purr).set(\freq, 200);

Ndef(\purr).fadeTime = 2
)
Ndef.clear(3)

Ndef(\purr).set(\purr,  = 2

​
Ndef(\a).play; // play to hardware output.
Ndef(\a).fadeTime = 2; // fadeTime specifies crossfade
// set the source
Ndef(\a, { SinOsc.ar([350, 351.3], 0, 0.2) });
Ndef(\a, { Pulse.ar([350, 351.3] / 4, 0.4, 0.2) });
Ndef(\a, Pbind(\dur, 0.03, \freq, Pbrown(0, 1, 0.1, inf).linexp(0, 1, 200, 350)));
​
Ndef(\a, { Ringz.ar(Ndef.ar(\b), [350, 351.3] * 2, 0.4) });
Ndef(\b, { Impulse.ar([5, 7]/2, [0, 0.5], 0.15) });
​
Ndef.clear(3); // clear all after 3 seconds

Ndef(\lfo2, { LFNoise1.kr(LFNoise1.kr(0.1).exprange(1, 300) ! 2, 400, 800) });
Ndef(\sound, { Blip.ar(Ndef.kr(\lfo2), 30) * 0.2 }).play;
​
Ndef(\lfo2, { [MouseX.kr(10, 300, 1), MouseY.kr(10, 300, 1)] });
setting and mapping parameters
Ndef(\sound, { |freq = 56, numHarm = 10| Blip.ar(freq, numHarm, 30) * 0.2 }).play;
Ndef(\sound).set(\freq, 15);
Ndef(\sound).set(\freq, 15, \numHarm, 100);
​
Ndef(\lfo, { LFNoise2.kr(2).exprange(10, 200) });
Ndef(\sound).map(\numHarm, Ndef(\lfo));
Ndef(\sound).set(\numHarm, nil); // unmap.
Ndef(\sound).stop;
Simple audio routing with the <<> operator
(
Ndef(\sound, {
    RHPF.ar(
        \in1.ar([0, 0]) * \in2.ar([0, 0]),
        \freq.kr(6000, 2),
        \rq.kr(0.2)
    ) * 7
}).play;
Ndef(\sound).fadeTime = 0.2;    // avoid harsh clicks
)
​
Ndef(\a, { SinOsc.ar(MouseX.kr(300, 1000, 1) * [1, 1.2], \phase.ar([0, 0]) * 0.2) });
Ndef(\b, { LFDNoise3.ar(MouseY.kr(3, 1000, 1) * [1, 1.2]) });
Ndef(\c, { LFTri.ar(MouseY.kr(3, 10, 1) * [1, 1.2]).max(0) });
Ndef(\a).fadeTime = 0.2;    // avoid harsh clicks again
​
Ndef(\sound) <<>.in1 Ndef(\a);
Ndef(\sound) <<>.in2 Ndef(\b);
Ndef(\sound) <<>.in2 Ndef(\c);
Ndef(\a) <<>.phase Ndef(\sound);
Ndef(\a) <<>.phase nil;    // unmap
Ndef.clear(3);        // fade out and clear all Ndefs




