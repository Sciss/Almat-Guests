//multichannel expansion issue
SynthDef(\hopf, {
	arg freq_coupling = 0.02, idx_coupling = 0.02, freq_filter = 0.0001;
	var n = 6;
	var local= LocalIn.ar(n)+Impulse.ar(0.1);
	var op_freq, op_idx, op_mul, op_phase, sig;
	op_freq = n.collect({arg i; Hopf.ar(local[i], K2A.ar(0.01*freq_coupling), K2A.ar(0.01)).at(0)});
	op_freq = op_freq.poll;
}).play


SynthDef(\hopf, {
	arg freq_coupling = 0.02, idx_coupling = 0.02, freq_filter = 0.0001;
	var n = 6;
	var local= LocalIn.ar(n)+Impulse.ar(0.1);
	var op_freq, op_idx, op_mul, op_phase, sig;
	op_freq = Hopf.ar(local, K2A.ar(0.01*freq_coupling), K2A.ar(0.01)).at(0);
	op_freq = op_freq.poll;
}).play


//multichannel serendipities

{
	var n = 6;
	var local= LocalIn.ar(n);
	var op_freq = rand(200!n);
	var op_idx = n.collect({rand(10!n)/100});
	var op_mul = n.collect({rand(10!n)/100}+0.001);
	var op_phase = n.collect({
		arg i;
		var modulators = n.collect({
			arg index;
			local[i]*op_idx[i][index];
		});
		modulators.sum;
	});

	var sig = n.collect({
		arg i;
		SinOsc.ar(op_freq[i], op_phase[i], op_mul[i]);
	});

	LocalOut.ar(sig);
	sig;

}.play


{
	var n = 6;
	var local= LocalIn.ar(n)+Impulse.ar(0.1);
	var op_freq = n.collect({arg i; Hopf.ar(local[i], K2A.ar(0.01*MouseY.kr(0.02,10,1)), K2A.ar(0.01))});
	var op_idx = n.collect({Pulse.ar(rand(1!n))});
	var op_mul = n.collect({rand(10!n)/10}+0.001);
	var op_phase = n.collect({
		arg i;
		var modulators = n.collect({
			arg index;
			local[i]*op_idx[i][index];
		});
		modulators.sum;
	});

	var sig = n.collect({
		arg i;
		SinOsc.ar(ZeroCrossing.ar(LPF.ar(op_freq[i],MouseX.kr(1,200))), op_phase[i], op_mul[i]);
	});

	sig = sig.clip(-0.5, 0.5);

	LocalOut.ar(sig);
	Splay.ar(HPF.ar(sig,100));

}.play


{
	var n = 6;
	var local= LocalIn.ar(n)*0.9+SoundIn.ar((0..5));
	var op_freq = n.collect({arg i; Hopf.ar(local[i], K2A.ar(0.01*MouseY.kr(0.02,10,1)), K2A.ar(0.01))});
	var op_idx = n.collect({arg i; Hopf.ar(op_freq[i], K2A.ar(0.01*MouseY.kr(0.02,rand(20!n),1)), K2A.ar(0.01))});
	var op_mul = n.collect({rand(10!n)/10}+0.001);

	var op_phase = n.collect({
		arg i;
		var modulators = n.collect({arg index; local[i]*op_idx[i][index]});
		modulators.sum;
	});

	var sig = n.collect({
		arg i;
		SinOsc.ar(ZeroCrossing.ar(LPF.ar(op_freq[i],MouseX.kr(1,200))), op_phase[i], op_mul[i]);
	});

	sig = sig.clip(-0.5, 0.5);

	LocalOut.ar(sig);
	Splay.ar(HPF.ar(sig,100));

}.play


Ndef(\hopf, {
	var n = 6;
	var local= LocalIn.ar(n)*SoundIn.ar((0..5));
	var op_freq = n.collect({arg i; Hopf.ar(local[i], K2A.ar(0.01*MouseY.kr(0.02,10,1)), K2A.ar(0.01))});
	var op_idx = n.collect({arg i; Hopf.ar(op_freq[i], K2A.ar(0.01*MouseY.kr(0.02,rand(20!n),1)), K2A.ar(0.01))});
	var op_mul = n.collect({rand(10!n)/10}+0.001);
	var op_phase = n.collect({
		arg i;
		var modulators = n.collect({
			arg index;
			local[i]*op_idx[i][index];
		});
		modulators.sum;
	});

	var sig = n.collect({
		arg i;
		SinOsc.ar(ZeroCrossing.ar(LPF.ar(op_freq[i],MouseX.kr(0.0001,200))), op_phase[i], op_mul[i]);
	});

	sig = sig.clip(-0.5, 0.5);

	LocalOut.ar(sig);
	Splay.ar(HPF.ar(sig,100));
}).play



