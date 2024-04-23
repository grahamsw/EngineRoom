// Code Example 11.1

(
s.waitForBoot({
	SynthDef(\pulse_noise, { |gate = 0|
		var sig, env;
		env = Env.asr(5, 1, 5, [2, -2]).kr(1, gate);
		sig = BPF.ar(PinkNoise.ar(1 ! 2), 1600, 0.01, 3);
		sig = sig * env * LFPulse.kr(8, width: 0.2);
		Out.ar(0, sig);
	}).add;
	SynthDef(\beating_tone, { |gate = 0|
		var sig, env;
		env = Env.asr(5, 1, 5, [2, -2]).kr(1, gate);
		sig = SinOsc.ar([250, 251], mul: 0.1) * env;
		Out.ar(0, sig);
	}).add;
	SynthDef(\crackle, { |gate = 0|
		var sig, env;
		env = Env.asr(5, 1, 5, [2, -2]).kr(1, gate);
		sig = Dust.ar(8 ! 2, 0.2) * env;
		Out.ar(0, sig);
	}).add;

	s.sync;

	~a = Synth.newPaused(\pulse_noise);
	~b = Synth.newPaused(\beating_tone);
	~c = Synth.newPaused(\crackle);
});
)

~a.set(\gate, 1).run(true); // pulsed filtered noise
~a.set(\gate, 0);

~b.set(\gate, 1).run(true); // beating tones
~b.set(\gate, 0);

~c.set(\gate, 1).run(true); // subtle crackles
~c.set(\gate, 0);



// Code Example 11.2

(
~a = (synth: Synth.newPaused(\pulse_noise), running: false);
~b = (synth: Synth.newPaused(\beating_tone), running: false);
~c = (synth: Synth.newPaused(\crackle), running: false);

~toggle = { |module|
	if(
		module[\running],
		{ module[\synth].set(\gate, 0) },
		{ module[\synth].set(\gate, 1).run(true) }
	);
	module[\running] = module[\running].not;
};
)

~toggle.(~a);
~toggle.(~b);
~toggle.(~c);



// Code Example 11.3

(
SynthDef(\beating_tone, { |freq = 250, freqlag = 0, gate = 0|
	var sig, env;
	env = Env.asr(5, 1, 5, [2, -2]).kr(1, gate);
	sig = SinOsc.ar(freq.lag(freqlag) + [0, 1], mul: 0.1) * env;
	Out.ar(0, sig);
}).add;
)

~b = (synth: Synth.newPaused(\beating_tone), running: false);

~toggle.(~b); // fade in

~b[\synth].set(\freq, 350, \freqlag, 1); // update frequency

~toggle.(~b); // fade out

// wait until silent...

~b[\synth].set(\freq, 450, \freqlag, 5); // update while paused

~toggle.(~b); // fade in, new values take effect when unpaused



// Code Example 11.4

