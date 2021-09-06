(

"loaded config.sc".postln;

~eventSounds =[
    \sparrow:([
        (\file: 'sounds/sparrow_1.wav', \clips: [(\start: 6.75, \length: 0.75),
                                                 (\start: 14.7, \length: 0.4),
                                                 (\start: 24.3, \length: 0.5)])
    ]),
    \goldfinch: ([
         (\file: 'sounds/goldfinch_1.wav',\clips: [(\start: 5.0, \length: 1)])
    ]),
    \bluejay: ([
        (\file: 'sounds/bluejay_1.wav', \clips: [(\start: 19.0, \length: 0.78),
                                                 (\start: 3.2, \length: 0.8)])
    ]),
    \cardinal: ([
        (\file: 'sounds/northern_cardinal_1.wav', \clips: [(\start: 35.0, \length: 3.51),
                                                           (\start:10.75, \length: 4.5)] )
    ]),
    \chickadee: ([
        (\file: 'sounds/chickadee_1.wav', \clips:[(\start: 4.2, \length:1),
                                                  (\start:12.91, \length: 1.7),
            (\start:6.7, \length: 0.65)])
    ]),
    \titmouse: ([
        (\file: 'sounds/titmouse_1.wav', \clips: [(\start: 23.25, \length: 1),
                                                  (\start: 25.3, \length: 1.2)])
    ]),
    \nuthatch:([
        (\file: 'sounds/nuthatch_1.wav',\clips: [(\start: 0.7, \length: 2.3),
                                                 (\start: 31.25, \length: 2.75)])
    ])
].asDict;

~site_events = [
    \home_page_view: (\play_event: {~playClip.(\sparrow)}),
    \program_page_view: (\play_event: {~playClip.(\goldfinch)}),
    \where_we_work_page_view: (\play_event: {~playClip.(\bluejay)}),
    \editorial_page_view: (\play_event: {~playClip.(\nuthatch)}),
    \about_page_view: (\play_event: {~playClip.(\chickadee)}),
    \careers_page_view: (\play_event: {~playClip.(\chickadee)}),
    \grant_interaction: (\play_event: {~playClip.(\goldfinch)}),
    \video_play: (\play_event: {~playClip.(\titmouse)}),
    \email_signup: (\play_event: {~playClip.(\cardinal)})
].asDict;

)