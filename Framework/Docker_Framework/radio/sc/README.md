taken from https://github.com/maxhawkins/sc_radio
Thanks Max Hawkins for making this available!

An example internet radio server using SuperCollider.

You could use this as a starting point for a procedural radio station.

* Supercollider for audio generation
* JACK with 'dummy' driver to work on cloud hardware
* Darkice to connect with icecast

It runs headless in Docker so your composition can be running on a server in the cloud somewhere.

To use, install Docker then:

    docker build -t scradio .
    docker run scradio

Then the stream will be accessible at https://audio.spiderhats.com/bells

I've only tested this on Linux.
