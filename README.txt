Engine Room 
July 2018

This is a series of explorations around sonification - turning data into sound.

It started from the observation that an engine conveys an enormous amount of information to an informed ear by the noise it makes. 
I wondered if I could reproduce this for monitoring, say, a web server. This turns out to be quite a large question.

The issues here are both technical and aesthetic/psycholological. The technical issues, while challenging, are the simpler. 
In fact the technical challenge is to create a framework wherein the aesthetic/psychological problem can be addressed. 
(Once you have something you like you could implement it in just about anything that makes a noise.)

The first attempt at this used ChucK (http://chuck.stanford.edu/), which is a fun language/environment for learning about sound 
synthesis, and can do great things, but then development switched to SuperCollider. (https://supercollider.github.io/)

Current development is under "CompositionFramework". There is some boilerplate code ("framework" is a massive overstatement), 
and some samples.

Essentially development consists of
* In SuperCollider
  * writing Synths
  * writing Routines/Pbinds that use instances of the Syths to create more elaborate sound events
  * adding Events that respond to OSC messages to trigger Routines or to change their parameters
* In Python
  * writing code to send OSC messages that will trigger the SuperCollider Events
  
The "framework" takes care of initializing SuperCollider, calling your code at the right time, listening for OSC messages and calling your Events. 
 
The Python messages will be in generated in response to whatever is being monitored: weather, financial information, biometrics, 
anything producing time series data.

There is a lot of lee-way in deciding how to split up the responsibilities - how complex the Synths should be, how complex the Routines, 
the Events, and the Python message handling. (Does the OSC message tell SuperCollider to change a frequency, or to increase the urgency?) 

The correct approach seems to be to use the strengths of each technology, Python is good at data, SuperCollider is good at scheduling and 
sample accurate synthesis. But the "framework" is simple enough that it's possible to experiment. 
