(
var num;
num = 6;
num = num * 4;
num = num - 1;
)

(
~num = 6;
~num = ~num * 4;
~num = ~num - 1;
)

~num;

(
n = 6;
n = n * 4;
n = n - 1;
)

(
~func = {
	var num;
	num = 6;
	num = num * 4;
	num = num - 1;
};
)

~num = ~func.value;

(
~func = {
	arg num;
	num = num * 4;
	num = num - 1;
};
)

~num = ~func.value(14);
~num = ~func.value(3.5);
~num = ~func.(3.5);

(
~func = {
	|num|
	num = num * 4;
	num = num - 1;
};
)

~num = ~func.value(14);
~num = ~func.value(3.5);
~num = ~func.(3.5);

14.0.class;

"this is a string".class;
"this is a string".size;
$i.class;

'sym'.class;
\sym.class;
\sym.size;

~myArray = [1, "hi", 3.5, 7, \there, -12.001];
~nums = [150, 190, 240, 345];

~nums.at(2);
~nums[2];
~myArray.at(4).class;

~myArray.reverse;
~myArray.scramble;

~myArray = ~myArray.scramble;

s.boot;

(
~mysound = {
	SinOsc.ar(300, 0, 0.2, 0);
};
)

x = ~mysound.play;
x.free;

(
~mysound = {
	|freq|
	SinOsc.ar(freq, 0, 0.2, 0);
};
)

x = ~mysound.play(args: [\freq, 400]);
x.free;

~mysound.play(args: [\freq, 850]);



