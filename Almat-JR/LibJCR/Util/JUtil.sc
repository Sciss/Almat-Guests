

JUtil { // Handy utility methods
	classvar catchKeyWin;
	classvar jfps;
	classvar <errorChecking = 3;
	classvar meter, scope, freqScope, treePlot;

	*showAll {
		Window.allWindows.do {|win| win.front };
	}

	*pwd {
		^thisProcess.nowExecutingPath.dirname;
	}

	*audioSetup {
		"open -a 'Audio MIDI Setup'".unixCmd;
	}

	*catchKeys {|callback|
		callback.isNil && { callback = {|view,char,mods,unicode,keycode| [char,keycode].postln}};

		catchKeyWin.isNil && { catchKeyWin = Window.new("I catch keystrokes", Rect(128,64,400,50)); };

		catchKeyWin.view.keyDownAction = callback;
		catchKeyWin.front;
	}

	*fpsbang {
		if(jfps.isNil) {
			jfps = JFPS.new();
		};
		^jfps.bang();
	}

	*fps {
		if(jfps.isNil) {
			jfps = JFPS.new();
		};
		^jfps.fps();
	}

	*debug {|printstring, errorlevel=3|
		if(errorlevel <= errorChecking) {
			var result = case
			{errorlevel == 1} { "!!!! ERROR: "; }
			{errorlevel == 2} { "!! WARNING: "; }
			{errorlevel == 3} { "! DEBUG: "; };

			result = result + printstring;
			Post << result << $\n;
		};
	}

	*monitor {arg serv, keepontop=false, plottree=false;
		meter = serv.meter;
		meter.window.alwaysOnTop_(keepontop).setTopLeftBounds(Rect(1320, 0, 100, 200));
		freqScope = serv.freqscope;
		freqScope.window.alwaysOnTop_(keepontop).setTopLeftBounds(Rect(900, 520, 100, 200));
		scope = serv.scope(2, 0);
		scope.window.alwaysOnTop_(keepontop).setTopLeftBounds(Rect(900, 0, 400, 500));
		if(plottree) {
		treePlot = Window.new("Node Tree", scroll: true).front.alwaysOnTop_(false);
		serv.plotTreeView(0.5, treePlot);
		treePlot.setTopLeftBounds(Rect(600, 0, 300, 850));
		};
	}
}

// A frames per second counter
JFPS {
	var avgperiod, lasthit;

	*new {
		^super.new.init;
	}

	init {
		avgperiod = 1.0;
		lasthit = 0.0;
	}

	// Call this each time a frame happens.
	// Returns the current FPS value
	bang {
			var thishit, period;
			thishit = Process.elapsedTime();
			period = thishit - lasthit;
			lasthit = thishit;
			avgperiod = (avgperiod + period) / 2.0;
			^avgperiod;
	}

	fps {
		^avgperiod;
	}
}



// Add timestamped entries to a log file.
JLog {
	var <>fpath;

	*new {|filepath, filename|
		^super.new.init(filepath, filename);
	}

	init {|filepath=nil, filename=nil|
		if(filename.isNil) {
			filename = "log_sc_program" ++ ".txt";
		} {
			filename = filename ++ ".txt";
		};

		if(filepath.isNil) {
			// Log to same directory as running process
			fpath = JUtil.pwd +/+ filename;
		} {
			fpath = filepath +/+ filename;
		};
	}

	log {|str=""|
		var timestamp, result, fh;
		timestamp = Date.getDate.asString;
		result = timestamp + " ### " + str + "\n";
		fh = File.open(fpath, "a");
		fh.write(result);
		fh.close();
		result.postln;
		// ALT: similar to python's with X open Y
		//f = File.use(~d_path, "a", {|thefile| thefile.write("Write somethin else "+rrand(200,300)+"\n");});

	}
}


// Useful gigging system for callbacks
JGig {
	classvar livefunc, panicfunc, mixfunc;

	*new {|livef, panicf, mixf|
		^super.new.init(livef, panicf, mixf);
	}

	init {|livef, panicf, mixf|
		livefunc = livef;
		panicfunc = panicf;
		mixfunc = mixf;
	}

	live {
		^livefunc.value;
	}

	panic {
		^panicfunc.value;
	}

	mix {
		^mixfunc.value;
	}

}


// Useful mapping functions
JMap {

	//((-100..100) / 10 ).collect({|item,i| JMap.peak(item, 10)}).plot;
	//((-100..100) / 10 ).collect({|item,i| JMap.valley(item, 2)}).plot;

	// Maps -1 to 1
	*peak {|fromval, width=1|
		var result;
		fromval = fromval / width;
		if(fromval <= 0) {
		result = (1 / (1 + exp(0 - fromval)))
		} {
		result = (1 / (1 + exp(fromval)));
		}
		^result;
	}

	// Maps -1 to 1
	*valley {|fromval, width=1|
		var result;
		fromval = fromval / width;
		if(fromval >= 0) {
		result = (1 / (1 + exp(0 - fromval)))
		} {
		result = (1 / (1 + exp(fromval)));
		}
		^result;
	}

}





// Some useful additions to Integer
+ Integer {

	/***
	Get the integer as two bytes
	***/
	toBytes {|whichbyte=(-1)|
	var result = [this & 0xFF,((this >> 8) & 0xFF)];
	if (whichbyte == 0 || whichbyte == 1) {
		result = result[whichbyte];
	};
	^result;
	}

}

//////////////////////////////////////////
// Additional methods to existing core classes.

+ String {
	notecps {
		^this.notemidi.midicps;
	}
}

+ Symbol {
	notecps {
		^this.asString.notecps;
	}
}

+ Server {

	*quickBoot {
		var tmp = Server.internal;
		tmp.options.memSize = 32768;
		Server.default = tmp.boot;
		^tmp;
	}


}

// Color additions
+ Color {
	*orange {|val=1.0, alpha=1.0|
		^Color.new(val, val, 0, alpha);
	}
}
