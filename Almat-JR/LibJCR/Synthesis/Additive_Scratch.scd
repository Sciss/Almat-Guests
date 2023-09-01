Server.default = s = Server.internal.boot;



// Some very interesting additive synthesis from Farnell's designing sound

( x={
var freq = MouseX.kr(100, 1000, 1) / SampleRate.ir;
	var distance = 3.00;
var index = MouseY.kr(0.42, 0.99);
var theta, beta, num, denom, son;
	freq.poll;
// Two phasors which will ramp from zero to 2pi
theta = Phasor.ar(0, freq, 0, 2pi);

	beta  = Phasor.ar(0, freq * distance, 0, 2pi);
      num = sin(theta) - (index * sin(theta - beta));
      denom = 1 + index.squared - (2 * index * cos(beta));
      son = num / denom;
      Out.ar(0, Pan2.ar(son * 0.3));
}.freqscope; // Use ".freqscope" or ".scope", both are illustrative. )\
);

{ Saw.ar(300, mul: 0.1) }.freqscope

FreqScopeView



Ndef(\test, {
	Saw.ar(Lag.kr(\f0.kr(200),0.3), mul: 0.1)
});
Ndef(\test).play
Ndef(\test).stop
Ndef(\test).edit; // make a gui


// Get em to the front..
Window.allWindows.do {|win| win.front }



/*
From Designing Sound pg. 269
Basically additive synthesis is a number of sine oscillators with
different envelopes. Oscillators can be grouped to share a similar envelope,
or controlled in different ways.

The trick is finding interesting frequency ratios and controlling all
those parameters! AddSynth has LOTS of parameters to control.

*/


// Take a gander at your envelope
Env([0,1,0.5,0.5,0],[1,1,0.5,2],\sin).plot;

// TODO: How about an interactive envelope plot for creating envelopes?

(
s = Server.quickBoot;
s.waitForBoot {
SynthDef(\osc, {|freq=60,phase=0,gain=0.1|
	var sig,envsig,env,envctl;
	env = Env.newClear(4);
	envctl = \env.kr(env.asArray);
	sig = SinOsc.ar(freq,phase);
	envsig = EnvGen.ar(envctl,1,gain,doneAction:2);
	Out.ar(0,sig * envsig);
}).add;

SynthDef(\oscsweep, {|fstart=60,fend=1200,pstart=0,pend=0,dur=1,exp=0,gain=0.1,pan=0|
	var sig,envsig,env,envctl,line,frange,prange,freq,phase;
	frange = fend-fstart; prange = pend-pstart;
	env = Env.newClear(4);
	envctl = \env.kr(env.asArray);
	line = ((1-exp)*Line.ar(0,1,dur)) + ((exp)*XLine.ar(0.00001,1, dur));
	freq = fstart + (line * frange);
	phase = pstart + (line * prange);
	sig = SinOsc.ar(freq,phase);
	envsig = EnvGen.ar(envctl,1,gain,timeScale: dur,doneAction:2);
	Out.ar(0,Pan2.ar(sig * envsig,pan));
}).add;

};

);

Synth(\oscsweep, [\fstart,200,\fend,300,\pstart,0,\pend,pi,\dur,1.1,\exp,1,\env,Env([0,1,0],[0.5,0.5],\sin),\gain,1,\pan,0]);


/*

Synth(\osc, [\freq,310,\env, Env([0,1,0.5,0.5,0],[1,1,0.5,2],\sin)]);
Synth(\osc, [\freq,610,\env, Env([0,0.2,0.9,0.5,0],[1.2,1,0.5,2],\sin)]);
Synth(\osc, [\freq,1210,\env, Env([0,1,0.5,0.5,0],[1.4,1,0.5,2],\sin)]);
Synth(\osc, [\freq,2410,\env, Env([0,1,0.5,0.5,0],[1.5,1,0.5,2],\sin)]);

*/

//Additive frequency relationships based on the Cantor set
~freqbounds = BoundedRealSet.new(50,8000);
~freqbounds = BoundedRealSet.new(120,15000);
~cantorSet = BoundedRealSet.makeCantor(3,~freqbounds);
~waitTime = 0.1;


( // Play all values as partials
s.makeBundle(nil, {
	var envs = Array.newClear;
	envs.add(Env([0,1,0.5,0.5,0],[1,1,0.5,2],\sin));
	envs.add(Env([0,0.5,1.0,0.6,0],[1,1,0.5,2],\sin));
	fork {
	~cantorSet.do({|boundedset,i|
		var left=boundedset.leftBound,right=boundedset.rightBound;
		var len = ~cantorSet.size;
		Synth(\osc, [\freq,left,\env,envs[0],\gain,0.05]);
		~waitTime.wait;
		Synth(\osc, [\freq,right,\env,envs[1],\gain,0.03]);
		~waitTime.wait;

	});
	};
});
)