(
s.waitForBoot({
	SynthDef(\pulse_noise, { |gate = 0|
		var sig, env;
		env = Env.asr(5, 1, 5, [2, -2]).kr(1, gate);
		sig = BPF.ar(PinkNoise.ar(1 ! 2), 1600, 0.005, 4);
		sig = sig * env * LFPulse.kr(8, width: 0.2);
		Out.ar(0, sig);
	}).add;
	SynthDef(\beating_tone, { |gate = 0|
		var sig, env;
		env = Env.asr(5, 1, 5, [2, -2]).kr(1, gate);
		sig = SinOsc.ar([250, 251], mul: 0.08) * env;
		Out.ar(0, sig);
	}).add;
	SynthDef(\crackle, { |gate = 0|
		var sig, env;
		env = Env.asr(5, 1, 5, [2, -2]).kr(1, gate);
		sig = Dust.ar(8 ! 2, 0.2) * env;
		Out.ar(0, sig);
	}).add;
	SynthDef(\buzzy, { |gate = 0|
		var sig, env, fb;
		env = Env.asr(5, 1, 5, [2, -2]).kr(1, gate);
		fb = LFNoise1.kr(3 ! 2).range(1.9, 2.1);
		sig = SinOscFB.ar([60, 60.2], feedback: fb, mul: 0.008) * env;
		Out.ar(0, sig);
	}).add;
	SynthDef(\windy, { |gate = 0|
		var sig, env, cf;
		env = Env.asr(5, 1, 5, [2, -2]).kr(1, gate);
		cf = LFNoise1.kr(0.2 ! 2).range(400, 800);
		sig = WhiteNoise.ar(0.2 ! 2);
		sig = BPF.ar(sig, cf, 0.05) * env;
		Out.ar(0, sig);
	}).add;

	s.sync;

	~modules = (
		a: Synth.newPaused(\pulse_noise),
		b: Synth.newPaused(\beating_tone),
		c: Synth.newPaused(\crackle),
		d: Synth.newPaused(\buzzy),
		e: Synth.newPaused(\windy)
	);
	~states = [
		[\a, \c, \e],
		[\b, \c, \d],
		[\a, \b],
		[] // state 3 (everything off)
	];
	~currState = [];
	~playState = { |selection|
		~prevState = ~currState;
		~currState = ~states[selection];
		~modules.keys.do({ |module|
			if(
				~currState.includes(module) &&
				~prevState.includes(module).not,
				{ ~modules[module].set(\gate, 1).run(true) }
			);
			if(
				~currState.includes(module).not &&
				~prevState.includes(module),
				{ ~modules[module].set(\gate, 0) }
			);
		});
		// return the state so it appears in the post window
		~states[selection];
	};
});
)

~playState.(0);
~playState.(1);
~playState.(2);

(
Routine({ // clean up when finished:
	~playState.(3);
	5.wait;
	~modules.do({ |n| n.free });
}).play;
)



// Code Example 11.5

(
s.waitForBoot({
	SynthDef(\beating_tone, {
		arg freq = 250, amp = 0.1, atk = 0.02,
		rel = 0.2, gate = 1, done = 2;
		var sig, env;
		env = Env.asr(atk, 1, rel, [2, -2]).kr(done, gate);
		sig = SinOsc.ar(freq + { Rand(-2.0, 2.0) }.dup(2)) * env * amp;
		Out.ar(0, sig);
	}).add;

	s.sync;

	~modules = (
		a: Pbind(
			\instrument, \beating_tone,
			\dur, 0.2,
			\degree, Prand([-9, -5, -1], inf),
			\atk, 1,
			\sustain, 1,
			\rel, 1,
			\done, 2,
			\amp, 0.04 * Pdefn(\a, 1),
		).play.pause,
		b: Pbind(
			\instrument, \beating_tone,
			\dur, Pexprand(0.001, 1),
			\freq, Phprand(3000, 8000),
			\atk, 0.001,
			\sustain, Pexprand(0.002, 0.015),
			\rel, 0.001,
			\amp, 0.015 * Pdefn(\b, 1),
		).play.pause,
		c: Pbind(
			\instrument, \beating_tone,
			\dur, 0.5,
			\degree, 10,
			\atk, 0.04,
			\sustain, 0.05,
			\rel, 0.3,
			\amp, Pseq(Array.geom(7, 0.1, 0.5), inf) * Pdefn(\c, 1),
		).play.pause
	);

	~states = [
		[\a, \b],
		[\a, \c],
		[\b, \c],
		[]
	];
	~currentState = [];
	~playState = { |selection, fadedur = 5|
		~prevState = ~currState;
		~currState = ~states[selection];
		~modules.keys.do({ |module|
			if(
				~currState.includes(module) &&
				~prevState.includes(module).not,
				{	// fade in
					Pdefn(
						module,
						Pseq([
							Env([0, 1], [fadedur]).asPseg,
							Pseq([1],inf)
						], 1)
					);
					~modules[module].reset.play;
				}
			);
			if(
				~currState.includes(module).not &&
				~prevState.includes(module),
				// fade out
				{ Pdefn(module, Env([1, 0], [fadedur]).asPseg) }
			);
		});
		// return the state so it appears in the post window
		~states[selection];
	}
});
)

