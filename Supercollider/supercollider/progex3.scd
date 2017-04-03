(

var counter_maker;
var make_counters_gui;
counter_maker = {
	| max_count|
	var current_count = 1;
	(
		count1: {
			if (current_count == max_count) {
				format("finished counting to %", max_count).postln;
			}
			{
				current_count = current_count + 1;
				format("counting % of %", current_count, max_count).postln;
			}
		},
		reset_count: {
			format("resetting % counter at %", max_count, current_count).postln;
			current_count = 0;
		},
		max_count: {max_count}


	)
};

make_counters_gui = { |... counts |
	 var window, counter;
	window = Window("Counters",
		Rect(400, 400, 200, 50 * counts.size + 10));
	window.view.decorator = FlowLayout(window.view.bounds, 5@5, 5@5);
	counts collect: counter_maker.(_) do: { |counter|
		Button(window, Rect(0,0,190, 20))
		.states_([["Counting to: " ++ counter.max_count.asString]])
		.action = {counter.count1};
		Button(window, Rect(0,0,190, 20))
		.states_([["Reset"]])
		.action = { counter.reset_count };
	};
	window.front;
};
make_counters_gui.(5, 10, 27);
)


(
var degrees, window,  button;
window = Window("melodies", Rect(400, 400, 200,200));
button = Button(window, window.view. bounds.insetBy(10, 10));
button.states = [["add a note"]];
button.action = {
	degrees = degrees add: 0.rrand(15);
	Pbind(\degree, Pseq(degrees), \dur, Prand([0.1, 0.2, 0.4], inf)).play;
};
window.front;
)

Set[1,2,3,3]

d = Dictionary[\a->8, 7 -> pi]

d[6]



a = (1..4)
a
a add: [12]
a = a.add(12)
a.detect(_>=4)

a.reverse
b = Array.fill(10, {|x| 10.rand()})

b.pyramid(3)
(1..3).pyramid(6)


(1..10).do({|i|
	(1..4).pyramid(i).postcs;
});

b.clump(5)