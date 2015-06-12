OscOut oscout;
("localhost", 6449) => oscout.dest;

 oscout.start("/siga/gain");
 oscout.add(0.4);
 oscout.send();
 oscout.start("/sigb/gain");
 oscout.add(0.4);
 oscout.send();

while(true){
	Math.random2(0,1) => int s;
    if (s == 0){
        oscout.start("/siga/pitch");
        oscout.add(Math.random2(800,1200));
    }
    else if (s == 1){
        oscout.start("/siga/bpm");
        oscout.add(Math.random2(200,400));
    }
	else {
        oscout.start("/siga/gain");
        oscout.add(Math.random2f(0.7, 0.8));
	}
    oscout.send();
	<<< "send" >>>;
	Math.random2(1, 10) * 1 :: second => now;
}

   