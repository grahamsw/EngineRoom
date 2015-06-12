fun float range(int steps, int step){
    return (step % steps) * 1.0 / steps;
}
// return -1.0 to 1.0 in sinusoidal steps
fun float sinusoid(int steps, int step){
    return Math.sin(2.0 * Math.PI * range(steps, step));
}  

Noise nz  => LPF filt => dac;

500.0 => filt.freq;
60.0 => filt.Q;
0.2 => filt.gain;
0 => int i;

while (true) {
    //Math.random2f(500.0, 2500.0) => filt.freq;
    //100.0 => imp.next;
    
    70.0 + 30.0 * sinusoid(100, i) => float q;
    q => filt.Q;
    <<< q >>>;
 //   1 :: second => now;
    
    i++;
}