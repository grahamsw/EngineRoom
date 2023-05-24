// Orchestral Sound texture v1

(
s.options.numBuffers = 1024 * 32;
//increase the memory available to the server
s.options.memSize = 8192 * 128;
)
//boot the server
s.boot;



//LOAD SAMPLES //////////////////////////////////////////////////////////////////

// VIOLINS 1
(
var tmp_buffers;
var tmp_array;
var path;

// 1. load samples from a folder extracting only one channel from the stereo files
path = PathName("/home/nicola/Musica/samples/Sonatina Symphonic Orchestra/Samples/1st Violins/");
path.entries.do{
	|item|
	if( item.fileName.contains("1st-violins-sus-"),
		{
			//item.fileName.postln;
			//item.fullPath.postln;
			tmp_buffers = tmp_buffers.add( Buffer.readChannel(s, item.fullPath, channels:1));

		},{	//do nothing
		}
	);
};

// 2. create an array of dictionaries
tmp_array = Array.newClear();

tmp_buffers.do{
  |item, index|
  var d = Dictionary.new;
  var string = PathName(item.path).fileNameWithoutExtension;
  var output = string.findRegexp("[abcdefgABCDEFG]#?[0123456789]");
  var noteNameAll = output[0][1];
  var octNumber = noteNameAll.rotate(1)[0].asString.asInteger;
  var noteName = noteNameAll[0].asString;
  var isSharp = noteNameAll.contains("#"); // boolean
  //[noteNameAll, noteName, octNumber, isSharp].postln;
  var midiNumber = (octNumber +1) * 12;
  switch( noteName,
    "c", { midiNumber = midiNumber+0; },
    "d", { midiNumber = midiNumber+2; },
    "e", { midiNumber = midiNumber+4; },
    "f", { midiNumber = midiNumber+5; },
    "g", { midiNumber = midiNumber+7; },
    "a", { midiNumber = midiNumber+9; },
    "b", { midiNumber = midiNumber+11; },
  );
  if(isSharp, {midiNumber = midiNumber + 1;});
  [noteNameAll, noteName, isSharp, octNumber, midiNumber].postln;
  d.add(\midi -> midiNumber.asInteger);
  d.add(\note -> noteNameAll);
  d.add(\buffer -> item);
  tmp_array = tmp_array.add(d);
};

tmp_array.sortBy(\midi);

~violins_1st_sus_lowest_note = tmp_array[0][\midi];
~violins_1st_sus_buffers = Array.newClear();
~violins_1st_sus_midinotes = Array.newClear();

tmp_array.do{
  |item, index|
  [index, item.values].postln;
  ~violins_1st_sus_buffers   = ~violins_1st_sus_buffers.add(item[\buffer]);
  ~violins_1st_sus_midinotes = ~violins_1st_sus_midinotes.add(item[\midi]);
};
)


// VIOLINS 2
(
var tmp_buffers;
var tmp_array;
var path;

// 1. load samples from a folder extracting only one channel from the stereo files
path = PathName("/home/nicola/Musica/samples/Sonatina Symphonic Orchestra/Samples/2nd Violins/");
path.entries.do{
	|item|
	if( item.fileName.contains("2nd-violins-sus-"),
		{
			//item.fileName.postln;
			//item.fullPath.postln;
			tmp_buffers = tmp_buffers.add( Buffer.readChannel(s, item.fullPath, channels:1));

		},{	//do nothing
		}
	);
};

// 2. create an array of dictionaries
tmp_array = Array.newClear();

tmp_buffers.do{
  |item, index|
  var d = Dictionary.new;
  var string = PathName(item.path).fileNameWithoutExtension;
  var output = string.findRegexp("[abcdefgABCDEFG]#?[0123456789]");
  var noteNameAll = output[0][1];
  var octNumber = noteNameAll.rotate(1)[0].asString.asInteger;
  var noteName = noteNameAll[0].asString;
  var isSharp = noteNameAll.contains("#"); // boolean
  //[noteNameAll, noteName, octNumber, isSharp].postln;
  var midiNumber = (octNumber +1) * 12;
  switch( noteName,
    "c", { midiNumber = midiNumber+0; },
    "d", { midiNumber = midiNumber+2; },
    "e", { midiNumber = midiNumber+4; },
    "f", { midiNumber = midiNumber+5; },
    "g", { midiNumber = midiNumber+7; },
    "a", { midiNumber = midiNumber+9; },
    "b", { midiNumber = midiNumber+11; },
  );
  if(isSharp, {midiNumber = midiNumber + 1;});
  [noteNameAll, noteName, isSharp, octNumber, midiNumber].postln;
  d.add(\midi -> midiNumber.asInteger);
  d.add(\note -> noteNameAll);
  d.add(\buffer -> item);
  tmp_array = tmp_array.add(d);
};

tmp_array.sortBy(\midi);

~violins_2nd_sus_lowest_note = tmp_array[0][\midi];
~violins_2nd_sus_buffers = Array.newClear();
~violins_2nd_sus_midinotes = Array.newClear();

tmp_array.do{
  |item, index|
  [index, item.values].postln;
  ~violins_2nd_sus_buffers   = ~violins_2nd_sus_buffers.add(item[\buffer]);
  ~violins_2nd_sus_midinotes = ~violins_2nd_sus_midinotes.add(item[\midi]);
};
)



