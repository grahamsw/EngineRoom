
(
// these functions are all defined by the composer, and may be
// redefined, with care, and rerun while the piece is running
// in order to extend it and continue experimentation

~allocBusses = {
	// create nodes for the FXs
};

~initServerNodes = {
	// create groups and FX nodes
};

// SynthDefs for the Synths used in the piece
~defineSynths = {

});

};

// list of Pbinds
~definePbinds = {

    ~seq = [4,3,2,1,0];

    ~step1 = {
        |s|
        [s[0], s[2], s[1], s[4], s[3]]
    };


    ~step2 = {
        |s|
        [s[1], s[0], s[3], s[2], s[4]]
    };


    ~nextStep = Routine({
        var cur_seq = ~seq;
        var first_run = true;
        cur_seq.yield;
        loop({
            cur_seq = ~step2.(cur_seq, first_run);
            first_run = false;
            cur_seq.yield;
            cur_seq = ~step1.(cur_seq);
            cur_seq.yield;
        })
    });

    ~changes = Routine({
        ~nextStep.reset;
        loop({
            var nextstep = ~nextStep.next;
            nextstep.postln;
            nextstep.do({
                |c|
                //   c.postln;
                (\degree: c, \dur: 0.2).play;
                0.2.wait;

            });
            0.1
        })

};

//performance events:
// array (or dictionary) of functions that when called start/stop/alter
// Pbinds, or possibly create and manipulate Synths via Routines
// might be called manually, or from GUI, or MIDI, or from external
// code via OSC
~events = [
    \startChanges, {~changes.play},
    \stopChanges, {
        ~changes.stop;
        ~changes.reset;
        ~nextStep.reset;
    },


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



~events[\startChanges].value;
~events[\stopChanges].value;


 (
~numBells = 6;

 ~chasePath = (1..~numBells).mirror2;


~bellPath = {
       |bell|
        var pos = if(bell.odd, {bell-1}, {~chasePath.size - bell});
        Routine({
            loop({
               ~chasePath[pos].yield;
               pos = (pos + 1)%~chasePath.size;
            });
        });
    };


        ~paths = ~numBells.collect({
            |bell|
            bell = bell + 1;
            ~bellPath.(bell);
        });

~nextPeal = {
            ~paths.collect({|path, bell| [bell+1,path.next];} ).sort({
                |bb, cc| bb[1] < cc[1]
            }).collect({|bb| bb[0]})

        };



        20.do({
            ~nextPeal.value.postln
            });

    )
        ~chasePath[]