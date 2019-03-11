s.reboot;


(
// sync freqs with mouse
{
	var n = 10;
	var phases = Kuramoto.ar(n // number or oscs, set on init
		, K2A.ar(0) // mode needs to be audio rate,
		// 0 - all are coupled
		// 1 - neighbors are coupled
		// 1 - neighbors are coupled, to prev negatively
		, Rand(0.0,3.0!n) // init phases
		, K2A.ar(Rand(0.02,0.05!n)) // phase increments, audio rate
		, K2A.ar(Rand(0.0001,0.01!n)) * MouseX.kr(0,10).lag2(0.1)); // coupling, audio rate
	Splay.ar(SinOsc.ar(0, phases)) * 0.1;
}.play
)





(
{
	var n = 70;
	var phases = Kuramoto.ar(n // number or oscs, set on init
		, K2A.ar(2) // mode needs to be audio rate,
		// 0 - all are coupled
		// 1 - neighbors are coupled
		// 1 - neighbors are coupled, to prev negatively
		, Rand(0.0,3.0!n) // init phases
		, K2A.ar(Rand(0.1,0.35!n)) // phase increments, audio rate
		, K2A.ar(Rand(0.0001,0.1!n)) * MouseX.kr(0,10).lag2(0.1)); // coupling, audio rate
	Splay.ar(SinOsc.ar(0, phases)) * 0.1;
}.play
)

