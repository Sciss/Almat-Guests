
(
{
	var n = 12;
	var incr = ~incrs;//Rand(0.02,0.03!n); //[0.072,0.009];
	var coupling = Rand(-0.08,0.08!n) * MouseX.kr(0,3).lag2(0.3);
	var initPhases =  Rand(0.0,pi*2!n); //[0.0, 2.72];
	var fb = LocalIn.ar(n, initPhases);
	var sumPh = fb;
	var diffs = sumPh.collect{ | thisPh |
		var diff = 0;
		sumPh.do{arg ph;
			diff = diff + (ph - thisPh).sin.cubed; 
		};
		diff;
	};
	sumPh = (sumPh + incr + (coupling * diffs)) % (2 * pi);
	//diffs.poll;
	LocalOut.ar(sumPh);
	Splay.ar(sumPh.sin * 0.1);
}.play
)
