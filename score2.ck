

DynamicValues dvs1;

dvs1.Init(["formant1", "formant2", "formant3", "folds", "dur", "vibratoFreq", "vibratoGain", "Q1", "Q2", "Q3"], 
           [600 ,       1400  ,      2500,      200,     500,   10,            1000,          20,   20,   20  ]);

Receiver r1;
r1.Init(6449, "siga", dvs1);

SynthVoicePlayer s1;

//s1.Init(dvs1);


DynamicValues dvs2;

dvs2.Init(["formant1", "formant2", "formant3", "folds", "dur", "vibratoFreq", "vibratoGain", "Q1", "Q2", "Q3"], 
           [800 ,       1800  ,      2400,      200,     500,   6,            1500,          20,   20,   20  ]);

Receiver r2;
r2.Init(6449, "sigb", dvs2);

SynthVoicePlayer s2;

s2.Init(dvs2);

// need this to keep the receiver and player objects around
while(true){
	1000 :: second => now;
}