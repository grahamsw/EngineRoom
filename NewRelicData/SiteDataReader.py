import NewRelicMonitor as nrm
from secrets import account_id, key_id 


# A data getter takes a query and returns the large, complex JSON data object,
# with all kinds of bookkeeping info, from New Relic, 
# various parts of which might sometimes be of interest.
myDataGetter = nrm.makeNewRelicDataGetter(account_id, key_id)

pageViewReader = nrm.makeNewRelicValueReader(myDataGetter, 
                                       'SELECT count(*) from PageView SINCE 1 minutes ago', 
                                       nrm.makeNamedResultReader('count'))

transactionDurationReader = nrm.makeNewRelicValueReader(myDataGetter,
                                        'SELECT average(duration) from Transaction since 1 minute ago', 
                                        nrm.makeNamedResultReader('average'))

errorReader = nrm.makeNewRelicValueReader(myDataGetter,
                                        'SELECT count(*) FROM TransactionError SINCE 10 MINUTES AGO', 
                                        nrm.makeNamedResultReader('count'))
# =============================================================================
# 
# #Calling, and extracting a named result
# nrm.getNewRelicValue(myDataGetter, 
#                      'SELECT average(duration) from Transaction since 1 minute ago', 
#                       nrm.makeNamedResultReader('average'))
# 
# # Same query, extracting something else (and arbitrary - just to show how easy it is).
# nrm.getNewRelicValue(myDataGetter,
#                      'SELECT average(duration) from Transaction since 1 minute ago', 
#                       lambda data: data['performanceStats']['responseBodyBytes'])
# 
# =============================================================================

import time
import ValueMappers as vm
from collections import namedtuple
from sendOSC2 import makeOscSender


MessageHandler = namedtuple("MessageHandler", "reader sender")

send = makeOscSender('127.0.0.1', 6449)
        
def sendPageViews(val):
    pulseWidth = vm.mapConstrainValue(val, 0, 20, 150, 10)
    send('/implOsc', ['pulseWidth', pulseWidth])
    print (f'PageViews: {val}, pulseWidth: {pulseWidth}')
 
    
def sendDuration(val):
    freq = vm.mapConstrainValue(val, 0, 4, 380, 500)
    send('/implOsc' , ['freq', freq])
    print (f'Duration {val}, freq: {freq}')

readers = {}
readers['PageViews'] = MessageHandler(pageViewReader, sendPageViews)   
readers['Duration'] = MessageHandler(transactionDurationReader, sendDuration )
 

while True:
    for k in readers:
        v = readers[k].reader()        
        readers[k].sender(v)
    time.sleep(5)
    


