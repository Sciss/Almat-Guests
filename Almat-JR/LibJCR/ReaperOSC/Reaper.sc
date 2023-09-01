/******************************************

Control Reaper from SuperCollider

2018 Jonathan Reus
jonathanreus.com
info@jonathanreus.com

TODO:

Most of the track parameters like number, select, mute, solo, pan,
Global project-wide parameters like time, beat, samples, frames, tempo, play/stop
FX units for each track, FX bypass, parameter names and controls, bypass, preset, openui

A weird condition occurs when a track is deleted, in such cases track numbers may change. There's no real absolute message to tell you a track was deleted. This is because Reaper assumes your control surface will have a fixed number of tracks matched to your Reaper setup.
Probably a script could be written to change this behavior...

Good idea?: write a custom address space to make parsing easier.. all addresses start with /rea/ ?

Feature Requests from Reaper devs:
- OSC notification when a track is deleted or created so that it can be registered on the ctrl surface
- a way for the ctrl surface to ping Reaper for the most updated track info
- OSC method for creating new effects by name on a track
- OSC actions with arguments

*******************************************/





/* USAGE: *********************

r = Reaper.new("localhost", 8000);




********************************/


Reaper {
	var <tracksById, <tracksByName;
	var oscfunc;
	var <reaperAddr;
	var <>verbose;

	*new {arg host="localhost", port=8000, verbose=false;
		^super.new.init(host, port, verbose);
	}

	/*
	Open Reaper and create a SC instance of Reaper. This method assumes that you have a Reaper project file named SC.RPP
	in the same directory as the active document.
	Only works on OSX.

	@param filepath  An optional filepath to the Reaper project file to open.

	@return  A Reaper instance

	@example
	f = "".resolveRelative +/+ "MyReaper.RPP";
	Reaper.open(f);

	@todo
	*/
	*open {arg filepath=nil;
		if(filepath.isNil) {
			filepath = Document.current.dir +/+ "SC.RPP";
		};

		// Open Reaper..
		("open -a Reaper64"+filepath).runInTerminal;

		^this.new;
	}

	send {arg addr, val=nil;
		"Sending Msg: % %".postf(addr, val);
		reaperAddr.sendMsg(addr,val);
	}

	// Get track by id or name
	track {arg id;
		if(id.isInteger) {
			^tracksById[id];
		} {
			^tracksByName[id];
		};
	}


	init {arg host, port, verbose_osc;
		//tracksById = Array.newClear(64);
		tracksById = Dictionary.new;
		tracksByName = Dictionary.new;
		reaperAddr = NetAddr(host, port);

		verbose = verbose_osc;

		// Set up the OSC listener
		oscfunc = {arg msg, time, addr;
			var matches, tnum, track, cmd, val;

			//msg.postln;
			matches = msg[0].asString.findRegexp("(/track/([0-9][0-9]?))[/]?([/A-Za-z0-9]*)");

			if(matches.size > 2) {
				tnum = matches[2][1].asInt;
				cmd = matches[3][1];
				val = msg[1];
				// If a track doesn't exist by name or by number, create it
				// parse the message, but let the track do that..
				track = tracksById[tnum];
				if(track.isNil) {
					track = ReaperTrack.new(tnum, this);
					tracksById[tnum] = track;
				};
				track.parseCmd(cmd, val);

			};

		};

		thisProcess.addOSCRecvFunc(oscfunc);
	}




}




ReaperTrack {
	var <params;
	var fxunits;
	var setup;

	*new {arg number, parentsetup;
		^super.new.init(number, parentsetup);
	}

	init {arg number, parentsetup;
		setup = parentsetup;
		params = Dictionary.new;
		params["number"] = number;
		fxunits = Dictionary.new;
	}

	parseCmd {arg cmd, val;
		if(cmd == "volume") {
			params[cmd] = val;
		};
		if(cmd == "name") {
			params[cmd] = val;
			setup.tracksByName[val] = this;
		};
	}

	volume_ {arg val;
		var addr;
		val = val.clip(0,1);
		params["volume"] = val;
		addr = "/track/%/volume".format(params["number"]);
		setup.send(addr, val);
	}


}

ReaperFX {
	var params;
	var parentTrack;
}

