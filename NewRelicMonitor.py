import json
import urllib2
import urllib


# A data getter takes a query and returns the large, complex JSON data object, with all kinds of bookkeeping info, from New Relic, various parts of which might sometimes be of interest.
# The actual value you want is in there somewhere, so in general we provide a query and a function that will extract that value from the data object the query returns. This way we have maximum flexibility.
# Lots of queries seem to return their result in a "result" value, which is an array of name/value pairs with one entry. "MakeNamedResultReader" makes a value reader function that will extract that named value
# Account and Key information is secret, so we use a factory to generate NewRelicDataGetter, so that we can libraryfy the code. (and use data from multiple accounts)

def makeNewRelicDataGetter(account, key):
    def getNewRelicData(query):
        escQuery = urllib.quote_plus(query)
        req = urllib2.Request('https://insights-api.newrelic.com/v1/accounts/' + account + '/query?nrql=' + escQuery)
        req.add_header('Accept', 'application/json')
        req.add_header('X-Query-Key', key)
        response = urllib2.urlopen(req)
        data = json.loads(response.read())
        return data
    return getNewRelicData
 

# The actual value you want is in there somewhere, so in general we provide a query and a function that will 
# extract that value from the data object the query returns.
# This way we have maximum flexibility.
def getNewRelicValue(dataGetter,query, valueReader):
    data = dataGetter(query)
    return valueReader(data)

# Lots of queries seem to return their result in a "result" value, which is an array of name/value pairs with one entry. 
# "makeNamedResultReader" makes a value reader function that will extract that named value
def makeNamedResultReader(name):
    def namedResultReader(data):
        return data['results'][0][name]
    return namedResultReader

# A factory to create value readers, this way we can store a bunch of them in a data structure, 
# and call them generically
# Could also create a data structure with queries and value readers instead - this seems slightly cleaner.
def makeNewRelicValueReader(dataGetter, query, valueReader):
    def newRelicValueReader():
        return getNewRelicValue(dataGetter, query, valueReader)
    return newRelicValueReader


