
me.dir() + "/audio/" => string dir;

4 => int mod;

// return 0.0 to 1.0 in linear steps 
fun float range(int steps, int step){
    return (step % steps) * 1.0 / steps;
}

// return -1.0 to 1.0 in sinusoidal steps
fun float sinusoid(int steps, int step){
    return Math.sin(2.0 * Math.PI * range(steps, step));
}  

fun dur interval(int i){
    // we want the variation to be sinusoidal
    // set up a range from 0 to 2PI
    2 * Math.PI *(i % 10000 ) /10000.0 => float r;
    100 + Std.ftoi(Math.round(10 * sinusoid(100, i))) => int d;
    <<< d >>>;
    return d::ms ;
}

SndBuf kick => dac;
SndBuf hihat => dac;
0.4 => kick.gain;
3.0 => hihat.gain;

dir + "kick_01.wav" => kick.read;
dir + "snare_01.wav" => hihat.read;

0 => int i;
while (true){
    0 => kick.pos;
    if (i % mod ==0) {
        0 => hihat.pos;
    }
    else {
        hihat.samples() => hihat.pos;
    }
    i => interval => now;
    i++;
}
    