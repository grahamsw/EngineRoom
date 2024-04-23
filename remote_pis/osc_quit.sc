b = NetAddr.new("192.168.1.25", 57120);    // create the NetAddr
b.sendMsg("/s_quit");

SynthDescLib.global.browse



(
thisThread.randSeed = 1;

~func =
{
    |anum|
    var levs = {rrand(-1.0, 1.0)}!anum;
    var peak = levs.abs.maxItem;
    levs * peak.reciprocal;

}
)

~func.(5)