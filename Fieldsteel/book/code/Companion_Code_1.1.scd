// Companion Code 1.1
// All About Arrays

// Arrays are ubiquitous in SC, and loaded with features that make it easy to express and manipulate all sorts of information, musical and otherwise. This companion code serves as a sort of "cheat sheet" for a variety of useful methods and techniques involving arrays.

/*-----------------*/
/* Creating Arrays */
/*-----------------*/

// Obviously, an array can always be written out manually:

x = [ 60, 62, 64, 65, 67, 69, 71, 72 ];

// For large arrays of specific values, this may be the only practical option. But, for arrays that follow some mathematical pattern, there are a variety of shortcuts.

// 'series' is a class method that populates an array using an arithmetic series. We provide the size of the array, the initial value, and an additive increment:

Array.series(12, 36, 7);

// 'geom' is a similar method that populates and array using a geometric (multiplicative) series. The third argument is used as a multiplicative increment:

Array.geom(8, 4000, 0.5);

// 'interpolation' returns an array of a specifc size whose first and last values are provided by the user, and fills in the rest with linear interpolation (i.e. equally-spaced values)

Array.interpolation(17, 4, 6);

// Even more concise than Array.series is the syntax shortcut (x..y), which returns an array starting at x and ending at y, with an increment of 1:

(20..60);

// SC will automatically figure out the correct "direction" if the second number is less than the first:

(20..-40);

// A slight syntactical modification of this shortcut lets us pick an increment other than 1:

(20, 25..60);

// Something like this, however, will fail:

(20, 25..-40);

// If we want an array of random numbers, we can wrap random number generator code in curly braces and duplicate it:

{ rrand(1, 200) } ! 16;

// 'fill' is an array class method that provides a similar option. We provide a size and a function — the interpreter will repeatedly evalute the function and populate an array with the results:

Array.fill(16, { rrand(1, 200) });

// We also have the array class methods 'rand' and 'exprand', which function similarly to the 'rrand' and 'exprand' methods defined for numbers. The same rules apply: (1) Array.rand returns an array of integers if the min/max arguments are both integers, but returns an array of floats if either the min or max is a float, and (2) with Array.exprand, the min/max values must have the same sign, and neither can be zero.

Array.rand(16, 1, 200); // uniform distribution

Array.exprand(16, 1, 100); // exponential distribution

/*--------------------------*/
/* Adding Items to an Array */
/*--------------------------*/

// The 'add' method can be used to add items to an array, increasing its size in the process, but there is a catch: every array has a fixed size, determined when it is created. Usually (if not always), this is the smallest power of two that can accommodate the number of items which initially populate the array. This means that the 'add' method may fail:

x = Array.fill(7, { rrand(0, 9) });

x.maxSize; // contains 7 items, but has a maxSize of 8

x.add(200); // add the number 200

x; // confirmed — the augmentation was successful

x.add(300); // attempt to add the number 300 — initially appears successful

x; // deception! the size of x remains 8, augmentation was unsuccessful

// One workaround is to always use '=' to assign the result of 'add' to the same variable that holds the pre-addition array:

x = x.add(300);

x; // successful!

// Without going into too much detail, this works because the act of assigning the result to the variable triggers new memory allocation, big enough to accommodate the new size. Alternatively, you can use the List class, which is marginally less efficient than arrays but has no size limitation.

// Related to the general idea of "augmenting" an array, the '++' operator can be used to concatenate two arrays:

[1, 2, 3] ++ [10, 20, 30];

/*-----------------------*/
/* Accessing Array Items */
/*-----------------------*/

// 'at' is the primary method for accessing an item stored in an array. Array items are referenced by numerical index, starting at zero. Square brackets can be used as a syntax shortcut for 'at':

x = [300, 700, 1200, 1600, 3500];

x.at(2);

x[2];

// We can also request a subset of an array:

x.at([1, 2, 3]); // items at indices 1, 2, and 3

x[[1, 2, 3]]; // syntax alternative

// The requested subset need not be contiguous:

x[[0, 2, 4]]; // items at indices 0, 2, and 4

// It's also possible to replace an item using a value assignment:

x[4] = 4800;

x; // confirm last item is now 4800

// This can also be done with 'put', providing the index and the new item:

x.put(4, 5600);

x; // confirm last item is now 5600

// We can ask whether an array includes a certain value:

x.includes(1500); // -> false

x.includes(1600); // -> true

// And we can do what is, in a sense, the opposite of what the 'at' method does: we can ask for the index of a particular item using 'indexOf'. If the array contains multiple copies of the item, it will return the lowest matching index. If the array does not contain the item, 'indexOf' returns nil.

x.indexOf(700); // -> 1