// CELLO

(
var tmp_buffers;
var tmp_array;
var path;

// 1. load samples from a folder extracting only one channel from the stereo files
path = PathName("/home/nicola/Musica/samples/Sonatina Symphonic Orchestra/Samples/Celli/");
path.entries.do{
	|item|
	if( item.fileName.contains("celli-sus-"),
		{
			//item.fileName.postln;
			//item.fullPath.postln;
			tmp_buffers = tmp_buffers.add( Buffer.readChannel(s, item.fullPath, channels:1));

		},{	//do nothing
		}
	);
};

// 2. create an array of dictionaries
tmp_array = Array.newClear();

tmp_buffers.do{
  |item, index|
  var d = Dictionary.new;
  var string = PathName(item.path).fileNameWithoutExtension;
  var output = string.findRegexp("[abcdefgABCDEFG]#?[0123456789]");
  var noteNameAll = output[0][1];
  var octNumber = noteNameAll.rotate(1)[0].asString.asInteger;
  var noteName = noteNameAll[0].asString;
  var isSharp = noteNameAll.contains("#"); // boolean
  //[noteNameAll, noteName, octNumber, isSharp].postln;
  var midiNumber = (octNumber +1) * 12;
  switch( noteName,
    "c", { midiNumber = midiNumber+0; },
    "d", { midiNumber = midiNumber+2; },
    "e", { midiNumber = midiNumber+4; },
    "f", { midiNumber = midiNumber+5; },
    "g", { midiNumber = midiNumber+7; },
    "a", { midiNumber = midiNumber+9; },
    "b", { midiNumber = midiNumber+11; },
  );
  if(isSharp, {midiNumber = midiNumber + 1;});
  [noteNameAll, noteName, isSharp, octNumber, midiNumber].postln;
  d.add(\midi -> midiNumber.asInteger);
  d.add(\note -> noteNameAll);
  d.add(\buffer -> item);
  tmp_array = tmp_array.add(d);
};

tmp_array.sortBy(\midi);

~celli_sus_lowest_note = tmp_array[0][\midi];
~celli_sus_buffers = Array.newClear();
~celli_sus_midinotes = Array.newClear();

tmp_array.do{
  |item, index|
  [index, item.values].postln;
  ~celli_sus_buffers   = ~celli_sus_buffers.add(item[\buffer]);
  ~celli_sus_midinotes = ~celli_sus_midinotes.add(item[\midi]);
};
)


// BASSES

