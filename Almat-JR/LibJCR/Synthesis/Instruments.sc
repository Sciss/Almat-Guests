/*
Jonathan Reus
4 Nov 2015

A collection of self-contained instruments to be controlled from the language.

Some additional sources of inspiration
"examples/pieces" folder
http://sccode.org
http://swiki.hfbk-hamburg.de:8888/MusicTechnology/524

*/


JSyn {
	var <serv;

	*new {
		^super.new.init();
	}

	init {
		Server.default.waitForBoot({
			this.load_synths(); // override this method in child classes
			(this.class.asString + "loaded...").postln;
		});
	}


	// Override this method in child classes to send synths to the server & do other initialization.
	load_synths {
		("load_synths not defined in " ++ this.class).postln;
	}
}


// Additive synthesis
AddSyn : JSyn {
	load_synths {
		// Send synthdef to the server
		SynthDef(\sinstack, {|freq=500, sweepstart=1.00,
			sweepend=1.00, spread=0.01, envtype=0, dur=5, gain=1.0, out=0|
			var tmp, sweep, env, envsig, sum = 0;
			env = Env.sine.duration = dur;
			envsig = EnvGen.ar(env, 1, doneAction: 2);
			sweep = Line.kr(sweepstart,sweepend,dur);
			30.do{|count|
				tmp = SinOsc.ar(freq * sweep * Rand(1 - spread,1 + (spread * count))).dup;
				sum = sum + tmp;
			};
			sum = sum * 0.01 * envsig * gain;
			Out.ar(out, sum);
		}).add;
	}

	fire {|f0=1000, sw_start=1, sw_end=2, spread=0.01, dur=7, gain=1.0, out=0|
		Server.default.waitForBoot({
			Synth.new(\sinstack, [\freq, f0, \sweepstart, sw_start, \sweepend, sw_end, \spread, spread, \dur, dur, \gain, gain, \out, out]);
		});
	}
}


// FM synthesis
FMSyn : JSyn {
	load_synths {
		// Send synthdef to the server
		SynthDef(\fmpair, {|f1=300, c1=5, m1=1, f2=400, c2=1, newenv, m2=5, dur=3, gain=1.0, sw_start=1, sw_end=2,
			attack=1, decay=0.1, sustain=1, release=1, out=0|
			var mod1, mod2, tmp, sweep, env, envsig, sum1 = 0, sum2 = 0;
			mod1 = f1 * (m1 / c1);
			mod2 = f2 * (m2 / c2);
			//env = Env.xyc([[0, 0, 4],[0.5, 1, -4],[1.0, 0, 4]]);
			env = Env.new([0,1.0,0.7,0.7,0.0], [attack, decay, sustain, release].normalizeSum);
			env.duration = dur;
			envsig = EnvGen.ar(env, doneAction: 2);
			sweep = XLine.kr(sw_start, sw_end, dur);
			20.do{|count|
				tmp = PMOsc.ar(f1 + (count * rrand(-10.0,10.0)), mod1, sweep * rrand(0.0, 10.0), rrand(0.0, 10.0));
				sum1 = sum1 + tmp;
			};
			20.do{|count|
				tmp = PMOsc.ar(f2 + (count * rrand(-10.0,10.0)), mod2, sweep * rrand(0.0, 10.0), rrand(0.0, 10.0) * sweep);
				sum2 = sum2 + tmp;
			};
			sum1 = sum1 * 0.01;
			sum2 = sum2 * 0.01;
			Out.ar(out, [sum1, sum2] * envsig * gain);
		}).add;
	}

	fire {|f1=1000, f2=1010, c1=1, m1=2, c2=1, m2=2, dur=3, gain=1.0, s1_start=1, s1_end=2,
		attack=0.25, decay=0.25, sustain=0.25, release=0.25, out=0|
		Server.default.waitForBoot({
			Synth(\fmpair, [\f1, f1, \c1, c1,\m1, m1, \f2, f2, \c2, c2, \m2, m2, \dur, dur, \gain, gain, \sw_start, s1_start, \sw_end, s1_end, \attack, attack, \decay, decay, \sustain, sustain, \release, release, \out, out ]);
		});
	}
}


