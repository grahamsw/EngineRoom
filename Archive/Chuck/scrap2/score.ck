

DynamicValues dvs1;
DynamicValues dvs2;

dvs1.Init(["freq", "onMs", "offMs", "gain"], 
           [300.0 ,  400  ,  200,       0.4,  ]);

Receiver r1;
r1.Init(6449, "siga", dvs1);

SinPlayer s1;
s1.Init(dvs1);

// need this to keep the receiver and player objects around
while(true){
	1000 :: second => now;
}