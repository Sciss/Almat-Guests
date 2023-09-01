/*(
s = Server.default;
s.quit;
s.options.device = "JackRouter";
s.options.sampleRate = 44100;
s.options.blockSize = 128;
s.options.memSize = 8192 * 32;
s.options.numOutputBusChannels = 2;
if (ServerOptions.devices.collect(_.asSymbol).includes('MADIface USB (23677925)') ) {
	s.options.device = "MADIface USB (23677925)";
	s.options.numOutputBusChannels = 24;
};
)*/

(
~waitForBoot = { | s, func |
	if (s.serverRunning) {
		func.fork(AppClock)
	} {
		OSCFunc({|msg | if (msg[1] ==1) { func.fork(AppClock) } }, '/n_go', s.addr).oneShot;
		s.boot;
	}
};

//s.plotTree;
~tscale = 1;
SynthDef("sine4", { | freq, amp, pan, out, gate = 1, ar = 0.1, dr = 0.6, i, index = 0.5|
	var audio = SinOsc.ar(freq, SinOsc.ar(26 - i * freq / 4)* EnvGen.ar(Env.perc( ar, dr, index)), amp) * Linen.kr(gate, ar, 1, dr, 2);
	OffsetOut.ar(out + i, audio);
}).add;

~directProduct = { | a, b |
	// all pairs from two arrays
	a.collect({|v | b.collect{ | w | v.copy.add(w) } }).flatten;
};

// for each element of t, creates an array of all of its occurences in s
~xtrct = { | s, t |
	var locales = t.size.collect({ | j |
		var hits = [];
		s.do({ | b, i | if (b == t[j]) { hits = hits.add(i) } });
		hits;
	});
	locales;
};

// generates all tuplets from within x, an array
// where each element is an array of occurences of a value
~allTuples = { | x |
	var index, size, current;
	size = x.size;
	if (size < 2) {
		x.first
	} {
		current = x[0].collect(_.asArray);
		(1..size-1).do { | i |
			current = ~directProduct.(current, x[i])
		};
		current
	};

};

~makeScore = { | pitchSets, cantus|
	var totallength;
	var score, parts,durs;
	var minItem;
	minItem = cantus.minItem;
	pitchSets = pitchSets - minItem;
	//	cantus = cantus - minItem;
	cantus = cantus.collect { | v | if (v ==\r) { v = -1 } { v = v - minItem }; v };
	durs = pitchSets.collect{ | ps | ~computeDurs.(ps, cantus) };
	score = durs.collect { | dur, i |
		var pset = pitchSets.at(i);
		pset = pset.collect { | p | if(p == \r) { p = -1}; p };
		-1.dup(dur[0]) ++
		dur[1..].collect { | d, j |
			pset.wrapAt(j).dup(d)
		}.flat
	};
	totallength = score.collect(_.size).maxItem;
	totallength = (totallength/cantus.size).roundUp * cantus.size;
	score = score.add(cantus.dup( (totallength/cantus.size).roundUp).flat);
	score = score.collect({ | part |
		part ++ -1.dup(totallength - part.size)
	});
	score;
};

// computes the duration of a set of time points relative to a cycle.
// s.makeWindow
~computeDur = { | tps, cycle |
	var dur = tps.differentiate[1..];
	dur = dur mod: cycle;
	dur = dur.collect({| v , i | if (v == 0){ v = cycle}; v });
	dur.sum;
};

// function to sort a groups of time points based on their total duration
~sortTuples = { | array, cycle |
	array.sort({| a, b| ~computeDur.(a, cycle) <= ~computeDur.(b, cycle) })
};

// computes and sorts all possible sub patterns of a pattern
~computeDurs = { | pattern, cantus, start = 0|
	var positions, tuples, durs;
	positions = ~xtrct.(cantus, pattern);
	tuples = ~allTuples.(positions);
	tuples = tuples.sort({| a, b | ~computeDur.(a, 7) > ~computeDur.(b, 7) });
	durs = ([start mod: cantus.size] ++ tuples.flat).slide(2).clump(2)
	.collect({ | pr | var dur = pr[1] - pr[0] mod: cantus.size; if (dur == 0) { dur = cantus.size}; dur });
	durs;
};

~makePart = { | argpattern, cantus, start = 0, stutter = 1|
	var durs, pattern;
	durs = ~computeDurs.(argpattern, cantus, start);
	if (stutter == 1) {
		pattern = [\r, Pseq(argpattern, inf)];
	} {
		pattern = [Pseq(\r.dup(stutter)), Pseq(argpattern.clump(stutter).stutter(stutter).flat, inf)];
		durs = durs.stutter(stutter)/stutter;
	};
	Ptuple([Pseq(pattern), Pseq(durs * 0.2)])

};

~tupletempo = TempoClock.new;
~spawner = Pspawner({|sp|
	var pat;
	var length, percentRests;
	var lPat, rPat;
	var offset = 0;
	var catpat =
	Pbind(*[
		instrument: \sine4,
		note: Prout({ loop{ Pseq(~cantus).embedInStream } }),
		note: Pkey(\note) * 2.4 + 4,  // NEW, was before in ~cantus
		dur: 0.2,
		db: -45,
		// octave: Pstutter(5,Pseq([3,5,4], inf)),
		octave:  5,
		detune: Pwhite(-2.0,2.0),
		pan: 0,
		out: Pwhite(0, 23),
		i: Pseq((0..23), inf),  // NEW, was constant before
		ar: 0.001,
		dr: 0.1,
		stretch: 1,
		legato: 1,   // NEW
	]);
	lPat = Pseq( (8..12).mirror, inf).asStream;				// length of the cantus
	rPat =  Pseq( (5..8).mirror/25, inf).asStream;	// NEW: till 8 instead of 9
	~oldPlot = nil;
	loop {
		~tupletempo.tempo = ((10..20)/30).choose /2 * ~tscale;
		length = lPat.next;
		~cantus = (Pbrown(-6, 6, 3) ).asStream.nextN(length); // NEW transposition moved to Pbind
		{ ~cantus[~cantus.size.rand] = \r }.dup((length * rPat.next).asInteger /* .postln */);
		// ("starting" + ~cantus).post;

		~catter = sp.par(catpat);

		~pitchsets = ~cantus.asSet.asArray.powerset.select{ | v | v.size == 3};
		~pitchsets = ~pitchsets.collect(_.scramble); // NEW

		// (" number of parts is" + ~pitchsets.size).postln;
		~pats = ~pitchsets.collect({ | part, i |
			i = i + offset mod: 24;   // NEW
			Pbind(*[
				instrument: \sine4,
				#[note, dur], Pseq([~makePart.(part,~cantus,0, [1,1,2,2,4].choose),
					Pfunc({ /* ("voice" + i + "done").postln; */ nil })]),
				note: Pkey(\note) * 2.4 + 4,  // NEW, was before in ~cantus
				db: -15,
				// octave: Pstutter(5,Pseq([3,5,4], inf)),
				octave:  5,
				legato: i.lincurve(0, ~parts.size, 0.02, 1, 0), // NEW, was linlin before
				detune: Pwhite(-2.0,2.0),
				//		out: Pseq((0..23), inf, i),
				i: Pseq((0..23), inf, i),
				ar: 0.001,
				dr: 0.1,
				stretch: 1,
				db: i.linlin(0, ~parts.size, -40, -30),
			]);
		});
		offset = offset + 1 mod: 24;  // NEW

		sp.par(Ppar(~pats) );
		sp.wait((~cantus.size * (~durs.sort.last div: ~cantus.size + 1) * 0.1) ); // NEW
		~oldtempo = ~tupletempo.tempo;               // NEW
		~tupletempo.tempo = rrand(1.0, 8.0); // .postln;  // NEW
		sp.wait((~cantus.size * (~durs.sort.last div: ~cantus.size + 1) * 0.1) ); // NEW
		// ("ending" + ~cantus).postln;
		~tupletempo.tempo = ~oldtempo;               // NEW
		// NEW -- removed { ~cantus[~cantus.size.rand] = \r }.dup(5);
		sp.wait(length *2 * 0.2);
		sp.suspend(~catter);
		sp.suspendAll;                               // NEW
	}
});

~t1 = Main.elapsedTime;
~test = ~spawner.asStream.nextN(4000);
~t2 = Main.elapsedTime;
["took", ~t2 - ~t1, " sec."].postln;

)
