/*_____________________________________________________________
Synthe.sc

Copyright (C) 2018 Jonathan Reus
http://jonathanreus.com

based on Thesaurus, by Darien Brito https://github.com/DarienBrito/dblib

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
@class
Manages a library of synth definitions.
Ths SynthLibrary looks for synthdef files (written as plain SC expressions) in the 'SynthDefs' directory
inside a provided library path.

@usage

Synthe.load();
*/
Synthe {
	classvar <synthdefs, <>path, <synthsFolderPath, <synthsFullPath, <fileNames;
	classvar <allSynthDefsNames;

	*load { | synthDefsPath |
		var sp;
		if (synthDefsPath.isNil) {
			path = 	"~/../Drive/DEV/SC_Synthesis/".asAbsolutePath; // put your synthdef library path here
		} {
			path = synthDefsPath;
		};
		fileNames = List();
		allSynthDefsNames = List();
		synthdefs = Dictionary.new; // add synthdefs hashed on name
		synthsFolderPath = path +/+ "SynthDefs";
		synthsFullPath = ( synthsFolderPath +/+ "*").pathMatch;
		synthsFullPath.do{|filepath| // Parse each synth file...
			var kw1,kw2,kw3; // keyword locations
			var fulltext,tmp1,tmp2;
			fulltext = File.readAllString(filepath);
			kw1 = fulltext.findAllRegexp("@synth");
			kw2 = fulltext.findAllRegexp("SynthDef");
			kw3 = fulltext.findAllRegexp("\.add;");
			kw3 = kw3 + 4; // move indexes forward to the end of the line where .add; was found

			// error checks
			if(kw1.size != kw2.size || kw2.size != kw3.size) { // same number of @synth, SynthDef and .add; strings found.
				"Syntax error in synthdefs library file % \nNumber of @synth tags and SynthDefs do not match.".format(filepath).throw;
			};

			kw1.size.do {arg idx; // check order of keyword locations follows sequence: @synth -> SynthDef -> .add;
				if ((kw1[idx] > kw2[idx]) || (kw2[idx] > kw3[idx])) {
					"Syntax error in synthdefs library file % \nNumber of @synth tags and SynthDefs do not match.".format(filepath).throw;
				};
			};

			// interpret synthdefs and parse metadata
			kw1.size.do {arg idx;
				var metatext, deftext, name, synthdesc, info;
				metatext = fulltext[kw1[idx]..(kw2[idx]-5)];
				deftext = fulltext[kw2[idx]..kw3[idx]];
				name = deftext.findRegexp("SynthDef[(]['\]([A-Za-z0-9_]+)[']?")[1][1].asSymbol;
				deftext.interpret; // interpret Synthdef & create SynthDesc, throws an error if the server is not running
				synthdesc = SynthDescLib.global.synthDescs[name];
				info = SynthInfo.new(synthdesc);
				info.parseDocString(metatext);
				info.metaData[\filePath] = filepath;
				synthdefs[name] = info;
				allSynthDefsNames.add(name);
			};

			fileNames.add(PathName.new(filepath).fileName);
		};

	}

	// Opens a window to navigate synths and file locations of synth definitions.
	*gui {
		var w, decorator, styler, subStyler, childView, childDecorator, substyler;
		var searchText, searchList, searchTypeDropdown1, searchTypeDropdown2;
		var findFunc;
		if(synthdefs.isNil) { this.load };

		// Master window
		w = Window("Synth Catalog", 210@800);
		styler = GUIStyler(w);
		w.view.decorator = FlowLayout(w.view.bounds);
		decorator = w.view.decorator;
		decorator.margin = Point(5,5);

		// Child window
		childView = styler.getWindow("SynthDefs", w.view.bounds, scroll: true);
		childView.decorator = FlowLayout(childView.bounds);
		childDecorator = decorator;

		// Search
		searchText = TextField(childView, 200@20);

		searchTypeDropdown1 = PopUpMenu(childView, 200@30)
		 .items_().stringColor_(Color.white)
		 .background_(Color.clear).hiliteColor_(Color.new(0.3765, 0.5922, 1.0000, 0.5));

		searchList = ListView(childView, 200@60)
		 .items_(allSynthDefsNames.asArray)
		 .stringColor_(Color.white)
		 .background_(Color.clear)
		 .hiliteColor_(Color.new(0.3765, 0.5922, 1.0000, 0.5));

		findFunc = { |name|
			if (name == "") {
				searchList.items_(allSynthDefsNames.asArray);
			} {
				var filtered = allSynthDefsNames.selectAs({ | item, i |
					item.asString.containsi(name);
				}, Array);
				searchList.items_(filtered)
			};
		};

		searchText.action = { |field |
			var search = field.value; findFunc.(search)
		};
		searchText.keyUpAction = {| view| view.doAction; };

		searchList.action_({ |sbs| // action when selecting items in the search list
			var synthdef = sbs.items[sbs.value];
			synthdef.postln;
			Synth(synthdef); // Play the synth with default values.
		});

		subStyler = GUIStyler(childView);
		synthdefs.keys.do{|key|
			var subView, name, btn, info;
			styler.getSizableText(childView, key.asString, 90, \left, 10);
			btn = styler.getSizableButton(childView, "source", size: 50@20);
			btn.action = {|btn|
				Document.open(synthdefs[key].filePath);
			};

			// Examples/Presets ~ child of child view
			subView = subStyler.getWindow(key, 200@20);
			subView.decorator = FlowLayout(subView.bounds);
			info = synthdefs[key];
			name = info.name;
			btn = subStyler.getSizableButton(subView, name, size: 180@20);
			btn.action = { |btn|
					Synth(name);
			};
		};
		w.front;
	}

	*browseSynths{
		SynthDescLib.global.browse;
	}

	/*
	@return a set containing all synthdef names
	*/
	*names {
		if(synthdefs.isNil) { this.load };
		^synthdefs.keys;
	}

	/*
	@return a set containing all synthdef types/categories
	*/
	*types {
		var result = Set.new;
		if(synthdefs.isNil) { this.load };
		synthdefs.values.do {|info|
			info.types.do {|type|
				result.add(type);
			};
		};
		^result;
	}

	*count {
		^synthdefs.size;
	}
}



