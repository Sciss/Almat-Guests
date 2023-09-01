s.options.numOutputBusChannels = 24;
s.options.numInputBusChannels = 24;
s.options.memSize = 8192 * 10;
s.options.numBuffers = 1024 * 10;

s.options.blockSize = 1;
s.reboot;

s.options.dump


{ Out.ar(0, Impulse.ar(30!6) * 0.1) }.play
s.meter

~c = Buffer.read(s, "/home/luc/Work/plastik/multi.wav")

SinOsc.ar(MouseX.kr(0,2000).poll)

(
{
	var hopf = Hopf.ar(SinOsc.ar(MouseX.kr(0,2000).poll), K2A.ar(0.001), K2A.ar(0.0001)).poll;
	var freqs = (hopf[2]  * 44100) / (2*pi) ;
	freqs.poll;
	[SinOsc.ar(freqs), SinOsc.ar(MouseX.kr(0,2000))] * 0.05;
}.play
)



(
{
	var hopf = Hopf.ar(SinOsc.ar(MouseX.kr(0,2000).poll), K2A.ar(0.001), K2A.ar(0.0001)).poll;
	var freqs = (hopf[2]  * 44100) / (2*pi) ;
	freqs.poll;
	[SinOsc.ar(freqs), SinOsc.ar(MouseX.kr(0,2000))] * 0.05;
}.play
)



(
{
	var n = 6
	var fb = LocalIn.ar(n,0.0);
	//	var inputs = DelayC.ar(PlayBuf.ar(1,~c.bufnum),0.05,Rand(0,0.05!n));
	var inputs = PlayBuf.ar(1,~c.bufnum)!n;
	var filters = n.collect({arg i;
		var out = inputs[i];
		n.do({arg k;
			if (k != i) {
				out = BPeakEQ.ar(out,fb[k].abs.clip(8,16000).lag2(0.1),0.1,-60);
			};
		});
		out;
	});
	var hopfs = Hopf.ar(filters, K2A.ar(0.014571*4), K2A.ar(0.0001));
	var freqs = hopfs.collect({ arg item,i; ( (item[2]  * 44100) / (2*pi) ) });
	LocalOut.ar(freqs);
	freqs.poll;
	Out.ar(0, Splay.ar(SinOsc.ar(freqs) * 0.05) + (inputs[0].dup));
}.play
)



(
// hierarchical
{
	var n = 6;
	var fb = LocalIn.ar(n,0.0);
	//var inputs = SoundIn.ar(0)!n;
	var inputs = PlayBuf.ar(1,~c.bufnum)!n;
	var filters = n.collect({arg i;
		var out = inputs[i];
		if ( i > 0)  {
			(i-1).do({arg k;
				out = BPeakEQ.ar(out,fb[k].abs.clip(8,16000).lag2(0.1),0.05,-60);
			});
		};
		out;
	});
	var hopfs = Hopf.ar(filters, K2A.ar(0.014571*4), K2A.ar(0.0001));
	var freqs = hopfs.collect({ arg item,i; ( (item[2]  * 44100) / (2*pi) ) });
	LocalOut.ar(freqs);
	
	freqs.poll;
	Out.ar(0, Splay.ar(SinOsc.ar(freqs) * 0.3));
}.play
)





~input = Bus.audio(s, 6);
~input.value



(
{
	var fms;
	var n = 6;
	var fb = LocalIn.ar(n,0.0);
	var inputs = LPF.ar(HPF.ar(Mix.ar(InFeedback.ar(~input.index,n)),1000),12500)!n/n;
	var filters = n.collect({arg i;
		var out = inputs[i];
		i.do({arg k;
			out = BPeakEQ.ar(out,fb[k].abs.clip(10,16000).lag2(0.08),0.1,-60);
		});
		out;
	});
	var hopfs = Hopf.ar(filters, K2A.ar(0.01*MouseY.kr(0.02,10,1)), K2A.ar(0.0001));
	var freqs = hopfs.collect({ arg item,i; ( (item[2]  * 44100) / (2*pi) ) });
	LocalOut.ar(freqs);
	fms = n.collect({arg i;
		BPeakEQ.ar(PMOsc.ar(freqs[i], freqs[(i+1)%n],
			MouseX.kr(0.5,10)),
			freqs[(i+2)%n].abs.clip(40,10000).lag2(0.3), 0.2, 20);
	});
	fms = LPF.ar(fms,15000);
	OffsetOut.ar(~input,fms);
	OffsetOut.ar(~input,Impulse.ar(1/10000));
	freqs.poll;
	fms = Limiter.ar(fms*0.5, 0.7);
	Out.ar(0, fms  * 0.01);
}.play
)


