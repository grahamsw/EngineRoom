(

Tdef(\a, {10.do {
    (instrument: \wave,
        freq: 50.rand * 1500).play;
    0.03.wait

}});

Tdef(\b, {[1,5,1,2,8,4,12].do {|x|
    (instrument: \wave, note: x+20).play; 0.1.wait;
}
}
);

Tdef(\c, {"c is just waiting".postln; 2.wait;});
Tdef(\x,
    {
        loop{
            Tdef(\a).embed;
            1.wait;
            Tdef(\b).embed;
            2.wait;
            Tdef(\a).fork;
            Tdef(\b).fork;
            Tdef(\c).embed;
        }
    }
).play;
)

Tdef(\a, {inf.do{(instrument:\wave, freq:50.rand + 500).play; 0.1.wait;}})

Tdef(\a, {10.do{(instrument:\wave, freq:50.rand + 1500).play; 0.1.wait;}})


(
Tdef(\a, {
    |in|
    in.at(\n).do{
        |i|
        in = (instrument: \wave, detune: 5.rand2).putAll(in);
        in .postln.play;
        in.delta.wait;

    }
});
)

(
Tdef(\x, {
    |inevent|
    loop {
        Tdef(\a).embed((note:[15,17], dur: 0.01, n:13));
        1.wait;
        Tdef(\a).embed((note: 9, dur: 0.5, n: 4));
        1.wait;
    }
}).play;
)

Tdef(\x).fadeTime(3)


)


)