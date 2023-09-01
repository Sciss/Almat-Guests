/* "electric wind" simple installation

This is a simplified version of the electronics for "Electric Wind", a piece for flute and electronics.

The basic principle of the piece is simple: two signals play in separate channels.
Whenever their instantaneous levels match and their derivatives are within a specified range,
they trade channels. This creates modulation patterns similar to switched tone codes, but
directly reflecting the tuning relation of the tones and their relative amplitude.

In this version, Tone 1 slowly advances through a sequence of frequencies, which can be expressed
as multiples of a fundamental "E" of 82.5 Hz:
4, 11, 12, 1, 9, 9, 4.8, 3, 14, 4.8, 2, 11, 14, 8, 7, 4, 16, 6, 3, 7, 8, 12, 1, 2, 6

And for each frequency, Tone 2 runs through the frequencies that follow in that sequence, changing at
at 10 second intervals.  At a randomly determined moment, the tempo is increased 30 fold until Tone 2
finishes its pitches and cadences. Then the original tempo is restored and Tone 1 advances to the next pitch.

Once this subtractive process completes, the additive reversal of that process begins.
And this goes back and forth indefinitely.

The piece will run of its own accord, but there is a bit of adjustment provided via an interface to a Korg NanoControl
or a standard NodeProxy gui window.


*/
~sequence = [ 330.0, 907.5, 990.0, 82.5, 742.5, 742.5, 396.0, 247.5,
	1155.0, 396.0, 165.0, 907.5, 1155.0, 660.0, 577.5, 330.0, 1320.0,
	495.0, 247.5, 577.5, 660.0, 990.0, 82.5, 165.0, 495.0 ];

~sectionIndex = 0;
~win = Window("section", Rect(20,0, 250, 250)).front;
~section = NumberBox(~win, Rect(0,0, 250, 250)).font_(Font("Courier", 200));
~section.value = 0;
~section.action_{ | v | ~sectionIndex = v.value };

Spec.add(\thresh, [-1, 10000, 7]);
Spec.add(\fbkVol, [0.001, 10, 'exp']);
Spec.add(\outVol, [-100, 30]);
Spec.add(\stretch,[0.001, 10, 'exp']);
Spec.add(\inGain, [-100, 30]);
Spec.add(\sinVol, [-100, 30]);
Spec.add(\mgate,[0,1]);
Spec.add(\sVol, [-100, 30]);
Spec.add(\ssVol, [-100, 30]);
Spec.add(\rrq, [0.00001, 2, 'exp']);

SynthDef("silent", {arg out;
	Out.ar(out, Silent.ar.dup);
}).store;

SynthDef("gated sine1", {arg out, f=1000, sVol = -10, at= 0.1, gate = 1, decay = 0.9, pan;
	Out.ar(out, Pan2.ar(SinOsc.ar(f , 0, sVol.dbamp * Linen.kr(gate, at, 1, decay, 2).squared), pan) )
}).store;

SynthDef("gated sine2", {arg out, f=1000, ssVol = -10, at= 0.1, gate = 1, decay = 0.9, pan;
	Out.ar(out, Pan2.ar(SinOsc.ar(f, 0, ssVol.dbamp * Linen.kr(gate, at, 1, decay, 2).squared), pan) )
}).store;
//
// SynthDef("gated sine2", {arg out, f=1000, ssVol = -10, at= 0.1, gate = 1, decay = 0.9, pan, lpscale = 7, rq = 0.1;
// 	var audio = LFTri.ar(f, 0, ssVol.dbamp * Linen.kr(gate, at, 1, decay, 2).squared);
// 	audio = RLPF.ar(audio, f * lpscale, rq);
// 	Out.ar(out, Pan2.ar(audio, pan) );
// }).store;

SynthDef("outLimiter", {arg out,  outGate = 1;
	ReplaceOut.ar(out, Limiter.ar(In.ar(out, 2), 0.4) * Linen.kr(outGate));
}).store;

SynthDef("nemit",
	{ arg out, outVol = -20,  thresh = 0.1, ar = 0.001;
		var s1, s2, d1, d2, o1, o2, diff, difftrig, switch, notswitch;

		s1 = In.ar(out);
		s2 = In.ar(out + 1);

		d1 = Slope.ar(s1);
		d2 = Slope.ar(s2);
		diff = s1 - s2;
		difftrig = 0.0 < diff;
		difftrig = max(0, difftrig - Delay1.ar(difftrig) );
		difftrig = difftrig * (thresh > abs(d1-d2));
		switch = ToggleFF.ar(difftrig);
		notswitch = 1 + neg(switch);

		o1 = (s1*switch) + (s2*notswitch) ;
		o2 = (s1*notswitch) + (s2*switch);

		ReplaceOut.ar(out, Limiter.ar([o1, o2] * Lag.kr(outVol, 0.3).dbamp, 0.5));

}).store;

