// (
// SynthDef("sine4", { | freq, amp, pan, out, gate = 1, ar = 0.1, dr = 0.6, i, index = 0.5|
// 	var audio = SinOsc.ar(freq, SinOsc.ar(26 - i * freq / 4)* EnvGen.ar(Env.perc( ar, dr, index)), amp) * Linen.kr(gate, ar, 1, dr, 2);
// 	// audio = PanAz.ar(24,audio**3, pan);
// 	OffsetOut.ar(out + i, audio);
// }).add;

// ~log = { arg arr; arr.postln; };
~logS = [];
// ~log = { arg arr; arr.postln; };
~log = { arg arr; ~logS = ~logS.add(arr.asString); };
~clearLog = { ~logS = [] };

~debug = true;

~directProduct = { | a, b |
	var res;
	// all pairs from two arrays
	res = a.collect({|v | b.collect{ | w | v.copy.add(w) } }).flatten;
	~log.(["directProduct", a, b, " => ", res]);
	res
};

// collects every occurence of elements of t in s
~xtrct = { | s, t |
	var locales = t.size.collect({ | j |
		var hits = [];
		s.do({ | b, i | if (b == t[j]) { hits = hits.add(i) } });
		hits;
	});
	~log.(["xtrct", s, t, " => ", locales]);
	locales;
};

// generates all tuplets from within x, an array
// where each element is an array of occurences of a value
~allTuples = { | x |
	var index, size, current, res;
	size = x.size;
	res = if (size < 2) {
		x.first
	} {
		current = x[0].collect(_.asArray);
		(1..size-1).do { | i |
			current = ~directProduct.(current, x[i])
		};
		current
	};
	~log.(["allTuples", x, " => ", res]);
	res
};

// computes the duration of a set of time points relative toa cycle.
~computeDur = { | tps, cycle |
	var dur, res;
	dur = tps.differentiate[1..];
	dur = dur mod: cycle;
	dur = dur.collect({| v , i | if (v == 0){ v = cycle}; v });
	res = dur.sum;
	// ~log.(["computeDur", tps, cycle, " => ", res]);
	res
};

// function to sort a groups of time points based on their total duration
~sortTuples = { | array, cycle |
	array.sort({| a, b| ~computeDur.(a, cycle) <= ~computeDur.(b, cycle) })
};

// computes and sorts all possible sub patterns of a pattern
~computeDurs = { | pattern, cantus, start = 0|
	var positions, tuples, durs, clump;
	positions = ~xtrct.(cantus, pattern);
	tuples = ~allTuples.(positions);
	tuples = tuples.sort({| a, b | var ad, bd, temp;
		ad = ~computeDur.(a, 7);
		bd = ~computeDur.(b, 7);
		// handle algorithmic ambiguity
		if (ad == bd) {
			temp = [a, b].flop.detect { |arr| arr[0] != arr[1] };
			temp[0] < temp[1];
		} {
			ad > bd;
		}
	});
	~log.(["computeDurs -- tuples", tuples]);
	clump = ([start mod: cantus.size] ++ tuples.flat).slide(2).clump(2);
	durs = clump.collect({ | pr | var dur = pr[1] - pr[0] mod: cantus.size; if (dur == 0) { dur = cantus.size}; dur });
	// ["computeDurs - clump", clump].postln;
	~log.(["computeDurs", pattern, cantus, start, " => ", durs]);
	durs;
};

~makePart = { | argpattern, cantus, start = 0, stutter = 1|
	var durs, pattern;
	~log.(["makePart", argpattern, cantus, start, stutter]);
	durs = ~computeDurs.(argpattern, cantus, start);
	// if (stutter == 1) {
		pattern = [\r, Pseq(argpattern, inf)];
// } {
	// pattern = [Pseq(\r.dup(stutter)), Pseq(argpattern.clump(stutter).stutter(stutter).flat, inf)];
	// durs = durs.stutter(stutter)/stutter;
// };
	~log.(["makePart - durs", durs]);
	["HELLO", durs.size, argpattern.size].postln;
	Ptuple([Pseq(argpattern /* pattern */), Pseq(durs * 0.2)])
	// [Pseq(argpattern /* pattern */), Pseq(durs * 0.2)]
};

~debugSort = { arg arr;
	arr.copy.sort { |a, b|
		[a, b].flop.any { |i| i[0] > i[1] } .not
	};
};

