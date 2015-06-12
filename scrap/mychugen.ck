class MyChugen extends Chugen {
    0 => int p;
    440 => float f;
    second /samp => float SRATE;
    fun float tick(float in){
        return Math.random2f(0, 1);
    }
}

MyChugen ch => dac;

while(true){
    1::second => now;
}