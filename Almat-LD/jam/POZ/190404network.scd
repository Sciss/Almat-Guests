//blocksize 4
//button 6/7

SynthDef(\001578, {
	|leak=0.9999, out=100, amp= -38.1, rate=0.1, rrate=1, pulse=12,
	freq=12.5, mod=0.01, mindx1=1.95, mindx2=0.8, sign=0, period=0, soundin_amp = 1,
	tone=2500, f1=1, f3=1, slopeBelow=5, zeroscale=4, zeroadd=0, sigamp=0, soundinamp=1, zc=1, trigger = 0|

	var router= InFeedback.ar((200..209)).clip(-1, 1).checkBadValues;
	var local= LocalIn.ar(2);
	var sig, op= Array.newClear(2);
	var op_freq= Array.newClear(2);
	var op_mod= Array.fill(2, {[0,0]});
	var zero= ZeroCrossing.ar(router[2])*MouseX.kr(0,1);
	var p1= freq*f1;//30*f1
	var p3= tone*f3*router[0];
	var gen= Select.ar(router[6].abs.sign, [K2A.ar(1), router[6].sqrt]);
	//first two inputs (David)
	var hopf = Hopf.ar(SoundIn.ar([2,3])*soundin_amp, K2A.ar(0.01*MouseY.kr(0.02,10,1)), K2A.ar(0.01));
	var mood= CombC.ar(hopf, 5.5, MouseX.kr(15.5, 0.015))+Pulse.ar(p1+p3)*mod+router[6]*gen;
	var sens;

	//mood = PlayBuf.ar(1, d.default[1]);
	Out.ar(301, mood*0.5);

	op_freq[0]= rate*rrate+(router[4].abs*100);
	op_freq[1]= router[0].sign*sign;

	op_mod[0][0]= Hopf.ar(router[8]);
	op_mod[1][0]= router[9];
	op_mod[0][1]= mindx1+router[4];
	op_mod[1][1]= mindx2+router[5];

	op_mod[0][0]= local[0]*op_mod[0][0];
	op_mod[0][1]= local[1]*op_mod[0][1];
	op_mod[1][0]= local[0]*op_mod[1][0];
	op_mod[1][1]= local[1]*op_mod[1][1];

	Out.ar(304, local);

	op[0]= SinOsc.ar(op_freq[0], op_mod[0][0]+op_mod[0][1]);
	op[1]= SinOsc.ar(op_freq[1], op_mod[1][0]+op_mod[1][1]);

	LocalOut.ar(op);

	//op = op + LPCError.ar(op, 5);

	sig= op*amp.dbamp;
	//sig= LeakDC.ar(sig, 0.99999999);
	//sig= LeakDC.ar(sig, leak);
	sens= SinOsc.ar((zero*zeroscale+(router[7]*13000)))*router[3];

	//Out.ar(300, sig*SinOsc.ar(LFNoise0.kr(0.2,0.5).abs).abs);
	Out.ar(300, sig*MouseY.kr(0,0.5));
	Out.ar(302, hopf);
	sig= LeakDC.ar(sig, 0.999999);
	//sig = LeakDC.ar(sig);
	//sig = BRF.ar(sig, 6300, 3);
	sig = sig.clip(-1,1);
	//Out.ar(out, sig*30.dbamp*EnvGen.kr(e,trigger));
	Out.ar(out, sig*30.dbamp);
	//Out.ar(out, [router[2],router[7]]);
}, [0.5]).add;

r= Router.new(100,0,4,4,0).loadStereo.survive;
n= Router(300,200,4,10,1,false,700,700).survive;
o= Router(300,200,4,10,2,false,700,550).survive;
p= Router(300,200,4,10,3,false,700,400).survive;
if(m.isNil){m = MidiMix.new(700,0)};

defer{r.threshold.valueAction= 0.16};
defer{r.gain.valueAction= 0.9};