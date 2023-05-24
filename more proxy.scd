s.boot;
t =  TempoClock(120);
p = ProxySpace.new(s, clock:t );
p.fadeTime = 2; // fadeTime specifies crossfade
p[\out].play; // monitor an empty placeholder through hardware output
// set its source
p[\out] = { SinOsc.ar([350, 351.3], 0, 0.2) };
p[\out] = { Pulse.ar([350, 351.3] / 4, 0.4) * 0.2 };
p[\out] = Pbind(\dur, 0.03, \freq, Pbrown(0, 1, 0.1, inf).linexp(0, 1, 200, 350));

// route one proxy through another:
p[\out] = { Ringz.ar(p[\in].ar, [350, 351.3] * 8, 0.2) * 4 };
p[\in] = { Impulse.ar([5, 7]/2, [0, 0.5]) };

p.clear(3); // clear after 3 seconds

p[\out].asCode
p[\out].document

p.clear(5)
p

// as soon as a sound function (or any compatible input) is assigned to a proxy
// this sound plays on its own private bus (so it is not audible yet.)
(
p[\x] = {
    RLPF.ar(Impulse.ar(4) * 20, [850, 950], 0.2)
}
)

p[\x].bus
p[\x].play
p = ProxySpace.push



// the sound function can be changed at any time:
(
~x = {
    RLPF.ar(Impulse.ar([5, 7]) * 5, [1450, 1234], 0.2)
}
)

// You can tune a sound function to your liking very easily
// by replacing it with little (or big) variations:

        // filter freqs higher:
~x = {    RLPF.ar(Impulse.ar([5, 7]) * 5, [1800, 2000], 0.2) }

        // same pulse ratio (5/8), different pulse tempo:
~x = {    RLPF.ar(Impulse.ar([5, 8] * 3.2) * 5, [1800, 2000], 0.2) }

        // different filter:
~x = {    Ringz.ar(Impulse.ar([5, 8] * 3.2), [1800, 2000], 0.05) }

// and if you set the proxy's fadeTime, you can create little
// textures by hand:

~x.fadeTime = 0.5;
        // different filter freqs every time:
~x = {    Ringz.ar(Impulse.ar([5, 8] * rrand(0.5, 1.5).postln) * 0.5, ({ exprand(200, 4000) } ! 2), 0.05) }

// here is another proxy:
~y = { Pan2.ar(Dust.ar(200), 0) };

~y.bus; // it has two channels, just as the ~x., but it plays on another (private) bus.

// note that ~y is not audible directly,
// but it can be used like a UGen in any other proxy:
(
~x = {
    RLPF.ar(~y.ar * 8, [1450, 1234], 0.2)
}
)

p = ProxySpace.new


~y.stop
~x = nil

s.freeAll



a = NodeProxy.new.source_({ Pulse.ar([350, 351.3] / 4, 0.4) * 0.2 });

a.play
a.fadeTime = 2;
a.source = { SinOsc.ar([350, 351.3], 0, 0.2) };
a.source = Pbind(\dur, 0.03, \freq, Pbrown(0, 1, 0.1, inf).linexp(0, 1, 200, 350));

p = ProxySpace.push
~snd.clear
~snd.play(numChannels: 1)
(
~snd = {|freq = 400, amp = 0.1|
    SinOsc.ar(freq, mul:amp)}
)
~snd.stop

~panner = {|a_in, pos = 0, amp=1| Pan2.ar(a_in, pos, amp)}
~panner.play
~panner.set(\a_in, ~snd)

~pos = {TRand.kr(-1,1, Impulse.kr(1))* 0.9}
~panner.set(\pos, ~pos, \amp, 0.5)

~freq = {LFNoise0.kr(3).range(400, 1000)}
~snd.set(\freq, ~freq)

p.clear



// the initial slot (0) is used when assigning directly.
// ~y is still unused, we will add it later.

~z = (~y * pi).sin * 0.1 * { LFSaw.kr(LFNoise1.kr(0.1 ! 3).sum * -18).max(0.2) };

// other slot numbers are accessed by positive integers:

~y[1] = { Saw.ar([400, 401.3], 0.4) };
~y[0] = { Saw.ar([300, 301], 0.4) };

// to remove one of them, nil is used:

~y[0] = nil;

// what is to be found at index 1?
~y.objects[0] // a playing interface
~y.objects[0].source.postcs // the function that was put in.
~y.objects.postcs     // this returns objects in the slots.
~y.source.postcs    // this returns the function in slot 0 only.





// the function is assigned to th slots from 1 to 4
~z[1..4] = { SinOsc.ar(exprand(300, 600), 0, LFTri.kr({exprand(1, 3)} ! 3).sum.max(0)) * 0.1 };