{ Out.ar(1, Impulse.ar(20) * 0.1) }.play


(
SynthDef(\hopffm, { arg amp = 0.1, fmin1=50, fmax1=5000, fmin2=50, fmax2=5000,
	fmin3=50, fmax3=5000, pulseWidth = 0.5, pulseFac = 0.5, pulseAmount=0.5,fbbus, index, coupling, inFac, divFreqs=1;
	
	var fms;
	var n = 6;
	var fb = LocalIn.ar(n,0.0);
	var soundin = SoundIn.ar((10..15));
	var inputs = LPF.ar(HPF.ar(Mix.ar(SelectX.ar(inFac.lag2(0.5),[InFeedback.ar(fbbus,n),soundin])),
		[fmin1.lag2(0.2),fmin2.lag2(0.2), fmin3.lag2(0.2),
			fmin1.lag2(0.2), fmin2.lag2(0.2), fmin3.lag2(0.2)]),
		[fmax1.lag2(0.2),fmax2.lag2(0.2), fmax3.lag2(0.2),
			fmax1.lag2(0.2), fmax2.lag2(0.2), fmax3.lag2(0.2)]);
	//	+ soundin;
	var filters = n.collect({arg i;
		var out = HPF.ar(inputs[i],6);
		i.do({arg k;
			out = BPeakEQ.ar(out,fb[k].abs.clip(6,16000).lag2(0.4),0.1,-60);
		});
		out;
	});
	var hopfs = Hopf.ar(filters, K2A.ar(0.01*coupling.lag2(2)), K2A.ar(0.0001));
	var freqs = hopfs.collect({ arg item,i; ( (item[2]  * 44100) / (2*pi) ) }).abs;
	var freqsLow = WrapOct.kr(A2K.kr(freqs), 4, 10).lag3(0.2) * pulseFac.lag3(0.5);
	
	LocalOut.ar(freqs);
	fms = n.collect({arg i;
		PMOsc.ar(freqs[i]/divFreqs, freqs[(i+1)%n]/divFreqs,
			(freqs[(i+3)%n].lag2(1)/100)*index.lag2(1))
		* SelectX.ar(pulseAmount.lag3(0.3),[K2A.ar(1),LFPulse.ar( (freqsLow[(i+4)%n]),0,
			(pulseWidth.lag3(0.4) * RMS.ar([(i+5)%n],4).clip(0.3,2)).clip(0.001,0.999) 
		).lag3(0.02) ])
		
	});

	fms = (BBandPass.ar(fms, freqs.reverse.lag3(0.1).clip(40,12000), 0.05) * 1.25)
	+ fms;
	
	fms = LPF.ar(fms,16000);
	OffsetOut.ar(fbbus,fms);
	//	OffsetOut.ar(fbbus,WhiteNoise.ar(0.1));
	//	freqs.poll;
	fms = Limiter.ar(fms*0.6, 0.7);
	Out.ar(0, fms  * 0.07 * amp.lag3(1));
	//	Out.ar(0, Splay.ar(fms)  * 0.05 * amp.lag2(0.4));
	
}).send(s);
)

s.meter

(

~synth = Synth(\hopffm, [\amp, ~ampCtrl.asMap,
\fmin1,~freq1Ctrl.asMap, \fmax1, ~freq2Ctrl.asMap, \fmin2,
~freq3Ctrl.asMap, \fmax2, ~freq4Ctrl.asMap, \fmin3, ~freq5Ctrl.asMap,
	\fmax3, ~freq6Ctrl.asMap, \pulseWidth,~pulseWidthCtrl.asMap,
\pulseFac,~pulseFacCtrl.asMap, \pulseAmount,~pulseAmountCtrl.asMap, 
	\fbbus,
	~fbbus.index, \index, ~indexCtrl.asMap, \coupling, ~couplingCtrl.asMap,
	\inFac, ~inFacCtrl.asMap, \divFreqs, ~divFreqsCtrl.asMap])

)

~synth.free;

