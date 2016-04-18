
public class SynthVoicePlayer {
	SawOsc folds;
	ResonZ formant1;
	ResonZ formant2;
	ResonZ formant3;
	DynamicValues _dvs;
	SinOsc vibrato;

	fun void Init(DynamicValues dvs){
		dvs @=> _dvs;
		folds => formant1 => dac;
		folds => formant2 => dac;
		folds => formant3 => dac;

		vibrato => folds;
		2 => folds.sync;

		spork ~ play();
	}
	fun void play(){
		while (1) {
			_dvs.ints["vibratoFreq"] => vibrato.freq; // 6.0
			_dvs.ints["vibratoGain"] /1000.0 => vibrato.gain; // 1.5
			_dvs.ints["Q1"] => formant1.Q; //20
			_dvs.ints["Q2"] => formant2.Q;
			_dvs.ints["Q3"] => formant3.Q;
			_dvs.ints["formant1"] => formant1.freq; // 500 - 800
			_dvs.ints["formant2"]  => formant2.freq; // 1000 - 2000
			_dvs.ints["formant3"]  => formant3.freq; // 2000 - 3000
			_dvs.ints["folds"]  => folds.freq; // 100 - 200
			_dvs.ints["dur"]/1000.0 * 1 :: second => now;
		}
	}
}