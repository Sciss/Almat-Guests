s.reboot;


(
// sync freqs with mouse
{
	var n = 10;
	var phases = Kuramoto.ar(n // number or oscs, set on init
		, K2A.ar(1) // mode needs to be audio rate,
		// 0 - all are coupled
		// 1 - neighbors are coupled
		// 1 - neighbors are coupled, to prev negatively
		, Rand(0.0,3.0!n) // init phases
		, K2A.ar(Rand(0.02,0.05!n)) // phase increments, audio rate
		, K2A.ar(0!n) // external phases, audio rate
		, K2A.ar(Rand(0.001,0.01!n)) * MouseX.kr(0,10).lag2(0.1)
		, K2A.ar(0!n) // external phases coupling, audio rate
	); // coupling, audio rate
	
	Splay.ar(SinOsc.ar(0, phases)) * 0.1;
}.play
)





(
{
	var n = 40;
	var phases = Kuramoto.ar(n // number or oscs, set on init
		, K2A.ar(2) // mode needs to be audio rate,
		// 0 - all are coupled
		// 1 - neighbors are coupled
		// 1 - neighbors are coupled, to prev negatively
		, Rand(0.0,3.0!n) // init phases
		, K2A.ar(Rand(0.1,0.35!n)) // phase increments, audio rate
		, K2A.ar(0!n) // external phases, audio rate
		, K2A.ar(Rand(0.0001,0.1!n)) * MouseX.kr(0,10).lag2(0.1)
		, K2A.ar(0!n) // external phases coupling, audio rate
	); // coupling, audio rate
	Splay.ar(SinOsc.ar(0, phases)) * 0.1;
}.play
)

