/*********************************************
A really good frequency scope.
TODO: Make a singleton? What is the point of this scope anyway...
**********************************************/
JFreqScope {


}

// Todo: Implement this as a singleton? Might be better, but maybe multiple freq scopes is fine..
// To analyze multiple channels, e.g.
JFreqScopeView {

	var fftSynth, fftBuf, fftBins, fftBufSize, fftMagnitudeData, fftRawData;
	var win, winUpdateRoutine, winRefreshRate=0.01;

	*build {|server|
		if (server.isNil) {
			^DoesNotUnderstandError("No server argument specified").throw;
		} {
			^super.new.init(server);
		}
	}


	init {|server|
		fftBins = server.options.blockSize * 16;
		fftBufSize = fftBins * 2;
		fftMagnitudeData = 0 ! fftBins;
		fftRawData = 0 ! fftBufSize;
		this.setup(server);
	}


	// Build the scope. Right now the only possibility is a frequency spectrum.
	// Todo: add additional options for formatting the scope and adding additional scopes and meters
	setup {|server,bus=0|

		// Hmm.. best way to do this? Have a FFT running, but on what signal?
		// A Bus.. could set bus to analyze.
		{
			("ABOUT TO RUN THE FORK! What is s ? "++server).postln;

			fftBuf = Buffer.alloc(server, fftBufSize);

			SynthDef('jFFT', {
				var sig, chain;
				sig = InFeedback.ar(bus,1);
				chain = FFT(fftBuf, sig, wintype: 1);
			}).send(server);

			server.sync;
			fftSynth = Synth('jFFT',target: server, addAction: \addAfter);
			this.makeWin();
		}.fork;
	}


	makeWin {
		var width=1024, height=400;
		{
			win = Window( "Digits", Rect( 0, 606, width, height )).front;
			win.view.background = Color.black;
			win.onClose = { fftSynth.free; winUpdateRoutine.stop; }; // close the FFT synth? Sure.
			win.drawFunc = {
				fftBins.do({ |i|
					Pen.fillColor = Color.hsv( fftMagnitudeData.at( i ).abs * 0.002 + 0.004, 1, 1);
					Pen.fillRect( Rect( i , 400 - ( fftMagnitudeData.at( i ).abs.trunc / 2) , 1,100) );
				});
			};
		}.defer;

		winUpdateRoutine = {
			({ win.isClosed.not }).while {
				fftBuf.getn(0, fftBufSize,{|buf|
					if (fftRawData != buf) {
						fftRawData = buf;
						fftMagnitudeData = fftRawData.clump(2).collect({ |x| Complex(x[0],x[1]).magnitude });
						// ~data = ~data2.clump(2).flop[0]; // ??
					};
					{ win.refresh }.defer;
				});
				winRefreshRate.wait;
			};
		}.fork(AppClock);

	}

}

/*********************************************
A useful window with lots of monitoring options...
TODO: Make a singleton?
**********************************************/
JMonitor {
	var win,wavescope,phasescope;
	var server;
	var wavebuf,phasebuf;

	*new {|theserver|
		^super.new.init(theserver);
	}

	init {|theserver|
		server=theserver;
		wavebuf = Buffer.alloc(server, 1024, 2);
		phasebuf = Buffer.alloc(Server.default, 1024,2);
		this.make;
	}


	make {
		win = Window("Monitor", 800@400).alwaysOnTop_(true);
		win.onClose_({
			// Do stuff here that should happen when the scope is closed.
			// Allow client to register functions? Or some other method... to do stuff that might be connected to the scope.
			"Monitor closed".postln;
			// Free buffers
			wavebuf.free; phasebuf.free;
		});
		// What other window event responders are there? How about something when a window is made active?

		win.addFlowLayout;
		wavescope = ScopeView(win,314@310).bufnum_(wavebuf.bufnum);
		phasescope = ScopeView(win, 314@310).bufnum_(phasebuf.bufnum);
		// customize waveScope
		wavescope.style_(1);   // overlay channels
		wavescope.waveColors_([Color.red,Color.yellow]).background_(Color.magenta(0.4)).xZoom_(1.7).yZoom_(1.2);
		// customize phaseScope
		phasescope.style_(2);   // lissajous mode
		phasescope.waveColors_([Color.magenta]).background_(Color.cyan(0.3)).xZoom_(1.2).yZoom_(1.2);
	}

	waveX_ {|xzoom|
		wavescope.xZoom_(xzoom);
	}
	waveX {
		^wavescope.xZoom;
	}

	phaseColor_ {|color|
		phasescope.waveColors_([color]);
	}

	phaseBGColor_ {|color|
		phasescope.background_(color);
	}

	scope {|signal|
		ScopeOut.ar(signal, wavebuf);
		ScopeOut.ar(signal, phasebuf);
	}

}

