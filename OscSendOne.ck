OscOut oscout;

"siga" => string msgHeader;
"gain" => string msg;
500=> int val;

6449 => int port;
("localhost", port) => oscout.dest;

"/" + msgHeader + "/" + msg  => oscout.start;
oscout.add(val);

oscout.send();
