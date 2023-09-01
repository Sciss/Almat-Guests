


a = Array.series(100,32,32); // harmonic partials of 32hz

// Make a sequential pattern from said array
p = Pseq(a);

q = p.asStream; // make me a stream

q.next; // call this until we run out... same as a routine

// Now.. much cooler. Pseq iterates its array as a collection of
// PATTERNS. So Pseq can replace any value in the array.

(
var a1,a2,a3,pat,stream;
a1 = Array.series(10,32,32);
a2 = Array.series(10,34,34);
a3 = Array.series(10,69,69);
pat = Pseq([Pseq(a1),Pseq(a2),Pseq(a3)]);
q = pat.asStream;
);

q.next; // goes through each pseq in order...

// embedInStream is how this magic happens. A routine can
// manually create pattern behavior by calling
// embedInStream instead of yield

// EVENTS
/*
An Event is an Environment with a play method. It is a Dictionary, a collection of key value pairs. The pattern Pbind connects specific patterns with specific names.

Running .play on an event stream doesn't actually return the pattern, but instead an EventStreamPlayer object which is responsible for running the pattern on a clock. Stuff like stop, pause, resume, play reset should be addressed to the eventstreamplayer object. A single pattern can play multiple times on multiple eventstreamplayers.
*/

// .record can record event patterns in realtime!
// Score can do non-realtime recordings of patterns.. though
// can be difficult.. check out Pfset or Pproto

/*
Pbind
Binds patterns to different keys in an event stream.
Patterns bound to keys are known as value patterns.
*/

Server.default = s = Server.internal.boot;

(
SynthDef(\oscsweep, {|fstart=60,fend=1200,pstart=0,pend=0,len=1,exp=0,amp=0.1,pan=0|
	var sig,envsig,env,envctl,line,frange,prange,freq,phase;
	frange = fend-fstart; prange = pend-pstart;
	env = Env([0,1,1,0],[0.33,0.33,0.33],\sin);
	line = ((1-exp)*Line.ar(0,1,len)) + ((exp)*XLine.ar(0.00001,1, len));
	freq = fstart + (line * frange);
	phase = pstart + (line * prange);
	sig = SinOsc.ar(freq,phase);
	envsig = EnvGen.ar(envctl,1,amp,timeScale: len,doneAction:2);
	OffsetOut.ar(0,Pan2.ar(sig * envsig,pan));
}).add;

);

Synth(\oscsweep, [\fstart,200,\fend,300,\pstart,0,\pend,pi,\len,1.1,\exp,1,\env,Env([0,1,0],[0.5,0.5],\sin).asArray,\amp,1,\pan,0]);

Pbind(\instrument,\oscsweep,
	\fstart,Pseq([200,300,400]),\fend,300,\len,1.1,\exp,1,\amp,1,\pan,0,\delta,1
).play;



a = Pbind(\instrument, \oscsweep,
	\fstart,Env([50,500,50],[0.2,1],\sin),
	\fend,Env([100,300,500,1200,1000],[3,1,1,0.2],\sin),
	\delta,0.05,
	\len,Pseq(Array.geom(30,1,0.9)),
	\exp,0,
	\amp,Pseq(Array.geom(30,0.5,0.9)),
	\pan,Prand([-1,1,-0.4,0.4],inf)
);
q = a.play;

q.stop;

s.scope

SynthDef(\adder, {|freqs=#[50,100,150],amps=#[0.5,0.3,0.2],phases=#[0,1,1.5]|
	var sig,env;
	sig = DynKlang.ar(`[freqs,amps,phases]);
	Out.ar(0,Pan2.ar(sig,0,1));
}).add;

b = Pmono(\adder,
	\freqs,Pfunc({Array.series(40,rrand(40,500),rrand(30,80))}),
	\amps,Array.fill(40,{|i| 1.0 / 40}),
	\phases,Array.fill(40, {|i| pi / 20}),
	\delta,Pseq([2,3],inf)

);


t=b.play;


