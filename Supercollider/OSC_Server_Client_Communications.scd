(
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
 SynthDef(\player , { arg buf, out = 0, rate = 1 ;
 Out.ar(out,
 FreeVerb.ar(in:PlayBuf.ar(1, buf, rate)
 *EnvGen.kr(Env.perc, doneAction:2)*2)
 )
 }).add ;
 SynthDef(\listener , {
var sig = SoundIn.ar(0) ;
 var loc = LocalBuf(1024, 1) ;
 var chain = FFT(loc, sig);
 SendReply.kr(
 Onsets.kr(chain, 0.75, \rcomplex ),
		'/attack',
 Loudness.kr(chain));
 }).add ;
 )
 (
 OSCFunc({
 arg msg;
 var rate = msg[3].linlin(20, 40, 1, 2) ;
		rate.postln;
 Synth(\player ).set(\rate , rate, \buf , b) ;
	}, '/attack');
Synth(\listener );
 )


