(
MIDIClient.init;
MIDIClient.sources;
MIDIIn.connectAll;

~amp = 0.5;

(
~makeSynth = {
    |freq, amp|
    Synth(\VoscPlayer, [
        \out,0,
        \bufLow,~buffsets[0][3], \bufHigh,~buffsets[0][7], \bufSteps,1000,
        \detuneLow, 0.15, \detuneHigh,0.25, \detuneSteps,1000,
        \freq,freq,
        \amp,amp,
        \panLow, (-1), \panHigh,1, \panSteps,30, \spread,1,
        \releaseTime,freq.cpsmidi.linlin(1, 200, 3, 0.0001),
        \gate,1])
};
)
//c = ~makeSynth.(400, 0.2)
//c.set(\gate,0)
(
var poly;
poly = Array.fill(128, 0); // array with all possible notes

MIDIIn.noteOn = {arg src, chan, num, vel;
    ["note", src, chan, num, vel].postln;
    poly[num] = ~makeSynth.(freq:num.midicps, amp:vel/127 * ~amp);
};

MIDIIn.noteOff = { arg src,chan,num,vel;
	poly[num].set(\gate, 0);
};

MIDIIn.bend = { arg src,chan,val;
    ["bend", src, chan, val].postln;
	//poly.do({arg synth; if( synth!=0 , { synth.set(\filter, val*0.148828125 ) }); });
};

MIDIIn.control = {arg src, chan, num, vel;
    ["control", src, chan, num, vel].postln;
    switch(num,
    7, {~amp = vel.linlin(0, 127, 0.0, 1.0)}
);
}
)
//	poly.do({arg synth; if( synth!=0 , { synth.set(\vibrato, vel ) }); });
//};

)

//controls
//
// C! => 73
// C2 => 75
// C3 => 72
// C4 => 74
// C5 => 79
// C6 => 84
// C7 => 94
// C8 => 95

// C9 => 7
// C10 :  24
// C11: 25
// C12: 26
// C13: 44
// C14: 45
// C16: 1

// pad 1: 36
// pad 2: 38
// pad 3: 42
// pad 4: 46
// pad 5: 50
// pad 6: 45
// pad 7: 51
// pad 8: 49

// Bend
// Pitch (C15) -> val 0 - 16383 (mid is 8192)

