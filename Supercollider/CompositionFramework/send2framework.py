from pythonosc import udp_client
import time


# save a sender and use it to send multiple messages to the same address
def sender(addr, ip='127.0.0.1', port=57120):
    client = udp_client.SimpleUDPClient(ip, port)
    def s(*args):
        client.send_message(addr, args)
    return s
    
# send a one-off message - msg must be an array
def send(addr, msg, ip='127.0.0.1', port=57120):
    sender(addr, ip, port)(*msg)
    
    
    
    
    
# sample using testImp.scd
# in practise event messages will be much less frequent - fast and 'musical' scheduling
# should. be built in to the SuperCollider Events

freq = 100
mult = 1.1
amp = 0.8
ampMult = 0.98
sleep = 0.05

s = sender('/implOsc')

s('makeS')

for i in range (40):
    s('setFreq', freq )
    s('setAmp', amp)
    
    freq = freq * mult
    amp = amp * ampMult
    time.sleep(sleep)
    
    
s('killS')   
    
send('/implOsc', ['makeS'])
send('/implOsc', ['setFreq', 800])
send('/implOsc', ['setAmp', 0.4])
time.sleep(3)
send('/implOsc', ['killS'])

