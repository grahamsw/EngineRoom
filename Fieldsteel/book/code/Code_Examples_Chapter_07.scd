// Code Example 7.1

s.boot;

MIDIIn.connectAll;

(
MIDIdef.noteOn(\simpleNotes, {
	|val, num, chan, src| // chan & src declared but not used
	{
		var sig, freq, amp;
		freq = num.midicps;
		amp = val.linexp(1, 127, 0.01, 0.25);
		sig = SinOsc.ar(freq * [0, 0.1].midiratio) * amp;
		sig = sig * Env.perc.kr(2);
	}.play;
});
)



// Code Example 7.2

(
~filtCutoff = 200;

MIDIdef.cc(\filtControl,
	{
		|val, num, chan, src|
		~filtCutoff = val.linexp(1, 127, 200, 10000);
	}, ccNum: 1 // only respond to CC#1 messages
);

MIDIdef.noteOn(\simpleNotes,
	{
		|val, num, chan, src|
		{
			arg cf = 200;
			var sig, freq, amp;
			freq = num.midicps;
			amp = val.linexp(1, 127, 0.01, 0.25);
			sig = Saw.ar(freq * [0, 0.1].midiratio) * amp;
			sig = RLPF.ar(sig, cf, 0.1);
			sig = sig * Env.perc.kr(2);
		}.play(args: [\cf, ~filtCutoff]);
	}
);
)



// Code Example 7.3

(
b = Buffer.read(s, Platform.resourceDir ++ "/sounds/a11wlk01.wav");

MIDIdef.freeAll;

MIDIdef.noteOn(\sampler, {
	|val, num, chan, src|
	{
		var sig, rate, amp;
		rate = (num - 60).midiratio;
		amp = val.linexp(1, 127, 0.1, 0.7);
		sig = PlayBuf.ar(
			1, b, BufRateScale.ir(b) * rate, startPos: 85000
		);
		sig = sig * Env.perc.kr(2) * amp ! 2;
	}.play;
});
)



// Code Example 7.4

(
MIDIdef.freeAll;

MIDIdef.noteOn(\weird, {
	|val, num, chan, src|
	case
	{ num == 60 } { exprand(1, 100).postln }
	{ num == 61 } {
		{ PinkNoise.ar(0.1 ! 2) * Line.kr(1, 1, 0.1, doneAction:2) }.play
	}
	{ num == 62 } { s.quit };
}, noteNum: [60, 61, 62]
);
)



// Code Example 7.5

// This example is non-functional code and instead is merely an example of what may be returned and printed in the post window after evaluating 'MIDIClient.destinations'.

-> [
	MIDIEndPoint("IAC Driver", "IAC Bus 1"),
	MIDIEndPoint("IAC Driver", "IAC Bus 2"),
	MIDIEndPoint("UltraLite mk3 Hybrid", "MIDI Port 1")
	MIDIEndPoint("UltraLite mk3 Hybrid", "MIDI Port 2")
	MIDIEndPoint("OSCulator In (8000)", "OSCulator In (8000)"),
	MIDIEndPoint("Oxygen 49", "Oxygen 49"),
]



// Code Example 7.6

(
// assumes 'm' is an appropriate instance of MIDIOut
r = Routine({
	inf.do({
		var note = rrand(40, 90);
		m.noteOn(0, note, exprand(20, 60).asInteger);
		(1/20).wait;
		m.noteOff(0, note);
		(3/20).wait;
	});
}).play;
)

r.stop;



// Code Example 7.7

(
~allNotesOff = {
	"all notes off".postln;
	(0..127).do({ |n| m.noteOff(0, n) });
};
CmdPeriod.add(~allNotesOff);
)

CmdPeriod.remove(~allNotesOff); // un-register this action



// Code Example 7.8

(
(
type: \midi,
midiout: m,
midicmd: \noteOn,
chan: 0,
midinote: 60,
amp: 0.5,
sustain: 2 // note-off sent 2 beats later
).play;
)



// Code Example 7.9

(
t = TempoClock.new(108/60);

p = Pbind(
	\type, \midi,
	\dur, 1/4,
	\midiout, m,
	\midicmd, \noteOn,
	\chan, 0,
	\midinote, Pseq([60, 72, 75],inf),
	\amp, 0.5,
	\sustain, 1/8,
);

~seq = p.play(t);
)

~seq.stop;



// Code Example 7.10

// This example is non-functional code and instead is merely an example of how a specific OSC message is represented using SC code.

[ '/sine/freqs', 220, 220.3, 221.05 ]



// Code Example 7.11

(
~myself = NetAddr("127.0.0.1", NetAddr.langPort);

OSCdef(\receiver,
	{
		|msg, time, addr, port|
		("random value is " ++ msg[2]).postln;
	},
	'/test'
);
)

~myself.sendMsg('/test', 5, exprand(100,200), -9); // send a message



// Code Example 7.12

x = Synth(\default, [freq: 300], s, \addToHead);

x.set(\gate, 0);



// Code Example 7.13

s.sendMsg('/s_new', "default", ~id = s.nextNodeID, 0, 1, "freq", 300);

s.sendMsg('/n_set', ~id, "gate", 0);



// Code Example 7.14

(
{
	var sig, freq, trig;
	trig = Impulse.kr(20);
	freq = LFDNoise3.kr(0.2).exprange(200, 1600);
	SendReply.kr(trig, '/freq', freq);
	sig = PinkNoise.ar(1 ! 2);
	sig = BPF.ar(sig, freq, 0.02, 4);
}.play;
)

(
OSCdef(\getfreq, {
	arg msg;
	~freq = msg[3].postln;
}, '/freq');
)

(
{	// evaluate repeatedly
	var sig = SinOsc.ar(~freq * [0, 0.2].midiratio);
	sig = sig * Env.perc.kr(2) * 0.2;
}.play;
)

(
s.freeAll; // cleanup
OSCdef.freeAll;
)



// Code Example 7.15

(
OSCdef(\fromTouchOSC, { |msg|
	"data received: ".post;
	msg[1].postln;
}, '/1/rotary1');
)

~touchOSC = NetAddr("10.195.91.103", 9000);

~touchOSC.sendMsg('/1/rotary1', rrand(0.0, 1.0));



// Code Example 7.16

(
// On the receiving computer:
OSCdef (\receiver, { |msg|
	var freq;
	if(msg[1].isNumber, {
		freq = msg[1].clip(20,20000);
		{
			var sig = SinOsc.ar(freq) * 0.2 ! 2;
			sig = sig * XLine.kr(1, 0.0001, 0.25, doneAction:2);
		}.play(fadeTime:0);
	});
}, '/makeTone');
)

// On the sending computer:
~sc = NetAddr("192.168.1.15", 57120); // local IP/port of receiver

~sc.sendMsg('/makeTone', 500);



// Code Example 7.17

(
// assumes ~port is a valid instance of SerialPort
var ascii = 0, chars = [];
r = Routine({
	loop{
		ascii = ~port.read.asAscii;
		if(ascii.isDecDigit) { chars = chars.add(ascii) };
		if(ascii == $a) {
			~val = chars.collect({ |n| n.digit }).convertDigits;
			chars = [];
		};
	};
}).play;
)



// Code Example 7.18

(
HIDdef.element(\getElem0, { |val, raw|
	[val, raw].postln;
}, elID: 0 // only respond to element 0
);
)