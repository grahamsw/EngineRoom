from DynamicValuesEditor import DynamicValue, DynamicValuesEditor


dvs = [
       DynamicValue('/sinOsc1/f/gain',  0,    1), 
       DynamicValue('/sinOsc1/f/freq',  200, 2000),
       DynamicValue('/sinOsc1/f/msOn',  0,    1000),
       DynamicValue('/sinOsc1/f/msOff', 0,    1000),
       DynamicValue('/sinOsc1/f/pfreq', 1000,    3000),
       ]
ed = DynamicValuesEditor(dvs, '127.0.0.1', 6449) 


# freq: 946
# msOn: 882
# msOff: 100
# vibratoFreq: 