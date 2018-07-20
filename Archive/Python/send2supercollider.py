# -*- coding: utf-8 -*-
"""
Created on Sun Jan  1 21:18:21 2017

@author: grahamsw
"""

import OSC


def makeOscSender(ip, port):
    ''' 
    For communicating with SuperCollider
    usage
        sender = makeOscSender('127.0.0.1', 57120)
        sender('/synthName', ['argName', 299])
    '''
    def send(addr, val):
        c = OSC.OSCClient()
        c.connect((ip, port))
        oscmsg = OSC.OSCMessage()
        oscmsg.setAddress(addr)
        oscmsg.append(val)
        c.send(oscmsg)
    return send

