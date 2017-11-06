
(
	e = [(\freq:  500, \amps:[0, 0.2, 0.5, 0.7, 0.2, 0]),
		 (\freq: 1000, \amps:[0, 0.1, 0.7, 0.6, 0.6, 0]),
		 (\freq: 2000, \amps:[0, 0.5, 0.5, 0.8, 0.8, 0]),
		 (\freq: 1500, \amps:[0, 0.5, 0.7, 0.8, 0.9, 0])
	    ];

	e.do({
		|i|
	{SinOsc.ar(i[\freq], mul:EnvGen.ar(Env(i[\amps], 0.5!(i[\amps].size - 2) ++ 1 ), doneAction:2)/3) * EnvGen.ar(Env.perc)}.play;
	});
)

j = e[0]
f = j[\amps]
f.size
0.2!(j[\amps].size - 2) ++ 3
Env(j[\amps], 0.2!(j[\amps].size - 2) ++ 2).plot
j[\amps]
0.2!(j[\amps].size - 1)