/*
@class
Wraps a SynthDesc for the storage of custom metadata and example presets.
*/
SynthInfo {
	var <synthDesc;
	var <>metaData;
	var <>examples;

	*new {arg sdesc;
		^super.newCopyArgs(sdesc);
	}

	/*
	Expects a string of the format:

	@synth
	@shortdesc Pulse Bass
	@desc Bass synthesizer derived from a pulse train.
	@types Bass, Lead
	*/
	parseDocString {arg metaStr;
		var tmp;
		if(metaData.isNil) {
			metaData = Dictionary.new;
		};
		tmp = metaStr.split($\@)[2..];
		tmp.do {arg ml;
			var key,val,regexp;
			//regexp = "^([A-Za-z0-9_]+) ([\"A-Za-z0-9 \t\r\n!\#$%&`()*\-,:;<=>?\[\\\]^_{|}~]+)";
			regexp = "^([A-Za-z0-9_]+) ([A-Za-z0-9 \t\r\n!\#$%&`()*\-,:;<=>?\[\\\]^_{|}~]+)";
			ml = ml.findRegexp(regexp);
			key = ml[1][1].asSymbol;
			val = ml[2][1];
			if(key == 'types') { // parse types
				val = val.split($,).collect({|item, idx|
					item.stripWhiteSpace;
				});
			};
			metaData[key] = val;
		};

	}

	doesNotUnderstand { | selector...args |
		var result;

		// Exists in SynthDesc?
		if(synthDesc.respondsTo(selector)) {
			result = synthDesc.performList(selector, args);
		} {
			// Exists in metaData?
			result = metaData.atFail(selector, {
				error("Selector % does not exist.".format(selector));
			});
		}

		^result;
    }
}

