OscOut oscout;
("localhost", 6449) => oscout.dest;

 oscout.start("/siga/gain");
 oscout.add(0.4);
 oscout.send();
 
 oscout.start("/siga/pitch");
 oscout.add(2600);
 oscout.send();

 oscout.start("/siga/bpm");
 oscout.add(1000);
 oscout.send();

 oscout.start("/sigb/gain");
 oscout.add(0.4);
 oscout.send();
 
 oscout.start("/sigb/pitch");
 oscout.add(800);
 oscout.send();

 oscout.start("/sigb/bpm");
 oscout.add(250);
 oscout.send();

while(true){
    string msgHeader;
	if (Math.random2(0,1) == 0){
		"siga" => msgHeader;
		Math.random2(0,1) => int s;
		if (s == 0){
			oscout.start("/" + msgHeader + "/pitch");
			oscout.add(Math.random2(2400,3000));
		}
		else {
			oscout.start("/" + msgHeader + "/bpm");
			oscout.add(Math.random2(800,1200));
		}
	}
	else {
		"sigb" => msgHeader;
		Math.random2(0,1) => int s;
		if (s == 0){
			oscout.start("/" + msgHeader + "/pitch");
			oscout.add(Math.random2(800,900));
		}
		else {
			oscout.start("/" + msgHeader + "/bpm");
			oscout.add(Math.random2(200,300));
		}
	}
    oscout.send();
	Math.random2(1, 10) * 1 :: second => now;
}

   