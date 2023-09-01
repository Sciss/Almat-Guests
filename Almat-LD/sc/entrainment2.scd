p = ();

p.rate = 0.01;

p.osc1 = ();
p.osc1.phase = 0;
p.osc1.incr = 0.01;
p.osc1.coupling = 0.005;

p.osc2 = ();
p.osc2.phase = 0.5;
p.osc2.incr = 0.01;
p.osc2.coupling = 0.005;

Tdef(\run, {
	loop {
		var diff = p.osc1.phase - p.osc2.phase;
		var corr1 = sin(diff * 2pi).neg * p.osc1.coupling;
		var corr2 = sin(diff * 2pi) * p.osc2.coupling;

		p.osc1.phase = p.osc1.phase + p.osc1.incr + corr1;
		if (p.osc1.phase > 1) {
			p.osc1.phase = p.osc1.phase - 1;
			().play;
		};

		p.osc2.phase = p.osc2.phase + p.osc2.incr + corr2;
		if (p.osc2.phase > 1) {
			p.osc2.phase = p.osc2.phase - 1;
			(degree:1).play;
		};
		diff.postln;
		p.rate.wait;
	}
});

Tdef(\run).play;
Tdef(\run).stop;

p.osc1.phase = 0; p.osc2.phase = 0.49;
