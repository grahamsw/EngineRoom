



(
var wA, wB, wC;

(PathName(thisProcess.nowExecutingPath).pathOnly ++ "windmillFactory.scd").loadPaths;

wA = ~windmillFactory.(150@150, 150, 15, [Color.red, Color.magenta]);
wB = ~windmillFactory.(100@500, 80, 23, [Color.magenta, Color.black]);
wC = ~windmillFactory.(400@420, 200, 9, [Color.black, Color.blue]);

Window.new("", 640@640).background_(Color.white).front.drawFunc_({
	wA.draw();
	wB.draw();
	wC.draw();
});
)





