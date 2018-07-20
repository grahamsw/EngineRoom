# -*- coding: utf-8 -*-
"""
Created on Mon Jan  2 22:51:39 2017

@author: grahamsw
"""
from send2supercollider import makeOscSender



sender = makeOscSender('127.0.0.1', 57120)

sender('/engine', ['mixCylinders', 0.8])
sender('/engine', ['engineSpeed', 0.3])

sender('/engine', ['mixParabolic', 0.9])
sender('/engine', ['parabolaDelay', 0.15])
sender('/engine', ['warpDelay', 0.4])

sender('/engine', ['waveguideWarp', 0.67])
sender('/engine', ['wguideFeedback', 0.35])
sender('/engine', ['wguideLength1', 0.2])
sender('/engine', ['wguideLength2', 0.3])
sender('/engine', ['wguideWidth1', 0.5])
sender('/engine', ['wguideWidth2', 0.7])

import time
def sendrange(name):
    for i in range(11):
        sender('/engine', [name, i/10.0])
        print(name, i/10.0)
        time.sleep(1)
    