// the function is assigned to the slots 1, 2 and 3 (subsequent)
~z[1..] = [ {SinOsc.ar(440) * 0.1 }, { SinOsc.ar(870) * 0.08 }, { SinOsc.ar(770) * 0.04 }];

// if no slot is given, all other slots are emptied
~z = { OnePole.ar(Saw.ar([400, 401.3], 0.3), 0.95) };

~z.end;
~y.end;

~z
// first hit cmd-period.
~z = { max(SinOsc.ar(ExpRand(3, 160)), Saw.ar([304, 304.3])) * 0.1 };
~z.play;        // monitor the proxy
~z.stop;        // note that now the proxy is still playing, but only in private
~z.isPlaying;        // is the group playing? yes.
~z.monitor.isPlaying;    // is the monitor playing? no.

~z


// first hit cmd-period.
~z.play; // monitor. this starts also the synth, if the group wasn't playing.

~z = { SinOsc.ar(ExpRand(20, 660) ! 2) * Saw.ar(ExpRand(200, 960) ! 2) * 0.1 };

~z.release; // release the synth. the current fadeTime is used for fade out

~z.send; // send a new synth. the current fadeTime is used for fade in

~z.send; // send another synth, release the old

~z.release;

~z.stop;

~z.end(3)



(
~z = {
    Splay.ar(
        SinOsc.ar(400 + ({exprand(1, 1.3)} ! rrand(1, 9)))
        * LFCub.ar({exprand(30, 900)} ! rrand(1, 9))
        * LFSaw.kr({exprand(1.0, 8.0)} ! rrand(1, 9)).max(0)
        * 0.1
    )
};
)

~z.play;
~z.rebuild;
~z.send;    // send just creates a new synth - new freq, all else remains the same
~z.rebuild;    // rebuild the synthdef, re-decide numbers of oscs
~z.end;
~z.clear
~z.source.postcs

~z.play;

~z.pause; // pause the synth.

~z = { SinOsc.ar({ExpRand(300, 660)} ! 2) * 0.1 };    // you can add a new function,
                            // which is paused.

~z.resume; // resume playing.

~z.play; // monitor. as the group was still playing, this does _not_ start the proxy.






~y.clear

~y.play;
~y = { arg freq=500; SinOsc.ar(freq * [1, 1.1]) * 0.1 };
~y.fadeTime  = 2

~y.xset(\freq, 300)
~y.objects
~y[2] = { arg freq=500; SinOsc.ar(freq * [1, 1.1]) * LFPulse.kr(Rand(1, 3)) * 0.1 };

~c = { MouseX.kr(100, 800, 1) };
~y.map(\freq, ~c);



~c2 = { [MouseX.kr(300, 800, 1), MouseY.kr(300, 800, 1)] };
~y = { arg freq=#[440, 550]; SinOsc.ar(freq) * SinOsc.ar(freq + 3) * 0.05 };
~y.map(\freq, ~c2);

~y.nodeMap;


p.clear(8)


p.pop


p = ProxySpace.push(s.boot);
~x.play; ~y.play;

// these two synths are started at the time when they are inserted:
~x = { Ringz.ar(Impulse.ar(1), 400, 0.05).dup };
~y = { Ringz.ar(Impulse.ar(1), 600, 0.05).dup };
TempoClock.tempo = 0.1
// adding a common clock:
~x.clock = TempoClock.default; ~x.quant = 1.0;
~y.clock = TempoClock.default; ~y.quant = 1.0;

// now they are in sync
~x = { Ringz.ar(Impulse.ar(1), 1000, 0.05).dup };
~y = { Ringz.ar(Impulse.ar(1), 2400, 0.05).dup };

// for simplicity, one can provide a clock and a quant for a whole proxy space:

p.clock = TempoClock.default; p.quant = 1.0;
~y = { Ringz.ar(Impulse.ar(1), 800, 0.05).dup };

~z.play;
~z = { Ringz.ar(Impulse.ar(1), [500, 514], 0.8).dup * 0.1};
~z = { Ringz.ar(Impulse.ar(1), exprand(300, 400 ! 2), 1.8).dup * 0.1 };
~z = { Ringz.ar(Impulse.ar(6), exprand(300, 3400 ! 2), 0.08).dup * 0.2 };
~z.end;

p.clear(5)





p.makeTempoClock(2.0); // create a new tempoclock with 2 beats/sec
~y.play; ~x.play;
~y.quant = 1; // set the quant back to 1 and the offset to 0
~y = { Ringz.ar(Impulse.ar(~tempo.kr), 1600, 0.05).dup }; // impulse uses tempo
~x = Pbind(\instrument, \default, \freq, Pseq([300, 400], inf)); // pattern uses tempoclock

p.clock.tempo = 0.5; // set the tempo to 1
p.clock.tempo = 2.2; // set the tempo to 2.2

~x.free;
~y.free;

p.clear; // clear all.