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
~ex = Panola.new("c4 d e f g a b c5");
~motif = Pchain(\dur, ~ex.durationPattern, \midinote, ~ex.midinotePattern);
postln(~ex.durationPattern.asStream.take(30));

~motif = ~forest_murmers_embryonic_014
b = ~motifPlayer.(motif: ~motif);
b.pbind.play;
b.state.stretch = 1.19152;
b.state.amp = 0.8;
b.state.ctranspose = 12;
*/

~motifPlayer.(motif:~nature_005)