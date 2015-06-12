OscOut oscout;
("localhost", 6449) => oscout.dest;

 oscout.start("/siga/gain");
 oscout.add(0.4);
 oscout.send();
 oscout.start("/sigb/gain");
 oscout.add(0.4);
 oscout.send();

while(true){
    string msgHeader;
	if (Math.random2(0,1) == 0){
		"siga" => msgHeader;
	}
	else {
		"sigb" => msgHeader;
	}
	Math.random2(0,1) => int s;
    if (s == 0){
        oscout.start("/" + msgHeader + "/pitch");
        oscout.add(Math.random2(800,1200));
    }
    else {
        oscout.start("/" + msgHeader + "/bpm");
        oscout.add(Math.random2(200,400));
    }
    oscout.send();
	Math.random2(1, 10) * 1 :: second => now;
}

   