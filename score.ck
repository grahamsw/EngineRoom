

DynamicValues dvs1;
DynamicValues dvs2;

["first", "freq", "onMs", "offMs", "gain"] @=> dvs1.names;
2800 =>  dvs1.ints["freq"];
40 =>  dvs1.ints["onMs"];
20 =>  dvs1.ints["offMs"];
400 => dvs1.ints["gain"];

["second", "freq", "onMs", "offMs", "gain"] @=> dvs2.names;
1800 =>  dvs2.ints["freq"];
400 =>  dvs2.ints["onMs"];
200 =>  dvs2.ints["offMs"];
300 => dvs2.ints["gain"];



Receiver r1;
Receiver r2;
r1.Init(6449, "siga", dvs1);
r2.Init(6449, "sigb", dvs2);


SinPlayer s1;
SinPlayer s2;
s1.Init(dvs1);
s2.Init(dvs2);

// need this to keep the receiver and player objects around
while(true){
	1000 :: second => now;
}