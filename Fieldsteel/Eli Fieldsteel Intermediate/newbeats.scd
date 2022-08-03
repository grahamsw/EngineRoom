

// these functions are all defined by the composer, and may be
// redefined, with care, and rerun while the piece is running
// in order to extend it and continue experimentation
(
~allocBusses = {
    ~reverbBus = Bus.audio(s, 2);
};

~initServerNodes = {
    ~fxGroup = Group.new;
    ~reverb = Synth(\reverb, [\in, ~reverbBus, \wet, 0.0, \dry, 1.0], ~fxGroup);
};

// SynthDefs for the Synths used in the piece
~defineSynths = {

   ~coscbuff = Buffer.alloc(s, 2048, 1);
   ~coscbuff.sine1(1.0/(1..6), true, true, true);

   SynthDef(\cosc,
            {
                |freq = 400, amp = 0.1, gate = 1, buf=0, beats=1, pos = 0, out = 0|

                var sig, env;
                env =  EnvGen.kr(Env.adsr, gate);
                sig = COsc.ar(buf, freq, beats, amp);
                Out.ar(out, Pan2.ar(env * sig, pos));
        }).add;



    SynthDef.new(\basic, {

        arg freq=500, atk=0.002, sus=0, rel=1,
        pan=0, amp=0.1, out=0;

        var sig, env;

        env = EnvGen.ar(
            Env.new([0,1,1,0],[atk,sus,rel],[2,0,-2]),
            doneAction:2
        );

        sig = SinOsc.ar(freq);
        sig = Pan2.ar(sig, pan, amp) * env;
        Out.ar(out, sig);
    }).add;

    SynthDef.new(\reverb, {
        arg in=0, drylevel=0.7, wetlevel=0.3, out=0;
        var sig, reverb;
        sig = In.ar(in, 2);
        reverb = In.ar(in, 2);
        reverb = LPF.ar(GVerb.ar(sig, 250, 4), 900);
        sig = (sig * drylevel) + (reverb * wetlevel);
        Out.ar(out, sig);
    }).add;
};

// list of Pbinds
~definePbinds = {

   Pbindef(\c1,
        \instrument, \cosc,

    )

};

//performance events:
// array (or dictionary) of functions that when called start/stop/alter
// Pbinds, or possibly create and manipulate Synths via Routines
// might be called manually, or from GUI, or MIDI, or from external
// code via OSC
~events = [

];


/////////////////////////////////
// code that doesn't change
////////////////////////////////
s.newBusAllocators;
~allocBusses.value;

ServerTree.removeAll;

s.waitForBoot {
	s.freeAll;
	Buffer.freeAll;
	s.sync;
	~defineSynths.value;
	s.sync;
	~buffs = ~loadBuffs.('sounds');
	s.sync;
	ServerTree.add({
        s.bind({
            ~initServerNodes.value;
        })
    });
    ServerTree.run;
};

~definePbinds.value;

)





)





