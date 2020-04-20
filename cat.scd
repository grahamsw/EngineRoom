(
a =SynthDef(\cat, {
	|freq = 50, purr_rate= 2, filter_freq = 300, purr_width=0.3, mul = 1, gate=1, out = 0|
	var sound, env, pulse;
	env =    EnvGen.kr(

		Env.new(
            levels: [0, 1, 1, 0],
            times: [0.01, 0.01, 0.01],
            releaseNode: 2 // sustains at level 0.5 until gate is closed
        ),
        gate: gate);
	pulse = LFPulse.ar(purr_rate, width: purr_width);
	sound = Saw.ar(freq, pulse * mul);
	sound = LPF.ar(sound, filter_freq) * env;
	Out.ar(out, sound);
}).add;
)
SynthDescLib.global[\cat].makeGui
x = Synth(\cat);

x.map(\purr_rate, b)
x.map(\freq, c)
x.map(\filter_freq, d)
x.set(\freq, 50)
x.set(\purr_rate,0.22)
x.set(\filter_freq, 200)
x.set(\purr_width, 0.9)
SynthDefAutogui(\cat) ;

(
Pdef(\cat_test, Pmono(\cat,
	\freq, Pgbrown(20, 30, 0.025, inf).trace,
	\purr_width,Pbrown(0.9, 0.95, 0.05, inf).trace,
	\purr_rate, Pbrown(8, 9, 0.1, inf).trace ,
	\mul, 0.3,
	\filter_freq, Pbrown(100, 150, 10, inf).trace,
	\dur, 0.5


)).play
)




Pdef(\cat_test).stop

\cat.sVarGui.gui

(

{ Out.ar(b, LFTri.ar(2).range(550, 650))}.play
)



(
c = Bus.audio(s, 1);

{ Out.ar(c, SinOsc.ar(1).range(15, 25))}.play
)
	(
d = Bus.audio(s, 1);
	{Out.kr(d, MouseX.kr(30, 3000, 1))}.play
	)
(
8.do({|i|
    var n, a;
    // generate array of harmonic amplitudes
    n = (i+1)**2; // num harmonics for each table: [1,4,9,16,25,36,49,64]
    a = {|j| ((n-j)/n).squared }.dup(n);
    // fill table
    s.listSendMsg([\b_gen, 80+i, \sine1, 7] ++ a);
});
)
	(
// allocate tables 80 to 87
8.do {|i| s.sendMsg(\b_alloc, 80+i, 1024); };

	)


(
// allocate and fill tables 80 to 87
8.do({|i|
    // generate array of harmonic amplitudes
    a = {1.0.rand2.cubed }.dup((i+1)*4);
    // fill table
    s.listSendMsg([\b_gen, 80+i, \sine1, 7] ++ a);
});
)


{ VOsc.ar(MouseX.kr(80,87), 120, 0, 0.3) }.scope(1, zoom:4);





().play