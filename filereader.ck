OscOut oscout;
("localhost", 6449) => oscout.dest;

"data.txt" => string filename;
FileIO file;

file.open(filename, FileIO.READ);

LineReader lr;
lr.setDelimiter("\t");

while(!file.eof()){
    file.readLine() => string line;
    if (lr.parseLine(line)){
        <<< lr.name(), "=>", lr.value() >>>;
    }
    oscout.start(lr.name());
    oscout.add(lr.value());
    0.5:: second => now;
}
<<< "eof" >>>;