x.indexOf(800); // -> nil

// We can access the 'first' or 'last' item in an array. x.first is arguably no better than x[0], but last is useful when we don't know the exact size of the array:

x.first;

x.last;

// We can also get the greatest or least item in an array:

x.maxItem;

x.minItem;

// Similarly, we can get the index of the greatest or least item:

x.maxIndex;

x.minIndex;

/*------------------------------*/
/* Removing Items from an Array */
/*------------------------------*/

// It's not always necessary to remove items from an Array — often, it's easier to just ignore the items we don't need. But, 'removeAt' can be used to remove an item at a particular index. After removal, the array size shrinks and the remaining items "snap" together to fill the gap.

x = [25, 27, 29, 31];

x.removeAt(2); // returns 29

x; // confirm new array — 29 has been removed and the size is now 3

// 'removeAt' returns the removed item, so it's usually not a good idea to capture the result in the same variable that holds the initial array (e.g. x = x.removeAt(2)), otherwise the array will be lost.

/*--------------------*/
/* Array Manipulation */
/*--------------------*/

// The order of an array's items can be randomized with 'scramble':

(0..9).scramble;

// or reversed using 'reverse':

(0..9).reverse;

// An array of numerical values can be arranged in ascending numerical order with 'sort'. A reverse sort is achieved by sorting, then reversing:

Array.rand(10, 0, 9).sort;

Array.rand(10, 0, 9).sort.reverse;

// 'rotate' will shift the items to the right or left by a certain amount, depending on the sign and quantity of the argument provided. Any items shifted "out" of the array will wrap back around to the other side:

(0..9).rotate(1); // shift 1 slot to the right

(0..9).rotate(2); // shift 2 slots to the right

(0..9).rotate(-2); // shift 2 slots to the left

// 'mirror' will concatenate a reversed copy on the end of the receiver, "pivoting" on the last item:

(0..9).mirror;

// 'mirror1' is nearly the same as 'mirror,' but drops the last item from the mirrored array. This is helpful in avoiding repeated values when sequencing over the new array:

(0..9).mirror1;

// 'mirror2' copies, reverses, and concatenates the entire receiver:

(0..9).mirror2;

// 'dupEach' will copy each item a certain number of times, proportionally growing the size of the array to accommodate:

(0..9).dupEach(2);

/*-------------------------*/
/* Multidimensional Arrays */
/*-------------------------*/

// A multidimensional array is an array that contains at least one array as one of its items. Some multidimensional arrays might contain even more "layers" of arrays within arrays within arrays. Suppose we have an array of several "chords", each represented as an array of pitch values:

x = [ [0, 4, 7], [2, 9, 10], [5, 7, 9], [0, 4, 5] ];

// 'at' methods can be chained together in order to access items that are stored several layers deep:

x.at(2).at(1);

x[2][1]; // syntax alternative

// A multidimensional array can be 'flattened', which removes the "inter" layer of brackets. Note that 'flatten' does not alter the receiver — it merely returns a new array, and it's up to us whether we want to capture the returned value in a variable.

x.flatten; // returns a flattened array

x; // but x remains the same

x = x.flatten; // overwrite x with the flattened array

x;

// 'clump' will do the opposite — it will group the contents of an array into sub-arrays of the specified size:

x = x.clump(3);

// 'flop' is a difficult-to-visualize operation that applies to multidimensional arrays. In the case of a two-dimensional array (an array with sub-arrays that run only one level deep), it is helpful to imagine the sub arrays as being written out in a vertical stack, like this:

[ 0, 4, 7  ]
[ 2, 9, 10 ]
[ 5, 7, 9  ]
[ 0, 4, 5  ]

// 'flop' will swap the rows and columns, turning this 4x3 array into the following 3x4 array:

[ 0, 2, 5, 0 ]
[ 4, 9, 7, 4 ]
[ 7, 10, 9, 5 ]

// Observe:

x.flop;

// Array flopping can inspire some interesting and unusual manipulations of musical data, like exchanging verical/horizontal aspects of melody and harmony.

// If we have a multidimensional array with sub-arrays that run several layers deep, 'flatten' will only remove one inner layer of brackets, but 'flat' will remove all inner brackets, returning a one-dimensional array. The following multidimensional array is written out on multiple lines for clarity:

(
x = [
	[
		[0, 2, 4],
		[1, 3, 5],
		[2, 4, 6]
	],
	[
		[4, 5, 6],
		[6, 7, 8],
		[0, 1, 2]
	],
]
)

x.flatten; // from 3 to 2 layers

x.flatten.flatten; // from 3 to 2 layers, then 2 layers to 1

x.flat; // from 3 layers directly to 1 layer