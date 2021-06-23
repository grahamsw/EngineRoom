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


def read_live_data():
    return {'numPageViews':pageMetrics()['rt:pageViews'].astype('int').sum(), 'activeUsers':userMetrics()['rt:activeUsers'].astype('int').sum()}