/*
Noteable params:
delay: 0.1
f: 1137-10610  d: 4
f: 1344-2982  d: 3
f: 707-10599  d: 4
f: 543-12208  d: 4
f: 83-2267   d: 3
f: 1675-12533 d: 4  w: 0.1916
*/

~waitTime = 0.1;
(  // Play segments
s.makeBundle(nil, {
	fork {
	var start,end,degree,envs = Array.newClear;
	envs.add(Env([0,1,0.5,0.5,0],[0.1,0.1,0.3,0.5],\sin));
	start = rrand(40,3000); end = rrand(start+100,start+12000);
	degree = [2,3,4,5].choose;
	~waitTime = rrand(0.05,1);
	(""+start++"-"++end++"hz "++degree++" "++~waitTime++"s ").postln;
	~cantorSet = BoundedRealSet.makeCantor(degree,BoundedRealSet.new(start,end));
	~cantorSet.do({|boundedset,i|
		var left=boundedset.leftBound,right=boundedset.rightBound;
		var len = ~cantorSet.size;
			Synth(\oscsweep, [\fstart,left,\fend,right,\pstart,0,\pend,0,\dur,rrand(0.1,(len)),\exp,0,
				\env,envs[0],\gain,(1.0 / len),\pan,0]);
		~waitTime.wait;
	});
	};
});


);

// Cool.. now how do I compose?
// How about something from Flake. A series of works based on the Cantor set



a = [1,2,3,4,5,6];
b = [11,22,33,44,55,66];
a.size / 2
b.size / 2
a ++ b
a.do({|val, i| val.postln; i.postln;});



// Frequency Based Analysis/Resynthesis/Frequency Sculpting...
// Benefit of Additive synthesis is that you can compose nearly any sound you can imagine.
// Though it takes a long time.. ADDSYNTH has a lot of parameters..
/*
Spectral Formula of a Waveform
Square: 1/n with no even partials
Sawtooth/Phasor wave: 1/n when n is even or odd.
Triangle wave: 1/n^2 when n is odd, 0 when n is even. (Note how "fast" the amplitudes of a triangle wave drop off—it’s said to be a "not very bright" timbre.)
*/
// Constructing a sawtooth wave (ramp/phasor) by superposing all harmonic partials n with amplitude 1/n.

// http://jahya.net/blog/?2012-05-overtones-harmonics-and-additive

{ Saw.ar(220,mul:-1.0) }.plot(0.02);
{
	var f0=220,sig=0;
	100.do {|i|
		sig=sig+SinOsc.ar(f0 * (i+1),mul: 0.5 / (i+1));
	};
	sig;
}.plot(0.02);
// Square wave
{
	var f0=220,sig=0;
	100.do {|i|
		var ampbase = 0.5 * ((i+1) % 2);
		sig=sig+SinOsc.ar(f0 * (i+1),mul: ampbase / (i+1));
	};
	sig;
}.plot(0.02);
// Tri wave
{ LFTri.ar(220) }.plot(0.02);
{
	var f0=220,sig=0;
	100.do {|i|
		var ampbase = 0.5 * ((i+1) % 2);
		sig=sig+SinOsc.ar(f0 * (i+1),mul: ampbase / ((i+1)**2));
	};
	sig;
}.plot(0.02);


/*
FFT(buf,input) --- FFT will store spectral data in a local buffer in the following order:
DC,nyquist,real 1f,imag 1f, real 2f, imag 2f ... real (N-1)f, image (N-1)f
Where f is the frequency corresponding to the window size. And N is the window size / 2
Buffer size must be a power of 2, and must be a multiple of SC's block size. The window size is equivalent to the buffer size. And window overlap defaults to 2. Both FFT and IFFT use a sine window by default, the combination of which (i.e. a raised sine) is a Hanning window.


.getn
.pvcollect
*/

~fftsize = s.options.blockSize * 16;
~fftbuf = Buffer.alloc(s, ~fftsize, 1);

{
	var sig,chain;
	sig = Saw.ar(220);
	chain = FFT(~fftbuf,sig);
}.play;


// Scoping an FFT

~bins = s.options.blockSize * 16; // frequency bins
~winsize = ~bins * 2; // window size (double the number of frequency bins we want)
~fftbuf = Buffer.alloc(s, ~winsize);
~data2 = 0 ! ~winsize; // init some 0'ed arrays
~data = 0 ! ~bins;
~rate = 100.reciprocal;



