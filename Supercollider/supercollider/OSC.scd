
(

~host = NetAddr("localhost", NetAddr.langPort);

~responder = OSCresponder(~host, "/testMsg", {
	|time, responder, message, address|
	[time, responder, message, address].postln;

	}
).add;
)

~host.sendMsg("/testMsg", 'hello')