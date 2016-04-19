Engine Room 
Feb 2014

A tool for producing an ACP (auditory control panel). 
Built using ChucK http://chuck.stanford.edu/


Input will be a series of readings - essentially name/value pairs

Each reading will be used to fire an event containing the value of that reading, each event will be associated with one or more monitors.

Monitors will produce a sound that varies with the reading (and possibly with the history of the readings, that's up to the monitor). Between readings the 
monitor can do whatever it likes. It will probably keep doing the same thing.

An example is an ACP for monitoring a web server. 
An event monitor, Splunk, say, produces a series of readings associated with CPU load, memory use, disk faults, exceptions, visitors on site, pages per second, bad URLs, etc.

Each monitor is associated with an instance of a MonitorEvent, a subclass of ChucK's Event class that contains a floating point reading value. When that event fires the monitor will, for example, vary its pitch, volune, vibrato, envelope, reverb.

With careful design it should be possible to create a barely noticable ambient sound that maintains awareness of the server state, and draws attention when something starts to go wrong.

The model is a car or ship engine: a background hum that can be ignored, but communicates the state and health of the engine.

Other data feeds could be weather, financial information, biometrics, anything producing time series.
