(
MIDIClient.init;
MIDIClient.sources;
MIDIIn.connectAll;

c = {|freq|
freq.cpsmidi.linlin(1, 200, 3, 0.0001)
}

c.(600)
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
c = ~makeSynth.(400, 0.2)
c.set(\gate,0)
(
var poly;
poly = Array.fill(128, 0); // array with all possible notes

MIDIIn.noteOn = {arg src, chan, num, vel;

    poly[num] = ~makeSynth.(freq:num.midicps, amp:vel/127/2);
};

MIDIIn.noteOff = { arg src,chan,num,vel;
	poly[num].set(\gate, 0);
};
/*
MIDIIn.bend = { arg src,chan,val;
	poly.do({arg synth; if( synth!=0 , { synth.set(\filter, val*0.148828125 ) }); });
};

MIDIIn.control = {arg src, chan, num, vel;
	poly.do({arg synth; if( synth!=0 , { synth.set(\vibrato, vel ) }); });
};

*/
)