// ~tupletempo = TempoClock.new;

~spawner = Pspawner({|sp|
	var pat;
	var length, percentRests;
	var lPat, rPat, startTime;
	var catpat =
	Pbind(*[
		instrument: \sine4,
		// note: the following is correct,
		// but ~cantus is not yet defined at this point
		// Pseq(~cantus, inf), // Prout({ loop{ Pseq(~cantus).embedInStream } }),
		note: Prout({ loop{ Pseq(~cantus).embedInStream } }),
		dur: 0.2,
		db: -45,
		// octave: Pstutter(5,Pseq([3,5,4], inf)),
		octave:  5,
		detune: Pseq([ 1.8891892433167, -0.388014793396, 1.2397193908691, 0.63693857192993, -0.338050365448, 1.5794167518616, -0.77405452728271, -0.31130313873291, 1.0970692634583, 0.99920129776001, 0.13957548141479 ], inf),
		pan: 0,
		out: Pseq([ 13, 5, 1, 23, 1, 20, 20, 22, 6, 23, 9, 20, 3 ], inf),
		i: 4,
		ar: 0.001,
		dr: 0.1,
		stretch: 1,
	]);
	startTime = Main.elapsedTime;
	lPat = Pseq( (8..12).mirror, inf).asStream;
	rPat =  Pseq( (5..9).mirror/25, inf).asStream;
	// lPat.next; rPat.next;
	4.do /* loop */ { |iter|
		// ~tupletempo.tempo = ((10..20)/30).choose /2;
		length = lPat.next;
		~cantus = (Pseq([ 3, 6, 4, 6, 4, 3, 6, 3, 5, 4, 6, 5, 4, 2, 5, 4, 2 ], inf) * 2.4).asStream.nextN(length) + 4;
		// { ~cantus[~cantus.size.rand] = \r }.dup((length * rPat.next).asInteger.postln);
		if (~debug) { ("starting" + ~cantus).postln };
		~catter = sp.par(catpat);
		~parts = ~cantus.asSet.asArray. sort /* ! */ .powerset.select{ | v | v.size == 3};
		~parts = ~debugSort.(~parts); /* ! */

		if (~debug) {
			"PARTS:".postln;
			~parts.do(_.postln);
		};

			// #note, dur =
			// ~makePart.(part,~cantus,0, [1,1,2,2,4][iter] /* .choose */);
		~pats = ~parts.collect({ | part, i |
			Pbind(*[
				instrument: \sine4,
				#[note, dur], Pseq([~makePart.(part,~cantus,0, [1,1,2,2,4][iter]),
					Pfunc({ ("voice" + i + "done").postln; nil })]),
				db: -15,
				// octave: Pstutter(5,Pseq([3,5,4], inf)),
				octave:  5,
				legato: i.linlin(0, ~parts.size, 0.02, 1),
				detune: Pseq([ -1.0107450485229, 1.7300729751587, 1.4609007835388, -0.92997121810913, -1.5555047988892, 0.80630779266357, 0.66229104995728, -1.8291440010071, -0.39934587478638, 1.7764806747437, -0.18212461471558 ], inf),
				//		out: Pseq((0..23), inf, i),
				i: Pseq((0..23), inf, i),
				ar: 0.001,
				dr: 0.1,
				stretch: 1,
				db: i.linlin(0, ~parts.size, -40, -30),
			]);
		});
		~here = Main.elapsedTime;
		sp.seq(Ppar(~pats) );
		("ending" + ~cantus + "; took " + (Main.elapsedTime - ~here)).postln;
		// this doesn't have any effect as far as I can tell:
		// { ~cantus[~cantus.size.rand] = \r }.dup(5);
		~waitDur = length *2 * 0.2;
		// ["waiting for", ~waitDur].postln;
		sp.wait(~waitDur);
		"---done waiting".postln;
		sp.suspend(~catter);
	};
	[ "spawn took", (Main.elapsedTime - startTime)].postln;
});

// ~spawner.asStream.all.do({|evt| evt.postln});
// ~rout = fork {
// 	~spawner.embedInStream;
// }
//
// ~rout.asStream.all.size

// "----BEGIN----".postln;~clearLog.();~spawner.asStream.all

// ~logS.size;
// ~logS.do({|s| s.postln; }); nil;
// ~logS.keep(900).do({|s| s.postln; }); nil;
// ~logS.drop(900).do({|s| s.postln; }); nil;
