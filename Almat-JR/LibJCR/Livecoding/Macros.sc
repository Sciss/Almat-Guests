/******************************************

Macro system within SuperCollider.


2018 Jonathan Reus
jonathanreus.com
info@jonathanreus.com


TODO:
* add auto-numbering of patterns, synthdefs, etc..

*******************************************/



/* USAGE: *********************

++mixer
++pattern

// disable
Macros.active = false;

********************************/


Macros {
	classvar isActive;
	classvar <>macrodict;

	*initClass {
		macrodict = IdentityDictionary.new;
		macrodict.put('boot',
"(
//s.options.device = \"EDIROL FA-101 (3797)\";
//s.options.device = \"USBMixer\";
s.options.outDevice = \"Soundflower (64ch)\";
s.options.inDevice = \"EDIROL FA-101 (3797)\";
s.options.numInputBusChannels = 4;
s.options.numOutputBusChannels = 16;
ServerOptions.devices;
s.options.memSize = 8192 * 2 * 2 * 2;
s.waitForBoot {
};
);"
		);
		macrodict.put('reaper',
"
~scRPP = \"\".resolveRelative +/+ \"SuperCollider-Live.RPP\";
(\"open -a Reaper64\"+~scRPP).runInTerminal;
"
		);


		macrodict.put('mix',
"(
Ndef('mix', {arg master=1.0;
\tvar mix;
\tvar in1,in2,in3,in4,in5,in6,in7,in8,in9;
\tin1 = In.ar(10, 2); in2 = In.ar(20, 2); in3 = In.ar(30, 2); in4 = In.ar(40, 2); in5 = In.ar(50, 2);
\tin6 = In.ar(60, 2); in7 = In.ar(70, 2); in8 = In.ar(80, 2); in9 = In.ar(90, 2);
\tmix = Mix([in1,in2,in3,in4,in5]);
\tmix = Limiter.ar(mix, 0.999, 0.001);
\tmix = LeakDC.ar(mix);
\tOut.ar(0, mix * master);
}).play;
);"
		);
		macrodict.put('setmix',"Ndef('mix').set('master', 0.0);");
		macrodict.put('pat',
"(
Pdef('p01').play(quant: 1);
Pdef('p01').stop;
Pdef('p01', Pbind(*[
\tinstrument: 'default',
\tdegree: Pseq([0,2,4,6,8],inf),
\tdur: 1,
\tamp: 1.0,
\tpan: 0,
\tout: 0
]
));
);"
		);
		macrodict.put('sdef',
"(
SynthDef('xxx', {arg out, amp=1.0, pan=0, freq=440, gate=1, atk=0.1, dec=0.1, sus=0.8, rel=0.1;
	var sig, env;
	env = EnvGen.ar(Env.adsr(atk, dec, sus, rel), gate, doneAction: 2);
	sig = WhiteNoise.ar();
	sig = sig * env;
	Out.ar(out, Pan2.ar(sig, pan, amp));
}).add;
);"
		);
		macrodict.put('ndef',
"(
Ndef('xxx', {arg amp=1.0, pan=0, out=10;
	var sig;
	sig = SinOsc.ar();
	Out.ar(10, Pan2.ar(sig, pan, amp));
}).play;
);"
		);
		macrodict.put('play',
"(
{
	Out.ar(0, SinOsc.ar(1400) * EnvGen.ar(Env.perc, timeScale: 0.1, doneAction: 2));
}.play(s);
);
"
		);
		macrodict.put('eq4',
"
sig = BLowShelf.ar(BPeakEQ.ar(BPeakEQ.ar(BHiShelf.ar(sig, 10000, 1, 0), 4000, 1, 0), 1200, 1, 0), 200, 1, 0);
"
		);

		this.active_(true);

	}

	*active {
		^isActive;
	}

	*active_ {|val=true|
		var prefunc = nil;
		if(val == true) {
			prefunc = {|code|
				if(code[0..1] == "++") {
					var doc, pos, snippet, cmd, linestart;
					var myscript = code[2..];
					("DOCUMENT CURRENT: "+Document.current).postln;
					doc = Document.current;
					pos = doc.selectionStart;
					linestart = pos - 1;

					while( {doc.getChar(linestart) != "\n"} )
					{
						linestart = linestart - 1;
					};
					linestart = linestart + 1;

					if(this.macrodict.includesKey(myscript.asSymbol)) {
						("Build a"+myscript).postln;
						snippet = this.macrodict[myscript.asSymbol];
						doc.string_(snippet, linestart, code.size);
						code.size.postln;
						code = nil; // only return nil if all the commands evaluated successfully
					};
				};
				code;
			};
		};
		thisProcess.interpreter.preProcessor = prefunc;
		isActive = val;
		^this;
	}


	// Loads macros from a given file. If no file is provided then the Default Macro set is loaded.
	*loadMacros {|filepath|
		// TODO
	}

	// Saves current macros to a file
	*saveMacros {|filepath|
		// TODO
	}

	// Register a new macro.
	*addMacro {|key, macro|
		macrodict.put(key, macro);
	}


}




