(
// Meandering Sines

// chord choosing function
~chords = Dictionary.new;
~chords.add(\fifth -> [1, 1.5, 2]);
~chords.add(\maj6 -> [1, 1.2, 1.6, 2]);
~chords.add(\min6 -> [1, 1.25, 1.666, 2]);
~chords.add(\maj7 -> [1, 1.25, 1.875, 2]);

// write pitches into array
~dronenotes = [
	{~chords[\fifth].choose}!8 * 44.midicps,
	{~chords[\maj6].choose}!8 * 41.midicps,
	{~chords[\fifth].choose}!8 * 44.midicps,
	{~chords[\min6].choose}!8 * 40.midicps
];


	s.sync;

	// instrument definition
	SynthDef.new(\sine, {
		var sig, env;
		env = Env.asr(\atk.ir(0.05), 0.75, \rel.ir(2)).kr(2, \gate.kr(1));
		sig = SinOsc.ar(
			\freq.kr(220, \freqlag.kr(1.2)) + SinOsc.kr({Rand(0.02, 0.06)}, 0, {Rand(0.1, 2.0)}), // frequency: slowly meandering a bit
			{Rand(0.0, 2pi)}, // phase
			SinOsc.kr({Rand(1/60, 3/60)}).range(0.2, 0.5));  // meandering amplitude
		sig = sig * env * \amp.kr(0.2, 0.2);
		sig = Pan2.ar(sig, SinOsc.kr(\panfreq.ir(1/10), {Rand(0.0, pi)}, {Rand(0.1, 0.99)})); // meandering panning
		Out.ar(\out.kr(0), sig);
	}).add;

	s.sync;

	Pbindef(\drones,
		\instrument, \sine,
		\freq, Pseq(~dronenotes,inf),
		\amp, 0.16,
		\dur, Pwhite(18, 30),
		\atk, Pwhite(3.2, 4),
		\legato, 1.1,
		\out, 0
	);
	s.sync;
	"done".postln;


// start performance
Pbindef(\drones).play;

)




