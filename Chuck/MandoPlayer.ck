public class MandoPlayer  {
    Mandolin m[4];
    
    fun void init(UGen outlet) {
        JCRev rev => outlet;
        for ( 0 => int i; i < 4; i++){
            m[i] => rev;
        }
        0.25 => rev.gain;
        0.02 => rev.mix;
    }
    
    fun void freqs(float gStr, float dStr, float aStr, float eStr){
        m[0].freq(gStr);
        m[1].freq(dStr);
        m[2].freq(aStr);
        m[3].freq(eStr);
    }
    
    fun void notes(int gNote, int dNote, int aNote, int eNote){
        this.freqs(
              Std.mtof(gNote),
              Std.mtof(dNote),
              Std.mtof(aNote),
              Std.mtof(eNote)
             );
    }
    
    fun void chord(string which){
        if (which == "G") {
            this.notes(55, 62, 71, 79);
        }
        else if (which == "C") {
            this.notes(55, 64, 72, 79);
        }
        else if (which == "D") {
            this.notes(57, 62, 69, 78);
        }
        else {
            <<< "unknown chord: ", which >>>;
        }
    }
         
    fun void roll(string chord, dur rate) {
         this.chord(chord);
         for(0 => int i; i < 4; i++) {
                1 => m[i].noteOn;
                rate => now;
         }
         
     }
 
     fun void strum(int note, dur howLong) {
         int whichString;
         if (note < 62) {
             0 => whichString;
         }
         else if (note < 69) {
             1 => whichString;
         }
         else if (note < 76 ){
             2 => whichString;
         }
         else {
             3 => whichString;
         }
         Std.mtof(note) => m[whichString].freq;
         now + howLong => time stop;
         while (now < stop) {
             Std.rand2f(0.5, 1.0) => m[whichString].noteOn;
             Std.rand2f(0.06, 0.09) :: second => now;
         }
     }
 
     fun void damp(float amount){
         for(0 => int i; i < 4; i++){
             amount => m[i].stringDamping;
         }
     }
 }
            
    
    