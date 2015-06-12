
public class LineReader{
    string _delimiter;
    
    fun void setDelimiter(string delim){
        delim => _delimiter;
    }
    
    fun float[] parseLine(string line){
        0 => int pos;
        line.length() => int len;
        while(pos < len){
            line.find(_delimiter, pos) => int newPos;
        
            if (newPos > -1 && newPos < len){
                line.substring(pos, newPos) => string val;
                line.substring(_pos + _delimiter.length()) => string val;
            }
        }
    }
    
}

