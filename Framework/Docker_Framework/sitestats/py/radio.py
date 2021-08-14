import sys
sys.path.append('./lib')

from send2framework import sender
from threadrunners import rlocker
import random
import time
import os


print("hello")

# a threadsafe sender
host =  os.getenv('SC_IP') or '172.20.0.2'
port =  57120 if not os.getenv('SC_PORT') else int(os.getenv('SC_PORT'))
osc_chan = os.getenv('SC_OSC_CHANNEL') or '/implOsc'


s = rlocker(sender(osc_chan, ip=host, port=port))



# ~events[\play_site_events].(\home_page_view,10, 30)
event_types = [ 
                'home_page_view',
                'program_page_view',
                'where_we_work_page_view',
                'editorial_page_view',
                'about_page_view',
                'careers_page_view',
                'grant_interaction',
                'video_play',
                'email_signup'
              ]

def get_next_event_val():
    return (random.choice(event_types), random.randrange(0, 20))

for event_type in event_types:
    s('play_site_events', event_type, random.randrange(0, 20), 30)
    
        
while True:
    event_type, val = get_next_event_val()
    print(event_type, val, flush=True)
    s('play_site_events', event_type, val, 30)
    time.sleep(10)
