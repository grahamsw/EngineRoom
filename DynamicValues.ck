// A repository of values, every time it is asked for a value (by name, and inheritantly, by type)
// it will give a value. That value may change over time.
// It may be updated by a OscReceiver, or over time. 

public class DynamicValues {
   //string names[]
	float floats[0];
	int ints[];
	bool bools[0];
	string strings[0];
}