~playState.(0, 10); // change to state 0 over 10 seconds
~playState.(1, 2);
~playState.(2, 5);
~playState.(3, 5); // when finished



// Code Example 11.6

(
s.waitForBoot({
	SynthDef(\crackle_burst, { |length = 3|
		var sig, env;
		env = Env.perc(0.01, length, curve: [0, -4]).kr(2);
		sig = Dust.ar(XLine.kr(30, 1, length) ! 2, 0.6) * env;
		sig = LPF.ar(sig, ExpRand(2000, 6000));
		Out.ar(0, sig);
	}).add;
	SynthDef(\buzzy_burst, {
		arg atk = 0.01, rel = 0.5, freq = 80, fb = 2, amp = 1;
		var sig, env;
		env = Env.perc(atk, rel, curve:[2, -2]).kr(2);
		fb = fb + LFNoise1.kr(3 ! 2, 0.2);
		sig = SinOscFB.ar(freq + [0, 1], feedback: fb, mul: 0.015);
		sig = sig * env * amp;
		Out.ar(0, sig);
	}).add;

	s.sync;

	~oneShots = (
		a: { Synth(\crackle_burst, [length: rrand(3, 6)]) },
		b: {
			[55, 58, 60, 65, 69].do({ |n|
				Synth(\buzzy_burst, [
					atk: 3,
					rel: 3,
					freq: n.midicps,
					fb: rrand(1.6, 2.2),
					amp: 1/3
				]);
			});
		},
		c: {
			Pfin({ rrand(9, 30) }, Pbind(
				\instrument, \buzzy_burst,
				\dur, Pexprand(0.01, 0.1),
				\amp, Pgeom(1, { rrand(-1.5, -0.7).dbamp }),
				\midinote, Pbrown(35, 110.0, 7),
				\fb, Pwhite(1.5, 2.6)
			)).play;
		}
	);
});
)

~oneShots[\a].();
~oneShots[\b].();
~oneShots[\c].();



// Code Example 11.7

~oneShots[\a] = { arg len = 5; Synth(\crackle_burst, [\length, len]) };

~oneShots[\a].(1.5); // short
~oneShots[\a].(8); // long



// Code Example 11.8

(
ServerTree.removeAll;
s.newBusAllocators;
~bus = Bus.audio(s, 2);
s.waitForBoot({
	SynthDef(\pulse_noise, {
		arg out = 0, auxout = 0, auxamp = 0, lag = 1, gate = 0;
		var sig, env;
		env = Env.asr(5, 1, 5, [2, -2]).kr(1, gate);
		sig = BPF.ar(PinkNoise.ar(1 ! 2), 1600, 0.005, 4);
		sig = sig * env * LFPulse.kr(8, width: 0.2);
		Out.ar(out, sig);
		Out.ar(auxout, sig * auxamp.varlag(lag));
	}).add;
	SynthDef(\crackle, {
		arg out = 0, auxout = 0, auxamp = 0, lag = 1, gate = 0;
		var sig, env;
		env = Env.asr(5, 1, 5, [2, -2]).kr(1, gate);
		sig = Decay2.ar(Dust.ar(8 ! 2), 0.0005, 0.005, SinOsc.ar(900));
		sig = Splay.ar(sig, 0.6) * env * 0.2;
		Out.ar(0, sig);
		Out.ar(auxout, sig * auxamp.varlag(lag));
	}).add;
	SynthDef(\reverb, { |in = 0, out = 0|
		var sig, fx;
		sig = In.ar(in, 2);
		sig = FreeVerb2.ar(sig[0], sig[1], 1, 0.85);
		Out.ar(out, sig);
	}).add;

	s.sync;

	~makeNodes = {
		~srcGroup = Group();
		~reverb = Synth.after(~srcGroup, \reverb, [in: ~bus]);
		~modules = (
			a: Synth.newPaused(\pulse_noise, [auxout: ~bus], 					~srcGroup),
			b: Synth.newPaused(\crackle, [auxout: ~bus], ~srcGroup),
		);
		~currState = [];
	};
	ServerTree.add(~makeNodes);
	ServerTree.run;
	~states = [
		[\a, \b],
		[]
	];
	~playState = { |selection|
		~prevState = ~currState;
		~currState = ~states[selection];
		~modules.keys.do({ |module|
			if(
				~currState.includes(module) &&
				~prevState.includes(module).not,
				{ ~modules[module].set(\gate, 1).run(true) }
			);
			if(
				~currState.includes(module).not &&
				~prevState.includes(module),
				{ ~modules[module].set(\gate, 0) }
			);
			~states[selection];
		});
	}
});
)



