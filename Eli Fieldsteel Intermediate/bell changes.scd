
(
// these functions are all defined by the composer, and may be
// redefined,an with care, and rerun while the piece is running
// in order to extend it and continue experimentation

~allocBusses = {
	// create nodes for the FXs
};

~initServerNodes = {
	// create groups and FX nodes
};

// SynthDefs for the Synths used in the piece
~defineSynths = {

      SynthDef(\bell, // a church bell (by Risset, described in Dodge 1997)
        {arg freq=440, amp=0.1, dur=4.0, out=0, pan;
            var env, partials, addPartial, son, sust, delay;

            freq = freq * 2;
            sust = 4;
            amp = amp/11;
            partials = Array.new(9);
            delay = Rand(0, 0.001);

            //bell = SinOsc(freq);

            addPartial = { |amplitude, rel_duration, rel_freq, detune, pan=0|
                partials.add((
                    Pan2.ar(
                        FSinOsc.ar(freq*rel_freq+detune, Rand(0, 2pi), amp * amplitude* (1 + Rand(-0.01, 0.01))), pan)
                    * EnvGen.kr(
                        Env.perc(0.01, sust*rel_duration* (1 + Rand(-0.01, 0.01)), 1, -4).delay(delay), doneAction: 0))
                ).tanh /2
        };

        //addPartial.(1, 1, 0.24, 0, Rand(-0.7, 0.7));
        addPartial.(1, 1, 0.95, 0, Rand(-0.7, 0.7));
        addPartial.(0.67, 0.9, 0.64, 1, Rand(-0.7, 0.7));
        addPartial.(1, 0.65, 1.23, 1, Rand(-0.7, 0.7));
        addPartial.(1.8, 0.55, 2, 0, 0); // root
        addPartial.(2.67, 0.325, 2.91, 1, Rand(-0.7, 0.7));
        addPartial.(1.67, 0.35, 3.96, 1, Rand(-0.7, 0.7));
        addPartial.(1.46, 0.25, 5.12, 1, Rand(-0.7, 0.7));
        addPartial.(1.33, 0.2, 6.37, 1, Rand(-0.7, 0.7));

        son = Mix(partials).tanh;
        son = DelayC.ar(son, 0.06, Rand(0, 0.02));
        EnvGen.kr(Env.perc(0.01, sust * 1.01), doneAction:2);

        Out.ar(out, son);
}).add;


};

// list of Pbinds
~definePbinds = {

    ~odd_change = {
        |seq|
        // swap 0 - 1; 2 - 3 .... until you run out
       // this only works for ~num_bells == 5
        [1,0,3,2,4].collect({
                |i|
                seq[i]
            });
    };

    ~even_change = {
        |seq|
        // swap 1-2; 3-4... until you run out
        // this only works for ~num_bells == 5
        [0, 2, 1, 4, 3].collect({
                |i|
                seq[i]
            });
    };

    ~plain_end = {
        |seq|
        // swap 2-3 ... until you run out
        // this only works for ~num_bells == 5
            [0, 1, 3, 2,4].collect({
                |i|
                seq[i]
            });
    };

    ~bob = {
        |seq|
        //swap 1-2 only (? or swap all except last 2 or 3?)
        [0, 2, 1, 3, 4].collect({
                |i|
                seq[i]
            });
    };


    ~num_bells = 5;
    ~plain_bob_minor =  {
        var seq = (1..~num_bells);
        Routine({
                seq.yield;
                loop({
                    3.do({
                        4.do({
                            seq = ~odd_change.(seq);
                            seq.yield;
                            seq = ~even_change.(seq);
                            seq.yield;
                        });
                        seq = ~odd_change.(seq);
                        seq.yield;
                        seq = ~plain_end.(seq);
                        seq.yield;
                    });

                    4.do({
                        seq = ~odd_change.(seq);
                        seq.yield;
                        seq = ~even_change.(seq);
                        seq.yield;
                    });
                    seq = ~odd_change.(seq);
                    seq.yield;
                    seq = ~bob.(seq);
                    seq.yield;
                });
            });
        };

    ~play_plain_bob_routine = {Routine({
            var deg, seq, pb = ~plain_bob_minor.value;
            loop({
                seq = pb.next;
                seq.postln;
                seq.do({
                    |c|
                    deg = 2 - c;
                (\degree: deg,\dur: 0.2, \instrument: \bell, \amp: rrand(0.27,0.31) ).play;
                   rrand(0.24, 0.26).wait;
                });
                //0.05.wait;
            });0

    })};



};

//performance events:
// array (or dictionary) of functions that when called start/stop/alter
// Pbinds, or possibly create and manipulate Synths via Routines
// might be called manually, or from GUI, or MIDI, or from external
// code via OSC
~events = [
    \start, {
        "starting".postln;
        ~peal = ~play_plain_bob_routine.value;
             ~peal.play;
    },
    \stop, {~peal.free;}

].asDict;





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



~events[\start].value;
~events[\stopChanges].value;



