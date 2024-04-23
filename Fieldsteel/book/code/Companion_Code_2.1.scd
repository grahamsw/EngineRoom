// Companion Code 2.1
// Using Argument Keywords

// Throughout this companion code, use [cmd]+[period] whenever you want to stop the sound. Let's boot the server first:

s.boot;

// The following expression produces a two-channel sine wave when evaluated. It's concise, but doesn't convey any information about what the numbers mean.

{ SinOsc.ar(300, 0, 0.1, 0) ! 2 }.play;

// This expression uses argument keywords, and produces the same result. It consumes more space, but it's more descriptive.

{ SinOsc.ar(freq: 300, phase: 0, mul: 0.1, add: 0) ! 2 }.play;

// Which style should you use? It's ultimately up to you. In some cases, particularly for methods with lots of arguments, the keyword style can be worth the space, as it helps avoid having to repeatedly check a help file. But, for simpler methods with fewer arguments, like 'pow', the verbose style can feel excessive, and maybe even a little confusing:

3.pow(aNumber: 4);

// A good observation is that a method like 'ar' doesn't semantically imply anything about its arguments, and in fact, the argument names themselves will vary based on the UGen, so a verbose style tends to be useful here. A method like 'pow', on the other hand, is a decent abbreviation of "to the power of," so the verbose style isn't nearly as helpful.

// A closer look at the SinOsc help file reveals the default values for these arguments, which are: freq = 440, phase = 0, mul = 1, and add = 0. In our example, the 'phase' and 'add' values are identical to the defaults, so we don't actually need to provide them. To provide only the 'freq' and 'mul' parameters, we can rely on keywords, and the sonic result is the same as before:

{ SinOsc.ar(freq: 300, mul: 0.1) ! 2 }.play;

// Without keywords in the expression immediately above, SC would interpret the first value as the frequency and the second as the phase, and would use the default values of 1 and 0 for 'mul' and 'add'. With a mul value that's 10 times greater than our original value, the sound would be significantly louder — perhaps even a little startling! You can try this, but you should turn your system volume down first.

// When using keywords, argument order doesn't matter. For example, swapping 'freq' and 'mul' is fine:

{ SinOsc.ar(mul: 0.1, freq: 300) ! 2 }.play;

// You can mix-and-match keyword and non-keyword styles to a limited extent. For example, the following expression is fine. The first argument doesn't have a keyword, so SC assumes it's supposed to be used for the first argument, which is 'freq'.

{ SinOsc.ar(300, mul: 0.1) ! 2 }.play;

// But, the following expression fails with a syntax error. Once you've begun using keywords in an argument enclosure, you must use keywords for all subsequent arguments. Otherwise, SC won't know what to do with the keywordless values.

{ SinOsc.ar(freq: 300, 0.1) ! 2 }.play;

// Generally, SC isn't picky about whitespace, but it matters when using keywords. As we've already seen, putting a space after each colon is fine:

{ SinOsc.ar(freq: 300, mul: 0.1) ! 2 }.play;

// Omitting the space is also fine:

{ SinOsc.ar(freq:300, mul:0.1) ! 2 }.play;

// But putting a space *before* each colon will produce a syntax error:

{ SinOsc.ar(freq :300, mul :0.1) ! 2 }.play;

// This feels a bit pedantic, but rigorous syntactical rules are intrinsic to programming languages, and computers demand that users follow these rules so that they can execute tasks precisely. As you press forward, don't be intimidated or discouraged by syntax errors (they're a natural part of the learning process). You'll learn to easily avoid them with practice. When you do stumble into a syntax error, it's often a simple fix — a forgotten semicolon, an enclosure accidentally left open, or something like that.

// Lastly, there is an IDE feature that aims to assist with argument keywords. You can try this yourself: copy the following SinOsc expression by typing it out on a new line (don't copy and paste). As soon as you type the left parenthesis symbol, you should see a small pop-up text that provides argument names and default values. Once the rectangle appears, you can press tab to auto-insert the first keyword. After typing in a value and a comma, press tab again to insert the next keyword, and so on. You can repeatedly press tab to cycle through keywords, allowing you to skip over certain arguments. Whenever your mouse cursor is inside an argument enclosure (even if it's not closed yet), the keyboard shortcut [shift]+[cmd]+[spacebar] will show the pop-up rectangle if it's not visible, and [esc] will hide it.

SinOsc.ar();

