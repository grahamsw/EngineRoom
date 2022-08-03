/*
//OPTIONAL Problem Set Week 12
//Due 3pm CDT Thursday November 19th

//First, save this scd file as a new file, renaming it with your Last name at the beginning of the file name (e.g. "Fieldsteel Problem Set Week 12.scd").

Problem 1.
Create a tic-tac-toe game for two human players sharing the same computer. The game should have the following features:

- A window containing 9 buttons arranged in a 3x3 grid, each with three states (blank, X, O).

- The game should keep track of whose turn it is. The first clicked button should change to the "X" state, the next clicked button should change to the "O" state, and this process should alternate.

- Players should only be able to click blank buttons. Once a button is clicked, it should become un-clickable (use the 'enabled' method, setting it equal to 'false' to make a Button uninteractable).

- After each button click, the game should check for a win. If a win is detected, post "X wins" or "O wins" in the post window. If all buttons are claimed but there is no three-in-a-row, post "draw" in the post window. You can check for a win by iterating over all eight possible "win" lines and checking if their states are equal at non-blank. You can check for a draw if the win case returns false but if no buttons are in their blank state.

- Include a reset button that resets all buttons to their blank state, re-enables all buttons to be clickable, and makes it X's turn.

- If you're feeling motivated, add some code so that the game will produce a unique sound for all three possible outcomes (X wins, O wins, draw).
*/

(
Window.closeAll;

~turn = 0; //if 0, it is X's turn. if 1, it is O's turn

//main window
w = Window.new("tic tac toe", Rect(20, 20, 340, 380)).front;

//use FlowLayout to avoid having to position each button manually
w.view.decorator_(FlowLayout.new(w.view.bounds, 10@10, 10@10));

//fill an array with the nine buttons
~playButtons = Array.fill(9, {
	Button.new(w, 100@100)
	.states_([
		//three states for each button,
		//vacant, claimed by X, claimed by O
		[\ , Color.white, Color.gray(0.9)],
		[\X, Color.blue, Color.gray(0.9)],
		[\O, Color.red, Color.gray(0.9)],
	])
	.canFocus_(false)
	.font_(Font(Font.defaultSansFace, 90))
	.action_({
		arg btn;
		//when a button is pressed, set its state according to whose turn it is
		btn.value_(~turn+1);

		//now it's the other player's turn
		~turn = 1 - ~turn;

		//the button has been claimed, so it can't be clicked again
		btn.enabled_(false);

		//after each button click, test for a win by evaluating this function
		~testForWin.value;
	});
});

//when the game ends, a reset button to play again
~resetButton = Button(w, 100@30)
.states_([[\reset, Color.black, Color.white]])
.canFocus_(false)
.action_({
	arg btn;

	//when reset is clicked, iterate over 9 buttons, enable them, and reset their state to 0 (vacant).
	~playButtons.do({
		arg btn;
		btn.enabled_(true);
		btn.value_(0);
		~turn = 0; //reset turn order to X's turn
	});
});

~testForWin = {
	var winner=false;
	[
		//array contains all eight arrays of three indices corresponding to a three-in-a-row win
		[0,1,2], //e.g. top row,
		[3,4,5], //middle row,
		[6,7,8],
		[0,3,6], //leftmost column,
		[1,4,7],
		[2,5,8],
		[0,4,8], //top left-to-bottom right diagonal
		[2,4,6]
	].do{
		//iterate over this collection, and test each three-in-a-row for a win
		arg winLine;
		winLine = winLine.collect({
			arg index;
			//return an array corresponding to the current state of the current three-in-a-row line being tested
			~playButtons[index].value;
		});

		//after testing the first row (indices [0,1,2]), e.g.:
		//if this row contains [ ] [O] [X], winLine == [0,2,1]
		//if this row contains [X] [ ] [ ], winLine == [1,0,0]

		case

		//every item in current test line == 1?
		{winLine.every({arg n; n == 1})}
		{
			//if so, X wins. disable all buttons.
			"X wins!".postln;
			winner = true;
			~playButtons.collect(_.enabled_(false));
		}

		//every item in current test line == 2?
		{winLine.every({arg n; n == 2})}
		{
			//if so, O wins. disable all buttons.
			"O wins!".postln;
			winner = true;
			~playButtons.collect(_.enabled_(false));
		}

		//otherwise, do nothing
		{true}{nil};
	};

	//are all buttons claimed, with no winning line?
	if(
		(
			~playButtons.collect({
				arg btn; btn.value
			}).includes(0).not
		) && (winner.not),

		{"draw!".postln}
	);
};
)