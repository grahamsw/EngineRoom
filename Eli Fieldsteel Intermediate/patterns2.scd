q = Pbind(\freq, 300, \dur, Pn(0.3, 2));



a = q.asStream

a.next(()).asOSC
e = a.next(())

~a = 6

.defaultParentEvent

currentEnvironment
topEnvironment

q.trace.play;

// Sound-wise ineffective modification of the incoming stream
p = Pbind(\degree, 6) <> q;
p.trace.play;

// Instead
p = Pbind(\degree, 6) <> Pfunc { |ev| ev.freq = nil } <> q;
p.trace.play;


~dur = [3,1,1,1]/8;
p = Pbind(\degree, Pseq([0, 2, 4, 7], inf)) <> Pbind(\dur, Pseq(~dur, inf)) <> Pbind(\amp, Pseq([0.2, 0.05, 0.05], inf))

p.play

Event.default[\eventTypes].do({|f| f.)



(

a = Pbind(\scale, Pn(Pstep([[0,2,4,5,7,9,11],[0,1,3,5,6,8,11]], 5)),
    \db, Pn(Pseg([-20,-6,-50, -60], 10))
);
b = Pbind(
    \degree, Pbrown(0, 6,1),
    \mtranspose, Prand([\rest, Pseq([0], 5.rand)], inf),
    \dur, 0.2,
    \octave, 6
);

c = Pbind(
    \degree, [0,2,4],
    \mtranspose, Pbrown(0, 6,1),
    \dur, 0.4,
    \db, -35
);

d = Pchain(Ppar([b,c]), a);

d.play

)