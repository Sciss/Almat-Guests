// #[a,  b] = [[ 1, 2, 3], [4, 5, 6]]

~lPat = Pseq( (8..12).mirror, inf).asStream;
~length = ~lPat.next;
~cantus = (Pbrown(-6, 6, 3) * 2.4).asStream.nextN(~length) + 4;

~parts = ~cantus.asSet.asArray.powerset.select{ | v | v.size == 3};
~part = ~parts[0];

x = Pseq([~makePart.(~part,~cantus,0, [1,1,2,2,4].choose),
					Pfunc({ ("voice" + i + "done").postln; nil })])

