
(
~readNotes = {|midi|

	l = List.new;
	e = midi.midiTrackEvents(0).do({
		|evt|
		if ( evt[2] == \noteOn,
		{l.add(evt[4])});
	});

	l;
    };
)

(
d = PathName("/home/grahamsw/Documents/dev/EngineRoom/Supercollider/midi/CC_assignment_3/IOACAS_QBH/midfile").entries.collect({|mf|
//	mf;
	SimpleMIDIFile.read(mf.fullPath);
});
)
e = d.collect ({|midi| ~readNotes.(midi)});
)


(
~chain = Dictionary.new;
~addToChain = {
	| first, second |
	var dict = ~chain.atFail(first, { ~chain.add( first -> Dictionary.new); ~chain.at(first); });
	var count = dict.atFail(second, { dict.add(second -> 0); 0; });
	~chain[first][second] = count + 1;
};


e.do({
	|notes|
	~addToChain.("s",notes[0]);
	(notes.size -2).do{
		|ix|
		~addToChain.(notes[ix], notes[ix+1]);
	}
});

)
(
~pickNext = {
	|note|
	var dict = ~chain[note];
	dict.keys.asArray.wchoose(dict.values.asArray.normalizeSum);
};

~makeTune = {
    |numNotes|
	var tune = List.new;
	var note = ~pickNext.("s");
	tune.add(note);
	(numNotes - 1).do({
		note = ~pickNext.(note);
		tune.add(note);
	});
	tune.asArray;
};
)

t = ~makeTune.(100);
(
p = Pdef(\tune,
	Pbind(\midinote, Pseq(t))
);
)


p.play

