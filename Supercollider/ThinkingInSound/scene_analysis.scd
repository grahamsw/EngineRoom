(

SynthDef(\fspace, {
	|freq = 440,  mul = 0.25, pos = 0|
	Out.ar(0, Pan2.ar(SinOsc.ar(freq, mul:mul), pos));
}).add;

)

(
b = Bus.control(s, 1);
c = Bus.control(s, 1);


{
	Out.kr(b, MouseX.kr(-1, 1))
}.play;

{
	Out.kr(c, MouseY.kr(-1, 1))
}.play;
)

(
d = Synth(\fspace);
e = Synth(\fspace, [\freq, 500]);
d.map(\pos, b);
e.map(\pos, c);

e.set(\freq, 600)
e.set(\mul, 0.25)
)







{Pan2.ar(SinOsc.ar(
	400, mul:0.25), Line.kr(-1, 1, 10) ) + Pan2.ar(SinOsc.ar(1500, mul:0.25),Line.kr(1, -1, 10))}.play
)