(
SynthDef("fft", {
var sig, chain, freqs, ringtimes;
freqs = Array.rand( 48, 800.0, 10000.0 ) * MouseX.kr( 0.25, 2, 1 );
ringtimes = Array.rand( 48, 1.0, 4.0 ) * MouseY.kr( 0.01, 10, 1 );
sig = DynKlank.ar(`[ freqs, nil, ringtimes ], Impulse.ar( MouseX.kr( 1,
25, 1 ), 0, 0.5 ));
chain = FFT(~fftbuf, sig, wintype: 1);
Out.ar( 0, sig );
}).add;

)


( // fft scope
var n, width, height, wpos, v;
height = 400;
width = 1024;
w = Window( "Digits", Rect( 0, 606, width, height )).front;
w.view.background = Color.black;
w.onClose = { x.free; r.stop; };
w.drawFunc = {
	~bins.do({ |i|
		Pen.fillColor = Color.hsv( ~data.at( i ).abs * 0.002 + 0.004, 1, 1);
		Pen.fillRect( Rect( i , 400 - ( ~data.at( i ).abs.trunc / 2) , 1,100) );
	});
};

x = Synth("fft");

{ SinOsc.ar(MouseX.kr(100,1000),mul:0.2) }.freqScope;

r = {
	while({ w.isClosed.not }, {
		~fftbuf.getn(0, ~winsize,
			{ |buf|
				if (~data2 != buf) {
					~data2 = buf;
					~data = ~data2.clump(2).collect({ |x| Complex(x[0],x[1]).magnitude });
					// ~data = ~data2.clump(2).flop[0]; // eller
				};

				{ w.refresh }.defer;
		});
		~rate.wait
	});
}.fork( AppClock );

)

Server.default = s = Server.internal.boot;

{ Saw.ar(MouseX.kr(100,1000),mul: MouseY.kr(0.1,0.9)) }.play;
s.meter

// Rough frequency scope
JScope.build(s);



// fft addsyn
(
~bufsize = s.options.blockSize * 128; // a higher fft window decreases overlap effects
~mybuf = Buffer.alloc(s,~bufsize);
x = {
	var chain,sig;
	chain = FFT(~mybuf,SinOsc.ar(0),hop: 0.5,wintype: 0);

	// max magnitude is windowsize / 2 ... but gets more intense the lower you go
	chain = chain.pvcalc(~bufsize,{|mags,phases|
		var mousey = 500; //MouseX.kr(1,300);
		mags[192] = mousey;
		[mags,phases];
	},frombin:0,tobin:400,zeroothers:0);

	Out.ar(0,IFFT(chain));
}.scope;
);

y = { Out.ar(1,SinOsc.ar(MouseY.kr(80,90).poll,mul: 0.3)) }.scope;
y.free;
// At 44.1ksps
// At a buffer size of 1024:
// Hop 1.0
// Bin 1 is about 33
// Bin 2 is about 64.59
// Bin 3 is approx 86
// Bin 4 is about 129.2
// Bin 5 is about 215.33 Hz
// Bin 6 is approx 258
// Bin 8 is about 344.5 Hz
// Bin 10 is about 430.65 Hz
// Bin 12 is approx 516.75 Hz
// Bin 16 is approx 690 Hz
// Bin 20 is approx 827.33Hz
// Bin 24 is about 1034Hz

// Half the bins, double the bin values.
// Bins are harmonic partials of the fundamental
// At a buffer size of 512:
// Bin 1 is about 86
// Bin 2 is about 172
// Bin 3 is approx
// Bin 4 is app 344 Hz
// Bin 5 is about  Hz
// Bin 6 is approx
// Bin 8 is about 689 Hz
// Bin 10 is about  Hz
// Bin 12 is approx  Hz
// Bin 16 is approx  Hz
// Bin 20 is approx Hz
// Bin 24 is about Hz
/*
UnpackFFT
PackFFT
*/

Server.default = s = Server.internal.boot;

// fft addsyn
(
~bufsize = s.options.blockSize * 64; // a higher fft window decreases overlap effects
~mybuf = Buffer.alloc(s,~bufsize);
~startbin = 24;
x = {
	var chain,sig;
	chain = FFT(~mybuf,SinOsc.ar(0),hop: 0.5,wintype: 0);

	// max magnitude is windowsize / 2 ... but gets more intense the lower you go
	chain = chain.pvcalc(~bufsize,{|mags,phases|
		var amp = 300; //MouseX.kr(1,300);
		mags[190 - ~startbin] = amp;
		mags[192 - ~startbin] = amp * 0.75;
		mags[250 - ~startbin]= amp * 0.5;
		mags[340 - ~startbin]= amp * 0.4;

		[mags,phases];
	},frombin:~startbin,tobin:350,zeroothers:0);

	Out.ar(0,IFFT(chain));
}.scope;
);

JScope.build(s);





