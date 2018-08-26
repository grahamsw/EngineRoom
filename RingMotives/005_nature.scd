(
// 5: Nature

~nature_005 = {
	| dur = 0.125, amp = 0.1, ctranspose = 0, instrument=\default|
	var state = (\dur: dur, \amp:amp, \ctranspose:ctranspose, \instrument:instrument);

	var midi_005_nature = [39, 46] ++ [51, 55] ++ [58, 63] ++ [67];
	var durs_005_nature = [5, 1].dup(3).flat ++ [6];

	var pstate = Pbind(
		\instrument, Pfunc({state.instrument}),
		\ctranspose, Pfunc({state.ctranspose}),
		\amp, Pfunc({state.amp}));

	var theme = Pbind(
	    \midinote, Pseq(midi_005_nature, inf),
		\dur, Pseq(durs_005_nature , inf)* Pfunc({state.dur})
	    );
	(\pbind: Pchain(pstate, theme), \state: state);
	}
)
/*
~n005 = ~nature_005.(ctranspose:12, dur:0.2, amp:1, instrument:\def);

~n005.pbind.play
~n005.state.dur=0.14
~n005.state.ctranspose = 2
~n005.state.amp = 0.1


~n005A = ~nature_005.(ctranspose:12, dur:0.2, amp:1, instrument:\def);
~n005A.pbind.play

~n005A.state.dur = 0.05
*/