// Code Example 11.9

~playState.(0); // play state zero

~srcGroup.set(\auxamp, -22.dbamp, \lag, 2); // subtle reverb, 2 second fade

~srcGroup.set(\auxamp, -3.dbamp, \lag, 5); // heavy reverb, 5 second fade

// fade out module 'b' reverb send over 5 seconds:
~modules[\b].set(\auxamp, 0, \lag, 5);

(
// fade out module 'a' reverb send, fade in module 'b' reverb send
~modules[\a].set(\auxamp, 0, \lag, 5);
~modules[\b].set(\auxamp, -3.dbamp, \lag, 5);
)

~srcGroup.set(\auxamp, 0, \lag, 8); // fade all reverb, 8 second fade

(
Routine({ // clean up when finished
	~playState.(1); // everything off
	5.wait; ~modules.do({ |n| n.free });
	3.wait; ~reverb.free;
}).play;
)



// Code Example 11.10

~states = [
	[\tone, \grains, \noise], 	// state 0
	[\crunchy, \grains, \pad], 	// state 1
	[\tone, \pad], 				// state 2
	[ ] 						// state 3
];



// Code Example 11.11

(
// This code can be paired with the setup & cleanup code in Figure 11.5
~stateStream = Pseq([0, 1, 2], inf).asStream;
~durStream = Pwhite(20, 80, inf).asStream;
~statePerformer = Routine({
	loop{
		~playState.(~stateStream.next);
		~durStream.next.wait;
	}
});
)

~statePerformer.play;



// Code Example 11.12

~targets = [
	(states: [0, 1, 2, 3], weights: [0, 0.3, 0.7, 0]),
	(states: [0, 1, 2, 3], weights: [0.9, 0, 0.1, 0]),
	(states: [0, 1, 2, 3], weights: [0.5, 0.5, 0, 0]),
	(states: [0, 1, 2, 3], weights: [1/3, 1/3, 1/3, 0])
];



// Code Example 11.13

(
~statePerformer = Routine({
	var next = [0, 1, 2].choose;
	loop{
		~playState.(next);
		next = ~targets[next][\states].wchoose(~targets[next][\weights]);
		wait(60);
	};
});
)

~statePerformer.play;

(
var off = ~states.collect({ |state| state == [ ] }).indexOf(true);
~statePerformer.stop;
~playState.(off);
)



// Code Example 11.14

(
~oneShotPerformer = Routine({
	loop{
		exprand(5, 60).wait;
		~oneShots.choose.();
	}
});
)

~oneShotPerformer.play;



// Code Example 11.15

(
~oneShotTargets = [
	[\foo, \bar], // valid options while in state 0
	[\foo], // ... state 1
	[\bar], // ... state 2
	[ ] // no one-shots are allowed in the empty state
];

~oneShotPerformer = Routine({
	var currIndex, selectedOneShot;
	loop{
		exprand(5, 45).wait;
		currIndex = ~states.collect({ |n|
			n == ~currState;
		}).indexOf(true);
		selectedOneShot = ~oneShotTargets[currIndex].choose;
		~oneShots[selectedOneShot].();
	}
});
)

~oneShotPerformer.play;