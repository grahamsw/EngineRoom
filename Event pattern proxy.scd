p = Pbind(\degree, Pseries(0, 1, 8), \dur, 0.5);


(
~proxy = EventPatternProxy();
~proxy.source_(
    Pbind(\degree, Pseq([0, 1, 2,3], 1), \dur, 0.4);
);
)
(



(
~proxy.play;  // an EventStreamPlayer
// you're watching the *player* (not the pattern)
x = SimpleController(~proxy.player)
.put(\stopped, {
	x.remove;  // mandatory cleanup
    ~proxy.source_(
        Pbind(\degree, Pseq([7,6,5,4], 1), \dur, 0.1);
     );
	"here is where you'd do whatever you need".postln;
});
)


Window.screenBounds