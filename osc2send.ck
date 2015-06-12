fun void trace(string label, string msg){
	<<< label + ": " + msg >>>;
}

OscOut oscout;
("localhost", 6449) => oscout.dest;

while(true){
    string msgHeader;
	string addr;
	if (Math.random2(0,1) == 0){
		"siga" => msgHeader;
		Math.random2(0,2) => int s;
		if (s == 0){
		    "/" + msgHeader + "/freq" => addr;
			oscout.start(addr);
			oscout.add(Math.random2(2400,3000));
		}
		else if (s == 1) {
		    "/" + msgHeader + "/onMs" => addr;
			oscout.start(addr);
			oscout.add(Math.random2(800,1200));
		}
		else {
		    "/" + msgHeader + "/offMs" => addr;;
			oscout.start(addr);
			oscout.add(Math.random2(200,400));
		}
	}
	else {
		"sigb" => msgHeader;
		Math.random2(0,2) => int s;
		if (s == 0){
		    "/" + msgHeader + "/freq" => addr;
			oscout.start(addr);
			oscout.add(Math.random2(1500,1600));
		}
		else if (s == 1) {
		    "/" + msgHeader + "/onMs" => addr;
			oscout.start(addr);
			oscout.add(Math.random2(200,300));
		}
		else {
		    "/" + msgHeader + "/offMs" => addr;
			oscout.start(addr);
			oscout.add(Math.random2(100,200));
		}
	}
	trace("send", addr);
    oscout.send();
	Math.random2(1, 10) * 1 :: second => now;
}

   