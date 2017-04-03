
(
{
	var carrier, modulator, carrfreq, modfreq;
	carrfreq = MouseX.kr(440, 5000, 'exponential');
	modfreq = MouseY.kr(1, 5000,'exponential');

	carrier = SinOsc.ar(carrfreq, 0, 0.5);
	modulator = SinOsc.ar(modfreq, 0, 0.5);

	carrier * modulator;
}.scope;
)

