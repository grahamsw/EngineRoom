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
)


~connect_to_remote.()

~quit_remote.()



(\amp: 0.5, \degree: [-4, 1]).play