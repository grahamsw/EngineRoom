b = Buffer.alloc(s, 2048, 1, bufnum: 80);
b.sine1(1.0/(1..6), true, true, true);

{ COsc.ar(80, 200, 1, 0.1) }.scope(1, zoom:4);