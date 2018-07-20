
public class MidiLine{
    "\t" => string _delimiter;
    
    int _wait;
    int _status;
    int _data1;
    int _data2;
        
    fun void parseLine(string s){
       // "111\t222\t3333\t4444" =>  s;

        s.find("\t")=> int pos;
        s.find("\t", pos + 1) => int pos2;
        s.find("\t", pos2 + 1  ) => int pos3;

        s.substring(0, pos) => string s1;
        s.substring(pos+1, pos2-pos-1) => string s2;
        s.substring(pos2 + 1, pos3-pos2-1) => string s3;
        s.substring(pos3 + 1, s.length()- pos3 -1) => string s4;
     //   <<< s1, s2, s3, s4 >>>;
        Std.atoi(s1) => _wait;
        Std.atoi(s2) => _status;
        Std.atoi(s3) => _data1;
        Std.atoi(s4) => _data2;
        
    }
    
    fun int wait(){
        return _wait;
    }
    fun MidiMsg msg(){
        MidiMsg msg;
        _status => msg.data1;
        _data1 => msg.data2;
        _data2 => msg.data3;
        return msg;
    }
    
         
}
/*
MidiLineReader lr;
lr.parseLine("");
<<< lr.sequence(), lr.duration() >>>;

lr.msg() @=> MidiMsg msg;
<<< msg.data1, msg.data2, msg.data3 >>>;

*/