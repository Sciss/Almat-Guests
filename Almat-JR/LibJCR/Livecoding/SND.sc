/******************************************

Sample library manager and buffer utilities

2018 Jonathan Reus
jonathanreus.com
info@jonathanreus.com

*******************************************/



/* USAGE: *********************

b = SND.load(s); // load sample library metadata from disk

b["drum001"]; // lazy load samples into buffers as needed and access them like so, with various pattern matching options
// e.g. by type, by directory..

// or like this..
b.drum001



********************************/


S[] {
	var samples; // all SampleFiles loaded
	var samplesByGroup; // outline of the loaded SampleFiles, indexed by group
	var buffers; // array of buffers by index


	*initClass {
	}

	*new {
		^super.new.init();
	}


	init {
		buffers = IdentityDictionary.new;
		samplesByGroup = IdentityDictionary.new;
	}

	newbuf {arg dur=1, key, frames, server;
		var newbuf;
		if(server.isNil) {
			server = Server.default;
		};

		if(server.serverRunning.not) {
			error("No Running Server to Allocate Buffers: Boot the Server First!");
			^nil;
		};

		if(frames.notNil) {
			newbuf = Buffer.alloc(server, frames);
		} {
			newbuf = Buffer.alloc(server, dur * server.sampleRate);
		};

		if(key.isNil) {
			key = ("buf" ++ buffers.size.asPaddedString).asSymbol;
		};
		buffers.put(key, newbuf);
		^(key -> newbuf);
	}



	// Called when using the slot operator
	at {arg key;
		^buffers[key];
	}


	*load {|filepath|
		var newsnd;
		newsnd = SND.new.load(filepath);
		^newsnd;
	}

	load {|sampleLibraryPath|
		var sampledir = PathName.new(sampleLibraryPath);
		sampledir.filesDo {arg path;
			var data, key, group, tmp;
			data = SampleFile.openRead(path.asAbsolutePath);
			if(data.notNil) {
				[data.duration, data.headerFormat, data.sampleFormat, data.numFrames, data.numChannels, data.sampleRate, path.folderName, path.extension, path.fileName, data.path].postln;


				samples.put(key, data);


				tmp = path.folderName.asSymbol;
				group = samplesByGroup.at(tmp);
				if(group.isNil) {
					group = IdentityDictionary.new;
					samplesByGroup.put(tmp, group);
				};
				group.put(key, data);




			};
		};

	}

}

SampleFile : SoundFile {
	var usage;     // rhythmic, one-shot, field recording, etc...
	var genre;     // european, house, techno, folk, etc...
	var source;    // voice, strings, pad, mono-synth, etc...

	// maybe fancier analysis-related things? Could also be generated and stored in metadata files.
	var frequency_profile;
	var average_tempo;
	var average_pitch;

	// MAYBE, need to overwrite openRead to add loading of metadata or analysis
	/*
	*openRead { arg pathName;
		var file;
		file = SoundFile(pathName);
		if(file.openRead(pathName)) { ^file } { ^nil }
	}
	*/


}



