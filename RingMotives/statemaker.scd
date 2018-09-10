// state maker
(
~stateMaker = {
		| stretch = 0.125, amp = 0.1, ctranspose = 0, instrument =\default|

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
	(pstate:pstate, state:state);
}
)
