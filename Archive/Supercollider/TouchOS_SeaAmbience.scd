

e = Synth(\engine);

(

~register = {
	| address, synth, variable, from = 0.0, to = 1.0|
	OSCFunc( {
		|msg|
		var val = msg[1];
		msg.postln;
		synth.set(variable, val.linlin(0, 1.0, from, to));
	}, address);
};
)

~register.('/1/faderA', 'engineSpeed')
~register.('/1/faderB', 'wguideLength1')
~register.('/1/faderC', 'mixCylinders')

(
e = Synth(\ocean, [\freqFrom, 200, \freqTo, 250, \freqFreq, 0.1]);

//freqFrom = 100, freqTo = 150, freqFreq = 0.3,	  bwrFrom = 0.3, bwrTo = 0.7, bwrFreq = 0.2,
~register.('/1/faderA', e, 'freqFrom', from: 20, to:1000);
~register.('/1/faderB', e, 'freqTo', from: 20, to:1000);
~register.('/1/faderC', e, 'freqFreq', from: 0.01, to:1);
~register.('/1/faderD', e, 'bwrFrom', from: 0.01, to:10);
~register.('/1/rotaryA', e, 'bwrTo', from: 0.01, to:10);
~register.('/1/rotaryB', e, 'bwrFreq', from: 0.01, to:10);
~register.('/faderM', e, 'amp');
);

OSCFunc.trace(false, true)
~register.('/1/rotaryA', e, 'bwrTo', from: 0.01, to:10);
~register.('/1/rotaryA', e, 'bwrTo', from: 0.01, to:10);

e.set('amp', 1)

