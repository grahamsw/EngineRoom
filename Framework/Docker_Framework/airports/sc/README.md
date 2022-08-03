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

    (or in my configuration, run the build.bat file to do the docker build, and push it to your repo, then run the radio.sh file on the remote VM to pull it from the repo and run it with 
    the appropriate network configuration)

Then the stream will be accessible at https://audio.spiderhats.com/<mountpoint>

I've only tested this on Linux.
