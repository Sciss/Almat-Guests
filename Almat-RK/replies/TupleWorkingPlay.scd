(
SynthDef("sine4", { | freq, amp, pan, out, gate = 1, ar = 0.1, dr = 0.6, i, index = 0.5|
	var audio = SinOsc.ar(freq, SinOsc.ar(26 - i * freq / 4)* EnvGen.ar(Env.perc( ar, dr, index)), amp) * Linen.kr(gate, ar, 1, dr, 2);
	// audio = PanAz.ar(24,audio**3, pan);
	OffsetOut.ar(out + i, audio);
}).add;

~tupletempo = TempoClock.new;
~tupletempo.tempo  = 1.0;

// ~spawner = Pspawner({|sp|
// 	var pat;
// 	var length, percentRests;
// 	var lPat, rPat;
// 	var catpat =
// 	Pbind(*[
// 		instrument: \sine4,
// 		// note: the following is correct,
// 		// but ~cantus is not yet defined at this point
// 		// Pseq(~cantus, inf), // Prout({ loop{ Pseq(~cantus).embedInStream } }),
// 		note: Prout({ loop{ Pseq(~cantus).embedInStream } }),
// 		dur: 0.2,
// 		db: -45,
// 		// octave: Pstutter(5,Pseq([3,5,4], inf)),
// 		octave:  5,
// 		detune: Pwhite(-2.0,2.0),
// 		pan: 0,
// 		out: Pwhite(0, 23),
// 		i: 4,
// 		ar: 0.001,
// 		dr: 0.1,
// 		stretch: 1,
// 	]);
// 	[ "spawn start", Main.elapsedTime ].postln;
// 	lPat = Pseq( (8..12).mirror, inf).asStream;
// 	rPat =  Pseq( (5..9).mirror/25, inf).asStream;
// 	4.do /* loop */ {
// 		~tupletempo.tempo = ((10..20)/30).choose /2;
// 		length = lPat.next;
// 		~cantus = (Pbrown(-6, 6, 3) * 2.4).asStream.nextN(length) + 4;
// 		{ ~cantus[~cantus.size.rand] = \r }.dup((length * rPat.next).asInteger.postln);
// 		("starting" + ~cantus).post;
// 		~catter = sp.par(catpat);
//
// 		~parts = ~cantus.asSet.asArray.powerset.select{ | v | v.size == 3};
// 		~pats = ~parts.collect({ | part, i |
// 			Pbind(*[
// 				instrument: \sine4,
// 				#[note, dur], Pseq([~makePart.(part,~cantus,0, [1,1,2,2,4].choose),
// 				Pfunc({ ("voice" + i + "done").postln; nil })]),
// 				db: -15,
// 				// octave: Pstutter(5,Pseq([3,5,4], inf)),
// 				octave:  5,
// 				legato: i.linlin(0, ~parts.size, 0.02, 1),
// 				detune: Pwhite(-2.0,2.0),
// 				//		out: Pseq((0..23), inf, i),
// 				i: Pseq((0..23), inf, i),
// 				ar: 0.001,
// 				dr: 0.1,
// 				stretch: 1,
// 				db: i.linlin(0, ~parts.size, -40, -30),
// 			]);
// 		});
// 		sp.seq(Ppar(~pats) );
// 		("ending" + ~cantus).postln;
// 		// this doesn't have any effect as far as I can tell:
// 		// { ~cantus[~cantus.size.rand] = \r }.dup(5);
// 		~waitDur = length *2 * 0.2;
// 		sp.wait(~waitDur);
// 		sp.suspend(~catter);
// 	};
// 	[ "spawn stop", Main.elapsedTime ].postln;
// });

s = Server.default;
s.quit;
s.options.device = "MOTU Traveler";
s.options.sampleRate = 44100;
s.options.blockSize = 128;
s.options.memSize = s.options.memSize * 10;
s.options.numOutputBusChannels = 8;

s.waitForBoot {
	~tuplesNP = NodeProxy.audio(s, 24);
	~tuplesNP.clock = ~tupletempo;
	~tuplesNP.playN([0,1,2,3]);
	s.sync;
	~tuplesNP[0] = ~spawner;
	~tuplesNP[10] = \filter -> { | in |
		in;
		Squiz.ar(in.excess(LFNoise1.kr({ 0.1.rand + 0.01}.dup(24)).exprange(0.00001, 0.002)),
			LFNoise1.kr(0.1.dup(24)).exprange(0.1, 12) max: 1 ,
		(1..24).linlin(1, 24, 1.4, 5)) * 0.3 + in

	};

	~tuplesNP[11] = \filter -> { | in |
		// in = in.clump(4).flop;
		// in =  in.collect { | in,i |
		// 	0.dup(i) ++ HPF.ar(JPverb.ar(Splay.ar(in),1.0), LFNoise1.kr(0.2).exprange(100, 1500))
		// }.sum;
		// in[0] = in[0] + in[4];
		in = HPF.ar(JPverb.ar(Splay.ar(in),1.0), LFNoise1.kr(0.2).exprange(100, 1500));
		CompanderD.ar(in * 2, 0.5, 1, 0, 0, 1) ++ Silent.ar(24)
	};
};
)
