// advanced engine
(
SynthDef(\engine, {

	| // arguments range: 0.0 - 1.0
	mixCylinders   = 0.8,
	mixParabolic   = 0.9,
	engineSpeed    = 0.5,
	parabolaDelay  = 0.15,
	warpDelay      = 0.4,
	waveguideWarp  = 0.67,
	wguideFeedback = 0.35,
	wguideLength1  = 0.2,
	wguideLength2  = 0.3,
	wguideWidth1   = 0.5,
	wguideWidth2   = 0.7
	|

	// To be able to send arrays as arguments you have to declare them as variables and
	// use NamedControl.kr. Take also a look at the MIDI example at the bottom how to address them.
	var transDelay = NamedControl.kr(\transDelay, [0.2, 0.3, 0.45]);
	var overtonePhase = NamedControl.kr(\overtonePhase, [0.25, 0.35, 0.5]);
	var overtoneFreq = NamedControl.kr(\overtoneFreq, [0.3, 0.47, 0.38]);
	var overtoneAmp = NamedControl.kr(\overtoneAmp, [0.1, 0.2, 0.2]);

	var noise, bufferA, bufferB, bufferTd, fourstroke, phasor, td, parabola, fm1, preFM1,
	fm2, preFM2, overtone, overtoneDrive, e1b, e2a, e2b, e1a, spacewarp, engine;

//	engineSpeed = MouseX.kr(0,1);


	bufferA = LocalBuf(44100, 1);
	bufferB = LocalBuf(44100, 1);
	bufferTd = LocalBuf(44100, 1);


	noise = WhiteNoise.ar;
	noise = OnePole.ar(noise, exp(-2pi * (20 * SampleDur.ir)));
	noise = OnePole.ar(noise, exp(-2pi * (20 * SampleDur.ir)));
	noise = (DelTapWr.ar([bufferA, bufferB], [noise * 0.5, noise * 30]));

	phasor = LFSaw.ar(
		OnePole.ar(K2A.ar(engineSpeed) * 30, exp(-2pi * (0.8 * SampleDur.ir))),
		1, 0.5, 0.5);
	td = DelTapWr.ar(bufferTd, phasor);

	fourstroke = DelTapRd.ar(bufferA, noise[0], [5, 10, 15, 20]/1000, 4);
	fourstroke = phasor + fourstroke - [0.75, 0.5, 0.25, 0];
	fourstroke = (fourstroke * 2pi).cos;
	fourstroke = fourstroke * (DelTapRd.ar(bufferB, noise[1], [5, 10, 15, 20]/1000, 4) + ((1 - engineSpeed) * 15 + 7));
	fourstroke = 1 / ((fourstroke * fourstroke) + 1);
	fourstroke = fourstroke.sum * mixCylinders;
	fourstroke = fourstroke - OnePole.ar(fourstroke, exp(-2pi * (4 * SampleDur.ir)));


	parabola = DelTapRd.ar(bufferTd, td, (parabolaDelay * 100)/1000, 1) - 0.5;
	parabola = parabola * parabola * (-4) + 1 * 3 * mixParabolic;


	preFM1 = DelTapRd.ar(bufferTd, td, (warpDelay * 100)/1000, 1);
	preFM1 = (preFM1 * 2pi).cos;
	preFM2 = K2A.ar(engineSpeed * waveguideWarp);
	preFM2 = OnePole.ar(preFM2, exp(-2pi * (0.2 * SampleDur.ir)));
	fm1 = (1 - preFM1) * preFM2 + 0.5;
	fm2 = (preFM2 * preFM1) + 0.5;


	overtoneDrive  = overtoneDrive!3;
	overtone = overtone!3;

	3.do{|i|

		overtoneDrive[i] = DelTapRd.ar(bufferTd, td, (transDelay[i]*100)/1000) * (0.5**(i+1)*32);
		overtoneDrive[i] = Wrap.ar(overtoneDrive[i]);

		overtone[i] = overtoneDrive[i].max(overtonePhase[i]) - overtonePhase[i];
		overtone[i] = overtone[i] * (1 - overtonePhase[i]).reciprocal;
		overtone[i] = overtone[i] * ((overtoneFreq[i] * 12) * overtonePhase[i]);
		overtone[i] = Wrap.ar(overtone[i]) - 0.5;
		overtone[i] = (overtone[i] * overtone[i]) * (-4) + 1 * 0.5;
		overtone[i] = (overtone[i] * (1 - overtoneDrive[i])) * (overtoneAmp[i] * 12);
	};


	# e1b, e2b, e2a, e1a = DelayC.ar(
		in: InFeedback.ar(bus:(10..13)),
		maxdelaytime: 1,
		delaytime: ((([wguideLength1,wguideWidth1,wguideLength2,wguideWidth2] * 40)
			* [fm1,fm1,fm2,fm1])/1000)
	);

	OffsetOut.ar(11, e1b + overtone[1]);

	e2b = e2b + overtone[2];
	OffsetOut.ar(13, e2b);

	e2a = e2a + overtone[0];
	OffsetOut.ar(10, e2a);

	OffsetOut.ar(12, e1a * wguideFeedback + (parabola - OnePole.ar(parabola, exp(-2pi * (30 * SampleDur.ir)))));

	spacewarp = e1b + e2b + e2a + e1a;

	spacewarp = spacewarp - OnePole.ar(spacewarp, exp(-2pi * (200 * SampleDur.ir)));
	spacewarp = spacewarp - OnePole.ar(spacewarp, exp(-2pi * (200 * SampleDur.ir)));

	engine = (spacewarp + fourstroke)!2 * 0.5;

	Out.ar(0, engine);

}).add;
)

e = Synth(\engine);
~register.value(e, "/engine");
e.set(\engineSpeed, 0.97)
e.set(\wguideLength1, 0.94)
e.set(\mixCylinders, 0.1)
e.free
