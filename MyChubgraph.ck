class MyChubgraph extends Chubgraph {
    inlet => Gain dry => outlet;
    dry => Delay delay => outlet;
    delay => Gain feedback => delay;
    
    0.8 =>  feedback.gain;
    1:: second => delay.delay;
}


