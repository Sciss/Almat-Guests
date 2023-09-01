/*_____________________________________________________________
SampleLib.sc

Sample library manager and buffer utilities

Copyright (C) 2018 Jonathan Reus
http://jonathanreus.com

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

________________________________________________________________*/




/*


@usage
b = SampleLib.load(s); // load sample library metadata from disk

b["drum001"]; // lazy load samples into buffers as needed and access them like so, with various pattern matching options
// e.g. by type, by directory..

// or like this..
b.drum001


********************************/
SampleLib[] {
	var <samples; // all available sample files by unique id
	var <samplesByGroup; // available sample files, by group name

	var <activeServer; // server where buffers are allocated and loaded, should be set on load

	var <window; // gui for navigating sample library

	// boolean toggles lazyloading of samples, false by default. If true will save some ram by only loading samples when necessary
	// However, keep in mind that samples are loaded into buffers on the server asynchronously from other language instructions,
	// and thus you must be wary of performing operations on buffer variables still holding nil.
	var <lazyLoad;

	*initClass {
	}

	*new {arg lazyload=false;
		^super.new.init(lazyload);
	}


	init {arg lazyload;
		lazyLoad = lazyload;
		samples = Dictionary.new;
		samplesByGroup = Dictionary.new;
	}



	// Returns the buffer for a given file. If the file is not loaded into a buffer on the server, it will be.
	// This is called when using the slot operator
	at {arg key;
		// Should load the buffer automatically if it isn't...
		var sample, result = nil;

		if(this.activeServer.serverRunning.not) {
			error("No Running Server to Allocate Buffers: Boot the Server First!");
			^nil;
		};

		sample = samples[key];
		if(sample.notNil) {
			var tmp;
			tmp = sample.buffer;
			if(tmp.isNil) {
				"Load file into buffer".postln;
				tmp = sample.loadFileIntoBuffer(this.activeServer);
			};
			result = tmp;
		};
		^result;
	}


	// By default will look for a 'samples' directory in the same directory as the current document.
	// If a server is not provided, server will be the default server.
	*load {|server=nil,filepath=nil,lazyload=false|
		var newsnd;
		if(server.isNil) {
			server = Server.default;
		};
		if(filepath.isNil) {
			filepath = Document.current.dir +/+ "samples";
		};
		newsnd = SampleLib.new(lazyload).load(filepath,server);
		^newsnd;
	}

	load {|sampleLibraryPath,server|
		var sampledir = PathName.new(sampleLibraryPath);
		activeServer = server;
		"Loading Samples from %".format(sampleLibraryPath).postln;
		sampledir.filesDo {arg path;
			var data, key, group, tmp;
			var groupname;
			data = SampleFile.openRead(path);
			if(data.notNil && data.isSoundFile) {
				[data.duration, data.headerFormat, data.sampleFormat, data.numFrames, data.numChannels, data.sampleRate, path.folderName, path.extension, path.fileName, data.path].postln;


				key = path.fileNameWithoutExtension.replace(" ","");
				samples.put(key, data);


				groupname = path.folderName.asSymbol;
				group = samplesByGroup.at(tmp);
				if(group.isNil) {
					group = Dictionary.new;
					samplesByGroup.put(groupname, group);
				};
				group.put(key, data);

				if(lazyLoad == false) {
					data.loadFileIntoBuffer(activeServer);
				};

			};
		};

	}

	gui {
		if(window.isNil) {
			var styler, subStyler, decorator, childView, childDecorator;
			var searchText, searchList, findFunc;
			var gui_width=250;
			window = Window("Samples", gui_width@800);
			styler = GUIStyler(window); // initialize with master window
			window.view.decorator = FlowLayout(window.view.bounds);
			decorator = window.view.decorator;
			decorator.margin = Point(0,0);

			// Child window
			window.view.bounds.postln;
			childView = styler.getWindow("Samples2", window.view.bounds, scroll: true);
			childView.decorator = FlowLayout(childView.bounds);
			childDecorator = decorator;

			styler.getSizableText(childView, "SAMPLES3", gui_width, \center, 12);

			// Search
			styler.getSizableText(childView, "search", 90, \left, 10);

			searchText = TextField(childView, gui_width@20);

			searchList = ListView(childView, gui_width@100)
			.items_(samples.keys.asArray)
			.stringColor_(Color.white)
			.background_(Color.clear)
			.hiliteColor_(Color.new(0.3765, 0.5922, 1.0000, 0.5));

			samples.values.sort({|a,b| a.name < b.name}).do{|samp|
				var subView;
				styler.getSizableText(childView, samp.asString.toUpper, gui_width - 100, \left, 10);
				styler.getSizableButton(childView, "prev", size: 50@20)
				.action = {|btn|
					"Playing %: % % %".format(samp, samp.numChannels, samp.sampleRate, samp.duration).postln;
					samp.play();
				};
			};
		};
		window.front;

	}

}


SampleFile : SoundFile {
	var <buffer;    // buffer, if loaded, on the server where this soundfile exists
	var <>name;

	var <usage;     // rhythmic, one-shot, field recording, etc...
	var <genre;     // european, house, techno, folk, etc...
	var <source;    // voice, strings, pad, mono-synth, etc...

	// maybe fancier analysis-related things? Could also be generated and stored in metadata files.
	var frequency_profile;
	var average_tempo;
	var average_pitch;

	/*
	@Override
	NOTE: This needs to be redone to return an instance of SampleFile, I might actually need to rewrite SoundFile
	*/
	*openRead {arg path;
		^super.new.init(path);
	}

	init {arg path;
		this.openRead(path.asAbsolutePath);
		name = path.fileNameWithoutExtension.replace(" ","");

	}

	isSoundFile {
		^this.headerFormat.matchRegexp("[WAV|WAVEAIFF]");
	}

	/*
	@param server The server to load this buffer into
	@param action Function to be evaluated once the file has been loaded into the server. Function is passed the buffer as an argument.
	*/
	loadFileIntoBuffer {arg server, action=nil;
		var newbuf;
		if(server.isNil) {
			server = Server.default;
		};
		if(server.serverRunning.not) {
			error("Server is not running, cannot load file into memory: Boot the Server First!");
			^nil;
		};
		"Loading into memory %".format(this.path).postln;
		newbuf = Buffer.read(server, this.path, action: action);
		buffer = newbuf;
		^buffer;
	}

	bufnum {
		^buffer.bufnum;
	}

	asString {
		^("SampleFile" + name);
	}

	play {|serv|
		var responseFunc;
		if(serv.isNil) { serv = Server.default };
		responseFunc = {|buf|
			if(buf.isNil) {
				"Cannot play %".format(name).postln;
				^nil;

			} {
				buf.play;
			};
		};
		if(buffer.isNil) {
			^this.loadFileIntoBuffer(serv, responseFunc);
		} {
			buffer.play;
		};

	}

	// MAYBE, need to overwrite openRead to add loading of metadata or analysis
	/*
	*openRead { arg pathName;
		var file;
		file = SoundFile(pathName);
		if(file.openRead(pathName)) { ^file } { ^nil }
	}
	*/


}



