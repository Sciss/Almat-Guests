//s.options.blockSize = 1;
s.options.numOutputBusChannels = 24;
s.options.numInputBusChannels = 16;

s.sampleRate

s.reboot;

s.options.blockSize = 64;

s.meter

{ Out.ar(5, SinOsc.ar(XLine.kr(60,10000,5)) * 0.05) }.play

{ Out.ar(5, SinOsc.ar(270*2) * 0.01) }.play


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
		, K2A.ar(Rand(0.02,0.04!n)) // phase increments, audio rate
		, K2A.ar(0!n) // external phases, audio rate
		, K2A.ar(Rand(0.01,0.01!n) * MouseX.kr(0,10).lag2(0.1))
		, K2A.ar(0!n) // external phases coupling, audio rate
	); // coupling, audio rate

	Splay.ar(SinOsc.ar(0, phases)) * 0.1;
}.play
)




(
{
	var input = SinOsc.ar(K2A.ar(MouseX.kr(100.0, 1000.0)).poll);
	//var input = SoundIn.ar(0);
	var hopf = Hopf.ar(input, K2A.ar(0.001));
	(hopf[2] * 44100 / (2*pi)).poll;
	//	var ph = hopf[1].atan2(hopf[0]);
	//	(ph - Delay1.ar(ph)).poll(label: \ph);
	//	((input.asin - Delay1.ar(input.asin)).abs).poll(label: \sin);
	//(ph - input.asin).poll;
	//var ph = hopf[1].atan2(hopf[0]);
	//	SinOsc.ar(0, ph) + input;
	//	(((hopf * 10) + input) * 0.1);
	hopf[3] * 0.00001; 
}.play
)

s.meter

s.scope