(
var tmp_buffers;
var tmp_array;
var path;

// 1. load samples from a folder extracting only one channel from the stereo files
path = PathName("/home/nicola/Musica/samples/Sonatina Symphonic Orchestra/Samples/Basses/");
path.entries.do{
	|item|
	if( item.fileName.contains("basses-sus-"),
		{
			//item.fileName.postln;
			//item.fullPath.postln;
			tmp_buffers = tmp_buffers.add( Buffer.readChannel(s, item.fullPath, channels:1));

		},{	//do nothing
		}
	);
};

// 2. create an array of dictionaries
tmp_array = Array.newClear();

tmp_buffers.do{
  |item, index|
  var d = Dictionary.new;
  var string = PathName(item.path).fileNameWithoutExtension;
  var output = string.findRegexp("[abcdefgABCDEFG]#?[0123456789]");
  var noteNameAll = output[0][1];
  var octNumber = noteNameAll.rotate(1)[0].asString.asInteger;
  var noteName = noteNameAll[0].asString;
  var isSharp = noteNameAll.contains("#"); // boolean
  //[noteNameAll, noteName, octNumber, isSharp].postln;
  var midiNumber = (octNumber +1) * 12;
  switch( noteName,
    "c", { midiNumber = midiNumber+0; },
    "d", { midiNumber = midiNumber+2; },
    "e", { midiNumber = midiNumber+4; },
    "f", { midiNumber = midiNumber+5; },
    "g", { midiNumber = midiNumber+7; },
    "a", { midiNumber = midiNumber+9; },
    "b", { midiNumber = midiNumber+11; },
  );
  if(isSharp, {midiNumber = midiNumber + 1;});
  [noteNameAll, noteName, isSharp, octNumber, midiNumber].postln;
  d.add(\midi -> midiNumber.asInteger);
  d.add(\note -> noteNameAll);
  d.add(\buffer -> item);
  tmp_array = tmp_array.add(d);
};

tmp_array.sortBy(\midi);

~basses_sus_lowest_note = tmp_array[0][\midi];
~basses_sus_buffers = Array.newClear();
~basses_sus_midinotes = Array.newClear();

tmp_array.do{
  |item, index|
  [index, item.values].postln;
  ~basses_sus_buffers   = ~basses_sus_buffers.add(item[\buffer]);
  ~basses_sus_midinotes = ~basses_sus_midinotes.add(item[\midi]);
};
)


// OBOES

(
var tmp_buffers;
var tmp_array;
var path;

// 1. load samples from a folder extracting only one channel from the stereo files
path = PathName("/home/nicola/Musica/samples/Sonatina Symphonic Orchestra/Samples/Oboes/");
path.entries.do{
	|item|
	if( item.fileName.contains("oboes-sus-"),
		{
			//item.fileName.postln;
			//item.fullPath.postln;
			tmp_buffers = tmp_buffers.add( Buffer.readChannel(s, item.fullPath, channels:1));

		},{	//do nothing
		}
	);
};

// 2. create an array of dictionaries
tmp_array = Array.newClear();

tmp_buffers.do{
  |item, index|
  var d = Dictionary.new;
  var string = PathName(item.path).fileNameWithoutExtension;
  var output = string.findRegexp("[abcdefgABCDEFG]#?[0123456789]");
  var noteNameAll = output[0][1];
  var octNumber = noteNameAll.rotate(1)[0].asString.asInteger;
  var noteName = noteNameAll[0].asString;
  var isSharp = noteNameAll.contains("#"); // boolean
  //[noteNameAll, noteName, octNumber, isSharp].postln;
  var midiNumber = (octNumber +1) * 12;
  switch( noteName,
    "c", { midiNumber = midiNumber+0; },
    "d", { midiNumber = midiNumber+2; },
    "e", { midiNumber = midiNumber+4; },
    "f", { midiNumber = midiNumber+5; },
    "g", { midiNumber = midiNumber+7; },
    "a", { midiNumber = midiNumber+9; },
    "b", { midiNumber = midiNumber+11; },
  );
  if(isSharp, {midiNumber = midiNumber + 1;});
  [noteNameAll, noteName, isSharp, octNumber, midiNumber].postln;
  d.add(\midi -> midiNumber.asInteger);
  d.add(\note -> noteNameAll);
  d.add(\buffer -> item);
  tmp_array = tmp_array.add(d);
};

tmp_array.sortBy(\midi);

~oboes_sus_lowest_note = tmp_array[0][\midi];
~oboes_sus_buffers = Array.newClear();
~oboes_sus_midinotes = Array.newClear();

tmp_array.do{
  |item, index|
  [index, item.values].postln;
  ~oboes_sus_buffers   = ~oboes_sus_buffers.add(item[\buffer]);
  ~oboes_sus_midinotes = ~oboes_sus_midinotes.add(item[\midi]);
};
)

// BASSON

