PathName(thisProcess.nowExecutingPath).parentPath
f = PathName(thisProcess.nowExecutingPath).parentPath +/+ "loadPaths_example.scd";
//first prepare a file with some code...
(
File.use(f, "w", { |file|
    file << "\"This text is the ploppity of a postln command which was loaded and executed by loadPaths\".postln;";
    file <<    "\"I will now throw a dice for you: \".post; 7.rand;"
})
)

// then load the file...
 // ... it posts some text, and the return value pf loadPaths is an array of the return values of each file
f.loadPaths;