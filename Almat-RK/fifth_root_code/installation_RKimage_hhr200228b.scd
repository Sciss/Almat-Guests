(
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
	minItem = cantus.reject(_ == \r).minItem; // added HHR
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

~mkScores = { arg num;
	var pat;
	var length, percentRests;
	var lPat, rPat, score;
	var offset = 0;
	var catpat =
	Pbind(*[
		instrument: \sine4,
		note: Prout({ loop{ Pseq(~cantus).embedInStream } }),
		note: Pkey(\note) * 2.4 + 4,
		dur: 0.2,
		db: -45,
		// octave: Pstutter(5,Pseq([3,5,4], inf)),
		octave:  5,
		detune: Pwhite(-2.0,2.0),
		pan: 0,
		out: Pwhite(0, 23),
		i: Pseq((0..23), inf),
		ar: 0.001,
		dr: 0.1,
		stretch: 1,
		legato: 1,
	]);
	lPat = Pseq( (8..12).mirror, inf).asStream;				// length of the cantus
	rPat =  Pseq( (5..8).mirror/25, inf).asStream;		// number of rests
	~oldPlot = nil;
	Array.fill(num, {
		length = lPat.next;
		~cantus = (Pbrown(-6, 6, 3) ).asStream.nextN(length);
		(length * rPat.next).asInteger.do {
			~cantus[~cantus.size.rand] = \r
		};
		~pitchsets = ~cantus.asSet.asArray.powerset.select{ | v | v.size == 3};
		~pitchsets = ~pitchsets.collect(_.scramble);
		~durs = ~pitchsets.collect({ | pset |~computeDurs.(pset, ~cantus).sum });
		score = ~makeScore.(~pitchsets, ~cantus);
		offset = offset + 1 mod: 24;
		score
	});
};
)

~scores = ~mkScores.(100);
~scores[0].plot(bounds: Rect(0, 1000, 1500, 700), discrete: true, minval: 1, maxval: 8).plotMode_(\steps);


(
~writeScores = { arg fName, scores;
	var f;
	f = File.new(fName, mode: "w");
	f.putInt32(scores.size);
	scores.do { arg score;
		f.putInt32(score.size);
		score.do { arg voice;
			f.putInt32(voice.size);
			voice.do { arg elem;
				if (elem.isKindOf(Integer)) {
					f.putInt32(elem);
				} {
					["Not an integer:", elem, elem.class].postln;
				}
			};
		};
	};
	f.close;
};
)

~writeScores.("rk-scores.bin", ~scores);
