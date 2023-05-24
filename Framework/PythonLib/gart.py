from googleapiclient.discovery import build
from oauth2client.service_account import ServiceAccountCredentials
import pandas as pd
#from secrets import profile_id

def get_service(key_file_location):
    api_name='analytics'
    api_version='v3'
    scope = 'https://www.googleapis.com/auth/analytics.readonly'
    credentials = ServiceAccountCredentials.from_json_keyfile_name(
            key_file_location, scopes=[scope])
    return build(api_name, api_version, credentials=credentials)

def get_results(service, profile_id, metrics, dimensions):
    # Use the Analytics Service Object to query the Core Reporting API
    # for the number of sessions within the past seven days.
    ret = service.data().realtime().get(
            ids=profile_id,
            metrics=metrics,
            dimensions=dimensions).execute()
    columns = [r['name'] for r in ret['columnHeaders']]
    return pd.DataFrame(ret['rows'], columns=columns)


def makeMetricGetter(key_file_location, profile_id, metrics, dimensions):
    def getMetrics():
        service = get_service(key_file_location)
        return get_results(service, profile_id, metrics, dimensions)
    return getMetrics



##############################################################################
## sample use
##############################################################################
 
key_file_location = r'/home/pi/PythonLib/FFOCREPORTING-8e839572ab2d.json'
key_file_location = r'C:\Users\graha\Documents\dev\github\DataAnalysis\secrets\FFOCREPORTING-8e839572ab2d.json'

master_view_profile_id = 'ga:175168708' 

profile_id = master_view_profile_id

pageMetrics = makeMetricGetter(key_file_location, profile_id,
                                    'rt:pageViews', 
                                    'rt:pageTitle, rt:pagePath')

userMetrics = makeMetricGetter(key_file_location, profile_id,
                               'rt:activeUsers',
                               'rt:userType, rt:deviceCategory')  

eventMetrics = makeMetricGetter(key_file_location, profile_id,
                               'rt:totalEvents',
                               'rt:eventAction,rt:eventCategory,rt:eventLabel')  




def read_live_data(sections):
    pm = pageMetrics()
    um = userMetrics()
    em = eventMetrics()
    return {'numPageViews':pm['rt:pageViews'].astype('int').sum(), 
            'activeUsers':um['rt:activeUsers'].astype('int').sum(),
            'sectionCounts': get_section_counts(pm, sections),
            'eventCounts': get_key_events(em)}


def make_dummy_reading(sections):
    big_num = float('inf')
    return {'numPageViews': big_num, 
            'activeUsers': big_num,
            'sectionCounts': {s:big_num for s in sections + ['other']},
            'eventCounts': {
                'videoPlays': big_num,
                'grantDetailViews':big_num,
                'fileDownloads':big_num,
                'signups': big_num
                }
          }

def get_section_counts(df, sections):
    sections = sorted(sections, key=lambda s: -len(s))
    sections.remove('/')
    def best_match(path):
        if path =='/':
            return '/'
        for s in sections:
            if path.startswith(s):
                return s
        else: 
            return "other"
    df['section'] = df['rt:pagePath'].apply(lambda p: best_match(p))
    df['cnt'] = pd.to_numeric(df['rt:pageViews'])
    ret = df.groupby('section').sum()['cnt'].to_dict()
    for s in sections:
        if s not in ret.keys():
            ret[s] = 0
    return ret
            
    

def get_key_events(events):
    vps = events[events['rt:eventAction']=='Play']
    ges = events[events['rt:eventAction']=='Grant Detail Expand']
    fds = events[events['rt:eventCategory']== 'File Download']
    signups = events[events['rt:eventCategory']=='Newsletter Signup']
    return {'videoPlays': len(vps), 
            'grantDetailViews':len(ges),
            'fileDownloads':len(fds),
            'signups': len(signups)}


def calc_section_count_difference(nrsc, lrsc):
    return {s: max(nrsc[s]-lrsc[s],0) for s in nrsc}


sections = [
                '/work/our-grants/',
                '/work/',
                '/the-latest/',
                '/our-work-around-the-world/',
                '/just-matters/',
                '/campaigns/',
                '/about/people/',
                '/about/careers/',
                '/about/',
                '/'
            ]

lr = make_dummy_reading(sections)
def get_new_data(sections):
    global lr
    nr = read_live_data(sections)
    ret  = {
        'numPageViews': max(nr['numPageViews'] - lr['numPageViews'], 0),
        'activeUsers': max(nr['activeUsers'] - lr['activeUsers'], 0),
        'sectionCounts': calc_section_count_difference(nr['sectionCounts'], lr['sectionCounts']),
        'eventCounts': {
            'videoPlays': max(nr['eventCounts']['videoPlays'] - lr['eventCounts']['videoPlays'],0),
            'grantDetailViews': max(nr['eventCounts']['grantDetailViews'] - lr['eventCounts']['grantDetailViews'],0),                         
            'fileDownloads': max(nr['eventCounts']['fileDownloads'] - lr['eventCounts']['fileDownloads'],0),
            'signups': max(nr['eventCounts']['signups'] - lr['eventCounts']['signups'], 0)                      
            }
    }
    lr = nr
    return ret

        
          

    
    
    
    
    
    
    