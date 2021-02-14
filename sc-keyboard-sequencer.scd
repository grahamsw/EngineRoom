


(

var notes = (60-24 .. 60 + 24);
var keyHeight = 80;
var keyWidth = 20;
var numKeys = notes.size;
var whiteKeys = [0,2,4,5,7,9,11];
var blackKeys = [1,3,6,8,10];
var isWhiteKey = {
	|note|
	whiteKeys.includes(note%12)
};

var keyX = {
	|note|
	var numPrevWhiteKeys = notes.collect({
		|n|
		if ((n < note) && (isWhiteKey.(n)), {1}, {0})
	}).sum;
	var xPos = numPrevWhiteKeys * keyWidth;
	xPos = if(isWhiteKey.(note), {xPos}, {xPos - (keyWidth/2)});
	//[note, xPos].postln;
	xPos;
};

var keyRect = {
	|note|
	var kh = keyHeight * if(isWhiteKey.(note), {1}, {0.6});
	Rect(keyX.(note), 0, keyWidth, kh)
};

var createButton = {
	|note|
	var btnText = if(isWhiteKey.(note), {"  \n  \n"++note}, {note});
			b = Button.new(w, keyRect.(note) );
	b.states = if (isWhiteKey.(note), {[[note, Color.black]]}, {[[btnText, Color.white, Color.black]]});
    b.action_({
		|btn|
		(\midinote: note ).play;
		note.postln;
	});
};


Window.closeAll;
w = Window.new("keyboard", Rect(20,20, keyWidth * notes.select(isWhiteKey).size, keyHeight)).front.alwaysOnTop_(true);

notes.select(isWhiteKey).do(createButton);
notes.reject(isWhiteKey).do(createButton);


20*25
)




(\note: 60).play

