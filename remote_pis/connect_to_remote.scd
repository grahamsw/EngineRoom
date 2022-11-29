(
~connect_to_remote = {
    Window.closeAll;
    o = ServerOptions.new;
    o.maxLogins = 2;
    t = Server.remote(\remote, NetAddr("192.168.1.39", 57110), o);
    t.makeWindow;
    Server.default = t;
};

~quit_remote = {
    b = NetAddr.new("192.168.1.39", 57120);    // create the NetAddr
    b.sendMsg("/s_quit");
    Server.default = Server.local;
    Window.closeAll;
};

~chime = {(\amp: 0.5, \degree: [0, 2, 4, 7], \strum: 0.1).play}
)


~connect_to_remote.()

~quit_remote.()

~chime.()



