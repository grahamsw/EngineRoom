

DynamicValues dvs1;
DynamicValues dvs2;

dvs1.Init(["freq", "onMs", "offMs", "gain"], 
           [2000 ,   40  ,      20,   400]);
dvs2.Init(["freq", "onMs", "offMs", "gain"], 
           [1800,     400,  200,    300]);

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