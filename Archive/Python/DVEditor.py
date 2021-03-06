# -*- coding: utf-8 -*-
"""
Created on Mon Jun 15 16:49:32 2015

@author: g.stalker-wilde
"""

import tkinter as tk
import uuid 
from collections import namedtuple
from sendOSC2 import makeOscSender
from VerticalScrolledFrame import VerticalScrolledFrame

import json

class DynamicValue:
    def __init__(self, address, fr, to, start):
        self.address = address
        self.fr = fr
        self.to = to
        self.start = start
        
DynamicValueEditor = namedtuple("DynamicValueEditor", "address_editor from_editor to_editor slider button")




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
            
                        
class DynamicValueConsole:
   # def __init__(self, instanceName, dvals, ip, port): 
    def __init__(self, jsonFile):
        r = DVReader(jsonFile)
        self.sender = makeOscSender(r.ip, r.port)
        
        self.root = tk.Tk()
       # self.root.geometry('200x600')
        self.root.title("Osc Console")
        self.frame = VerticalScrolledFrame(self.root)
        self.frame.pack(fill=tk.BOTH, expand=tk.YES)
        self.dves = {}
        for dv in r.dvs:
            self.addSetter(r.instanceName, dv)
        self.root.mainloop()
      
           
    def send(self, addr, val):  
        print (addr + ': ' + str( float(val) ))
        self.sender(addr, float(val) )

    
    def update(self, key):
        dve = self.dves[key]
        print (dve.address_editor.get() + ' from: ' + dve.from_editor.get() + ' to: ' + dve.to_editor.get())
        dve.slider["from_"] = float(dve.from_editor.get()) 
        dve.slider["to"] = float(dve.to_editor.get()) 
        dve.slider.set(float(dve.from_editor.get()))
        
    def addSetter(self, instanceName, dval): 
        key = uuid.uuid4()   
       # separator1 = tk.Frame(height=2, bd=1, relief=tk.SUNKEN)
        address1 = tk.Entry(self.frame.interior)
        address1.insert(0,'/' + instanceName + '/' + dval.address)
        from1 = tk.Entry(self.frame.interior)
        from1.insert(0,dval.fr)
        to1 = tk.Entry(self.frame.interior)
        to1.insert(0,dval.to)
        
        button1 = tk.Button(self.frame.interior, text="Update", command=lambda: self.update(key))
        slider1 = tk.Scale(self.frame.interior, from_=dval.fr, to=dval.to , orient=tk.HORIZONTAL, command=lambda x: self.send(address1.get(), x), resolution=0.1, relief=tk.SOLID)
 #       separator1.pack(fill=tk.X, padx=5, pady=10)     
        address1.pack()
        slider1.pack()
        from1.pack()
        to1.pack()
        button1.pack(pady=5)  
        slider1.set(dval.start)
        self.dves[key] = DynamicValueEditor(address1, from1, to1, slider1, button1)
        self.send(dval.address, dval.start)
   