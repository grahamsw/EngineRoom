OscOut oscout;
("localhost", 6449) => oscout.dest;

while(true){
    oscout.start("/siga/property2");
    oscout.add(Math.random2f(0.0,10.0));
    oscout.send();
    1::second => now;
}

   