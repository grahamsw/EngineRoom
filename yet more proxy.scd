(
a = NodeProxy.new.source_({ Pulse.ar([350, 351.3] / 4, 0.4) * 0.2 });
a.set('fadeTime', 2);
a.play;
);
