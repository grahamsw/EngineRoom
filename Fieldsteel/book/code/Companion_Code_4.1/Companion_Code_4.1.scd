// Companion Code 4.1
// Buffers and Buffer Management

s.boot;

// The structure of a sample library can vary significantly. There may be one folder that contains all your audio files, or there may be any number of subfolders within subfolders. Some subfolders might contain a combination of files and folders, and non-audio files may be present. There may even be subfolders at different depths with identical names. It is therefore extremely useful to have a robust buffer-reading function that is capable of preserving a sound file library's structure while anticipating and automatically handling potential issues.

// This companion code file resides in a main folder called "Companion_Code_4.1," which includes a subfolder named "audio." This audio folder intentionally includes some "unexpected" features described above: the "glass" subfolder contains two audio files plus a subfolder of more samples, and the "bell" folder contains a text file.

// There are at least three distinct problems we might encounter:

/*
(1) We may not know in advance the exact quantity or organization of subfolders.
(2) We may encounter non-audio files or files with invalid formats.
(3) A subfolder may have the same name as another subfolder at a different depth.
*/

// Problem (1) is optimally solved with a recursive algorithm: an algorithm capable of repeatedly calling itself until some condition is met. Recursive function definitions are supported in sclang, and the factorial operation provides an introductory demonstration. The factorial operation of some non-negative integer 'n' is conventionally denoted

n!

// and is equal to

n * (n-1) * (n-2) * ... * 2 * 1

// In SC, the exclamation mark is a shortcut for the 'dup' method, which fills an array with copies of its receiver. The factorial operation is accessible through the 'factorial' method:

5.factorial; // equals 5 * 4 * 3 * 2 * 1

// but we'll define our own version for demonstration purposes. It is worth mentioning that recursion is not strictly necessary to create a factorial function. It can be written using a combination of iteration, addition, and multiplication. Given some value n, the following function returns the product of the integers 1 through n:

f = { |n| n.collect({ |x| x + 1 }).product };

f.(5);

// A recursive factorial function can be created as follows. Given some non-negative integer n, check if it is greater than one. If so, return the product of n multiplied by the result of the same function evaluated for the integer one less than n. If n is not greater than one, recursion stops and the final evaluation of the function returns a value of one.

f = { |n| if(n > 1, {n * f.(n - 1)}, {1}) };

f.(5);

// The behavior of this evaluation process can be visualized as follows:

f.(5)
= 5 * f.(4)
= 5 * 4 * f.(3)
= 5 * 4 * 3 * f.(2)
= 5 * 4 * 3 * 2 * f.(1)
= 5 * 4 * 3 * 2 * 1
= 120

// Without proper caution, a recursive function can become locked in an endless loop, so there must be some mechanism in place to ensure that the recursive process eventually stops. In the previous example, this mechanism is essentially a countdown that stops when the starting value is not greater than one.

// We return now to the original problem of preserving the organizational structure of a sample library with an unknown number of structural levels and other potential "surprises." In simple language, we require an algorithm that operates on a folder and checks to see if it contains any subfolders. If so, recursively perform that same algorithm on each of the subfolders. A mechanism to prevent endless recursion is inherent to this context; a folder cannot contain an infinite number of folders, in other words, at the end of any branch, the contents will exclusively be files.

// In the following block, ~makeBuffers is a recursive function that loads an arbitrarily-structured sample library into an Event that contains arrays of buffers. Each array represents the audio files in a particular subfolder. This function makes use of 'select,' an iteration method that operates on a collection and returns a subset collection containing all items for which its function returns true. As a simple example, the following iteration expression returns an array of all the prime numbers between 1 and 50:

(1..50).select({ |n| n.isPrime });

// ~makeBuffers takes two arguments: a path string and an Event. The function then establishes two variables: an instance of PathName named 'dir', which represents the folder at the current path, and 'contents,' an array of PathName instances that represent the contents of the current folder. Comments are included in-line.

(
~makeBuffers = { |path, event|
	var dir = PathName.new(path);
	var contents = dir.entries;

	// First, check if the directory contains files.
	// This conditional statement returns true if
	// the directory contains at least one file.
	if (contents.select({ |n| n.isFile }).size > 0)
	{
		// If so, isolate the files from the folders.
		// Iterate over the files, load each one into
		// a buffer, and store the resulting array of
		// buffers in the Event, associated with a key
		// named according to the parent folder.
		var files, bufArray;
		files = contents.select({ |n| n.isFile });
		bufArray = files.collect({ |n| Buffer.read(s, n.fullPath) });
		event[dir.folderName.asSymbol] = bufArray;
	};

	// Next, check if the directory contains folders.
	if (contents.select({ |n| n.isFolder }).size > 0)
	{
		// If so, isolate the folders, iterate over them,
		// and call ~makeBuffers on each folder. Each time
		// the function is recursively called, we provide
		// the new path string to the current subfolder, as
		// well as the Event. By passing the Event to
		// subsequent recursive function calls, we ensure
		// that it properly accumulates arrays of buffers
		// as the recursive process plays out.
		var folders = contents.select({ |n| n.isFolder });
		folders.do({ |n| ~makeBuffers.(n.fullPath, event) });
	};

	// Finally, return the Event, so that we can
	// capture it at the end of this process,
	// fully populated with arrays of buffers
	// corresponding to all file-filled subfolders.
	event;
};
)

// We can now evaluate the function, providing it with the path string for the main folder and an initially empty Event:

b = ~makeBuffers.("audio/".resolveRelative, ());

