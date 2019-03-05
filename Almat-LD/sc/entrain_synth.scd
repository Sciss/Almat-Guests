s.options.blockSize = 1;
s.reboot;


{ Out.ar(0, SinOsc.ar(100) * 0.01) }.play

(
{
	var incr = [0.072,0.009];
	var coupling = [0.01, 0.01] * MouseX.kr(0,3).lag2(0.3);
	var initPhases = [0.0, 2.72];
	var fb = LocalIn.ar(2, initPhases);
	var sumPh1 = fb[0] ;
	var sumPh2 = fb[1];
	var diff1 = (sumPh2 - sumPh1).sin;
	var diff2 = (sumPh1 - sumPh2).sin;
	sumPh1 = (sumPh1 + incr[0] + (coupling[0] * diff1)) % (2 * pi);
	sumPh2 = (sumPh2 + incr[1] + (coupling[1] * diff2)) % (2 * pi);
	diff1.poll;
	LocalOut.ar([sumPh1,sumPh2]);
	Out.ar(0, [sumPh1.sin, sumPh2.sin] * 0.1 );
}.play
)



~incrs = Array.rand(12, 0.03, 0.08);

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
			diff = diff + (ph - thisPh).sin;
		};
		diff;
	};
	sumPh = (sumPh + incr + (coupling * diffs)) % (2 * pi);
	//diffs.poll;
	LocalOut.ar(sumPh);
	Splay.ar(sumPh.sin * 0.1);
}.play
)


~incrs = Array.rand(12, 0.01, 0.1);


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

// Experiment:X
// gleiche freqs, nur phasen hören im raum
// phasendiffernzen sonifizieren, diffs sonifizieren
// mikro als oszillaotur
// phasendiff aus mirko input, hörer bewegen, mikro bewegen


// ugen
// special index for unary op for sin and cubed
