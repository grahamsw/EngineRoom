<<< "poop">>>;
public class Range {
    float _from;
    float _to;
    int _steps;
    int _step;
    
    fun void init(float from, float to, int steps){
       from => _from;
       to => _to;
       steps => _steps;
       0 => _step;
    } 
    fun float next(){
        return step(_step++);
    }
    fun float step(int step){
        return _from + (_to - _from) * step / _steps;
    }
}

