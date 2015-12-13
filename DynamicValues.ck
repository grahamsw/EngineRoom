// A repository of values, every time it is asked for a value (by name, and inheritantly, by type)
// it will give a value. That value may change over time.
// It may be updated by a OscReceiver, or over time. 


/*
  usage:
  DynamicValues dvs;
  dvs.Init()


*/


public class DynamicValues {

    string _names[];	
	float _vals[0];

	fun void Init(string names[], float vals[]){
		names @=> _names;
		for(0 => int i; i < _names.cap(); i++){
			vals[i] => _vals[_names[i]];
		}
	}

	fun void diagnostics(){
		for(0 => int i; i < _names.cap(); i++){
			<<< _names[i], _vals[_names[i]] >>>;
		}
	}


}