~houston = Buffer.read(s, "/usr/share/sounds/alsa/Rear_Center.wav");
~chooston = Buffer.read(s, "/home/grahamsw/Documents/sounds/327141__xserra__speech-male-hprmodel-residual.wav");

{PlayBuf.ar(1, ~houston)}.play;
{PlayBuf.ar(1, ~chooston)}.play;

[~houston.bufnum, ~houston.numChannels, ~houston.path, ~houston.numFrames];
[~chooston.bufnum, ~chooston.numChannels, ~chooston.path, ~chooston.numFrames];

,

(
~kbus1 = Bus.control;
~kbus2 = Bus.control;

{
	var speed, direction;
	speed = In.kr(~kbus1,1) * 0.2 + 1;
	direction = In.kr(~kbus1);
	PlayBuf.ar(1, ~chooston, (speed * direction), loop: 1);

}.play;
)

(
{Out.kr(~kbus1, LFNoise0.kr(12))}.play;
{Out.kr(~kbus2, LFClipNoise.kr(1/4))}.play;
)

(
{
	var speed, direction;
	speed = In.kr(~kbus1,1) * 0.2 + 1;
	direction = In.kr(~kbus2);
	Out.ar(1, PlayBuf.ar(1, ~houston, (speed * direction), loop: 1));
}.play;
)