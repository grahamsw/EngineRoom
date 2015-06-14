// A repository of values, every time it is asked for a value (by name, and inheritantly, by type)
// it will give a value. That value may change over time.
// It may be updated by a OscReceiver, or over time. 

public class DynamicValues {

    string names[];
	int ints[0];

	fun void Init(string nms[], int vals[]){
		nms @=> names;
		for(0 => int i; i < names.cap(); i++){
			vals[i] => ints[names[i]];
		}
	}

	fun void diagnostics(){
		for(0 => int i; i < names.cap(); i++){
			<<< ints[names[i]] >>>;
		}
	}
}