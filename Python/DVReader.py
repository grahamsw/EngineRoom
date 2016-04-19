# -*- coding: utf-8 -*-
"""
Created on Tue Apr 19 17:10:59 2016

@author: g.stalker-wilde
"""

import json
from DVEditor import DynamicValue

class DVReader:
    def __init__(self, filename):
        with open(filename) as jsonfile:
            self.json = json.load(jsonfile)
            self.instanceName = self.json["instanceName"]
            print(self.json["ip"])
            self.ip = self.json["ip"]
            self.port = self.json["port"]
            self.dvs = []
            for dv in self.json["vals"]:
                self.dvs.append(DynamicValue(dv["name"], dv["min"], dv["max"], dv["init"]))
            
                