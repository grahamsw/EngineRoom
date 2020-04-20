(

SynthDef(\RmOctaver,

	{
		|bus|
		var in, an, freq;
		in = In.ar(bus);
		an = Pitch.kr(in).poll(2);
		freq = an[0];
		Out.ar(0, SinOsc.ar(freq:freq * 0.5 ) * in + in);
		//Out.ar(0,  in);
}).add;
)

(
~bus = Bus.audio(s);
{Out.ar(~bus,Blip.ar(MouseX.kr(100, 5000, 1).poll(2), 5, 0.5))}.play;
~rmer = Synth(\RmOctaver, [\bus, ~bus]);

~bus.scope;

)


(


{SinOsc.ar(MouseY.kr(10, 5000, 1).poll(2, "Y") + SinOsc.ar(MouseX.kr(10, 1000, 1).poll(2, "X"), mul:1000), mul:0.5) }.play

{SinOsc.ar(2000 +
	SinOsc.ar(MouseX.kr(10, 1000, 1).poll(2, "X"),
		mul:MouseY.kr(0, 20000))) }.play




(
{SinOsc.ar(
	1000


