"JITLibExtensions".include;

currentEnvironment.postln; // anEnvironment
~x; // access the environment: there is nothing stored: nil
~x = 9; // store something
~x;     // now 9 is stored
~x + 100; // calculate with it

currentEnvironment.postln; // the value is stored in the

y = `nil

z = y + 7

y.value = 8
z.value

~q = 6

~q
q=8


p = ProxySpace.push;

~x = {SinOsc.kr(0)};
~y = {SinOsc.kr(0)};
~z = {SinOsc.ar(1100*(0.midiratio))* 0.2};
~z.play

p.clear(2)
p.pop