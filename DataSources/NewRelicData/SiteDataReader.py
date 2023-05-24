from NewRelicMonitor import makeNewRelicDataGetter, makeNewRelicValueReader, makeNamedResultReader
from NewRelic_secrets import account_id, key_id 
import time
from send2framework import sender
from ValueMappers import makeConstrainMapper

# A data getter takes a query and returns the large, complex JSON data object,
# with all kinds of bookkeeping info, from New Relic, 
# various parts of which might sometimes be of interest.
myDataGetter = makeNewRelicDataGetter(account_id, key_id)

pageViewReader = makeNewRelicValueReader(myDataGetter, 
                                       'SELECT count(*) from PageView SINCE 1 minutes ago', 
                                       makeNamedResultReader('count'))

transactionDurationReader = makeNewRelicValueReader(myDataGetter,
                                        'SELECT average(duration) from Transaction since 1 minute ago', 
                                        makeNamedResultReader('average'))

errorReader = makeNewRelicValueReader(myDataGetter,
                                        'SELECT count(*) FROM TransactionError SINCE 10 MINUTES AGO', 
                                        makeNamedResultReader('count'))

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
# 
# 
# =============================================================================

def maxMin(vals):
    pages = [p for (p,_,_) in vals]
    durations = [d for (_,d,_) in vals]
    errors = [e for (_,_,e) in vals]
    print(f"pages:{min(pages)} - {max(pages)}")
    print(f"durations:{min(durations)} - {max(durations)}")
    print(f"errors:{min(errors)} - {max(errors)}")


send = sender('/implOsc')
send('init2')

mapPagesToFreq = makeConstrainMapper(0, 10, 300, 1000, True)
mapDurationToBwr = makeConstrainMapper(0, 5, 0.2, 1)
#constrainRate = makeConstrainMapper(0, )

vals = []
while True:
    time.sleep(1)

    
    pages = pageViewReader()
    durations = transactionDurationReader()
    errors = errorReader()
    vals.append((pages, durations, errors))
    print(f"pages: {pages}, durations: {durations}, errors: {errors}")
    
    bwr = mapDurationToBwr(durations)
    freq = mapPagesToFreq(pages)
    amp = 0.4 #constrainAmp(errors)
    print(f"bwr: {bwr}, freq: {freq}, amp: {amp}")
    send('bwr', bwr)
    send('freq2', freq)
    send('amp2', amp)
    
    
    
import matplotlib.pyplot as plt
import numpy as np

x = np.linspace(0, 1, 100)
y = [constrainRate(a) for a in x]
plt.plot(x,y)

x = np.linspace(0, 10, 100)
y = [constrainFreq(a) for a in x]
plt.plot(x,y)

plt.plot([d for (_,d,_) in vals])