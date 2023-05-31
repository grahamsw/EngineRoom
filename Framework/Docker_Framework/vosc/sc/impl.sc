~voscs = ();
~numBuffsets = 4;

~createVoscObject = {
    | out = 0, freq = 80, amp = 0.5,
    detuneLow = 0.05, detuneHigh = 0.2,
    durLow = 0.15, durHigh = 0.55,
    buffSet = 0,
    panLow = -1,
    panHigh = 1,
    spread = 0.25,
    panSteps = 20
    |
    var ob = (
        \out: out,
        \freq:freq, \amp:amp,
        \detuneLow:detuneLow, \detuneHigh:detuneHigh,
        \durLow:durLow, \durHigh:durHigh,
		\buffs:  ~buffsets[buffSet],
        \panLow: panLow,
        \panHigh: panHigh,
        \panSteps: panSteps,
        \spread: spread

    );
    var buffs = ob[\buffs];

    ob[\pVosc] = Pmono(\VoscChorus,
        \out, 0,
        \dur, Pwhite(
            Pfunc({ob[\durLow]}),
            Pfunc({ob[\durHigh]})
        ),
        \bufindex, Pbrown(
            buffs[0].bufnum,
            buffs[buffs.size - 2].bufnum,
            0.3
        ),
        \detune, Pbrown(
            Pfunc({ob[\detuneLow]}),
            Pfunc({ob[\detuneHigh]})
        ),
        \freq, Pfunc({ob[\freq]}),
        \amp, Pfunc({ob[\amp]}),
        \pan, Pbrown(
            Pfunc({ob[\panLow]}),
			Pfunc({ob[\panHigh]}),
            Pfunc({(ob[\panHigh] -  ob[\panLow])/ob[\panSteps]})
        ),
        \spread, Pfunc({ob[\spread]})
    );

    ob;
};


// util for creating a bus, mapping a parameter to it and
// cleaning up afterward
~controlParam = {
    | synth, field, levels, times, curve, freeSynth=false |
    var bus = Bus.control(s);
	var param = {Out.kr(bus, EnvGen.kr(Env(levels, times, curve),doneAction:2))};
	{
		param.play;
		synth.map(field, bus);
		(times.sum).wait;
		if (freeSynth,
			{
				synth.free;
			},
			{
				synth.set(field, levels[levels.size-1]);
			}
		);
		bus.free;
	}.fork;
};

~makeBufs = {
    | which=0, randSeed = 0 |
    var numbuffs = 8;
    var buffs = Buffer.allocConsecutive(numbuffs, s, 1024, 1);
	if (randSeed > 0, {thisThread.randSeed = randSeed});

    buffs.do({ arg buf, i;
        var n =(numbuffs), a;
        a = switch(which,
            0, {Array.fill(i+1, { arg j; ((n-j)/n).squared.round(0.001) })},
            1, {Array.fill(i, 0) ++ [0.5, 1, 0.5];},
            2, {a = Array.fill(32,0);
                12.do({a.put(32.rand, 1).postln });
                a},
            {Array.fill((i+1)**2, {1.0.rand2 })}
        );
        a.postln;
        buf.sine1(a);
    });
    buffs;
};

~loadBuffs = {
	~buffsets = ~numBuffsets.collect{|i| ~makeBufs.(i)};
};

~allocBusses = {

};

~initServerNodes = {
    ~fxGroup = Group.new;
};

// SynthDefs for the Synths used in the piece
~defineSynths = {
    SynthDef(\test, {
        Out.ar(0, SinOsc.ar(mul:0.2));
    }).add;

    SynthDef(\VoscChorus,{
        |out = 0, bufindex = 0, freq=400, detune=0.15, amp=1, pan=0, spread=1|
        var rats, cfreq, sig;
        rats = {Rand(0.08, 0.15)}!8;
        cfreq = freq  * (LFNoise1.kr(rats).bipolar(detune).midiratio);
        sig = VOsc.ar(bufindex, cfreq, Rand(0, 2pi), amp);
        sig = Splay.ar(sig,spread, center:pan);
        sig = LeakDC.ar(sig);
        Out.ar(out, sig * amp);
    }).add;

    SynthDef(\reverb, {
        | out = 0, mix = 0.1|
        var dry = In.ar(out);
        var wet =FreeVerb.ar(dry,0.45,2.0,0.5);
        wet = DelayN.ar(wet, 0.03, 0.03);
        wet = SplayAz.ar(2, wet);
        wet = LPF.ar(wet, 1500);
        XOut.ar(out, mix, wet);
    }).add;
};

// list of Pbinds
~definePbinds = {

};

//performance events:
// array (or dictionary) of functions that when called start/stop/alter
// Pbinds, or possibly create and manipulate Synths directly via Routines
// might be called manually, or from a Pattern or a Routine, or from
// a GUI, or MIDI, or from external code via OSC

