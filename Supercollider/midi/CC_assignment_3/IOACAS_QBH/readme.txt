**************************************************
*       IOACAS Query-by-Humming Corpus           *
**************************************************
Institute of Acoustics, Chinese Academy of Sciences
E-Mail:  liming.ioa@gmail.com

Specifications:

midfile 	This directory contains 298 MIDI files. The file name is just the MIDI ID. Since we use notes with very low pitch or rest notes
		to label music phrase for part of MIDI files, you must ignore rest notes or notes whose pitch is low than 45.
wavfile		This directory contains 759 singing queries. All files are Window 16-bit PCM format at 8k sample rate. 
		No guarantee for each humming starts from the beginning of the songs.
query.list	query list file with the ground truth MIDI ID.
midi.list	MIDI list file. Most of them are Chinese pop songs. 
		