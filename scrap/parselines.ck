// expect delimited string
// name##3.45
// for some delimiter (## in this case)
// with a string and a float.

class LineReader(){
    string _delimiter;
    string _line = "";
    int _pos = -1;
    string _name = "";
    float _val = -1;
    int _isValid = 0;
    
    fun void setDelimiter(string delim){
        _delimiter = delim;
    }
    
    fun void parseLine(string line){
        line.length() => int len;
        line.find(delim) => _pos;
        if (_pos > -1 && _ pos < len){
            line.substring(0, pos) => _name;
            line.substring(pos + delim.length() => string val;
            Std.atof(val) => _val;
            1 => _isValid;
        }
        
        

fun int validLine(sting line, string delim
fun string parseName(string line, string delim){
    line.find(delim) => int pos;
    return line.substring(0, pos);
}

fun float parseValue(string line, string delim){
    line.find(delim) => int pos;
    return Std.atof());
}

<<< parseName("poo@34.2", "@")>>>;
<<< parseValue("poo@34.2", "@")>>>;

