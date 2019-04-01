s.options.numOutputBusChannels = 6;
s.options.memSize = 8192 * 10;
s.options.numBuffers = 1024 * 10;
s.reboot;
s.options.blockSize = 1;
s.options.dump


{ Out.ar(5, Impulse.ar(30) * 0.01) }.play
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



 
