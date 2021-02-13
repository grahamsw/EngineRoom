/*
OPTIONAL Problem Set Week 13
Due 3pm CDT Thursday December 3rd

First, save this scd file as a new file, renaming it with your Last name at the beginning of the file name (e.g. "Fieldsteel Problem Set Week 13.scd").

Create a simple sampler program in SuperCollider, similar to the one created during the live stream. You don't need a giant library of samples, just one sample will do, but it should be relatively long (at least 10 seconds), such as a sustained piano note or something similar. Your sampler should allow you to play at least one octave of MIDI note numbers, so that the sample is played back, transposed up or down according to the incoming note numbers. Make sure to include this file with your SC project folder, and use the 'thisProcess.nowExecutingPath' method.

The main challenge of this assignment: create a functioning sustain pedal. If you don't have an actual sustain pedal, any CC message will suffice. When that CC message value is greater than 0, the sustain pedal should be "active." When the value of that controller is equal to 0, the sustain pedal should disengage.

While active, the sustain pedal should cause all note off messages to be ignored or bypassed. If a note is pressed, but a sound is already sustaining at that note, a new note should be created, replacing the old note. When the sustain pedal is disengaged, all sustaining notes, except for those with actively depressed controller keys, should have their gate arguments set to zero, and the program should stop ignoring further note-off messages.
*/