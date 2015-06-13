"C:/Users/g.stalker-wilde/Documents/gsw/dev/engineroom" => string dir;
Machine.add(dir + "/DynamicValues.ck");
Machine.add(dir + "/receiver.ck");
Machine.add(dir + "/SinPlayer.ck");
Machine.add(dir + "/score.ck");

// this can be launched seperately - in fact it doesn't need  to be in Chuck at all
// next version will be a Python program that generates and sends OSC messages
//Machine.add(dir + "/osc2send.ck");