(
{
	var n = 60;
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

a = Signal.newClear(4096);
a.waveFill({ arg x, old, i; exp(x.squared.neg*1000) }, -1, 1);
a.plot
b = Buffer.sendCollection(s, a.asWavetable);




(
// sync freqs with mouse
x = { arg off = 0;
	var phases, hopfFreqs, n = 6;
	//	var mics = SoundIn.ar((0..5));
	//	var mics = BPeakEQ.ar(HPF.ar(SoundIn.ar((0..5)),400),650,3,12);
	//	var mics = HPF.ar(SoundIn.ar((0..5)),400).poll;
	//	var mics = Resonz.ar(SoundIn.ar((0..5)),Rand(400,2000!n),0.2).poll;
	var mics = DelayC.ar(HPF.ar(SoundIn.ar((0..5)),400),1,Rand(0.0,0.1!n));
	var hopf = Hopf.ar(mics, K2A.ar(0.001));
	var hilbert = Hilbert.ar(mics);
	//var hilbert = HilbertFIR.ar(mics, LocalBuf(2048));

	hopfFreqs = hopf.collect({ arg item; item[2] * 44100 / (2*pi)});
	
	hilbert = hilbert.collect({ arg item; item[1].atan2(item[0]) });

	hopf = hopf.collect({ arg item; item[3] });
	
	phases = Kuramoto.ar(n // number or oscs, set on init
		, K2A.ar(2) // mode needs to be audio rate,
		// 0 - all are coupled
		// 1 - neighbors are coupled
		// 2 - neighbors are coupled, to prev negatively
		, Rand(0.0,(2*pi)!n) // init phases
		, K2A.ar(0!n)// K2A.ar(Rand(0.02,0.04!n)) // phase increments, audio rate
		, hilbert // external phases, audio rate
		, K2A.ar(0!n)//K2A.ar(Rand(0.005,0.005!n) * MouseX.kr(0,10).lag2(0.1))
		// external phases coupling, audio rate
		//		, K2A.ar(0.3226!n)
		, K2A.ar(MouseX.kr(0,0.8!n))
		// LFNoise1.ar(0.01!n).range(0.1,0.6)//
	); // coupling, audio rate
	
		Out.ar(0, phases.sin * 0.005 * Line.kr(0,1,0.5) * EnvGen.kr(Env([1,0],[0.4]),off,doneAction:2));

	
	//Out.ar(0, Osc.ar(b.bufnum, 0, phases) * 0.01 * Line.kr(0,1,0.5) * EnvGen.kr(Env([1,0],[0.4]),off,doneAction:2));
}.play
)

s.scope

x.set(\off, 1);

s.meter

{ Out.ar(0, Osc.ar(b.bufnum, 0, SinOsc.ar(10) * 2 * pi) * 0.05) }.play





(
// sync freqs with mouse
x = { arg off = 0;
	var phases, hopfFreqs, n = 6;
	//	var mics = SoundIn.ar((0..5));
	//	var mics = BPeakEQ.ar(HPF.ar(SoundIn.ar((0..5)),400),650,3,12);
	//	var mics = HPF.ar(SoundIn.ar((0..5)),500).poll;
	var mics = SoundIn.ar((0..5));
	var hopf = Hopf.ar(mics, K2A.ar(0.001));
	var hilbert = Hilbert.ar(mics);

	hopfFreqs = hopf.collect({ arg item; item[2] * 44100 / (2*pi) });
	
	hilbert = hilbert.collect({ arg item; item[1].atan2(item[0]) });

	hopf = hopf.collect({ arg item; item[3] });
	
	phases = Kuramoto.ar(n // number or oscs, set on init
		, K2A.ar(1) // mode needs to be audio rate,
		// 0 - all are coupled
		// 1 - neighbors are coupled
		// 2 - neighbors are coupled, to prev negatively
		, Rand(0.0,(2*pi)!n) // init phases
		, K2A.ar(0.001!n)// K2A.ar(Rand(0.02,0.04!n)) // phase increments, audio rate
		, hopf // external phases, audio rate
		, K2A.ar(0.00001!n)//K2A.ar(Rand(0.005,0.005!n) * MouseX.kr(0,10).lag2(0.1))
		// external phases coupling, audio rate
		, K2A.ar(0.0!n) 
	); // coupling, audio rate

		// Out.ar(0, SinOsc.ar(0, phases) * 0.01 * Line.kr(0,1,0.5) * EnvGen.kr(Env([1,0],[0.4]),off,doneAction:2));
	
	Out.ar(0, Osc.ar(b.bufnum, 0, phases) * 0.02 * Line.kr(0,1,0.5) * EnvGen.kr(Env([1,0],[0.4]),off,doneAction:2));
}.play
)

s.scope






(
// sync freqs with mouse
x = { arg off = 0;
	var phases, hopfFreqs, n = 6;
	//	var mics = SoundIn.ar((0..5));
	//	var mics = BPeakEQ.ar(HPF.ar(SoundIn.ar((0..5)),400),650,3,12);
	var mics = HPF.ar(SoundIn.ar((8..13)),1000).poll;
	var hopf = Hopf.ar(mics, K2A.ar(0.005));
	var hilbert = Hilbert.ar(mics);

	hopfFreqs = hopf.collect({ arg item; item[2] * 44100 / (2*pi) });
	
	hilbert = hilbert.collect({ arg item; item[1].atan2(item[0]) });

	hopf = hopf.collect({ arg item; item[3] });
	
	phases = Kuramoto.ar(n // number or oscs, set on init
		, K2A.ar(1) // mode needs to be audio rate,
		// 0 - all are coupled
		// 1 - neighbors are coupled
		// 2 - neighbors are coupled, to prev negatively
		, Rand(0.0,(2*pi)!n) // init phases
		, K2A.ar(0!n)// K2A.ar(Rand(0.02,0.04!n)) // phase increments, audio rate
		, hopf // external phases, audio rate
		, K2A.ar(0.0006!n)//K2A.ar(Rand(0.005,0.005!n) * MouseX.kr(0,10).lag2(0.1))
		// external phases coupling, audio rate
		, K2A.ar(MouseX.kr(0,0.8!n)) 
	); // coupling, audio rate

		// Out.ar(0, SinOsc.ar(0, phases) * 0.01 * Line.kr(0,1,0.5) * EnvGen.kr(Env([1,0],[0.4]),off,doneAction:2));
	
	Out.ar(0, Osc.ar(b.bufnum, 0, phases) * 0.01 * Line.kr(0,1,0.5) * EnvGen.kr(Env([1,0],[0.4]),off,doneAction:2));
}.play
)

s.meter



// freq track


(
// sync freqs with mouse
x = { arg off = 0;
	var hopf, hilbert, phases, phasesInput, hopfFreqs, n = 6;
	var mics = HPF.ar(SoundIn.ar((0..5)),1700);
	var freqIncs = mics.collect({ arg mic;
		var fr,hasFr;
		# fr, hasFr = Pitch.kr(mic,700,500,6000);
		//Gate.ar(K2A.ar((fr.poll / s.sampleRate) * (2*pi)).lag2(0.05), K2A.ar(hasFr)) + 0.00001;
		Gate.ar(K2A.ar(fr).lag2(0.05), K2A.ar(hasFr)) + 0.00001;
	});
	
	//var hopf = Hopf.ar(mics, K2A.ar(0.001));
	mics = BPF.ar(mics,freqIncs.clip(50,12000).poll,2);
	
	hilbert = Hilbert.ar(mics);

	//	
	//phasesInput.poll;
	//phasesInput = Integrator.ar(K2A.ar(freqIncs)).mod(2*pi);
	//phasesInput = mics - SinOsc.ar(0, phasesInput);
	
	// hopfFreqs = hopf.collect({ arg item; item[2] * s.sampleRate / (2*pi)});
	
	hilbert = hilbert.collect({ arg item; item[1].atan2(item[0]) });

	
	// hopf = hopf.collect({ arg item; item[3] });
	
	phases = Kuramoto.ar(n // number or oscs, set on init
		, K2A.ar(2) // mode needs to be audio rate,
		// 0 - all are coupled
		// 1 - neighbors are coupled
		// 2 - neighbors are coupled, to prev negatively
		, Rand(0.0,(2*pi)!n) // init phases
		, K2A.ar(0!n)// K2A.ar(Rand(0.02,0.04!n)) // phase increments, audio rate
		, hilbert // external phases, audio rate
		, K2A.ar(0!n)//K2A.ar(Rand(0.005,0.005!n) * MouseX.kr(0,10).lag2(0.1))
		// external phases coupling, audio rate
		//		, K2A.ar(0.3226!n)
		, K2A.ar(MouseX.kr(0,0.8!n))
		// LFNoise1.ar(0.01!n).range(0.1,0.6)//
	); // coupling, audio rate
	
		Out.ar(0, phases.sin * 0.01 * Line.kr(0,1,0.5) * EnvGen.kr(Env([1,0],[0.4]),off,doneAction:2));

	
	//Out.ar(0, Osc.ar(b.bufnum, 0, phases) * 0.01 * Line.kr(0,1,0.5) * EnvGen.kr(Env([1,0],[0.4]),off,doneAction:2));
}.play
)


s.reboot;

// cross-correlation

(
{
	var corr;
	var snd1 = SinOsc.ar(400);
	var snd2 = SinOsc.ar(MouseX.kr(400,1000));
	var chain1 = FFT(LocalBuf(4096),snd1);
	var chain2 = FFT(LocalBuf(4096),snd2);
	chain2 = PV_Conj(chain2);
	chain1 = PV_Mul(chain1, chain2);
	corr = RMS.ar(IFFT.ar(chain1));
	corr.poll;
}.play
)




(
// sync freqs with mouse
x = { arg off = 0;
	var coup,hopf, hilbert, phases, phasesInput, hopfFreqs, n = 6;
	var mics = HPF.ar(SoundIn.ar((0..5)),50);
	var fb = LocalIn.ar(n);
	
	//var hopf = Hopf.ar(mics, K2A.ar(0.001));
	//	hilbert = Hilbert.ar(mics);
	//	hilbert = hilbert.collect({ arg item; item[1].atan2(item[0]) });
	// hopf = hopf.collect({ arg item; item[3] });

	var fftIn = FFT(LocalBuf(4096*2!n), mics);
	var fftOut = FFT(LocalBuf(4096*2!n), fb);
	var corrs = fftIn.collect({ arg in, i; RMS.ar(IFFT.ar(PV_Mul(in, PV_Conj(fftOut[i]))),10) });
	corrs = (1 / corrs.clip(0.00001, 10)) * 2 * pi;
	corrs.poll;

	coup = RMS.ar(mics).explin(0.00001,0.05,3,0.000001).lag2(4);
	
	//	corrs = mics - fb;
	
	phases = Kuramoto.ar(n // number or oscs, set on init
		, K2A.ar(3) // mode needs to be audio rate,
		// 0 - all are coupled
		// 1 - neighbors are coupled
		// 2 - neighbors are coupled, to prev negatively
		, Rand(0.0,(2*pi)!n) // init phases
		, K2A.ar(0.0!n)// K2A.ar(Rand(0.02,0.04!n)) // phase increments, audio rate
		, corrs // external phases, audio rate
		, K2A.ar(0!n)//K2A.ar(Rand(0.005,0.005!n) * MouseX.kr(0,10).lag2(0.1))
		// external phases coupling, audio rate
		//		, K2A.ar(0.3226!n)
		, K2A.ar(MouseX.kr(0.001,200!n,1))
		// LFNoise1.ar(0.01!n).range(0.1,0.6)//
	); // coupling, audio rate

	LocalOut.ar(phases);
	
		Out.ar(0, phases.sin * 0.01 * Line.kr(0,1,0.5) * EnvGen.kr(Env([1,0],[0.4]),off,doneAction:2));

	
	// Out.ar(0, Osc.ar(b.bufnum, 0, phases) * 0.01 * Line.kr(0,1,0.5) * EnvGen.kr(Env([1,0],[0.4]),off,doneAction:2));
}.play
)

s.meter




(
// sync freqs with mouse
x = { arg off = 0;
	var coup, hopf, hilbert, phases, phasesInput, hopfFreqs, n = 6;
	var mics = HPF.ar(SoundIn.ar((0..5)),300);
	var fb = LocalIn.ar(n);
	
	//var hopf = Hopf.ar(mics, K2A.ar(0.001));
	//	hilbert = Hilbert.ar(mics);
	//	hilbert = hilbert.collect({ arg item; item[1].atan2(item[0]) });
	// hopf = hopf.collect({ arg item; item[3] });

	// var fftIn = FFT(LocalBuf(4096!n), mics);
	// var fftOut = FFT(LocalBuf(4096!n), fb);
	// var corrs = fftIn.collect({ arg in, i; RMS.ar(IFFT.ar(PV_Mul(in, PV_Conj(fftOut[i])))) });
	// corrs = (1 / corrs.clip(0.00001, 10)) * 2 * pi;
	// corrs.poll;
	
	var corrs = (mics - fb);

	coup = RMS.ar(mics).explin(0.00001,0.05,3,0.000001).lag2(1);
	
	phases = Kuramoto.ar(n // number or oscs, set on init
		, K2A.ar(3) // mode needs to be audio rate,
		// 0 - all are coupled
		// 1 - neighbors are coupled
		// 2 - neighbors are coupled, to prev negatively
		, Rand(0.0,(2*pi)!n) // init phases
		, K2A.ar(0!n)// K2A.ar(Rand(0.02,0.04!n)) // phase increments, audio rate
		, corrs // external phases, audio rate
		, K2A.ar(0!n)//K2A.ar(Rand(0.005,0.005!n) * MouseX.kr(0,10).lag2(0.1))
		// external phases coupling, audio rate
		//		, K2A.ar(0.3226!n)
		, K2A.ar(MouseX.kr(0,0.5!n)*coup)
		// LFNoise1.ar(0.01!n).range(0.1,0.6)//
	); // coupling, audio rate

	LocalOut.ar(phases);
	
		Out.ar(0, phases.sin * 0.01 * Line.kr(0,1,0.5) * EnvGen.kr(Env([1,0],[0.4]),off,doneAction:2));

	
	// Out.ar(0, Osc.ar(b.bufnum, 0, phases) * 0.01 * Line.kr(0,1,0.5) * EnvGen.kr(Env([1,0],[0.4]),off,doneAction:2));
}.play
)





(
// sync freqs with mouse
x = { arg off = 0;
	var coup, hilbert, phases, phasesInput, hopfFreqs, n = 6;
	var mics = HPF.ar(SoundIn.ar((0..5)),1000);
	var fb = LocalIn.ar(n);
	
	var hopf = Hopf.ar(mics, K2A.ar(0.001));
	hilbert = Hilbert.ar(mics);
	hilbert = hilbert.collect({ arg item; item[1].atan2(item[0]) });
	hopf = hopf.collect({ arg item; item[3] });

	coup = RMS.ar(mics).explin(0.00001,0.05,3,0.000001);
	
	// var fftIn = FFT(LocalBuf(4096!n), mics);
	// var fftOut = FFT(LocalBuf(4096!n), fb);
	// var corrs = fftIn.collect({ arg in, i; RMS.ar(IFFT.ar(PV_Mul(in, PV_Conj(fftOut[i])))) });
	// corrs = (1 / corrs.clip(0.00001, 10)) * 2 * pi;
	// corrs.poll;

	// var corrs = (mics - fb);

	
	
	phases = Kuramoto.ar(n // number or oscs, set on init
		, K2A.ar(2) // mode needs to be audio rate,
		// 0 - all are coupled
		// 1 - neighbors are coupled
		// 2 - neighbors are coupled, to prev negatively
		, Rand(0.0,(2*pi)!n) // init phases
		, K2A.ar(0.0!n)// K2A.ar(Rand(0.02,0.04!n)) // phase increments, audio rate
		, hilbert // external phases, audio rate
		, K2A.ar(0!n)//K2A.ar(Rand(0.005,0.005!n) * MouseX.kr(0,10).lag2(0.1))
		// external phases coupling, audio rate
		//		, K2A.ar(0.3226!n)
		, K2A.ar(coup.lag(10))
		// LFNoise1.ar(0.01!n).range(0.1,0.6)//
	); // coupling, audio rate

	
	LocalOut.ar(phases);
	
	Out.ar(0, (phases.sin * coup.lag(4)) * 0.02 * Line.kr(0,1,0.5) * EnvGen.kr(Env([1,0],[0.4]),off,doneAction:2));

	
	// Out.ar(0, Osc.ar(b.bufnum, 0, phases) * 0.01 * Line.kr(0,1,0.5) * EnvGen.kr(Env([1,0],[0.4]),off,doneAction:2));
}.play
)


s.reboot;

(
{

	var input = SoundIn.ar(5); 
	var namp = MovingAverage.power(input,44100*0.5,44100*0.5) - MovingAverage.power(input,44100*3,44100*3);
	(namp * 1000).poll;
	DC.ar(0);
}.play
)

(0.001 * 44100) / (2*pi)




	Array.geom(32, 80, 1.18).last


(
{
	var m = K2A.ar(MouseX.kr(0,1)).poll;
	Compander.ar(m, m, 0.1, 0.2, -0.8).poll;
	DC.ar(0);
}.play
)

1.rrand(10)

[1,2,3]/[3,4,5]

(
// possibility for presentation
{

	var mics = LPF.ar(HPF.ar(SoundIn.ar((0..5)),50), 11000);
	var coupling = Mix.ar(MovingAverage.rms(mics,44100,44100)).linlin(0.01,0.03,0.005,0.5).lag(4);
	var hopf = Hopf.ar(mics, K2A.ar(MouseX.kr(0.001,0.9,1)).poll, K2A.ar(0.0001));

	var freqs = hopf.collect({ arg item,i; ( (item[2]  * 44100) / (2*pi) ) });
	var phases = hopf.collect({ arg item; item[3] });

	var oscs = Blip.ar(freqs/[10,20,10,40,5,10], 250);

	
	
	oscs = oscs.collect({ arg ph;
		var bands = BBandPass.ar(ph, Array.geom(32, 70, 1.18), 0.21);
		Mix.ar(Compander.ar(bands, bands, 0.03, 0.4, -0.9, 1.exprand(12.0), 2.exprand(16.0))); 
	});
	//	phases.scope;
	Limiter.ar(oscs*0.7,0.9) * 0.001;


	//	Out.ar(0, Osc.ar(b.bufnum, 0, phases) * 0.01)
	//Out.ar(0, phases * 0.02)
}.play
)


(
// possibility for presentation alternative 2
{

	var mics = LPF.ar(HPF.ar(SoundIn.ar((0..5)),50), 11000);
	var coupling = Mix.ar(MovingAverage.rms(mics,44100,44100)).linlin(0.01,0.03,0.005,0.5).lag(4);
	var hopf = Hopf.ar(mics, K2A.ar(MouseX.kr(0.001,0.9,1)).poll, K2A.ar(0.0001));

	var freqs = hopf.collect({ arg item,i; ( (item[2]  * 44100) / (2*pi) ) });
	var phases = hopf.collect({ arg item; item[3] });

	var oscs = Blip.ar(freqs/60, 250);
	
	oscs = oscs.collect({ arg ph, i;
		var bands = BBandPass.ar(ph, Array.geom(32, 70, 1.18),
			32.collect({ arg i; i.linlin(0,31,0.22,0.4)}));
		// var micbands = BBandPass.ar(mics[i], Array.geom(32, 70, 1.18),
		// 	32.collect({ arg i; i.linlin(0,31,0.25,0.8)}));
		Mix.ar(Compander.ar(bands, bands, 0.03, 0.4,
			-0.9, 1.exprand(12.0), 2.exprand(16.0))); 
	});
	//	phases.scope;
	oscs * 0.07 * 0.005 * Line.kr(0,1,0.4);


	//	Out.ar(0, Osc.ar(b.bufnum, 0, phases) * 0.01)
	//Out.ar(0, phases * 0.02)
}.play
)




(
// possibility for presentation alternative 2, sidechain compander
{

	var mics = LPF.ar(HPF.ar(SoundIn.ar((0..5)),50), 11000);
	var coupling = Mix.ar(MovingAverage.rms(mics,44100,44100)).linlin(0.01,0.03,0.005,0.5).lag(4);
	var hopf = Hopf.ar(mics, K2A.ar(MouseX.kr(0.001,0.9,1)).poll, K2A.ar(0.0001));

	var freqs = hopf.collect({ arg item,i; ( (item[2]  * 44100) / (2*pi) ) });
	var phases = hopf.collect({ arg item; item[3] });

	var oscs = Blip.ar(freqs/60, 250);
	var bands = oscs.collect({arg osc;
		BBandPass.ar(osc, Array.geom(32, 60, 1.185),
			32.collect({ arg i; i.linlin(0,31,0.2,0.3)}));
	});
	
	oscs = bands.collect({ arg osc, i;
		Mix.ar(Compander.ar(osc, bands[(i+1)%6], 0.03, 0.4,
			-0.9, 1.exprand(6.0), 2.exprand(10.0))); 
	});
	//	phases.scope;
	oscs * 0.05 * 0.005 * Line.kr(0,1,0.4);

}.play
)

s.meter




Array.geom(6, 170, 1.8)

(

{

	var mics = BBandPass.ar(SoundIn.ar((0..5)),Array.geom(6, 170, 1.8),0.01);
	var hopf = Hopf.ar(mics, K2A.ar(MouseX.kr(0.001,0.9,1)), K2A.ar(0.0001));
	var freqs = hopf.collect({ arg item,i; ( (item[2]  * 44100) / (2*pi) ).poll });
	var phases = hopf.collect({ arg item; item[3] });

	var oscs = Blip.ar(freqs/[10,20,10,40,5,10], 250);

	oscs = oscs.collect({ arg ph;
		var bands = BBandPass.ar(ph, Array.geom(32, 70, 1.18), 0.21);
		Mix.ar(Compander.ar(bands, bands, 0.03, 0.4, -0.9, 1.exprand(12.0), 2.exprand(16.0))); 
	});
	//	phases.scope;
	Limiter.ar(oscs*0.7,0.9) * 0.02;


	//	Out.ar(0, Osc.ar(b.bufnum, 0, phases) * 0.01)
	//Out.ar(0, phases * 0.02)
}.play
)
















s.scope

s.meter

(
// sync freqs with mouse
x = { arg off = 0;
	var corrs,coup, hilbert, phases, phasesInput, hopfFreqs, n = 6;
	var mics = HPF.ar(SoundIn.ar((0..5)),300);
	var fb = LocalIn.ar(n);
	
	var hopf = Hopf.ar(mics, K2A.ar(0.001));
	//	hilbert = Hilbert.ar(mics);
	//	hilbert = hilbert.collect({ arg item; item[1].atan2(item[0]) });
	var namp = MovingAverage.power(mics,44100*0.5,44100*0.5) - MovingAverage.power(mics,44100*3,44100*3);
	//	coup = MovingAverage.rms(mics,1500,1500) - MovingAverage.rms(mics,44100*3,44100*3);
	//	coup[4].poll;
	(namp * 1000).round(0.1).poll;
	hopf = hopf.collect({ arg item; item[3] }) * (namp.lag2(2) * 1000);

	// var fftIn = FFT(LocalBuf(4096!n), mics);
	// var fftOut = FFT(LocalBuf(4096!n), fb);
	// var corrs = fftIn.collect({ arg in, i; RMS.ar(IFFT.ar(PV_Mul(in, PV_Conj(fftOut[i])))) });
	// corrs = (1 / corrs.clip(0.00001, 10)) * 2 * pi;
	// corrs.poll;
	

	//	mics = mics.collect({arg m, i; m.atan2(mics[(i-2)%n])});

	//	corrs = (mics - fb);
	//	corrs = mics;

	
	
	
	phases = Kuramoto.ar(n // number or oscs, set on init
		, K2A.ar(4) // mode needs to be audio rate,
		// 0 - all are coupled
		// 1 - neighbors are coupled
		// 2 - neighbors are coupled, to prev negatively
		, Rand(0.0,(2*pi)!n) // init phases
		, K2A.ar(0!n)// K2A.ar(Rand(0.02,0.04!n)) // phase increments, audio rate
		, hopf // external phases, audio rate
		, K2A.ar(0!n)//K2A.ar(Rand(0.005,0.005!n) * MouseX.kr(0,10).lag2(0.1))
		// external phases coupling, audio rate
		//		, K2A.ar(0.3226!n)
		, K2A.ar(MouseX.kr(0.001,1!n))
		// LFNoise1.ar(0.01!n).range(0.1,0.6)//
	); // coupling, audio rate

	LocalOut.ar(phases);
	
	Out.ar(0, phases.sin * 0.01 * Line.kr(0,1,0.5) * EnvGen.kr(Env([1,0],[0.4]),off,doneAction:2));

	
	// Out.ar(0, Osc.ar(b.bufnum, 0, phases) * 0.01 * Line.kr(0,1,0.5) * EnvGen.kr(Env([1,0],[0.4]),off,doneAction:2));
}.play
)





(
// sync freqs with mouse
x = { arg off = 0;
	var corrs,coup, hilbert, phases, phasesInput, hopfFreqs, n = 6;
	var mics = HPF.ar(SoundIn.ar((0..5)),400);
	var fb = LocalIn.ar(n);
	
	var hopf = Hopf.ar(mics, K2A.ar(0.001));
	hilbert = Hilbert.ar(mics);
	hilbert = hilbert.collect({ arg item; item[1].atan2(item[0]) });

	hopf = hopf.collect({ arg item; item[3] });

	// var fftIn = FFT(LocalBuf(4096!n), mics);
	// var fftOut = FFT(LocalBuf(4096!n), fb);
	// var corrs = fftIn.collect({ arg in, i; RMS.ar(IFFT.ar(PV_Mul(in, PV_Conj(fftOut[i])))) });
	// corrs = (1 / corrs.clip(0.00001, 10)) * 2 * pi;
	// corrs.poll;
	

	//	mics = mics.collect({arg m, i; m.atan2(mics[(i-2)%n])});
	coup = RMS.ar(mics,20).expexp(0.04,0.13,4,0.2).lag2(10);
	
	corrs = (mics - fb);
	//	corrs = mics;

	
	
	
	phases = Kuramoto.ar(n // number or oscs, set on init
		, K2A.ar(2) // mode needs to be audio rate,
		// 0 - all are coupled
		// 1 - neighbors are coupled
		// 2 - neighbors are coupled, to prev negatively
		, Rand(0.0,(2*pi)!n) // init phases
		, K2A.ar(0!n)// K2A.ar(Rand(0.02,0.04!n)) // phase increments, audio rate
		, hilbert // external phases, audio rate
		, K2A.ar(0!n)//K2A.ar(Rand(0.005,0.005!n) * MouseX.kr(0,10).lag2(0.1))
		// external phases coupling, audio rate
		//		, K2A.ar(0.3226!n)
		, K2A.ar(MouseX.kr(0,0.5!n)*coup)
		// LFNoise1.ar(0.01!n).range(0.1,0.6)//
	); // coupling, audio rate

	LocalOut.ar(phases);
	
		Out.ar(0, phases.sin * 0.01 * Line.kr(0,1,0.5) * EnvGen.kr(Env([1,0],[0.4]),off,doneAction:2));

	
	// Out.ar(0, Osc.ar(b.bufnum, 0, phases) * 0.01 * Line.kr(0,1,0.5) * EnvGen.kr(Env([1,0],[0.4]),off,doneAction:2));
}.play
)






(

x = { arg off = 0;
	var corrs,coup, hilbert, phases, phasesInput, hopfFreqs, freqs, oscs, n = 6;
	var mics = HPF.ar(SoundIn.ar((0..5)),300);
	
	var hopf = Hopf.ar(mics, K2A.ar(0.1), K2A.ar(0.001));

	hopf = hopf.collect({ arg item; item[3] });

	phases = Kuramoto.ar(n // number or oscs, set on init
		, K2A.ar(3) // mode needs to be audio rate,
		// 0 - all are coupled
		// 1 - neighbors are coupled
		// 2 - neighbors are coupled, to prev negatively
		, Rand(0.0,(2*pi)!n) // init phases
		, K2A.ar(0!n)// K2A.ar(Rand(0.02,0.04!n)) // phase increments, audio rate
		, hopf // external phases, audio rate
		, K2A.ar(0.01!n)//K2A.ar(Rand(0.005,0.005!n) * MouseX.kr(0,10).lag2(0.1))
		// external phases coupling, audio rate
		//		, K2A.ar(0.3226!n)
		, K2A.ar(MouseX.kr(0,0.5!n))
		// LFNoise1.ar(0.01!n).range(0.1,0.6)//
	); // coupling, audio rate

	LocalOut.ar(phases);

	oscs = Osc.ar(b.bufnum, 0, phases);


	oscs = oscs.collect({ arg ph;
		var bands = BBandPass.ar(ph, Array.geom(32, 70, 1.18), 0.21);
		Mix.ar(Compander.ar(bands, bands, 0.03, 0.5, -0.95,
			2.exprand(12.0), 3.exprand(16.0))); 
	});

	
	Out.ar(0, oscs * 0.007 * Line.kr(0,1,1) * EnvGen.kr(Env([1,0],[0.4]),off,doneAction:2));


}.play
)






(
// possibility for presentation with auto coupling
{

	var mics = LPF.ar(HPF.ar(SoundIn.ar((0..5)),50), 11000);
	//	var coupling = Mix.ar(MovingAverage.rms(mics,44100*2,44100*2)).linlin(0.01,0.03,0.004,0.5).lag(10);
	var hopf = Hopf.ar(mics, SinOsc.ar(0.002).range(0,1).cubed.linlin(0,1,0.003,0.6).poll, K2A.ar(0.0001));

	var freqs = hopf.collect({ arg item,i; ( (item[2]  * 44100) / (2*pi) ) });
	var phases = hopf.collect({ arg item; item[3] });

	var oscs = Blip.ar(freqs/[10,20,10,40,10,5], 350);

	
	
	oscs = oscs.collect({ arg ph;
		var bands = BBandPass.ar(ph, Array.geom(32, 70, 1.18), 0.21);
		Mix.ar(Compander.ar(bands, bands, 0.03, 0.4, -0.9, 1.exprand(12.0), 2.exprand(16.0))); 
	});
	//	phases.scope;
	Limiter.ar(oscs*0.7,0.9) * 0.01;


	//	Out.ar(0, Osc.ar(b.bufnum, 0, phases) * 0.01)
	//Out.ar(0, phases * 0.02)
}.play
)