~spawner = Pspawner{ | sp |
	var i;
	~np.set(\stretch, 1);
	~sequences = ~sequence.collect { | v, i | ~sequence[i..] };
	~sequences = ~sequences.mirror;
	~sequences.pop;
	loop {
		i = 0;
		while({  i  <  (~sequences.size - 2 ) }, {
			var syn1, syn2;
			i =  ~sectionIndex;
			i.postln;
			defer { topEnvironment[\section].valueAction_(i) };

			syn1 = (instrument: 'gated sine1', gate: 1, f: ~sequences[i][0],
				pan: -1, at: 15, decay: 1, amp: 80/~sequences[i][0] min: 1).synth;
			topEnvironment[\np][0] = syn1;
			topEnvironment[\np][1] = (instrument: 'gated sine2', amp: 0, at: 3);
			defer({ TempoClock.default.tempo = 15}, (~sequences[i + 1].size * 6).rand.max(3).postln);
			sp.wait(0.5);
			sp.seq(
				Pbind(*[
					dur: 10,
					stretch: Pfunc{ 1 /TempoClock.default.tempo },
					freq: Pseq(~sequences[i + 1]), detune: \r,
					finish: { var scale;
						scale = ~dur/TempoClock.default.tempo;
						syn2 = (instrument: 'gated sine2', gate: 1,
							f: ~freq + 0.01, pan: 1,
							at: 0.4 * scale , decay: 0.5 * scale ,
							amp: 80/~freq min: 1, sustain: scale );
						topEnvironment[\np][1] = syn2;
						[
							#[c,'c#', d, 'd#', e, f, 'f#', g, 'g#', a, 'a#',b] [~freq.cpsmidi.round.mod(12)],
							(~freq.cpsmidi.round(0.01) - ~freq.cpsmidi.round(1)).round(0.01), ~freq
						].postln;
					},
					sustain: Prand([0.1, 1, 1, 3],inf)
				])
			);
			TempoClock.default.tempo = 1;
			syn2 = (instrument: 'gated sine',
				gate: 1, f: ~sequences[i][0], pan: 1, at: 4 , decay: 4 ,
				amp: 80/~sequences[i][0] min: 1, sustain: 5 );
			topEnvironment[\np][0] = \silent;
			topEnvironment[\np][1] = syn2;
			sp.wait(5);
			topEnvironment[\np][1] = \silent;
			topEnvironment[\np][0] = \silent;

			sp.wait(3);
			if (~sectionIndex == i) { ~sectionIndex = i + 1 };
		});
		topEnvironment[\np][0] = { Silent.ar };
		~sectionIndex = 0;
		sp.wait(1.5);
	};
};

~startpiece = {
		~np.playN([0,1]);
		~np[100] = \nemit;
		~np[110] = e = (instrument: \outLimiter).synth;
		~np.set(\outGate, 1);
		~np.set(\thresh, 200);
		~ps = ~spawner.play;
};
~stoppiece = {
		~ps.stop;
		~np[0] = \silent;
		~np[1] = \silent;
		~np.set(\outGate, 0);
		~section.value = 0;
};
b = Button(nil, Rect(20, 20, 170, 30))
.states_([
	["start electric wind", Color.black, Color.red],
	["stop electric wind", Color.white, Color.black],
])
.action_({ arg butt;
	if (butt.value ==1) { ~startpiece.value } { ~stoppiece.value};
	}).front;

	CmdPeriod.add ((cmdPeriod: { defer{ b.valueAction = 0; } }) );

// small nanoKontrol 2 control interface

c = Button(nil, Rect(190, 20, 170, 30))
.states_([ ["reconnect MIDI", Color.black, Color.red] ])
.action_({ arg butt;
	MIDIClient.disposeClient;
	MIDIIn.connectAll;
}).front;

MIDIClient.disposeClient;
MIDIIn.connectAll;

MIDIdef.cc(\cc, { | v, cc |
	var k = ~np.controlNames.collect(_.name)[cc];
	if (k.notNil && k.asSpec.notNil) { ~np.set(k, k.asSpec.map(v/127)) };
}, (0..7));

MIDIdef.cc(\stretch, { | v, cc |
	if(v>0) {
		TempoClock.default.tempo =  [15, 10, 5, 3, 1].wrapAt(cc - 32);
	}
}, (32..36 ));

MIDIdef.cc(\resetTempo, { | v, cc |
	if(v>0) {
		TempoClock.default.tempo = 1;
	}
}, [44]);

MIDIdef.cc(\startSpawner, { | v, cc |
	if(v>0) { defer { b.valueAction = 1}  };
}, 41);

MIDIdef.cc(\stopSpawner, { | v, cc |
	if(v>0) 	{ defer { b.valueAction = 0 }	};
}, 42);

s.quit;
s.options.blockSize = 4;

s.waitForBoot({
	~np.clear;
	~np = NodeProxy.audio(s, 3);
	s.sync;
	~np.set(\sVol, -20);
	~np.set(\ssVol, -20);
	s.sync;
	~np.gui(10, Rect( 30, 550, 400, 150));
	b.valueAction = 1;

})
