"~spriteRoutines".postln;

// depends on global dictionary ~synths

~spriteSetProp =  {
		| msg |
		var val, prop, name;
		name = msg[2];
		prop = msg[3];
		val  = msg[4];
		//[name, prop, val].postln;
		//~synths[name].postln;
		~synths[name].set(prop, val.asFloat);
	};
~spriteAddSprite =  {
		|msg|
		var name, freq, amp, rate, attack, pos;
		name = msg[2];
		freq = msg[3];
		amp  = msg[4];
		rate = msg[5];
		attack = msg[6];
		pos = msg[7];
		[name, freq, amp, rate, attack, pos].postln;
		~synths[name] = Synth(\sprite, [\freq, freq,
			                            \amp, amp,
			                            \rate, rate,
			                            \attack, attack,
			                            \pos, pos
		                               ]);
	};

~spriteClearAll =  {
		~synths.keysValuesDo {
			|key, value|
			value.free;
			~synths.removeAt(key);
	};

	};