OscOut oscout;

"sigb" => string msgHeader;
"diagnostics" => string msg;
0=> int val;

6449 => int port;
("localhost", port) => oscout.dest;

"/" + msgHeader + "/" + msg  => oscout.start;
oscout.add(val);

oscout.send();
