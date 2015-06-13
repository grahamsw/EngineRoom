
Receiver r1;
SinPlayer s1;


SignalValue svs11;
"freq" => svs11.name;
800 => svs11.value;

SignalValue svs12;
"onMs" => svs12.name;
200 => svs12.value;

SignalValue svs13;
"offMs" => svs13.name;
200 => svs13.value;
[svs11, svs12, svs13] @=> SignalValue svs1[];

s1.Init(svs1);
r1.Init(6449, "siga", s1);

Receiver r2;
SinPlayer s2;

SignalValue svs21;
"freq" => svs21.name;
1600 => svs11.value;

SignalValue svs22;
"onMs" => svs22.name;
80 => svs22.value;

SignalValue svs23;
"offMs" => svs23.name;
80 => svs23.value;
[svs21, svs22, svs23] @=> SignalValue svs2[];

s2.Init(svs2);
r2.Init(6449, "sigb", s2);


// need this to keep the receiver object around
while(true){
	1000 :: second => now;
}