// We have made good but incomplete progress toward our goal. For the most part, this function works well — it has populated the Event with keys whose names match the four subfolders that exist in the 'audio' folder:

b.keys;

// Each of these keys identifies an array of buffers, which can be played:

b[\glass][0].play;
b[\rattle][0].play;
b[\lowglass][0].play;

// But, we now must address problem (2), indicated by the following message that appeared in the post window:

"File '.../_textfile.txt' could not be opened: Format not recognised."

// The 'bell' folder contains a text file and two aiff files, so one of the following three lines will produce an error:

b[\bell][0].play;
b[\bell][1].play;
b[\bell][2].play;

// To correct this problem, we can modify ~makeBuffers so that it includes an additional conditional check to verify file format before attempting to load the data into a buffer:

(
~makeBuffers = { |path, event|
	var dir = PathName.new(path);
	var contents = dir.entries;

	if (contents.select({ |n| n.isFile }).size > 0)
	{
		var files, bufArray;
		files = contents.select({ |n| n.isFile });

		// Here is the additional step. After isolating the files
		// from the folders, we use 'select' again to check
		// whether each file extension is included in an array of
		// valid extensions.
		files = files.select({ |n|
			["aif", "aiff", "wav"].includesEqual(n.extension)
		});
		bufArray = files.collect({ |n| Buffer.read(s, n.fullPath) });
		event[dir.folderName.asSymbol] = bufArray;
	};

	if (contents.select({ |n| n.isFolder }).size > 0)
	{
		var folders = contents.select({ |n| n.isFolder });
		folders.do({ |n| ~makeBuffers.(n.fullPath, event) });
	};

	event;
};
)

// After evalutaing this revised function, we can confirm that the text files was ignored. The bell array contains the correct number of buffers, stored at indices 0 and 1:

Buffer.freeAll; // free all buffers first

b = ~makeBuffers.("audio/".resolveRelative, ());

b[\bell].size;

b[\bell][0].play;
b[\bell][1].play;
b[\bell][2].play; // <- nothing here

// Finally, we should also address problem (3). Though rare, it is possible that some subfolder will have the exact same name as another subfolder at a different level. Due to the recursive nature of our function, and the fact that duplicate keys are not possible in an Event, one subfolder will overwrite and replace the other subfolder. To demonstrate, you'll need to make a quick change to the audio folder: In your operating system, navigate to the "lowglass" folder, rename it as "glass", and then evaluate ~makeBuffers once more:

Buffer.freeAll; // free all buffers first

b = ~makeBuffers.("audio/".resolveRelative, ());

// After evaluating, we can see that the Event now only contains three keys, instead of four:

b.keys; // only three keys

// Our function created a 'glass' key, which was subsequently replaced by the deeper subfolder with the same name. The 'glass' key identifies an array of our three lower-pitched glass samples. Although our higher-pitched glass samples have been loaded into buffers, the overwriting behavior has effectively erased them from the Event, and they are no longer accessible.

b[\glass].size; // three low-pitched bottle samples

b[\glass][0].play;
b[\glass][1].play;
b[\glass][2].play;

b[\lowglass]; // <- nothing here

// The most practical and advisable solution to this problem is to name your subfolders more responsibly! Every step taken to ensure a well-organized and sensibly named sample library means one fewer step needed when loading files onto the audio server. We could attempt to modify ~makeBuffers to detect duplicate subfolder names and modify the name before loading buffers (e.g. by appening an incrementing number to the folder name). However, no matter what name-altering scheme we choose, there will likely be some folder names that "trick" the algorithm and produce unexpected behavior. Instead, a more appropriate solution would be to post a warning if a duplicate subfolder name is encountered, as a way of encouraging the user to make the necessary change themselves.

(
~makeBuffers = { |path, event|
	var dir = PathName.new(path);
	var contents = dir.entries;

	if (contents.select({ |n| n.isFile }).size > 0)
	{
		var files, bufArray;
		files = contents.select({ |n| n.isFile });
		files = files.select({ |n|
			["aif", "aiff", "wav"].includesEqual(n.extension)
		});

		// Here, before loading files into buffers, we check
		// to see if an array already exists at the key
		// specified by the folder name, by checking for
		// inequality with nil. If the item is not nil, then
		// an identically named folder containing at least one
		// audio file was already encountered, a warning is
		// posted, and the files are ignored. Otherwise, the
		// function proceeds with loading buffers and storing
		// the array at the folder-named key.
		if (event[dir.folderName.asSymbol] != nil)
		{ "duplicate subfolder name ignored".warn; }
		{
			bufArray = files.collect({ |n| Buffer.read(s, n.fullPath) });
			event[dir.folderName.asSymbol] = bufArray;
		};
	};

	if (contents.select({ |n| n.isFolder }).size > 0)
	{
		var folders = contents.select({ |n| n.isFolder });
		folders.do({ |n| ~makeBuffers.(n.fullPath, event) });
	};

	event;
};
)

// We can now demonstrate this feature. A warning is posted when we evaluate the function (you may need to scroll up in the post window). The Event contains three keys, and the deeper "glass" folder is ignored, so the 'glass' key references an array containing the two higher-pitched bottle samples.

Buffer.freeAll; // free all buffers first

b = ~makeBuffers.("audio/".resolveRelative, ()); // a warning is posted

b.keys; // the Event contains three keys

b[\glass].size;

b[\glass][0].play;
b[\glass][1].play;

// If the name of the deeper "glass" folder is reverted to "lowglass" or changed to something similarly unique, then ~makeBuffers will detect four unique subfolders and produce an Event with four keys. All audio files will be accessible in the Event, and the warning will no longer appear.