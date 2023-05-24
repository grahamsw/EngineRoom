~loadBuff = {
	|filename, isAbsolute = false|
	var fn = if (isAbsolute, {filename}, {PathName(thisProcess.nowExecutingPath).parentPath ++ filename});
	Buffer.read(s, f.fullPath);
};


~sparrow = ~loadBuff.("sounds/sparrow_1.mp3")