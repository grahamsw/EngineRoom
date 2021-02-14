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

~player = "X";

~checkWin = {
	var ret = false;
	3.do{|i|
		ret = ret || if ((~vals[i][0] == ~vals[i][1]) && (~vals[i][1] == ~vals[i][2]), {~vals[i][0]}, {false});
		ret = ret || if ((~vals[0][i] == ~vals[1][i]) && (~vals[1][i] == ~vals[2][i]), {~vals[0][i]}, {false});
};
ret;
};

~togglePlayer = {
	if (~player == "X", {~player = "O"}, {~player = "X"});
};
~vals = Array.fill(3, {Array.fill(3)});
~makeButton = {
	|w, x, y, width, height|
	var button = Button.new(w, Rect(x*width, y*width, width, height))
	.states_([
		[""], ["X"], ["O"]
	])
	.font_(Font(Font.defaultSansFace, 90))
	.action_({ arg button;
		~vals[x][y] = ~player;
		~vals.postln;
		button.value_(if(~player == "X", {1},{2}));
		button.enabled_(false);
		~togglePlayer.();
		~checkWin.value.postln;

	});
	button;
};


Window.closeAll;
~width = 70;
~height = 70;
w = Window.new("tic tac fuck me", Rect(50, 50, 3*~width, 3*~height + 50))
    .front
    .alwaysOnTop_(true)
 .background_(Color.magenta);
~buttons = [[0,0], [0,1], [0,2],
	[1,0],[1,1], [1,2],
	[2,0], [2,1], [2,2]].collect({
	 |ps|
	~makeButton.(w, ps[0], ps[1], ~width, ~height);
});


)
~vals
~vals[0][0]==~vals[0][1]==~vals[0][2]
~checkWin.value