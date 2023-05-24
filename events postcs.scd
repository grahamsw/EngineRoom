Event.eventTypes.keys.postcs

Event.parentEvents.default[\type].postcs

Event.eventTypes[\note].postcs

Event.parentEvents.default[\play].postcs


(
p = Pbind(
    \dur, 1,
    \degree, Prand(
        [
            Pseq((0..1), 1),
            Rest()
        ], inf
    ).trace
);
p.play
)

().play




t = TempoClock()

~po = {t.beats.postln; 1}

~po.()