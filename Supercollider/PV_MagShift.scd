


(

var buffer = Buffer.alloc(s, 2048, 1);
buffer.sine1([2, 1, 0, 1, 1, 0.4, 0, 0 , 2], true, asWavetable:true);

{Osc.ar(buffer, 100, mul:0.2)}.scope(zoom:2);
)


(

var sig = Signal.sineFill(1024, [2, 1, 0, 1, 1, 0.4, 0, 0 , 2].normalizeSum);
var buffer = Buffer.loadCollection(s, sig.asWavetable, 1);

{

	var signal = PlayBuf.ar(1, buffer, BufRateScale.kr(buffer), loop:1);
	signal = FFT(LocalBuf(1024), signal);
	signal = PV_MagShift(signal, stretch: LFTri.kr(0.01).range(0.5, 2), shift: LFTri.kr(0.07).range(1, 3));
	signal = IFFT(signal);

}.scopeResponse;
)


