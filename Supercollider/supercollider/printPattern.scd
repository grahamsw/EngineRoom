
(
~printPattern = { |pattern, max = 20|
	var val, stream, safety = 0;
	stream = pattern.asStream;
	val = stream.next;
	while ({(val.notNil) && (safety < max) }, {
		val.postln;
		val = stream.next;
		safety = safety + 1;
})};
)
