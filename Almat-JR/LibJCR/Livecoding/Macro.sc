/******************************************

Macro system within SuperCollider.


2018 Jonathan Reus
jonathanreus.com
info@jonathanreus.com


TODO:
* add auto-numbering of patterns, synthdefs, etc..
* add in-code macros for flow signal / multigesture/envelope drawing/random envelope system
* add code that automatically runs to macros

*******************************************/



/* USAGE: *********************

++mixer
++pattern

// disable
Macro.active = false;

********************************/


Macro {
	classvar isActive;
	classvar <rewrites, <funcs; // rewrite text and functions for each macro
	classvar <f_addmac;
	classvar <preProcessorFuncs; // Add additional preprocessor functions on top of the Macros system
	// this is useful when you want to add additional SC preprocessor work without overwriting the macro system
	classvar <>parseStr;

	*initClass {
		parseStr = ">>";
		rewrites = Dictionary.new;
		funcs = Dictionary.new;
		preProcessorFuncs = List.new;
		f_addmac = {arg key, rewrite=nil, func=nil;
			// command key, rewrite text, and function to evaluate upon replacing text in the editor
			this.rewrites.put(key, rewrite);
			this.funcs.put(key, func);
		};
		this.initMacros();
		this.active_(true);
	}

	*initMacros {
		f_addmac.('boot',
"(
//s.options.device = \"EDIROL FA-101 (3797)\";
//s.options.device = \"USBMixer\";
//s.options.outDevice = \"Soundflower (64ch)\";
//s.options.inDevice = \"EDIROL FA-101 (3797)\";
//s.options.device = \"Fireface UCX (23590637)\";
s.options.numInputBusChannels = 10;
s.options.numOutputBusChannels = 10;
s.options.memSize = 8192 * 2 * 2 * 2;
s.waitForBoot {
};
);",
			{
				ServerOptions.devices.postln;
			}
		);
		f_addmac.('reaper',
"
~scRPP = \"\".resolveRelative +/+ \"SuperCollider-Live.RPP\";
(\"open -a Reaper64\"+~scRPP).runInTerminal;
"
		);


		f_addmac.('mix',
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
		f_addmac.('setmix',"Ndef('mix').set('master', 0.0);");
		f_addmac.('pat',
"
Pdef('p01').play(quant: 1);
Pdef('p01').stop;
(
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
		f_addmac.('pmono',
"
Pdef('p01').play(quant: 1);
Pdef('p01').stop;
(
Pdef('p01', Pmono(*[
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
		f_addmac.('sdef',
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
		f_addmac.('ndef',
"(
Ndef('xxx', {arg amp=1.0, pan=0, out=10;
	var sig;
	sig = SinOsc.ar();
	Out.ar(10, Pan2.ar(sig, pan, amp));
}).play;
);"
		);
		f_addmac.value('play',
"(
{
	Out.ar(0, SinOsc.ar(1400) * EnvGen.ar(Env.perc, timeScale: 0.1, doneAction: 2));
}.play(s);
);
"
		);
		f_addmac.value('eq4',
"
sig = BLowShelf.ar(BPeakEQ.ar(BPeakEQ.ar(BHiShelf.ar(sig, 10000, 1, 0), 4000, 1, 0), 1200, 1, 0), 200, 1, 0);
"
		);

		f_addmac.value('start',nil,{arg line;
	var opts,serv;
	serv = Server.default; opts = serv.options;
	opts.numInputBusChannels = 10; opts.numOutputBusChannels = 10;
	opts.memSize = 8192*2*2*2;
	serv.waitForBoot {};
		});
	}

	*addPreProcessorFunc {arg newfunc;
		preProcessorFuncs.add(newfunc);
	}

	*clearPreProcessorFuncs {
		preProcessorFuncs = List.new;
	}

	*active {
		^isActive;
	}

	// Evaluate any macros on the given line number
	*evalLine {arg ln;
		var doc,line,pslen,command;
		var snippet,func;
		doc = Document.current;
		line = doc.getLine(ln);
		pslen = this.parseStr.size();
		if((pslen==0) || line[0..(pslen-1)] == this.parseStr) { // limit to parse string
			command = line[pslen..].asSymbol;
			snippet = this.rewrites.at(command);
			func = this.funcs.at(command);
			if(snippet.notNil) {
				doc.replaceLine(ln, snippet);
			};
			if(func.notNil) {
				func.value(line);
			};
		};

	}


	*active_ {|val=true|
		var prefunc = nil;
		if(val == true) {
			prefunc = {|code, interpreter|
				var psLen = this.parseStr.size();
				if((psLen==0) || code[0..(psLen-1)] == this.parseStr) {
					var doc, pos, snippet, cmd, linestart, func;
					var myscript = code[psLen..];
					doc = Document.current;
					pos = doc.selectionStart; // this is where the code was run
					linestart = pos - 1;

					while( {doc.getChar(linestart) != "\n"} )
					{
						linestart = linestart - 1;
					};
					linestart = linestart + 1;

					snippet = this.rewrites.at(myscript.asSymbol);
					func = this.funcs.at(myscript.asSymbol);
					if(snippet.notNil) {
						snippet = this.rewrites[myscript.asSymbol];
						doc.string_(snippet, linestart, code.size);
						code = nil; // only return nil if all the commands evaluated successfully
					};
					if(func.notNil) {
						func.value;
						if(snippet.isNil) { // if there is no rewrite then evaluate after the script command
							var scriptlen = myscript.size() + psLen;
							code = code[scriptlen..];
						};
					};
				};

				if(preProcessorFuncs.size() > 0) {
					// preprocess the code through additional preProcessor functions
					preProcessorFuncs.do {arg pre;
						code = pre.value(code, interpreter);
					};

				};
				code; // send the code through to SC without further preprocessing
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
	*addMacro {|key, rewrite=nil, func=nil|
		f_addmac.value(key, rewrite, func);
	}


}


/***
Useful additions to Document

USAGE:
d = Document.current;
d.cursorLine;
d.getLine(51);
d.getLineRange(51);
d.replaceLine(51, "d.cursorLine;");

***/
+ Document {

	// Get the current line where the cursor is positioned.
	cursorLine {
		var ln,lines,thisline,doc;
		doc=this;
		thisline = doc.getSelectedLines(doc.selectionStart()-1, 0); // get the full current line
		thisline = thisline.replace("\n","");
		lines = doc.string.split($\n);
		ln = lines.detectIndex({|item| item == thisline; }) + 1;
		^ln;
	}

	// Get the line at a given line number
	getLine {arg ln;
		^this.string.split($\n).at(ln-1);
	}

	// get the start and end index of a given line, and the length [start,end,length]
	getLineRange {arg ln;
		var start=0, end, lines = this.string.split($\n);
		lines[..(ln-2)].do {arg line;
			start = start + line.size() + 1; // add +1 for the removed newline
		};
		end = start + lines[ln-1].size();
		^[start,end,end-start];
	}

	// replace the contents of a given line with a new string
	replaceLine {arg ln, newstring;
		var range = this.getLineRange(ln);
		this.string_(newstring, range[0], range[2]);
	}
}