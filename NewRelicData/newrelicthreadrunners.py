import os

root = r"C:\Users\g.stalker-wilde\Google Drive\Documents\dev\repos\EngineRoom\\"
os.chdir(root + r"NewRelicData")



from send2framework import sender
from threadrunners import rlocker, run_in_thread
from generators import const_gen,  gen_proxy, makeSafeKeyedSetterGetter                                 
from osc_receiver import readSupercolliderVal
import time
# a threadsafe sender
s = rlocker(sender('/implOsc'))


from NewRelicMonitor import makeNewRelicDataGetter, makeNewRelicValueReader, makeNamedResultReader
from NewRelic_secrets import account_id, key_id 

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



pageViewsInterval_setter, pageViewsInterval_getter = makeSafeKeyedSetterGetter(const_gen(15))
transactionDurationInterval_setter, transactionDurationInterval_getter = makeSafeKeyedSetterGetter(const_gen(15))
errorCountInterval_setter, errorCountInterval_getter = makeSafeKeyedSetterGetter(const_gen(15))


@rlocker
def readPageViews(ignore):
    pvs = pageViewReader()
    print(f'page views: {pvs}')
    return pvs



@rlocker
def readTransactionDurations(ignore):
    tds = transactionDurationReader()
    print(f'transaction Durations: {tds}')
    return tds



@rlocker
def readErrorCount(ignore):
    errors = errorReader()
    print(f'error count: {errors}')
    return errors





# run and save stopper event
sPageViews, _ = run_in_thread(readPageViews, const_gen(1), gen_proxy(pageViewsInterval_getter))
time.sleep(5)
sTransactionDurations, _ = run_in_thread(readTransactionDurations, const_gen(1), gen_proxy(transactionDurationInterval_getter))
time.sleep(5)
sErrorCounts, _ = run_in_thread(readErrorCount, const_gen(1), gen_proxy(errorCountInterval_getter))


def stopAll():
    sPageViews.set()
    sTransactionDurations.set()
    sErrorCounts.set()
    
stopAll()