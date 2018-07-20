// Define the score
(
var myDurs = Pseq([Pn(1, 5), 3, Pn(1, 5), 3, Pn(1, 6), 1/2, 1/2, 1, 1, 3, 1, 3]
) * 0.4;
~upperMelody = Pbind(
\midinote, Pseq([69, 74, 76, 77, 79, 81, Pseq([81, 79, 81, 82, 79, 81], 2),
82, 81, 79, 77, 76, 74, 74], inf),
\dur, myDurs
	);
~lowerMelody = Pbind(
\midinote, Pseq([57, 62, 61, 60, 59, 58, 57, 55, 53, 52, 50, 49, 50, 52, 50,
55, 53, 52, 53, 55, 57, 58, 61, 62, 62], inf),
\dur, myDurs
);
)
// Play the two together:
(
~player1 = ~upperMelody.play;
~player2 = ~lowerMelody.play;
)
// Stop them separately:
~player1.stop;
~player2.stop;
// Other available messages
~player1.resume;
~player1.reset;
~player1.play;
~player1.start; // same as .play

{PMOsc.ar(440, MouseY.kr(1,550), MouseX.kr(1,15))}.play;