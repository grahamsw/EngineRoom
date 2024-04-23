// Companion Code 1.2
// Pitch to Note Number Conversion

// In this companion code, we'll build a function that accepts as its input a symbol, representing a letter name and octave (such as 'C4', 'F#3', or 'Bb6'), and returns the MIDI note number it represents. We'll use the convention that middle C on a piano is equivalent to 'C4', which is note number 60. When ascending, octave numbers increment on every C. This exercise combines a few different concepts from Chapter 1, particularly conditional logic, iteration, funcntions, and a few other basic classes. Comments are included throughout.

(
~p2n = { |pitch = \c4|
	var result, letter, octave;

	// We'll first need to separate the input into two components: the letter name and the octave. So, the first step is to convert the symbol to a string so it can be broken down into individual characters. True, we could have the user provide the input as a string instead of a symbol, but symbols have the advantage of being expressible with a single backslash, rather than a pair of quotes, so it's one less character we'll have to type later on.
	pitch = pitch.asString;

	// To get the octave information, take the last character of the string and convert it to a proper digit. This converts a member of the Char (short for Character) class to a member of the Integer class, assuming it's a number.
	octave = pitch.last.digit;

	// Now, drop the last character from the string and convert to lowercase. This allows the user to specify the letter name as either uppercase or lowercase.
	letter = pitch.drop(-1).toLower;

	// Now, the actual computation in which we start building our result. We start with a switch in order to determine the basic pitch class. All C's are divisible by 12, so we'll use 0 as a starting point and build a major scale from there. Any D will return 2, and E will return 4, etc.
	result = switch(
		letter[0],
		$c, {0},
		$d, {2},
		$e, {4},
		$f, {5},
		$g, {7},
		$a, {9},
		$b, {11}
	);

	// Next, we incorporate the sharp/flat with a case statement. We access this information by taking the item at index 1 from the letter component of the input. If there's no sharp or flat, letter[1] returns nil, and we'll pass harmlessly through the case block. If it's a flat (lowercase 'b'), decrement the result by 1. If it's a sharp (lowercase 's' or the '#' symbol), increment the result by 1. Note that lowercase 's' is an option here because the symbol backslash notation will fail when using '#', e.g. \Cs4 is valid, but \C#4 is a syntax error.
	case(
		{ letter[1] == $b }, { result = result - 1 },
		{ (letter[1] == $s) || (letter[1] == $#) }, { result = result + 1 }
	);

	// Finally, incorporate the octave. For \C4 to return 60, we'll need to add 1 to the the octave number, multiply by 12, and add that to our result.
	result = result + (12 * (octave + 1));
};
)

// And we're done! We can do a few simple tests to see if the function is working correctly:

~p2n.(\c4); // -> 60

~p2n.(\c3); // -> 48

~p2n.(\d3); // -> 50

~p2n.(\ds3); // -> 51

~p2n.(\db3); // -> 49

// We can use iteration to concisely test a large number of inputs. Here, we see an example of "nested" iteration. We use 'do' to iterate over several octave numbers. For each octave number, we then iterate over a string of all 7 letter names. As a result, the innermost code is executed 4 x 7 = 28 times, once for each permutation. Inside the nested 'do', we construct the relevant symbol, and post it, along with the result of the function when the symbol is used as an input.

(
[3, 4, 5, 6].do({ |octave|
	"cdefgab".do({ |letter|
		var pitch = (letter ++ octave.asString);
		[ pitch, ~p2n.(pitch) ].postln;
	});
});
)

// In practical usage, we might have some complex harmony, typed out into an array:

~harmony = [\f2, \eb3, \a3, \d4, \g4, \c5];

// We can't pass this array directly into our function, because our function expects a symbol, rather than an array of symbols. They're not the same thing!

~p2n.(~harmony); // error!

// But, we can iterate over the array and call our function for each symbol. 'collect' makes sense here, because we want to return and capture a new array based on the application of our ~p2n function:

~notes = ~harmony.collect({ |n| ~p2n.(n) }); // -> [ 41, 51, 57, 62, 67, 72 ]