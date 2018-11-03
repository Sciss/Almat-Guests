/*
Granular Synthesis Instruments
(c) 2018 Jonathan Reus



*/

/*


@TODO: Look into approaches for interleaving selectable segments of sound files.

@usage
// stereo munger
m = Mung(2, [buffer1, buffer2...]);
m.gui;
m.play;
m.stop;

*/

// Munger, developed during the Constant Transmarcations Residency in December 2017
Mung {
	var <bufs;
	var <chan;
	var <win; // gui window
	var <play_task; // grain playback task
	var <obj; // grain playback parameters
	var <out; // output channel

	/*
	@param buffers A list of buffers to be included in the grain munger.
	*/
	*new {arg chans=1, buffers;
		^super.new.init(chans, buffers);
	}

	init {arg chans, buffers;
		bufs = List.new;
		chan = chans;
		out = 0;
		buffers.do {arg buf;
			bufs.add(buf);
		};

		this.loadSynths;
	}

	loadSynths {
		SynthDef('grain', {arg buf, out, playspeed=1.0, startpos=0.0, dur=0.1, pan=0.0, amp=0.5;
			var sig, ctrlsig, duration, startsample, endsample, numframes, env;
			startsample = BufFrames.kr(buf) * startpos;
			numframes = dur * SampleRate.ir * playspeed;
			endsample = min(startsample + numframes, BufFrames.kr(buf));
			ctrlsig = Line.ar(startsample, endsample, dur, doneAction: 2);
			env = EnvGen.ar(Env.sine, timeScale: dur, doneAction: 2);
			sig = BufRd.ar(chan, buf, ctrlsig) * amp * env;
			Out.ar(out, Pan2.ar(sig, pan));
		}).add;
	}

	gui {
		var params;
		// Pseudo-object for stochastics and meta parameters for sculpting sound algorithmically...
		ControlSpec.specs['ms'] = ControlSpec(0.001, 1.0, 4, 0.0001, 1.0, "s");
		ControlSpec.specs['gps'] = ControlSpec(0.5, 2000, 3, 1, 100, "gps");
		ControlSpec.specs['pitch'] = ControlSpec(-2.0, 2.0, 'lin', 0.001, 1.0);
		ControlSpec.specs['n'] = ControlSpec(1, 20000, 'lin', 1, 1000, "steps");
		ControlSpec.specs['stretch'] = ControlSpec(0.01, 100.0, 4, 0.01, 1.0);
		ControlSpec.specs['pan'] = ControlSpec(-1.0, 1.0, 0, 0.01, 0.0);
		ControlSpec.specs['amp'] = ControlSpec(0.0, 1.0, 0, 0.01, 0.5);
		ControlSpec.specs['buf'] = ControlSpec(0, 10, 0, 1, 0);

		// Helper function to count the numbers after a decimal point
		~countDecimals = {arg num;
			var val = 0, pt, str = num.asString;
			pt = str.find(".");
			if (pt.notNil) {
				val = str.size - pt - 1;
			};
			val;
		};


		obj = ();
		obj.sl = ();  // sliders
		obj.nb = ();  // number boxes
		obj.tx = ();  // static text (label)
		obj.un = ();  // static text (units)


		// Parameters array [reference, default value, controlspec]
		params = [
			['gbuf', 0, ControlSpec.specs['buf']],
			['glen', 0.1, ControlSpec.specs['ms']],
			['glenv', 0.0, ControlSpec.specs['ms']],  // grain length variation, v suffix indicates a variation parameter
			['grate', 100, ControlSpec.specs['gps']],  // grains per second (together with gsteps controls grain flow)
			['gratev',0.00, ControlSpec.specs['gps']],
			['gsteps', 1000, ControlSpec.specs['n']],   // number of grains the sound file will be divided into
			['gstretch', 1.0, ControlSpec.specs['stretch']],  // stretch factor TODO: redundant, can be replaced completely by gsteps?
			['gpitch', 1.0, ControlSpec.specs['pitch']],
			['gpitchv', 0.0, ControlSpec.specs['pitch']],
			['gposv', 0.00, ControlSpec.specs['ms']],    // random variation of grain position in the buffer
			['gpan', 0.0, ControlSpec.specs['pan']],
			['gpanv', 0.0, ControlSpec.specs['pan']],
			['gamp', 0.3, ControlSpec.specs['amp']],
			['gampv', 0.00, ControlSpec.specs['amp']],
		];

		win = Window.new("Munger", Rect(0, 0, 500,500)).front;
		win.layout = VLayout.new();

		params.do {arg item;
			var sym, default, spec;
			sym = item[0]; default = item[1]; spec = item[2];
			obj[sym] = default;
			obj.tx[sym] = StaticText().minWidth_(60).string_(sym);
			obj.sl[sym] = Slider().orientation_('horizontal').value_(spec.unmap(default)).maxHeight_(20)
			.action_({|sl| obj[sym] = spec.map(sl.value); obj.nb[sym].value_(obj[sym]); });
			obj.nb[sym] = NumberBox().maxWidth_(60).value_(default).decimals_(~countDecimals.value(spec.step))
			.action_({|nb| obj[sym] = nb.value; obj.sl[sym].value_(spec.unmap(nb.value); )});
			obj.un[sym] = StaticText().string_(spec.units);
			win.layout.add(HLayout.new(obj.tx[sym], [obj.sl[sym], stretch: 1], obj.nb[sym], obj.un[sym]));
		};
	}

	/*
	Sets one of the Munger's parameter values.
	*/
	set {arg key, value;
		obj.nb[key].valueAction = value;
	}

	play {arg outchan=0;
		out = outchan;
		play_task = Tdef('munger', {
			var spd, st, dur, pause, pan, amp, step, buf;
			inf.do {arg count;
				buf = obj.gbuf;
				if(buf >= bufs.size) {
					buf = rrand(0, bufs.size - 1);
				};
				step = count % (obj.gsteps * obj.gstretch);
				spd = (obj.gpitch + rand2(obj.gpitchv)).abs;
				st = ((step / obj.gsteps / obj.gstretch) + rand2(obj.gposv)).abs;
				dur = (obj.glen + rand2(obj.glenv)).abs;
				pan = obj.gpan + rand2(obj.gpanv);
				amp = (obj.gamp + rand2(obj.gampv)).abs;
				pause = (obj.grate + rand2(obj.gratev)).abs.reciprocal;
				Synth('grain', [
					'buf', bufs[buf].bufnum,
					'playspeed', spd,
					'startpos', st,
					'dur', dur,
					'pan', pan,
					'amp', amp,
					'out', out
				]);
				pause.yield;
			};
		});
		play_task.play(quant: 1); // start the routine
	}

	stop {
		play_task.stop;
	}

}



