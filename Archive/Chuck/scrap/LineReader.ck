// expect delimited string
// name##3.45
// for some delimiter (## in this case)
// with a string and a float.

/*        
LineReader lr;
lr.setDelimiter("##");
if (lr.parseLine("name##23.45")){
    <<< lr.name()>>>;
    <<< lr.value() >>>;
}
else {
    <<< "bad line" >>>;
}
*/
public class LineReader{
    string _delimiter;
    "" => string _line;
    -1 => int _pos;
    "" => string _name;
    -1 => float _val;
    0 => int _isValid;
    
    fun void setDelimiter(string delim){
        delim => _delimiter;
    }
    
    fun int parseLine(string line){
        line.length() => int len;
        line.find(_delimiter) => _pos;
        if (_pos > -1 && _pos < len){
            line.substring(0, _pos) => _name;
            line.substring(_pos + _delimiter.length()) => string val;
            Std.atof(val) => _val; // if val is not a float it will parse as 0.0
            return true;
        }
        else {
            return false;
        }
    }
    fun string name() {
        return _name;
    }
    fun float value() {
        return _val;
    }
}

