import NewRelicMonitor as nrm
# NewRelicCredentials defines newRelicAccount and
# queryKey to specify the account read and provide read access
# this will not be checked into Git for security reasons
# (not that there's much security risk - it's read only access, and I don't think there's
# a limit on reads - really, I'm just practicing open source security)
import NewRelicCredentials 


myDataGetter = nrm.makeNewRelicDataGetter(NewRelicCredentials.newRelicAccount, NewRelicCredentials.queryKey)

# A data getter takes a query and returns the large, complex JSON data object,
# with all kinds of bookkeeping info, from New Relic, 
# various parts of which might sometimes be of interest.
myDataGetter('SELECT average(duration) from Transaction since 1 minute ago')


#Calling, and extracting a named result
nrm.getNewRelicValue(myDataGetter, 
                     'SELECT average(duration) from Transaction since 1 minute ago', 
                      nrm.makeNamedResultReader('average'))

# Same query, extracting something else (and arbitrary - just to show how easy it is).
nrm.getNewRelicValue(myDataGetter,
                     'SELECT average(duration) from Transaction since 1 minute ago', 
                      lambda data: data['performanceStats']['responseBodyBytes'])


import time
import ValueMappers as vm
from collections import namedtuple
from sendOSC2 import makeOscSender


send = makeOscSender('127.0.0.1', 6449)

messageSenders = {}
        
def sendPageViews(val):
    onMs = vm.mapConstrainValue(val, 0, 20, 150, 10)
    offMs = vm.mapConstrainValue(val, 0, 20, 150, 10)
    send("/sinOsc1/f/msOn", onMs)
    send("/sinOsc1/f/msOff", offMs)
    print ('PageViews %d, msOn: %f, msOff %f' % (val, onMs, offMs))
    
    
def sendDuration(val):
    freq = vm.mapConstrainValue(val, 0, 4, 380, 500)
    send("/sinOsc1/f/freq", freq)
    print ('Duration %f, freq: %f' % (val, freq))

MessageHandler = namedtuple("MessageHandler", "reader sender")

readers = {}
readers['PageViews'] = MessageHandler(nrm.makeNewRelicValueReader(myDataGetter, 
                                                        'SELECT count(*) from PageView SINCE 1 minutes ago', 
                                                        nrm.makeNamedResultReader('count')),
                                             sendPageViews)
readers['Duration'] = MessageHandler(nrm.makeNewRelicValueReader(myDataGetter, 
                                                          'SELECT average(duration) from Transaction since 1 minute ago', 

                                                           nrm.makeNamedResultReader('average')),
                               sendDuration )


while (1):
    for k in readers:
        v = readers[k].reader()        
        readers[k].sender(v)
    time.sleep(5)
    


