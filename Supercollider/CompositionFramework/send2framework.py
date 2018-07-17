from pythonosc import udp_client
import time

# can send an array 
def sendSC(addr, val):
    sendMsg('127.0.0.1', 57120, addr, val)
    
def sendMsg(ip, port, addr, val):
  client = udp_client.SimpleUDPClient(ip, port)
  client.send_message(addr, val)




# sample using testImp.scd
# in practise event messages will be much less frequent - fast and 'musical' scheduling
# will be built in to the SuperCollider Events

freq = 100
mult = 1.1
amp = 0.8
ampMult = 0.98
sleep = 0.05


sendSC('/implOsc', ['makeS'])
for i in range (40):
    sendSC('/implOsc', ['setFreq', freq ])
    freq = freq * mult
    sendSC('/implOsc', ['setAmp', amp])
    amp = amp * ampMult
    time.sleep(sleep)
    
    
sendSC('/implOsc', ['killS'])   
    