(
var tmp_buffers;
var tmp_array;
var path;

// 1. load samples from a folder extracting only one channel from the stereo files
path = PathName("/home/nicola/Musica/samples/Sonatina Symphonic Orchestra/Samples/Bassoons/");
path.entries.do{
	|item|
	if( item.fileName.contains("bassoons-sus-"),
		{
			//item.fileName.postln;
			//item.fullPath.postln;
			tmp_buffers = tmp_buffers.add( Buffer.readChannel(s, item.fullPath, channels:1));

		},{	//do nothing
		}
	);
};

// 2. create an array of dictionaries
tmp_array = Array.newClear();

tmp_buffers.do{
  |item, index|
  var d = Dictionary.new;
  var string = PathName(item.path).fileNameWithoutExtension;
  var output = string.findRegexp("[abcdefgABCDEFG]#?[0123456789]");
  var noteNameAll = output[0][1];
  var octNumber = noteNameAll.rotate(1)[0].asString.asInteger;
  var noteName = noteNameAll[0].asString;
  var isSharp = noteNameAll.contains("#"); // boolean
  //[noteNameAll, noteName, octNumber, isSharp].postln;
  var midiNumber = (octNumber +1) * 12;
  switch( noteName,
    "c", { midiNumber = midiNumber+0; },
    "d", { midiNumber = midiNumber+2; },
    "e", { midiNumber = midiNumber+4; },
    "f", { midiNumber = midiNumber+5; },
    "g", { midiNumber = midiNumber+7; },
    "a", { midiNumber = midiNumber+9; },
    "b", { midiNumber = midiNumber+11; },
  );
  if(isSharp, {midiNumber = midiNumber + 1;});
  [noteNameAll, noteName, isSharp, octNumber, midiNumber].postln;
  d.add(\midi -> midiNumber.asInteger);
  d.add(\note -> noteNameAll);
  d.add(\buffer -> item);
  tmp_array = tmp_array.add(d);
};

tmp_array.sortBy(\midi);

~bassoons_sus_lowest_note = tmp_array[0][\midi];
~bassoons_sus_buffers = Array.newClear();
~bassoons_sus_midinotes = Array.newClear();

tmp_array.do{
  |item, index|
  [index, item.values].postln;
  ~bassoons_sus_buffers   = ~bassoons_sus_buffers.add(item[\buffer]);
  ~bassoons_sus_midinotes = ~bassoons_sus_midinotes.add(item[\midi]);
};
)


// CLARINETS

(
var tmp_buffers;
var tmp_array;
var path;

// 1. load samples from a folder extracting only one channel from the stereo files
path = PathName("/home/nicola/Musica/samples/Sonatina Symphonic Orchestra/Samples/Clarinets/");
path.entries.do{
	|item|
	if( item.fileName.contains("clarinets-sus-"),
		{
			//item.fileName.postln;
			//item.fullPath.postln;
			tmp_buffers = tmp_buffers.add( Buffer.readChannel(s, item.fullPath, channels:1));

		},{	//do nothing
		}
	);
};

// 2. create an array of dictionaries
tmp_array = Array.newClear();

tmp_buffers.do{
  |item, index|
  var d = Dictionary.new;
  var string = PathName(item.path).fileNameWithoutExtension;
  var output = string.findRegexp("[abcdefgABCDEFG]#?[0123456789]");
  var noteNameAll = output[0][1];
  var octNumber = noteNameAll.rotate(1)[0].asString.asInteger;
  var noteName = noteNameAll[0].asString;
  var isSharp = noteNameAll.contains("#"); // boolean
  //[noteNameAll, noteName, octNumber, isSharp].postln;
  var midiNumber = (octNumber +1) * 12;
  switch( noteName,
    "c", { midiNumber = midiNumber+0; },
    "d", { midiNumber = midiNumber+2; },
    "e", { midiNumber = midiNumber+4; },
    "f", { midiNumber = midiNumber+5; },
    "g", { midiNumber = midiNumber+7; },
    "a", { midiNumber = midiNumber+9; },
    "b", { midiNumber = midiNumber+11; },
  );
  if(isSharp, {midiNumber = midiNumber + 1;});
  [noteNameAll, noteName, isSharp, octNumber, midiNumber].postln;
  d.add(\midi -> midiNumber.asInteger);
  d.add(\note -> noteNameAll);
  d.add(\buffer -> item);
  tmp_array = tmp_array.add(d);
};

tmp_array.sortBy(\midi);

~clarinets_sus_lowest_note = tmp_array[0][\midi];
~clarinets_sus_buffers = Array.newClear();
~clarinets_sus_midinotes = Array.newClear();

tmp_array.do{
  |item, index|
  [index, item.values].postln;
  ~clarinets_sus_buffers   = ~clarinets_sus_buffers.add(item[\buffer]);
  ~clarinets_sus_midinotes = ~clarinets_sus_midinotes.add(item[\midi]);
};
)


// SYNTH DEFS

