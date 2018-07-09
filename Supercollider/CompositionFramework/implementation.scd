

~framework_defineSynths = {
	"~framework_defineSynths".postln;
	SynthDef(\test, {
		|freq = 440, amp = 1, out = 0|
		var sig, env;
		env = EnvGen.kr(Env.perc, doneAction:2);
		sig = LFSaw.ar(freq, mul:amp);
		Out.ar(out, env * sig);
	}).add;

};
~framework_createPermanentSynths = {
	"~framework_createPermanentSynths".postln;
};
~framework_attachControllers = {
	"~framework_attachControllers".postln;
	{
		inf.do{
			~events[\low].value;
			1.wait;
			~events[\cord].value;
			0.25.wait;
			~events[\cord].value;
			2.wait;
		}
	}.fork;

};

~framework_addEvents = {
	"~framework_addEvents".postln;
	//~events.add(\eventName -> {});
	~events.add(\low -> {Synth(\test, [\freq, 200])});
	~events.add(\cord -> {
		[50, 53, 56].midicps.do({
			|freq|
			Synth(\test, [\freq, freq, \amp, 0.2])
		});
	});
};

~framework_createBusses = {
	"~framework_createBusses".postln;
	//~bus.add(\reverb -> Bus.audio(s,2));
};