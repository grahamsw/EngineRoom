(
~swingify = Prout({ |ev|
    var now, nextTime = 0, thisShouldSwing, nextShouldSwing = false, adjust;
    while { ev.notNil } {
        // current time is what was "next" last time
        now = nextTime;
        nextTime = now + ev.delta;
        thisShouldSwing = nextShouldSwing;
        nextShouldSwing = ((nextTime absdif: nextTime.round(ev[\swingBase])) <= (ev[\swingThreshold] ? 0)) and: {
            (nextTime / ev[\swingBase]).round.asInteger.odd
        };
        adjust = ev[\swingBase] * ev[\swingAmount];
        // an odd number here means we're on an off-beat
        if(thisShouldSwing) {
            ev[\timingOffset] = (ev[\timingOffset] ? 0) + adjust;
            // if next note will not swing, this note needs to be shortened
            if(nextShouldSwing.not) {
                ev[\sustain] = ev.use { ~sustain.value } - adjust;
            };
        } {
            // if next note will swing, this note needs to be lengthened
            if(nextShouldSwing) {
                ev[\sustain] = ev.use { ~sustain.value } + adjust;
            };
        };
        ev = ev.yield;
    };
});
)



p = Pbind(\degree, Pseries(0, 1, 8), \dur, 0.25);
​
p.play;  // straight 16ths
​
// swingBase: 0.25: Every other 16th-note is delayed
// swingAmount: 1/3: Off-beat notes will be delayed by 1/3 of a 16th-note
Pchain(~swingify, p, (swingBase: 0.25, swingAmount: 1/6)).play;
​
// note duration = twice swingBase, no swing (correct)
Pchain(~swingify, Pstretch(2, p), (swingBase: 0.25, swingAmount: 1/3)).play;
​
// hear the result of different swing amounts
(
Ppar([
    // 60% of a 16th-note
    Pchain(~swingify, p, (swingBase: 0.25, swingAmount: 0.6, pan: -1)),
    // 20% of a 16th-note
    Pchain(~swingify, p, (swingBase: 0.25, swingAmount: 0.2, pan: 1, octave: 6))
]).play;
)
​
​
(
q = Ppar([
    // walking bass (by a bass player who only chooses notes randomly)
    Pbind(
        \octave, 3,
        \degree, Pwhite(0, 7, inf),
        \dur, 0.5
    ),
    Pseq([
        Pchain(
            ~swingify,
            Pbind(
                \degree, Pseries(-7, 1, 15) +.x Pseq([0, 9], 1),
                \dur, Pwhite(1, 3, inf) * 0.25
            ),
            (swingBase: 0.25, swingAmount: 0.2)
        ),
        Pfuncn({ q.stop; Event.silent(1) }, 1)
    ])
]).play;
)
Examples