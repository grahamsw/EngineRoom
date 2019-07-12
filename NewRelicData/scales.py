
    
notes = {'C': 0,
         'C#': 1, 'Db': 1,
         'D': 2,
         'D#': 3, 'Eb': 3,
         'E': 4,
         'F': 5,
         'F#': 6, 'Gb': 6,
         'G': 7,
         'G#': 8, 'Ab': 8,
         'A': 9, 
         'A#': 10, 'Bb': 10,
         'B': 11,
         }
  
    
# convert note, or list of notes, from MIDI to freq
# can "rebase" to transpose or for convenience
def midi2freq(note, refNote = 69,  refFreq = 440):
    return refFreq * 2**((note-refNote)/12)
    
def n2m(n, s):
    return  notes[n] + 12 * (s + 1)   

def n2f(n,s):
    return midi2freq(n2m(n,s))

# Here are the seven modes that can be derived from the pitches of the C major scale:
# C Ionian (major) — CDEFGABC
# D Dorian — DEFGABCD
# E Phrygian — EFGABCDE
# F Lydian — FGABCDEF
# G Mixolydian — GABCDEFG
# A Aeolian (minor) — ABCDEFGA
# B Locrian — BCDEFGAB

majorScale = [('C', 4),
              ('D', 4),
              ('E', 4),
              ('F', 4),
              ('G', 4),
              ('A', 5),
              ('B', 5),
              ('C', 5)
             ]

minorScale = [('C', 4),
              ('D', 4),
              ('Eb', 4),
              ('F', 4),
              ('G', 4),
              ('A', 5),
              ('B', 5),
              ('C', 5)
             ]    

aeolian = [('C', 4),
           ('D', 4),
           ('Eb', 4),
           ('F', 4),
           ('G', 4),
           ('Ab', 5),
           ('Bb', 5),
           ('C', 5)
       ]

pentatonic_minor = [('C', 4),
                    ('Eb', 4),
                    ('F', 4),
                    ('G', 4),
                    ('Bb', 4),
                    ('C', 5)]

pentatonic_major = [('C', 4),
                    ('D', 4),
                    ('E', 4),
                    ('G', 4),
                    ('A', 4),
                    ('C', 5)]