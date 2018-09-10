(
// Motif Player

~motifPlayer = {
	| stretch = 0.125, amp = 0.1, ctranspose = 0, instrument =\default, motif|

	var state = stateMaker(stretch:stretch, amp:amp, ctranspose:ctranspose, instrument:instrument);

	(\pbind: Pchain(state.pstate, motif), \state, state.state);
	}
)
/*
~n005 = ~nature_005(ctranspose:12, dur:0.2, amp:1, instrument:\def);

~n005.pbind.play
~n005.state.dur=0.14
~n005.state.ctranspose = 2
~n005.state.amp = 0.1


~n005A = ~nature_005.(ctranspose:12, dur:0.2, amp:1, instrument:\def);
~n005A.pbind.play

~n005A.state.dur = 0.05
*/


