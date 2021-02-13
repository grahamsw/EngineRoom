/*
OPTIONAL Problem Set Week 13
Due 3pm CDT Thursday December 3rd

First, save this scd file as a new file, renaming it with your Last name at the beginning of the file name (e.g. "Fieldsteel Problem Set Week 13.scd").

Create a simple sampler program in SuperCollider, similar to the one created during the live stream. You don't need a giant library of samples, just one sample will do, but it should be relatively long (at least 10 seconds), such as a sustained piano note or something similar. Your sampler should allow you to play at least one octave of MIDI note numbers, so that the sample is played back, transposed up or down according to the incoming note numbers. Make sure to include this file with your SC project folder, and use the 'thisProcess.nowExecutingPath' method.

The main challenge of this assignment: create a functioning sustain pedal. If you don't have an actual sustain pedal, any CC message will suffice. When that CC message value is greater than 0, the sustain pedal should be "active." When the value of that controller is equal to 0, the sustain pedal should disengage.

While active, the sustain pedal should cause all note off messages to be ignored or bypassed. If a note is pressed, but a sound is already sustaining at that note, a new note should be created, replacing the old note. When the sustain pedal is disengaged, all sustaining notes, except for those with actively depressed controller keys, should have their gate arguments set to zero, and the program should stop ignoring further note-off messages.
*/

(
/* each item in the ~notes Array is an array of two things:
the Synth (nil if it doesn't exist), and an integer indicating
whether the key is currently being held down. this is important
for defining the sustain pedal's behavior. */
~notes = Array.fill(128, [nil, 0]);
~sustain = 0;
MIDIClient.init;
MIDIIn.connectAll;
s.waitForBoot({

	//load buffers
	Buffer.freeAll;
	b = PathName("/Users/eli/Sounds/scaudio/piano/longloud1/").entries.collect({
		arg filepath;
		Buffer.read(s, filepath.fullPath);
	});

	//basic sample player SynthDef
	SynthDef.new(\playbuf, {
		arg buf=0, gate=1, amp=1, rel=0.1, pan=0, out=0;
		var sig, env;
		env = EnvGen.kr(Env.asr(0.01, 1, rel), gate, doneAction:2);
		sig = PlayBuf.ar(1, buf, BufRateScale.ir(buf), doneAction:2);
		sig = sig * env;
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;

	MIDIdef.noteOn(\on, {
		arg val, num, chan, src;

		//when a new note-on message comes in, a Synth at that note index may already be sounding because of the sustain pedal. first, check to see if there's already a note playing at the incoming note index:

		if(~notes[num][0].notNil, {

			//if so, fade out the current Synth and replace it with a new one
			//it's possible to use the addAction:\addReplace, but it
			//results in freeing the old Synth, and you might hear a click.
			~notes[num][0].set(\rel, 0.02, \gate, 0);
			~notes.put(num, [
				Synth.new(\playbuf, [
					\buf, b.at(num-21),
					\gate, 1,
					\amp, val.linexp(0,127,0.05,0.5),
					\pan, 0,
					\out, 0,
				]).register, //registering is useful to be able to check if a Synth is currently playing
				1 //note-on means the key is held down, so the second item should be 1
			]);
		},
		{
			//if there's no Synth currently playing in this slot, just create one.
			~notes.put(num, [
				Synth.new(\playbuf, [
					\buf, b.at(num-21),
					\gate, 1,
					\amp, val.linexp(0,127,0.05,0.5),
					\pan, 0,
					\out, 0,
				]).register,
				1
			]);
		});
	}, (21..108));

	MIDIdef.noteOff(\off, {
		arg val, num, chan, src;

		//if the sustain pedal is currently disengaged,
		if(~sustain == 0, {

			//and if there's currently a Synth at this index,
			//fade it out and replace it with nil, marking the
			//second item in the array as 0 to represent that the
			//key has been lifted.
			if(~notes[num][0].isPlaying, {
				~notes[num][0].set(\gate, 0);
				~notes.put(num, [nil, 0]);
			});
		},
		{
			//if the sustain pedal is active, leave the Synth alone
			//but change the data to reflect that the key has still
			//been lifted.
			~notes.at(num).put(1, 0);
		});
	}, (21..108));

	MIDIdef.cc(\sus, {
		arg val, num, chan, src;

		//update the global sustain value
		~sustain = val;

		//no other action is needed when the sustain pedal is engaged.
		//but if the sustain pedal becomes disengaged, do the following:
		if(~sustain == 0, {

			//iterate over all Synths.
			~notes.do({
				arg item;

				//if there's a Synth playing, but its corresponding
				//key has been lifted (i.e. it's sustaining via pedal),
				//fade it out and replace it with nil.
				if((item[1] == 0) && (item[0].isPlaying), {
					item[0].set(\gate, 0);
					item.put(0, nil);
				});
			});
		});
	}, 64); //only listen to CC from controller 64.
});
)