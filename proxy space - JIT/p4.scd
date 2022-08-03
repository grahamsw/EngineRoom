p.clear

~out.play;

~out = { arg freq=500, ffreq=120; SinOsc.ar(freq*[1,1.1], SinOsc.ar(ffreq, 0, pi), 0.2) };
~out.set(\freq, 400 + 100.rand2);
~out.set(\freq, 400 + 100.rand2);
~out.set(\ffreq, 30 + 20.rand2);
~out.unset(\freq, \ffreq);    // remove the setting
~out.set(\ffreq, 30 + 10.rand2, \freq, 500 + 200.rand2);


// argument settings and mappings are applied to every new function
~out = { arg freq=100, ffreq=20; SinOsc.ar(freq, SinOsc.ar(SinOsc.ar(ffreq)*ffreq, 0, pi), 0.2) };

// mapping to other proxies
~lfo = { SinOsc.kr(0.3, 0, 80, 100) };
~out.map(\ffreq, ~lfo);

~out = { arg freq=300, ffreq=20; Pulse.ar(freq * [1, 1.1] + SinOsc.ar(ffreq, 0, freq), 0.3, 0.1) };
~out = { arg freq=300, ffreq=20; BPF.ar(LFSaw.ar(ffreq * [1, 1.1], 0, 1), freq, 0.2) };

~lfo = { FSinOsc.kr(0.3, 0, 30, 200) + FSinOsc.kr(10, 0, 10) };
~out = { arg freq=300, ffreq=20; SinOsc.ar(freq*[1,1.1], SinOsc.ar(ffreq, 0, pi), 0.1) };


// crossfaded setting and mapping: fadeTime is used
~out.fadeTime = 2;
~out.xset(\freq, 9000);
~out.xset(\freq, rrand(400, 700));

~lfo = { FSinOsc.kr(0.1, 0, 30, 100) };
~lfo2 = { LFClipNoise.kr(3, 100, 200) };
~lfo3 = StreamKrDur(Pseq([Prand([530, 600],1), 700, 400, 800, 500].scramble, inf) / 3, 0.2);

~out.xmap(\ffreq, ~lfo2);
~out.xmap(\ffreq, ~lfo);
~out.xmap(\ffreq, ~lfo3);

// argument rates: just like a synthdef has input 'rates' (like \ir or \tr), a nodeproxy control
// can be given a rate. this rate is used for each function passed into the proxy.

// trigger inputs
~out = { arg trig, dt=1; Decay2.kr(trig, 0.01, dt) * Mix(SinOsc.ar(7000 * [1.2, 1.3, 0.2])) }
~out.setRates(\trig, \tr);

// set the group, so the node proxy does not store the new value
~out.group.set(\trig, 0.1, \dt, 0.1);
~out.group.set(\trig, 0.4, \dt, 0.31);
~out.group.set(\trig, 0.13, \dt, 2);

// lagging controls:
~out.lag(\xfreq, 1); // equivalent to ~out.setRates(\xfreq, 1);
(
~out = { arg trig, dt=1, xfreq=700;
    Decay2.kr(trig, 0.01, dt) * Mix(SinOsc.ar(xfreq * [1.2, 1.3, 0.2]))
};
)
~out.group.set(\trig, 0.1, \dt, 1, \xfreq, rrand(2000,9000));
~out.group.set(\trig, 0.1, \dt, 0.5, \xfreq, rrand(2000,9000));
~out.group.set(\trig, 0.1, \dt, 1, \xfreq, rrand(2000,9000));

// changing the lag, the synth is reconstructed with the new lag:

~out.lag(\xfreq, 0.01);
~out.group.set(\trig, 0.1, \dt, 1, \xfreq, rrand(2000,9000));
~out.group.set(\trig, 0.1, \dt, 1, \xfreq, rrand(2000,9000));
~out.group.set(\trig, 0.1, \dt, 1, \xfreq, rrand(2000,9000));

// removing the trig rate:
~out.setRates(\trig, nil);