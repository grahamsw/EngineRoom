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
# 
# 
# =============================================================================