Ndef(\hopf, {
	var n = 6;
	var local= LocalIn.ar(n)+Impulse.ar(0.1);
	var op_freq = n.collect({arg i; Hopf.ar(local[i], K2A.ar(0.01*MouseY.kr(0.02,10,1)), K2A.ar(0.01))});
	var op_idx = n.collect({arg i; Hopf.ar(op_freq[i], K2A.ar(0.01*MouseY.kr(0.02,rand(20!n),1)), K2A.ar(0.01))});
	var op_mul = n.collect({rand(10!n)/10}+0.001);
	var op_phase = n.collect({
		arg i;
		var modulators = n.collect({
			arg index;
			local[i]*op_idx[i][index];
		});
		modulators.sum;
	});

	var sig = n.collect({
		arg i;
		SinOsc.ar(ZeroCrossing.ar(LPF.ar(op_freq[i],MouseX.kr(0.0001,200))), op_phase[i], op_mul[i]);
	});

	sig = sig.clip(-0.5, 0.5);

	LocalOut.ar(sig);
	Splay.ar(HPF.ar(sig,100));
}).play

Ndef(\hopf, {
	var n = 6;
	var local= LocalIn.ar(n)+Impulse.ar(0.1);
	var op_freq = n.collect({arg i; Hopf.ar(local[i], K2A.ar(0.01*MouseY.kr(0.02,10,1)), K2A.ar(0.01))});
	var op_idx = n.collect({arg i; Hopf.ar(op_freq[i], K2A.ar(0.01*MouseY.kr(0.02,rand(20!n),1)), K2A.ar(0.01))});
	var op_mul = n.collect({rand(10!n)/10}+0.001);
	var op_phase = n.collect({
		arg i;
		var modulators = n.collect({
			arg index;
			local[i]*op_idx[i][index];
		});
		modulators.sum;
	});

	var sig = n.collect({
		arg i;
		SinOsc.ar(ZeroCrossing.ar(LPF.ar(op_freq[i],MouseX.kr(0.0001,200))), op_phase[i], op_mul[i]);
	});

	sig = sig.clip(-0.5, 0.5);

	LocalOut.ar(sig);
	Splay.ar(HPF.ar(sig,100));
}).play


6.collect({ (rand(10!6)/10)+0.001});

5.collect({ 1 + 2 })+0.1

SynthDef(\hopf, {
	arg freq_coupling = 0.02, idx_coupling = 0.02, freq_filter = 0.0001;
	var n = 6;
	var local= LocalIn.ar(n)+Impulse.ar(0.1);
	var op_freq = n.collect({arg i; Hopf.ar(local[i], K2A.ar(0.01*freq_coupling), K2A.ar(0.01))});
	var op_idx = n.collect({arg i; Hopf.ar(op_freq[i], K2A.ar(0.01*(idx_coupling/rand(10!n))), K2A.ar(0.01))});
	var op_mul = n.collect({rand(10!n)/10}+0.001);
	var op_phase = n.collect({
		arg i;
		var modulators = n.collect({
			arg index;
			local[i]*op_idx[i][index];
		});
		modulators.sum;
	});

	var sig = n.collect({
		arg i;
		SinOsc.ar(ZeroCrossing.ar(LPF.ar(op_freq[i],freq_filter)), op_phase[i], op_mul[i]);
	});

	sig = sig.clip(-0.5, 0.5);

	LocalOut.ar(sig);
	Out.ar(0,Splay.ar(HPF.ar(sig,100)));
}).add

m = MidiMix.new.setKnobs(0.01, 1, 0.01, 20, 0.01, 200)

c = Synth(\hopf, [
	\freq_coupling, m.knobs.subBus(0).asMap,
	\idx_coupling, m.knobs.subBus(1).asMap,
	\freq_filter, m.knobs.subBus(2).asMap
])


c.free