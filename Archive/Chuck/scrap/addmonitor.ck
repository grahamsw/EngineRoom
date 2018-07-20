public class AddMonitor{
	fun static int Add( Monitor monitor, MonitorEvent event){
	   1 => int eventCount;
		while( true ){
		    <<< monitor.label + " " + eventCount>>>;
			event => now;
			event => monitor.Signal;
			1 +=> eventCount;
		}
	}
}
