_.isPrime ! 10

{|x| x.isPrime} ! 10

(_@_).(30, 40)

(1..8).collect([\a, \b, _])

(a: _, b: _, c: _).(*Array.rand(3, 0, 100))


Server.default.boot;
(
var window, routine;
window = Window("close me to stop").front;
window.onClose = {routine.stop};
routine = {
	loop {
		(degree: -10 + 30.xrand, dur: 0.05, amp:0.6.rand).play;
		0.05.rand.wait;
	}
}.fork;

routine.def.sourceCode.postln
)

(
var foo;
foo = {|x, y| a.pow(b)};
foo.def.sourceCode.postln;
)


(
~fff = {|path|
	var thisFunc = thisFunction;
	format("===== now exploring: %", path).postln;
	path.pathMatch do: { |p|
		if (p.last == $/) {thisFunc.(p ++ "*") }{ p.postln;}
	}
}.("*")
)





		