(
SynthDef(\play_orchestra, {
	|out=0,amp=0.5, gate=1, buf, rate=1.0,pan=0.0, atk=0.01, dcy=0.2, sus=0.7, rel=0.1|
	var sig, env;
	env = EnvGen.ar(Env.adsr(atk, dcy, sus, rel), gate, doneAction:2);
	sig = Mix.ar(PlayBuf.ar(2, buf, BufRateScale.ir(buf)*rate, 1, doneAction:0));
	sig = sig * amp * env;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)

// a synth to play buffers in a granular way
// NOTE: you will need buffers to be loaded as MONO !!!
(
SynthDef(\grain_buffer, {
	|out=0, gate=1, amp=0.9, buf, atk=5, rel=5, rate=1, pan=0.0|
    var sig, env;

	var density = LFNoise0.kr(25).range(1, 5);
	var trigger = Impulse.kr( density );
	var pos = 0.5 + TRand.kr(trigger, -0.35, 0.35);
	var length = 1 + TRand.kr(trigger, 0.25, 0.35);

	env = EnvGen.kr(Env.asr(atk, 1, rel, -4), gate, doneAction:2);

    sig = GrainBuf.ar(2,
		trigger,
		length,
		buf,
		rate,
		pos,
		2,
		pan: pan);

	sig = sig * amp * env;
	Out.ar(out, sig);
}).add;
)


(
SynthDef(\verb, {
	|out=0, mix=0.6, room=0.8, damp=0.6|
    var in;
    in = In.ar(out, 2);
	in = FreeVerb.ar(in, mix, room, damp);
	Out.ar(out, Pan2.ar(in));
}).add;
)

// PATTERNS

~root = 0; // also try to use 5, 7 and 9

(
~violins_1st_sus_pattern = Pbind(
	\instrument, \grain_buffer,
	\scale, Scale.major,
	\root, Pfunc({~root}),
	\octave, Pwrand([5,6,7],[1,0.5, 0.125].normalizeSum, inf),
	\degree, Pxrand([1, 4, 5], inf)-1,
	\index, Pfunc { |e| ((e.use{ ~midinote.()} - ~violins_1st_sus_lowest_note-1)/3).floor },
	\buf, Pindex(~violins_1st_sus_buffers, Pkey(\index)),
	\rate, (Pfunc{ |e| e.use {~midinote.()}} - Pindex(~violins_1st_sus_midinotes, Pkey(\index))).midiratio,
	\amp, Pwhite(0.05, 0.1, inf),
	\dur, Pwhite(4,8, inf),
	\type, Pwrand([\note, \rest], [1,0.25].normalizeSum, inf),
	\atk, Pkey(\dur) * 0.6,
	\rel, Pkey(\atk),
	\out, 0,
	\pan, Pwhite(-0.8, 0.2,inf)
);

~violins_2nd_sus_pattern = Pbind(
	\instrument, \grain_buffer,
	\scale, Scale.major,
	\root, Pfunc({~root}),
	\octave, Pwhite(5,6,inf).round(1),
	\degree, Pxrand([1, 4, 5], inf)-1,
	\index, Pfunc { |e| ((e.use{ ~midinote.()} - ~violins_2nd_sus_lowest_note-1)/3).floor },
	\buf, Pindex(~violins_2nd_sus_buffers, Pkey(\index)),
	\rate, (Pfunc{ |e| e.use {~midinote.()}} - Pindex(~violins_2nd_sus_midinotes, Pkey(\index))).midiratio,
	\amp, Pwhite(0.05, 0.1, inf),
	\dur, Pwhite(4,8, inf),
	\type, Pwrand([\note, \rest], [1,0.25].normalizeSum, inf),
	\atk, Pkey(\dur) * 0.6,
	\rel, Pkey(\atk),
	\out, 0,
	\pan, Pwhite(-0.2, 0.8,inf)
);

~celli_sus_pattern = Pbind(
	\instrument, \grain_buffer,
	\scale, Scale.major,
	\root, Pfunc({~root}),
	\octave, Pwrand([3, 4], [0.25, 1].normalizeSum, inf),
	\degree, Pseq([1], inf)-1,
	\index, Pfunc { |e| ((e.use{ ~midinote.()} - ~celli_sus_lowest_note-1)/3).floor },
	\buf, Pindex(~celli_sus_buffers, Pkey(\index)),
	\rate, (Pfunc{ |e| e.use {~midinote.()}} - Pindex(~celli_sus_midinotes, Pkey(\index))).midiratio,
	\amp, Pwhite(0.1, 0.2, inf),
	\dur, Pwhite(2,7, inf),
	\type, Pwrand([\note, \rest], [1,0.125].normalizeSum, inf),
	\atk, Pkey(\dur) * 0.6,
	\rel, Pkey(\atk),
	\out, 0,
	\pan, Pwhite(-0.3, 0.3,inf)
);

~basses_sus_pattern = Pbind(
	\instrument, \grain_buffer,
	\scale, Scale.major,
	\root, Pfunc({~root}),
	\octave, 3,
	\degree, Pseq([1], inf)-1,
	\index, Pfunc { |e| ((e.use{ ~midinote.()} - ~basses_sus_lowest_note-1)/3).floor },
	\buf, Pindex(~basses_sus_buffers, Pkey(\index)),
	\rate, (Pfunc{ |e| e.use {~midinote.()}} - Pindex(~basses_sus_midinotes, Pkey(\index))).midiratio,
	\amp, Pwhite(0.1, 0.2, inf),
	\dur, Pwhite(4,8, inf),
	\type, Pwrand([\note, \rest], [1,0.125].normalizeSum, inf),
	\atk, Pkey(\dur) * 0.6,
	\rel, Pkey(\atk),
	\out, 0,
	\pan, 0.0
);

~oboes_sus_pattern = Pbind(
	\instrument, \grain_buffer,
	\scale, Scale.major,
	\root, Pfunc({~root}),
	\octave, Pwhite(5,6,inf).round(1),
	\degree, Pwrand([1,5],[0.3, 0.6], inf)-1,
	\index, Pfunc { |e| ((e.use{ ~midinote.()} - ~oboes_sus_lowest_note-1)/3).floor },
	\buf, Pindex(~oboes_sus_buffers, Pkey(\index)),
	\rate, (Pfunc{ |e| e.use {~midinote.()}} - Pindex(~oboes_sus_midinotes, Pkey(\index))).midiratio,
	\amp, Pwhite(0.1, 0.2, inf),
	\dur, Pwhite(4,8, inf),
	\type, Pwrand([\note, \rest], [1,0.25].normalizeSum, inf),
	\atk, Pkey(\dur) * 0.6,
	\rel, Pkey(\atk),
	\out, 0,
	\pan, Pwhite(-0.2, 0.8,inf)
);

~clarinets_sus_pattern = Pbind(
	\instrument, \grain_buffer,
	\scale, Scale.major,
	\root, Pfunc({~root}),
	\octave, Pwhite(5,6,inf).round(1),
	\degree, Pwrand([1,5],[0.3, 0.6], inf)-1,
	\index, Pfunc { |e| ((e.use{ ~midinote.()} - ~clarinets_sus_lowest_note-1)/3).floor },
	\buf, Pindex(~clarinets_sus_buffers, Pkey(\index)),
	\rate, (Pfunc{ |e| e.use {~midinote.()}} - Pindex(~clarinets_sus_midinotes, Pkey(\index))).midiratio,
	\amp, Pwhite(0.2, 0.3, inf),
	\dur, Pwhite(4,8, inf),
	\type, Pwrand([\note, \rest], [1,0.25].normalizeSum, inf),
	\atk, Pkey(\dur) * 0.6,
	\rel, Pkey(\atk),
	\out, 0,
	\pan, Pwhite(-0.8, 0.2,inf)
);

~bassoons_sus_pattern = Pbind(
	\instrument, \grain_buffer,
	\scale, Scale.major,
	\root, Pfunc({~root}),
	\octave, Pwhite(4,5,inf).round(1),
	\degree, Pwrand([1,5],[0.3, 0.6], inf)-1,
	\index, Pfunc { |e| ((e.use{ ~midinote.()} - ~bassoons_sus_lowest_note-1)/3).floor },
	\buf, Pindex(~bassoons_sus_buffers, Pkey(\index)),
	\rate, (Pfunc{ |e| e.use {~midinote.()}} - Pindex(~bassoons_sus_midinotes, Pkey(\index))).midiratio,
	\amp, Pwhite(0.1, 0.2, inf),
	\dur, Pwhite(4,8, inf),
	\type, Pwrand([\note, \rest], [1,0.25].normalizeSum, inf),
	\atk, Pkey(\dur) * 0.6,
	\rel, Pkey(\atk),
	\out, 0,
	\pan, Pwhite(-0.4, 0.4,inf)
);
)

(
~ensamble = Pfx(Ppar([
	~violins_1st_sus_pattern,
	~violins_2nd_sus_pattern,
	~oboes_sus_pattern,
	~clarinets_sus_pattern,
	~bassoons_sus_pattern,
	~celli_sus_pattern,
	~basses_sus_pattern
],inf), \verb).asEventStreamPlayer;
)

// play
~ensamble.play;
~ensamble.stop;