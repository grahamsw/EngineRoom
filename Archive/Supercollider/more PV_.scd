(

{
	var sound = FFT(LocalBuf(512), ClipNoise.ar());
	//sound = PV_BrickWall(sound, SinOsc.kr(0.5).range.(-0.3, 0.1));
	sound = PV_RectComb(sound, SinOsc.kr(0.2).range(2,7),0, SinOsc.kr(1).range(0, 0.5));

	sound = IFFT(sound);
}.scopeResponse
)

{BPF.ar(ClipNoise.ar(1), SinOsc.kr(0.2).range(100, 600))}.scopeResponse