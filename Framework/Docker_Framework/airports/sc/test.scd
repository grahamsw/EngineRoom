(

~airports=[
    [5,7,4,2,0,12,7,5,7,4,2,0],
    [5,7,4,2,0,12,4,7,5,0],
    [-5,2,0,4,7,12,5,2,7,4,0,7,2,5,5,2,4,0],
    [7,7,2,4,4,4,2,0,7,0,0],
].collect({|a| Pseq((a+60).midicps,1)});

q = ~airports.collect({|a| Pseq((a+60).midicps,1)});

Pfxb(
    Pbind(
        \instrument, Pwrand([\comb_piano, \polyperc], [0.9, 0.1], inf),
        \freq, Pswitch(q, Prand([0,1,2,3], inf)),
        \dur, 1+Prand([0.02,0.05,1,2,0.5,0.25,2]/2, inf).trace*rrand(0.78,1.32),
        \legato, 2,
        \out, ~fxBus
    ),
    \reverb).play
)



().play



notepulse=1;
noterate=TChoose.kr(Dust.kr(notepulse)+Impulse.kr(0),[0.02,0.05,1,2,0.5,0.25,2]/2)*Rand(0.78,1.32);
notepulse=Impulse.kr(noterate);
seq=Demand.kr(Dust.kr(0.1)+Impulse.kr(0),0,Dxrand(airports,inf));
seqnote=Demand.kr(notepulse,0,Dseq(seq,inf));
