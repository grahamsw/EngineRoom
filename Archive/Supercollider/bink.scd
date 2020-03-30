s.options.memSize;// = 32 * s.options.memSize


(

SynthDef(\bink,
	{
		|freq = 440, pan=1|
		var sig, del;
		sig = Pulse.ar( freq *
			Line.kr(1, LFNoise1.kr(0.1).linlin(-1,1, -0.5,0).midiratio, 0.1),
			width:0.1);
		del = Mix.fill(20, { |i|
			DelayL.ar(sig,
				delaytime:LFNoise1.kr(0.1).linlin(-1,1, 0.01, 0.1));
		});
		Out.ar(0, Pan2.ar((sig + del)*EnvGen.kr(Env.perc, doneAction:2),
			LFNoise1.kr(pan), 0.1));
}).add;
)


s.scope
Synth(\bink, [\freq, 110.midicps])


(
var arr, window;
arr = Array.fill(8, {|i|
	Task({
		var pitch;
		inf.do({
			pitch =( ( i * [3,5,7].choose + 40) %80 + 20).postln;
			Synth(\bink, [\freq, pitch.midicps,
				\pan, pitch/50]);
			((9-1)/8).wait;
		});
	})
});

arr.do({|t| t.play});

window = Window("control", Rect(100, 100, 8 * 50, 50)).front;
8.do({|i|
	Button(window, Rect(i * 50, 0, 50,50))
	.states_([[i.asString, Color.red], [i.asString, Color.black]])
	.action_({|me| if(me.value == 1) {arr[i].pause}{arr[i].play}});
});

)