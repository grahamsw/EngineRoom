# -*- coding: utf-8 -*-
"""
Created on Thu Mar 10 00:25:15 2016

@author: grahamsw
"""
from DVEditor import DynamicValue, DynamicValueConsole

   
# generates the signals listened for in simpleOscReceiverScore.ck      
dvs = [DynamicValue('/sinOsc1/f/gain', 0.0, 1.0, 0.5), 
       DynamicValue('/sinOsc1/f/freq', 100.0, 2000.0, 400), 
       DynamicValue('/sinOsc1/f/msOn', 50.0, 200.0, 100),
       DynamicValue('/sinOsc1/f/msOff', 50.0, 200.0, 80),
       DynamicValue('/sinOsc1/f/pfreq', 1000.0, 3000.0, 1500),
       ]
#dvs1.Init(["f/gain",  "f/freq", "f/msOn", "f/msOff", "f/pfreq"], 
#         [0.7 ,      400.0  ,  100.0,    200, 2000 ]);
ed = DynamicValueConsole(dvs, '127.0.0.1', 6449)   
