
Receiver r1;
r1.Init(6449, "siga", ["onMs", "offMs", "freq"]);

Receiver r2;
r2.Init(6449, "sigb", ["onMs", "offMs", "freq"]);


// need this to keep the receiver object around
while(true){
	1000 :: second => now;
}