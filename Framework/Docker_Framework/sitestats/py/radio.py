import sys
sys.path.append('./lib')

from send2framework import sender
from threadrunners import rlocker
from gart import get_new_data
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

# {'numPageViews': 0, 
#  'activeUsers': 0, 
# 'sectionCounts': {'/': 0, 
#     '/about/': 0, 
#     '/about/careers/': 0, 
#     '/about/people/': 0, 
#     '/just-matters/': 0, 
#     '/our-work-around-the-world/': 0, 
#     '/the-latest/': 0, 
#     '/work/': 0, 
#     '/work/our-grants/': 0, 
#                 'other': 0}, 
# 'eventCounts': {
#     'videoPlays': 0, 
#     'grantDetailViews': 0, 
#     'fileDownloads': 0, 
#     'signups': 0}}

def get_latest_traffic():
    nd = get_new_data()
    ret = {
                'home_page_view': nd['sectionCounts']['/'],
                'program_page_view': nd['sectionCounts']['/work/'],
                'where_we_work_page_view': nd['sectionCounts']['/our-work-around-the-world/'],
                'editorial_page_view': nd['sectionCounts']['/just-matters/'],
                'about_page_view': nd['sectionCounts']['/about/'],
                'careers_page_view': nd['sectionCounts']['/about/careers/'],
                'grant_interaction': nd['sectionCounts']['/work/our-grants/'] + nd['eventCounts']['grantDetailViews'],
                'video_play': nd['eventCounts']['videoPlays'],
                'email_signup': nd['eventCounts']['signups']
    }
    return ret


while True:
    latest_traffic = get_latest_traffic()
    print(latest_traffic, flush=True)
    for event_type in event_types:
        s('play_site_events', event_type, latest_traffic[event_type], 30)
        time.sleep(30/len(event_types))

