fun void trace(string label, string msg){
	<<< label + ": " + msg >>>;
}

OscOut oscout;
("localhost", 6449) => oscout.dest;

while(true){
    "siga" => string msgHeader;
	string addr;
		    "/" + msgHeader + "/offMs" => addr;
			oscout.start(addr);
			oscout.add(Math.random2(100,200));
		}
	}
	trace("send", addr);
    oscout.send();
	Math.random2(1, 1) * 1 :: second => now;
}

   