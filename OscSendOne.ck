OscOut oscout;
6449 => int port;
("localhost", port) => oscout.dest;
"sigb" => string msgHeader;

fun void send(string name, int val){
	"/" + msgHeader + "/" + name  => oscout.start;
	oscout.add(val);
	oscout.send();

}

fun void range(string name, int min, int max, int inc){
	for(min => int v; v <= max; inc +=> v){
		send(name, v);
		1 :: second => now;
	}
}


send("formant1", 900);
send("formant2", 1200);
send("formant3", 1200);




send("Q1", 30);
send("Q2", 30);
send("Q3", 30);


range("formant1", 200, 1000, 40);

range("vibratoFreq", 0, 20, 1);

//send("folds", 150);
//send("dur", 1000);

