import os

root = r"C:\Users\g.stalker-wilde\Google Drive\Documents\dev\repos\EngineRoom\\"
os.chdir(root + r"NewRelicData")



from send2framework import sender
from threadrunners import rlocker, run_in_thread
from generators import const_gen,  gen_proxy, makeSafeKeyedSetterGetter , zip_gen                                
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
def handleReading(reader, formatter):
    val = reader()
    print(formatter.format(val))
    return val






# run and save stopper event
sPageViews, _ = run_in_thread(handleReading, zip_gen(const_gen(pageViewReader), const_gen('pageViews: {}')), gen_proxy(pageViewsInterval_getter))
time.sleep(5)
sTransactionDurations, _ = run_in_thread(handleReading, zip_gen(const_gen(transactionDurationReader), const_gen('transaction Duration: {}')), gen_proxy(transactionDurationInterval_getter))
time.sleep(5)
sErrorCounts, _ = run_in_thread(handleReading, zip_gen(const_gen(errorReader), const_gen('error Count: {}')), gen_proxy(errorCountInterval_getter))


def stopAll():
    sPageViews.set()
    sTransactionDurations.set()
    sErrorCounts.set()
    
stopAll()
