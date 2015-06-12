# -*- coding: utf-8 -*-
"""
Created on Sat Jan 24 20:39:37 2015

@author: g.stalker-wilde
"""

import matplotlib.pyplot as pt
import numpy as np

samples = 500
rg = np.linspace(-15,15,samples)
sn = np.sin(rg)


sn2 = np.sin(2 * rg)
sn3 = np.sin(4 * rg)

snc = sn + 0.5 * sn2 + 0.25 * sn3

s = np.random.rand(samples)

pt.plot(rg, s, 'grey')

def rot(a, offset=1):
    return np.append(a[offset:], a[0 : offset])
    
def onezero(a):
    return (a + rot(a,1))/2.0
    
pt.plot(rg,onezero(s),'r')
