# -*- coding: utf-8 -*-
"""
Created on Mon Jun 15 16:49:32 2015

@author: g.stalker-wilde
"""

import Tkinter as tk
import OSC

c = OSC.OSCClient()
c.connect(("127.0.0.1",6449))



def send(addr, val):  
    print addr + ': ' + val
    oscmsg = OSC.OSCMessage()
    oscmsg.setAddress(addr)
    oscmsg.append(int(val))
    c.send(oscmsg)

def update(slider, label,address,from_, to):
    label["text"] = address
    slider["from_"] = from_
    slider["to"] = to
    slider.set(from_)

def addSetter(root):
    addr = "/siga/freq"
    f = 100
    t = 200
    label1 = tk.Label(root, text=addr)
    address1 = tk.Entry(root)
    address1.insert(0,addr)
    from1 = tk.Entry(root)
    from1.insert(0,f)
    to1 = tk.Entry(root)
    to1.insert(0,t)
    
    button1 = tk.Button(root, text="Update", command=lambda: update(slider1,label1,address1.get(),from1.get(), to1.get()))
    slider1 = tk.Scale(root, from_=f, to=t, orient=tk.HORIZONTAL, command=lambda x: send(address1.get(), x))
    label1.pack()
    slider1.pack()
    address1.pack();
    from1.pack()
    to1.pack()
    button1.pack()  
  
  
  
root = tk.Tk()
root.title("Osc Console")
for i in range(5):
    addSetter(root)
root.mainloop()

   