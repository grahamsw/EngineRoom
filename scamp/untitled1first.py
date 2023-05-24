from scamp import *

s = Session()
cello = s.new_part("Cello")

s.start_transcribing()
for p in [48, 53, 67]:
    cello.play_note(p, 0.5, 1.0)
    
s.stop_transcribing().save_to_json(r'C:\Users\graha\poo.json')