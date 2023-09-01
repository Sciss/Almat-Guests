s.reboot;


a = Signal.newClear(4096);
a.waveFill({ arg x, old, i; exp(x.squared.neg*1840000) }, -1, 1);
a.plot
b = Buffer.sendCollection(s, a.asWavetable);


(
// demo sync
x = { arg off = 0;
	var n = 6, mics = SoundIn.ar((0..5));
	
	var phases = Kuramoto.ar(n // number or oscs, set on init
		, K2A.ar(0) // mode needs to be audio rate,
		, n.collect({arg i; i.linlin(0,6,0, 2*pi) + 0.rrand(0.01*pi) }) // init phases
		, K2A.ar(0.00015!n)
		, K2A.ar(0.0!n) // external phases, audio rate
		, K2A.ar(0.000006!n)//K2A.ar(Rand(0.005,0.005!n) * MouseX.kr(0,10).lag2(0.1))
		, K2A.ar(0.0!n) 
	); 
	
	Out.ar(0, Osc.ar(b.bufnum, 0, phases) * 0.015 * Line.kr(0,1,0.5)
		* EnvGen.kr(Env([1,0],[0.4]),off,doneAction:2));

}.play
)

x.set(\off, 1);

s.meter



(
// Hopf Ghent Installation
{

	var mics = LPF.ar(HPF.ar(SoundIn.ar((0..5)),50), 11000);

	var hopf = Hopf.ar(mics, K2A.ar(MouseX.kr(0.001,0.9,1)), K2A.ar(0.0001));

	var freqs = hopf.collect({ arg item,i; ( (item[2]  * 44100) / (2*pi) ) });
	var phases = hopf.collect({ arg item; item[3] });

	var oscs = Blip.ar(freqs/60, 250);
	
	oscs = oscs.collect({ arg ph, i;
		var bands = BBandPass.ar(ph, Array.geom(32, 70, 1.18),
			32.collect({ arg i; i.linlin(0,31,0.22,0.4)}));
		Mix.ar(Compander.ar(bands, bands, 0.03, 0.4,
			-0.9, 1.exprand(12.0), 2.exprand(16.0))); 
	});

	oscs * 0.065 * 0.005 * Line.kr(0,1,0.4);

}.play
)


(
// Hopf Ghent Installation fix
{

	var mics = LPF.ar(HPF.ar(SoundIn.ar((0..5)),50), 11000);

	var hopf = Hopf.ar(mics, K2A.ar(0.014571), K2A.ar(0.0001));

	var freqs = hopf.collect({ arg item,i; ( (item[2]  * 44100) / (2*pi) ) });

	var oscs = Blip.ar(freqs/60, 125);
	
	oscs = oscs.collect({ arg ph;
		var bands = BBandPass.ar(ph, Array.geom(32, 70, 1.18),
			32.collect({ arg i; i.linlin(0,31,0.22,0.4)}));
		Mix.ar(Compander.ar(bands, bands, 0.03, 0.4,
			-0.9, 1.exprand(12.0), 2.exprand(16.0))); 
	});

	oscs * 0.065 * 0.0035 * Line.kr(0,1,0.4);

}.play
)