~events = [
    \start: {

        ~rand = {1000000.rand.round(1)};
        ~reverb = Synth(\reverb, [\mix, 0.2]);
        ~runstart.()
    },
    \addVosc: {
        |key,
        freq = 80, amp = 0.5,
        detuneLow = 0.05, detuneHigh = 0.2,
        durLow = 0.15, durHigh = 0.55,
        buffSet = 0,
        panLow = -1,
        panHigh = 1,
        panSteps = 20,
        spread = 1
        |
        ~voscs[key] = ~createVoscObject.(freq:freq,
            amp:amp,
            detuneLow:detuneLow,
            detuneHigh:detuneHigh,
            durLow:durLow,
            durHigh:durHigh,
            buffSet:buffSet,
            panLow:panLow,
            panHigh:panHigh,
            panSteps:panSteps,
            spread:spread
        );
    },
    \playVosc: {
        |key|
        ~voscs[key][\stream] = ~voscs[key][\pVosc].play;
    },
    \stopVosc: {
        |key|
        ~voscs[key][\stream].stop;
    },
    \setFreq: {
        |key, freq|
        ~voscs[key][\freq] = freq;
    },
    \setDetune: {
        |key, detuneLow=0.05, detuneHigh=0.2|
        ~voscs[key][\detuneLow] = detuneLow;
        ~voscs[key][\detuneHigh] = detuneHigh;
    },
    \setDur: {
        |key, durLow=0.15, durHigh=0.55|
        ~voscs[key][\durLow] = durLow;
        ~voscs[key][\durHigh] = durHigh;
    },
    \setAmp: {
        |key, amp|
        ~voscs[key][\amp] = amp;
    },
    \setPan:{
        |key, panLow=(-1), panHigh=1, panSteps=20, spread=0.1|
        ~voscs[key][\panLow] = panLow;
        ~voscs[key][\panHigh] = panHigh;
        ~voscs[key][\panSteps] = panSteps;
        ~voscs[key][\spread] = spread;
    },
    \setReverbMix: {
        |mix|
        ~reverb.set(\mix, mix);
    }
].asDict;

~runstart = {
    ~events[\addVosc].(\bass,
            freq: 100,
            amp: 0.4,
		    buffSet: 3,
            detuneLow:0.1,
            detuneHigh:0.15,
            panLow:-0.1,
            panHigh:0.1,
            spread:1
        );
    ~events[\playVosc].(\bass);

    ~events[\addVosc].(\aa,
            freq: 200,
            amp:0.3,
		    buffSet: 1,
            detuneLow:1,
            detuneHigh:2,
            panLow:-0.5,
            panHigh:0.5,
            panSteps:50,
            spread:0.5
        );
    ~events[\playVosc].(\aa);

    ~events[\addVosc].(\bb,
            freq: 300,
            amp: 0.2,
		    buffSet: 0,
            detuneLow:0.1,
            detuneHigh:0.12,
            panLow:-1,
            panHigh:1,
            panSteps:10,
            spread:0.3
        );
    ~events[\playVosc].(\bb);
};

~playBomb = {
    | out=0,
     buffLevels=0, buffTimes=0, buffCurves=0,
     freqLevels=400, freqTimes=0, freqCurves=0,
     detuneLevels=0, detuneTimes=0, detuneCurves=0,
	 ampLevels=#[0.5, 0.001], ampTimes=#[1], ampCurves=#[-1],
     panLevels=0, panTimes=0, panCurves=0,
     spreadLevels=0, spreadTimes=0, spreadCurves=0
     |
     var strip_params = {
			|levels|
			if(levels.isArray,
			  {levels[0]},
			  {levels});
		};
	var vosc;

	vosc = Synth(\VoscChorus, [
        \out, 0,
			\bufindex, strip_params.(buffLevels),
			\freq, strip_params.(freqLevels),
			\detune, strip_params.(detuneLevels),
			\amp, strip_params.(ampLevels),
			\pan, strip_params.(panLevels),
			\spread, strip_params.(spreadLevels)
    ]);

	if(buffLevels.isArray,
			{~controlParam.(
				vosc,
				\bufindex,
				buffLevels,
				buffTimes,
				buffCurves,
				freeSynth:false)});
	if(freqLevels.isArray,
			{~controlParam.(
				vosc,
				\freq,
				freqLevels,
				freqTimes,
				freqCurves,
				freeSynth:false)});
	if(detuneLevels.isArray,
			{~controlParam.(
				vosc,
				\detune,
				detuneLevels,
				detuneTimes,
				detuneCurves,
				freeSynth:false)});
	if(ampLevels.isArray,
			{~controlParam.(
				vosc,
				\amp,
				ampLevels,
				ampTimes,
				ampCurves,
				freeSynth:true)});
	if(panLevels.isArray,
			{~controlParam.(
				vosc,
				\pan,
				panLevels,
				panTimes,
				panCurves,
				freeSynth:false)});
	if(spreadLevels.isArray,
			{~controlParam.(
				vosc,
				\spread,
				spreadLevels,
				spreadTimes,
				spreadCurves,
				freeSynth:false)});

};



