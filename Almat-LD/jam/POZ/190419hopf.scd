SynthDef(\hopf, {
	arg freq_coupling = 0.02, idx_coupling = 0.02, freq_filter = 0.0001;
	var n = 6;
	var local= LocalIn.ar(n)+Impulse.ar(0.1);
	var op_freq, op_idx, op_mul, op_phase, sig;
	op_freq = n.collect({arg i; Hopf.ar(local[i], K2A.ar(0.01*freq_coupling), K2A.ar(0.01)).at(3)});
	op_idx = n.collect({
		arg i;
		n.collect({
			arg idx;
			Hopf.ar(op_freq[i], K2A.ar(0.01*(idx_coupling/LFNoise2.kr(1,10,10))), K2A.ar(0.01)).at(2)
		})
	});
	op_mul = n.collect({rand(10!n)/10}+0.001);
	op_phase = n.collect({
		arg i;
		var modulators = n.collect({
			arg index;
			local[i]*op_idx[i][index];
		});
		modulators.sum;
	});

	sig = n.collect({
		arg i;
		SinOsc.ar(ZeroCrossing.ar(LPF.ar(op_freq[i],freq_filter)), op_phase[i], op_mul[i]);
	});

	sig = sig.clip(-0.5, 0.5);

	LocalOut.ar(sig);
	Out.ar(0,Splay.ar(LPF.ar(sig,1000)*0.5));
}).add

m = MidiMix.new.setKnobs(0.01, 1, 0.01, 20, 0.01, 200)

c = Synth(\hopf, [
	\freq_coupling, m.knobs.subBus(0).asMap,
	\idx_coupling, m.knobs.subBus(1).asMap,
	\freq_filter, m.knobs.subBus(2).asMap
])

c.free