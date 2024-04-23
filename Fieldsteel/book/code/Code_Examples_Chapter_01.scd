// Code Example 1.1

4.squared.reciprocal;

reciprocal(squared(4));



// Code Example 1.2

3.pow(4);

pow(3, 4);



// Code Example 1.3

(
var num;
num = 4;
num = num.squared;
num = num.reciprocal;
)



// Code Example 1.4

(
var thingA = 7, thingB = 5, result;
thingA = thingA.squared;
thingB = thingB.reciprocal;
result = thingA + thingB;
)



// Code Example 1.5

(
n = 4;
n = n.squared;
n = n.reciprocal;
)

(
~num = 4;
~num = ~num.squared;
~num = ~num.reciprocal;
)



// Code Example 1.6

(
~num = 4;
~num = ~num.squared.postln;
~num = ~num.reciprocal;
)



// Code Example 1.7

(
/*
this is a multi-line comment, which might
be used at the top of your code in order
to explain some features of your program.
*/
var num = 4; // a single-line comment: declare a variable
num = num.squared;
num = num.reciprocal;
)



// Code Example 1.8

// symbolic operators have equal precedence, applied left-to-right:
4 + 2 * 3; // -> 18

// parentheses have precedence over symbolic operators:
4 + (2 * 3); // -> 10

// methods have precedence over symbolic operators:
4 + 2.pow(3); // -> 12.0

// parentheses have precedence over methods:
(4 + 2).pow(3); // -> 216.0

// parentheses first, then methods, then binary operators:
1 + (4 + 2).pow(3); // -> 217.0



// Code Example 1.9

// a typical string
"Click the green button to start.";

// using the escape character to include quotation marks
"The phrase \"practice makes perfect\" is one I try to remember.";

// using the escape character to include new lines
"This string\nwill print on\nmultiple lines.";



// Code Example 1.10

"Hello" + "there!"; // -> "Hello there!"

"Some" ++ "times"; // -> "Sometimes"

"I'm a string.".size; // return the number of characters in the string

"I'm a string.".reverse; // reverse the order of the characters

"I'm a string.".scramble; // randomize the order of the characters

"I'm a string.".drop(2); // remove the first two characters

"I'm a string.".drop(-2); // remove the last two characters



// Code Example 1.11

"hello".asSymbol.class; // -> Symbol

\hello.asString.class; // -> String



// Code Example 1.12

1 < 2; // -> true

1 > 2; // -> false

1.isInteger; // -> true

1.0.isInteger; // -> false

"hello".isEmpty; // -> false

"".isEmpty; // -> true



// Code Example 1.13

(
var num;
num.isNil.postln; // check the variable — initially, it's nil
num = 2; // make an assignment
num.isNil.postln; // check again — it's no longer nil
)



// Code Example 1.14

x = [ 4, "freq", \note, 7.5, true ];

x.at(3); // -> 7.5 (return the item stored at index 3)

x[3]; // alternate syntax



// Code Example 1.15

[ 50, 60, 70 ].squared;			// -> [ 2500, 3600, 4900 ]

1 + [ 50, 60, 70 ];				// -> [ 51, 61, 71 ]

[ 1, 2, 3 ] + [ 50, 60, 70 ];	// -> [ 51, 62, 73 ]

[ 1, 2 ] + [ 50, 60, 70 ];		// -> [ 51, 62, 71 ]



// Code Example 1.16

7.dup; // -> [ 7, 7 ] (default size is 2)

7.dup(4); // -> [ 7, 7, 7, 7 ]

7 ! 4; // -> [ 7, 7, 7, 7 ] (alternate syntax)



// Code Example 1.17

(
f = {
	var num = 4;
	num = num.squared;
	num = num.reciprocal;
};
)

f.value; // -> 0.0625

f.(); // alternate syntax for evaluating



// Code Example 1.18

(
f = {
	arg input = 4;
	var num;
	num = input.squared;
	num = num.reciprocal;
};
)

f.(5); // -> 0.04 (evaluate, passing in a different value as the input)

f.(); // -> 0.0625 (evaluate using the default value)



// Code Example 1.19

(
g = { |thingA = 7, thingB = 5|
	var result;
	thingA = thingA.squared;
	thingB = thingB.reciprocal;
	result = thingA + thingB;
};
)

g.(3, 2); // -> 9.5 (thingA = 3, thingB = 2);



// Code Example 1.20

rrand(1, 9); // random integer between 1 – 9, uniform distribution

rrand(40.0, 90.0); // random float between 40 – 90, uniform distribution

exprand(1, 100); // random float between 1 – 100, exponential distribution



// Code Example 1.21

(
var scale, note;
scale = [ 0, 2, 4, 5, 7, 9, 11, 12 ];
note = scale.choose;
)



// Code Example 1.22

(
var bag, pick;
bag = [\red, \green, \blue];
pick = bag.wchoose([750, 220, 30].normalizeSum);
)



// Code Example 1.23

rrand(40, 90).dup(8); // 8 copies of 1 random value

{ rrand(40, 90) }.dup(8); // 8 uniquely chosen random values



// Code Example 1.24

// "receiver-dot-method" syntax:
([0, 1].choose == 1).if({ \heads.postln }, { \tails.postln });

// "method(receiver)" syntax:
if([0, 1].choose == 1, { \heads.postln }, { \tails.postln });

// structured as a multi-line block:
(
if(
	[0, 1].choose == 1,
	{ \heads.postln },
	{ \tails.postln }
);
)



// Code Example 1.25

(
if(
	([0, 1].choose == 1) && ([0, 1].choose == 1),
	{ "both heads".postln },
	{ "at least one tails".postln }
);
)



// Code Example 1.26

(
var roll = rrand(1, 6);
case(
	{roll == 1}, {\red.postln},
	{roll == 2}, {\orange.postln},
	{roll == 3}, {\yellow.postln},
	{roll == 4}, {\green.postln},
	{roll == 5}, {\blue.postln},
	{roll == 6}, {\purple.postln}
);
)



// Code Example 1.27

(
var roll = rrand(1, 6);
switch(
	roll,
	1, {\red.postln},
	2, {\orange.postln},
	3, {\yellow.postln},
	4, {\green.postln},
	5, {\blue.postln},
	6, {\purple.postln}
);
)



// Code Example 1.28

// (a)
[30, 40, 50, 60].do({ "this is a test".postln });

// (b)
4.do({ "this is a test".postln });

// (c)
[30, 40, 50, 60].do({ |item, index| [item, index].postln });



// Code Example 1.29

x = [30, 40, 50, 60].collect({ |item, index| item * index });
// -> the array [0, 40, 100, 180] is now stored in x



// Code Example 1.30

x = [101, 102, 103, 104, 105, 106, 107];

// return the subset of the array for which the function returns true:
x.select({ |n| n.isPrime }); // -> [101, 103, 107]

// return the first item for which the function returns true:
x.detect({ |n| n.isPrime }); // -> 101

// return true if the function returns true for at least one item:
x.any({ |n| n.isPrime }); // -> true

// return true if the function returns true for every item:
x.every({ |n| n.isPrime }); // -> false

// return the number of items for which the function returns true:
x.count({ |n| n.isPrime }); // -> 3