/*
Sampler.
Loads all samples from a given directory (samples should be mono .wav files)
*/
Sampler : JSyn {
	var <bufs;
	var sampledir;

	// Provide a path to the samples directory. Optionally open a dialog to choose the directory.
	// If samplepath is left nil and dialog left False the Sampler will by default use the 'Samples' directory
	// in the same directory as the current working file.
	*new {|samplepath=nil, dialog=false|
		^super.new.initLoadSamplePath(samplepath,dialog);
	}


	initLoadSamplePath{|samplepath,dialog|
		if (dialog) {
			Dialog.openPanel( {|path| samplepath = path.dirname; }, { samplepath = nil; });
		};
		samplepath ?? {
			samplepath = JUtil.pwd +/+ "Samples/";
		};

		// Load the buffers
		Server.default.waitForBoot({
			("Loading samples from "++samplepath).postln;
			bufs = (samplepath +/+ "*.wav").pathMatch;
			bufs = bufs.collect({|path,idx|
				Buffer.read(serv, path);
				// Alt.. to load a single channel buffer -> Buffer.readChannel(s, path, channels:[0])
			});
		});
	}

	load_synths{
		var numchannels = 1;
		SynthDef(\sampleplayer, {|buf, prate=1, startpos=0, t_trig=1, pan=0.0, gain=1.0, loop=0, out=0|
			var sig,dur,env,envsig,seg;
			dur = BufDur.kr(buf);
			seg = dur / 10.0;
			env = Env.linen(seg,dur-seg-seg,seg);
			envsig = EnvGen.ar(env, doneAction: 2);
			sig = PlayBuf.ar(numchannels, buf, prate, t_trig, startpos, loop);
			sig = Pan2.ar(sig, pan, gain * envsig);
			Out.ar(out, sig);
		}).add;
	}


	fire {|sampleidx, prate=1.0, pan=0.0, gain=1.0, loop=0, out=0|
		var thebuf,startpos=0;
		thebuf = bufs[sampleidx];
		if(thebuf.isNil) {
			("No such sample index "++sampleidx++". Max index is "++(bufs.size - 1)).postln;
		} {
			if(prate < 0) {
				startpos = thebuf.numFrames;
			};
			Server.default.waitForBoot({
				Synth.new(\sampleplayer, [\buf, thebuf, \prate, prate, \startpos, startpos, \t_trig, 1, \pan, pan, \loop, loop, \gain, gain, \out, out]);
			});
		};
	}

	asString {
		var result = "";
		bufs.do {|item|
			result = result + item + "\n";
		};
		^result;
	}

}




/* Remains of LiSa

init {|outputbus=0|
buf.free; syn1.free; ndef1.stop;
buf = nil; syn1 = nil; ndef1=nil;
outbus = outputbus;
rate_syn=1;
rate_ndef=1;
}


play {
syn1.free;
{
syn1 = {|prate=1,t_trig=1,gain=1.0|
var sig = PlayBuf.ar(buf.numChannels, buf, prate,t_trig,loop: 1);
Out.ar(outbus, sig * gain);
}.play(Server.default);
Server.default.sync;
syn1.set(\prate,rate_syn);
}.fork;
}

playAsNdef {
ndef1 = Ndef(\lisaplayer, {|prate=1,t_trig=1,gain=1.0|
var sig = PlayBuf.ar(buf.numChannels, buf, prate,t_trig,loop: 1);
Out.ar(outbus, sig * gain);
}).play(outbus, 2);
ndef1.set(\prate,rate_ndef);
}

stop {
ndef1.clear(1); ndef1=nil; syn1.free; syn1=nil;
}

playRate_ {|therate=1.0,target='syn'|
if(target == 'syn') {
rate_syn = therate;
syn1.isNil && { this.play; };
syn1.set(\prate, rate_syn);
} {
rate_ndef = therate;
this.playAsNdef;
}
}

gain_ {|thegain=0.1,target='syn'|
if(target == 'syn') {
syn1.isNil && { this.play; };
syn1.set(\gain, thegain);
} {
this.playAsNdef;
ndef1.set(\gain, thegain);
}
}




printOn {|stream|
stream << "LiSa Object " << rate_syn << ", " << 1;

}

}




MySins

(
Ndef(\mysin,
{
var sig1, numsin=80;
sig1 = Mix.fill(numsin, {|i| SinOsc.ar(MouseX.kr(0.5,5)*(i+1), mul: (LFTri.ar(MouseY.kr(100,500), phase: i * pi) + 1) * 1.0 / numsin)});
sig1.dup;
}
).play;
)

*/



