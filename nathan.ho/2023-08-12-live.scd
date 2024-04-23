(
var lfo;
var getParams;

lfo = { |rate|
	var trigger;
	trigger = Dust.ar(rate);
	Select.ar(ToggleFF.ar(trigger), [
		LFNoise2.ar(rate * TExpRand.ar(1, 10, trigger)),
		TRand.ar(-1, 1, trigger)
	]);
};

getParams = {
	{ |i| NamedControl.kr(("param%".format(i + 1)).asSymbol, 0, 0.1) } ! 4;
};

SynthDef(\gabber, {
	var snd, velocity, numBands;
	var freq, params;
	params = getParams.();
	velocity = \velocity.kr(0);
	freq = (
		params[0].pow(1.5).linexp(0, 1, 10, 8000)
		* Env([24, 3, 0] * velocity, [0.05, 0.5] / (velocity + 0.1), -4).ar.midiratio
	);
	snd = SinOsc.ar(freq);
	snd = snd * (1 + Env.perc(0, 5).ar);
	snd = snd * (1 + (velocity * 3));
	snd = (snd * 5).fold2;
	numBands = 64;
	snd = BPF.ar([snd], (0..numBands - 1).linexp(0, numBands - 1, 100, 8000), 0.1).sum;
	snd = (snd * 3).tanh;
	snd = MoogFF.ar(snd, params[1].linexp(0, 1, 100, 8000, 0));
	snd = (snd * 3).fold2;
	snd = snd + HPF.ar(SinOsc.ar(freq), 60);
	snd = snd.tanh;
	snd = snd * Env.asr(velocity.linexp(0, 1, 1, 0.003), 1, 0.03).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * \amp.kr(-5).dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\subtractive, {
	var snd, velocity, numBands, freqs;
	var params, rate;
	numBands = 32;
	freqs = (0..numBands - 1).linexp(0, numBands - 1, 10, 8000);
	params = getParams.();
	rate = params[2].linexp(0, 1, 0.3, 16);
	velocity = \velocity.kr(0);
	snd = {
		var snd;
		snd = Pulse.ar((params[0].linexp(0, 1, 10, 8000) * (lfo.(rate) * 24).midiratio).min(16e3));
		2.do {
			snd = RLPF.ar(snd, (lfo.(rate).linexp(-1, 1, 100, 4000) * (1 + (8 * params[1])) * (1 + (16 * Env.perc(0, 0.1).ar))).min(16e3), 0.3);
			snd = (snd * 3).fold2;
			snd = Latch.ar(snd, Impulse.ar((lfo.(rate).linexp(-1, 1, 1000, 8000) * (1 + (8 * params[1]))).min(SampleRate.ir / 4)));
		};
		snd = (snd * 3).tanh;
		snd = Sanitize.ar(snd);
	} ! 2;
	snd = BPF.ar(snd[0], freqs, 0.1) * Amplitude.ar(BPF.ar(snd[1], freqs, 0.1), 0.01, 0.5);
	snd = snd.sum * 10.dbamp;
	snd = snd + Latch.ar(BPF.ar(WhiteNoise.ar, XLine.kr(8000, 100, 0.03)) * Env.perc(0.001, 0.1).ar * 30.dbamp, Impulse.ar(XLine.kr(16e3, 4000, 0.1)));
	snd = snd * Env.asr(velocity.linexp(0, 1, 1, 0.003), 1, 0.001).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * \amp.kr(-5).dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\snare, {
	var snd, random, numPartials, params, trigger;
	params = getParams.();
	numPartials = 16;
	random = { |count| Hasher.kr(Rand(-1, 1) + (0..count - 1)) };
	trigger = Impulse.ar(params[2].linexp(0, 1, 4, 100) * params[2]);
	snd = SinOsc.ar(random.(numPartials).linexp(-1, 1, 100, 8000) * params[0].linlin(-1, 1, -10, 10).midiratio * (1 + Env.perc(0, 0.01).ar(Done.none, trigger)));
	snd = snd * Env.perc({ ExpRand(0.001, 0.01) } ! numPartials, random.(numPartials).linexp(-1, 1, 0.01, 3)).ar(Done.none, trigger);
	snd = snd * random.(numPartials).linlin(-1, 1, 0, -10).dbamp;
	snd = snd.sum;
	snd = snd * Env.asr(0, 1, 0.1).ar(Done.freeSelf, \gate.kr(1));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * \amp.kr(-5).dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\primes, {
	var snd, params, freq, ratios, freqs;
	params = getParams.();
	freq = params[0].linexp(0, 1, 10, 440);
	ratios = [1] ++ (0..20).nthPrime;
	freqs = freq * ratios * (2 ** ((1 + LFNoise2.kr(params[2].linlin(0, 1, 1, 20))) * params[2] * 2.5).round);
	snd = SinOsc.ar(freqs);
	snd = snd * ratios.log2.linlin(0, 3, 0, -20);
	snd = snd * ((freqs.log2 + params[1]) * pi).sin.pow(7);
	snd = snd.sum;
	snd = (snd * 1).tanh;
	snd = snd * Env.asr(0.01, 1, 0.01).ar(Done.freeSelf, \gate.kr(1));
	snd = Pan2.ar(snd, \pan.kr(0));
	snd = snd * -10.dbamp;
	snd = snd * \amp.kr(-5).dbamp;
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\freqShift, {
	var snd, up, down, shift, params;
	params = getParams.();
	shift = params[1] * 100;
	snd = LocalIn.ar(1);
	snd = snd + (PinkNoise.ar * -20.dbamp);
	up = snd;
	up = FreqShift.ar(up, shift);
	up = CombC.ar(up, 0.1, 1 / params[0].linexp(0, 1, 100, 3000), 0.1);
	up = LeakDC.ar(up).tanh;
	down = snd;
	down = FreqShift.ar(down, shift.neg);
	down = BPF.ar(down, LFNoise2.kr(0.2).linexp(0, 1, 100, 4000) * (24 * [-1, 1] * params[2]).midiratio, 0.1);
	down = down.sum;
	down = LeakDC.ar(down).tanh;
	snd = up + down;
	LocalOut.ar(snd);
	snd = snd * Env.asr(0.001, 1, 0.001).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * \amp.kr(1);
	snd = Pan2.ar(snd, 0);
	Out.ar(\out.kr(0), snd);
}).add;

// Two ways to make vocal formants:
// 1. Pulse wave FMing a sine wave, modulate the FM index. (Idea stolen from Sahy Uhns.)
// 2. Take a sound that already has vocal formants, and run it through a sample rate reducer.
// This SynthDef uses both.
SynthDef(\ling, {
	var snd, params, rate;
	params = getParams.();
	rate = params[2].linexp(0, 1, 0.1, 16);
	snd = (LFPulse.ar(params[0].linexp(0, 1, 10, 8000)) - 0.5) * lfo.(rate) * 4000;
	snd = SinOsc.ar(params[1].linexp(0, 1, 1000, 8000) + snd);
	snd = Latch.ar(snd, Impulse.ar(lfo.(rate).linexp(-1, 1, 1000, 16e3)));
	snd = snd * Env.asr(0.001, 1, 0.01).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * -10.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\ambient, {
	var snd, params, rate, freqs, edo;
	params = getParams.();
	edo = 5;
	freqs = (
		params[0].linexp(0, 1, 100, 1000)
		* (edo + 1).collect { |i|
			(2 ** (params[2].linlin(0, 1, 1, edo).round * i / edo)) * (LFNoise2.kr(0.3 ! 5) * 0.1).midiratio
		}
	);
	freqs = freqs.flat;
	freqs = freqs.min(SampleRate.ir / 4);
	snd = Pulse.ar(freqs, { LFNoise2.kr(0.3).linlin(-1, 1, 0, 1) } ! freqs.size);
	snd = MoogFF.ar(
		snd,
		params[1].linexp(0, 1, 100, 8000) *
		({ LFNoise2.kr(0.3).linexp(-1, 1, 0.1, 5) } ! snd.size),
		1
	);
	snd = Splay.ar(snd.scramble);
	snd = snd * Env.adsr(0.1, 0.3, 0.7, 0.01).ar(Done.freeSelf, \gate.kr(1));
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\acid, {
	var snd, params, rate, freq, trigger, filterFreq;
	params = getParams.();
	freq = 60;
	rate = params[2].linexp(0, 1, 1, 16);
	trigger = Dust.ar(rate);
	filterFreq = (
		1000
		* (Env.perc(0.001, 1 / rate).ar(Done.none, CoinGate.ar(0.7, trigger)) * LFNoise2.kr(rate).linlin(-1, 1, 0, 30)).midiratio
		* (LFNoise2.kr(rate) * 12).midiratio
	);
	snd = Saw.ar(
		(
			(params[0].linexp(0, 1, 30, 1000)
				* TExpRand.ar(0.25, 4, trigger))
			+ (LocalIn.ar(1) * 1000 * params[3])
		).min(SampleRate.ir / 4).max(20)
	);
	snd = MoogFF.ar(snd, filterFreq, LFNoise2.kr(rate).linlin(-1, 1, 2, 3.99));
	snd = (snd * 3).tanh + (snd * 3).fold2;
	snd = snd.tanh;
	LocalOut.ar(snd);
	snd = snd * Env.asr(0.01, 1, 0.01).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * -3.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\fx, {
	var snd, params, pitch, numTaps, delays, delayed;
	params = getParams.();
	snd = In.ar(\out.kr(0), 2);
	snd = Sanitize.ar(snd);
	snd = LeakDC.ar(snd);


	pitch = snd;
	pitch = PitchShift.ar(pitch, 0.03, 1 + (params[0] * 3));
	pitch = CombC.ar(pitch, 0.2, 1 / params[0].linexp(0, 1, 100, 20), 0.3);
	pitch = FreqShift.ar(LeakDC.ar(pitch), params[0] * 100);
	snd = snd.blend(pitch * 5.dbamp, (params[0] * 3).clip(0, 1));

	numTaps = 8;
	delayed = snd;
	delays = [];
	numTaps.do { |i|
		delayed = DelayC.ar(delayed, 0.1, 0.1 / (1 + params[1]));
		delays = delays.add(Balance2.ar(delayed[0], delayed[1], (((i % 2) * 2) - 1) * (i / (numTaps / 2))));
	};
	delays = delays * (params[1] * (1..numTaps) * 2pi).cos.squared;
	delays = delays.sum * (params[1] * 3).clip(0, 1);
	snd = snd + delays;

	snd = LeakDC.ar(snd);
	snd = snd * 10.dbamp;
	snd = Sanitize.ar(snd);
	snd = Limiter.ar(snd, dur: 0.001);
	ReplaceOut.ar(\out.kr(0), snd);
}).add;
)

(
MIDIClient.init;
MIDIIn.connectAll;
)

MIDIFunc.trace(true);
MIDIFunc.trace(false);

(
var ccNums, controlBusses;
var synthDefs, midiNotes, synths;

synthDefs = [
	\gabber, \subtractive, \snare, \primes,
	\freqShift, \ling, \ambient, \acid,
];
midiNotes = (36..43);

ccNums = (70..77);
controlBusses = { Bus.control } ! ccNums.size;

controlBusses.do { |controlBus, index|
	controlBus.set(if(index < 4, 0.5, if(index == 7, 0.5, 0)));
};

synths = nil ! synthDefs.size;

Synth.tail(nil, \fx, [
	param1: controlBusses[4].asMap,
	param2: controlBusses[5].asMap,
	param3: controlBusses[6].asMap,
	param4: controlBusses[7].asMap,
]);

ccNums.do { |ccNum, index|
	MIDIFunc.cc({ |value|
		controlBusses[index].set(value / 127);
	}, ccNum);
};

midiNotes.do { |midiNote, index|
	MIDIFunc.noteOn({ |value|
		var velocity;
		velocity = value / 127;
		if(synths[index].isNil) {
			synths[index] = Synth(synthDefs[index], [
				velocity: velocity,
				param1: controlBusses[0].asMap,
				param2: controlBusses[1].asMap,
				param3: controlBusses[2].asMap,
				param4: controlBusses[3].asMap,
			]);
		};
	}, midiNote);

	MIDIFunc.noteOff({ |value, number, channel, source|
		if(synths[index].notNil) {
			synths[index].set(\gate, 0);
			synths[index] = nil;
		};
	}, midiNote);
};
)