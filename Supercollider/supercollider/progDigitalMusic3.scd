2.do({| c, i| postln(c );postln(i);})

(
~score = {
  var freqs, size=32, selector, output;
	freqs = Array.fill(size, {rrand(36, 84).midicps});
	selector = LFSaw.ar(1.0, mul:size/2, add:size/2);
	output = Select.kr(selector, freqs);
}
)

~synths = [SinOsc, Saw, Pulse, LFTri, Blip];

(
var choice, amp, output;
choice = [0, 2, 3, 4,1];
amp = 0.707/(choice.size);
output = Array.newClear(choice.size);

choice.size.do{
	|i|
	choice[i] = if(choice[i] > 0,
		           choice[i],
		           0);
	choice[i] = if(choice[i] < (~synths.size),
		           choice[i],
		           (~synths.size-1));
	output[i] = {
		~synths[choice[i]].ar(~score, mul:amp)
	}.play;
}
)

