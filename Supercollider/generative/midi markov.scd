
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



