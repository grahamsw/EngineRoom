(
// Motif Player
~motifPlayer = {
	| stretch = 0.125, amp = 0.1, ctranspose = 0, instrument =\default, motif|

	var state = (\amp:amp,
		         \ctranspose:ctranspose,
		         \instrument:instrument,
		         \stretch: stretch);

	var pstate = Pbind(
	             	\instrument, Pfunc({state.instrument}),
		            \ctranspose, Pfunc({state.ctranspose}),
		            \amp, Pfunc({state.amp}),
		            \stretch, Pfunc({state.stretch})
	             );

	(pbind: Pchain(pstate, motif), state: state);
	}
)


/*
b = ~motifPlayer.(motif: forest_murmers_embryonic_014);
b.pbind.play;
b.state.stretch = 0.12;
b.state.amp = 0.36;
b.state.ctranspose = 12;
*/