(
MIDIIn.connectAll;


~fbbus = Bus.audio(s, 6);



ControlSpec.specs[\amp] = ControlSpec(0.0, 1, 1, 0.00001, 0);
ControlSpec.specs[\freq] = ControlSpec(6, 15000, 3, 0.001, 1);
ControlSpec.specs[\index] = ControlSpec(0.00001, 50, 5, 0.00001, 2);
ControlSpec.specs[\coupling] = ControlSpec(0.00005, 10, 6, 0.0000001, 0.1);
ControlSpec.specs[\inFac] = ControlSpec(0.0, 1, 0.001, 0.00001, 0.1);
ControlSpec.specs[\divFreqs] = ControlSpec(1, 20, 2, 1, 1);
ControlSpec.specs[\pulseWidth] = ControlSpec(0.001, 0.999, 1, 0.0001, 0.5);
ControlSpec.specs[\pulseFac] = ControlSpec(0.01, 20, 5, 0.0001, 0.5);
ControlSpec.specs[\pulseAmount] = ControlSpec(0.0, 1, 1, 0.0001, 0.5);

~ampCtrl = Bus.control(s, 1).set(0.0);
~freq1Ctrl = Bus.control(s, 1).set(100.0);
~freq2Ctrl = Bus.control(s, 1).set(1000.0);
~freq3Ctrl = Bus.control(s, 1).set(100.0);
~freq4Ctrl = Bus.control(s, 1).set(1000.0);
~freq5Ctrl = Bus.control(s, 1).set(100.0);
~freq6Ctrl = Bus.control(s, 1).set(1000.0);
~pulseWidthCtrl = Bus.control(s, 1).set(0.5);
~pulseFacCtrl = Bus.control(s, 1).set(0.5);
~pulseAmountCtrl = Bus.control(s, 1).set(1);
~couplingCtrl = Bus.control(s, 1).set(0.05);
~indexCtrl = Bus.control(s, 1).set(1);
~inFacCtrl = Bus.control(s, 1).set(0);
~divFreqsCtrl = Bus.control(s, 1).set(1);

MIDIdef.cc(\amp, { arg v;
	~ampCtrl.set(ControlSpec.specs[\amp].map(v/127).postln)}, 41);

MIDIdef.cc(\inFac, { arg v;
	~inFacCtrl.set(ControlSpec.specs[\inFac].map(v/127).postln)}, 42);

// 43 input2

MIDIdef.cc(\divFreqs, { arg v;
	~divFreqsCtrl.set(ControlSpec.specs[\divFreqs].map(v/127).postln)}, 43);

MIDIdef.cc(\pulseAmount, { arg v;
	~pulseAmountCtrl.set(ControlSpec.specs[\pulseAmount].map(v/127).postln)}, 44);


MIDIdef.cc(\pulseFac, { arg v;
	~pulseFacCtrl.set(ControlSpec.specs[\pulseFac].map(v/127).postln)}, 45);

MIDIdef.cc(\pulseWidth, { arg v;
	~pulseWidthCtrl.set(ControlSpec.specs[\pulseWidth].map(v/127).postln)}, 46);

MIDIdef.cc(\fOffset3, { arg v;
	~fOffset3Ctrl.set(ControlSpec.specs[\fOffset].map(v/127).postln)}, 47);



MIDIdef.cc(\fr1, { arg v;
	~freq1Ctrl.set(ControlSpec.specs[\freq].map(v/127))}, 1);
MIDIdef.cc(\fr2, { arg v;
	~freq2Ctrl.set(ControlSpec.specs[\freq].map(v/127))}, 2);
MIDIdef.cc(\fr3, { arg v;
	~freq3Ctrl.set(ControlSpec.specs[\freq].map(v/127))}, 3);
MIDIdef.cc(\fr4, { arg v;
	~freq4Ctrl.set(ControlSpec.specs[\freq].map(v/127))}, 4);
MIDIdef.cc(\fr5, { arg v;
	~freq5Ctrl.set(ControlSpec.specs[\freq].map(v/127))}, 5);
MIDIdef.cc(\fr6, { arg v;
	~freq6Ctrl.set(ControlSpec.specs[\freq].map(v/127))}, 6);

MIDIdef.cc(\coupling, { arg v;
	~couplingCtrl.set(ControlSpec.specs[\coupling].map(v/127))}, 7);

MIDIdef.cc(\idx, { arg v;
	~indexCtrl.set(ControlSpec.specs[\index].map(v/127).postln)}, 8);

)



 
MIDIFunc.trace(false)

x = { Out.ar(0, PinkNoise.ar(0.1)!6) }.play
x.free

s.meter

{ LFPulse.ar(100) }.plot


