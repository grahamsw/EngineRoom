import OSC

c = OSC.OSCClient()
c.connect('127.0.0.1', 6449)

def send(addr, val):
	oscmsg = OSC.OSCMessage()
	oscmsg.setAddress(addr)
	oscmsg.append(val)
	c.send(oscmsg)

