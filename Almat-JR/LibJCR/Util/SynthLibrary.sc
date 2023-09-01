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
	classvar <guiWindow;
	classvar <allNames, <allTypes;

	*load { | synthDefsPath |
		var sp;
		if (synthDefsPath.isNil) {
			path = 	"~/../Drive/DEV/SC_Synthesis/".asAbsolutePath; // put your synthdef library path here
		} {
			path = synthDefsPath;
		};
		fileNames = List();
		allNames = List();
		allTypes = List();
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
				info.parseDocString(metatext, filepath);
				synthdefs[name] = info;
				allNames.add(name);
			};
			fileNames.add(PathName.new(filepath).fileName);
		};
		// Collect all types
		allTypes = Set.new;
		synthdefs.values.do {|sinfo|
			sinfo.types.do {|type|
				allTypes.add(type);
			};
		};
		allTypes = allTypes.asList.sort;
		allNames = allNames.sort;
	}

	// Opens a window to navigate synths and file locations of synth definitions.
	*gui {
		var decorator, styler, subStyler, childView, childDecorator, substyler;
		var subView, btn, key, s_info;
		var searchText, searchList, searchTypeDropdown1, searchTypeDropdown2;
		var width=300, height=800, lineheight;
		var findFunc;
		if(synthdefs.isNil) { this.load };

		// Master window
		if(guiWindow.notNil) { guiWindow.close };
		guiWindow = Window("Synth Catalog", (width+20)@height);
		styler = GUIStyler(guiWindow);
		guiWindow.view.decorator = FlowLayout(guiWindow.view.bounds);
		decorator = guiWindow.view.decorator;
		decorator.margin = Point(5,5);

		// Child window
		childView = styler.getWindow("SynthDefs", guiWindow.view.bounds, scroll: true);
		childView.decorator = FlowLayout(childView.bounds);
		childDecorator = decorator;

		// Search
		searchText = TextField(childView, width@lineheight);

		searchTypeDropdown1 = PopUpMenu(childView, (width/2)@lineheight)
		.items_(allTypes.putFirst("--").asArray).stringColor_(Color.white)
		.background_(Color.clear);

		searchTypeDropdown2 = PopUpMenu(childView, (width/2)@lineheight)
		.items_(allTypes.putFirst("--").asArray).stringColor_(Color.white)
		.background_(Color.clear);

		searchList = ListView(childView, width@200)
		.items_(allNames.asArray)
		.stringColor_(Color.white)
		.background_(Color.clear)
		.hiliteColor_(Color.new(0.3765, 0.5922, 1.0000, 0.5));


		findFunc = { |name|
			var type1=nil, type2=nil, filteredNames;
			if(searchTypeDropdown1.value > 0) {
				type1 = searchTypeDropdown1.item;
			};
			if(searchTypeDropdown2.value > 0) {
				type2 = searchTypeDropdown2.item;
			};
			filteredNames = allNames.selectAs({ |item, i|
				var result,t1,t2;
				t1 = synthdefs[item].isType(type1, type2);
				if(name=="") {
					t2 = true;
				} {
					t2 = item.asString.containsi(name);
				};
				t1 && t2;
			}, Array);
			searchList.items_(filteredNames)
		};

		searchText.action = { |field |
			var search = field.value; findFunc.(search);
		};
		searchText.keyUpAction = {| view| view.doAction; };

		searchTypeDropdown1.action = {
			var search = searchText.value; findFunc.(search);
		};

		searchTypeDropdown2.action = {
			var search = searchText.value; findFunc.(search);
		};

		subStyler = GUIStyler(childView);
		subView = subStyler.getWindow("Subwindow", width@600);

		searchList.action_({ |sbs| // action when selecting items in the search list
			var key, s_info, btn, txt, extext, synthdef = sbs.items[sbs.value];
			synthdef.postln;
			Synth(synthdef); // Play the synth with default values.
			subView.removeAll; // remove subViews
			subView.decorator = FlowLayout(subView.bounds);

			s_info = synthdefs[synthdef];
			key = s_info.name;

			styler.getSizableText(subView, key.asString, 50, \left, 10);

			btn = styler.getSizableButton(subView, "source", size: 50@lineheight);
			btn.action = {|btn|
				var idx, d = Document.open(s_info.filePath);
			};

			btn = subStyler.getSizableButton(subView, key, size: 100@lineheight);
			btn.action = { |btn|
				Synth(key);
			};

			txt = subStyler.getTextEdit(subView, width@400);
			File.readAllString(s_info.filePath).split($@).do {|chunk,i|
				var found = chunk.findRegexp("^example "++ key.asString ++"[\n][*][/][\n](.*)");
				if(found != []) {
					found = found[1][1];
					txt.string_(found[..(found.size - 5)]);
				};
			};
		});

		guiWindow.front;
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
	@return a list containing all synthdef types/categories
	*/
	*types {
		if(synthdefs.isNil) { this.load };
		^allTypes;
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
	parseDocString {arg metaStr, filePath=nil;
		var tmp;
		if(metaData.isNil) { metaData = Dictionary.new; };
		if(filePath.notNil) { metaData[\filePath] = filePath; };
		tmp = metaStr.split($\@)[2..];
		tmp.do {arg ml;
			var key,val,regexp;
			//regexp = "^([A-Za-z0-9_]+) ([\"A-Za-z0-9 \t\r\n!\#$%&`()*\-,:;<=>?\[\\\]^_{|}~]+)";
			regexp = "^([A-Za-z0-9_]+) ([A-Za-z0-9 \t\r\n!\#$%&`()*\-,:;<=>?\[\\\]^_{|}~]+)";
			ml = ml.findRegexp(regexp);
			key = ml[1][1].asSymbol;
			val = ml[2][1];
			if(key == 'types') { // parse types
				val = val.split($\n)[0].split($,).collect({|item, idx|
					item.stripWhiteSpace.asSymbol;
				});
			};
			metaData[key] = val;
		};
	}

	/*
	@returns true if this synth matches the given types, returns true if arguments are nil
	*/
	isType {|...args|
		var found, result = true;

		args.do {|testFor|
			if(testFor.isNil) {
				found = true;
			} {
				found = false;
				this.types.do {|type|
					if(testFor == type) {
						found = true;
					};
				};
			};
			if(found.not) {
				result = false;
			};
		};
		^result;
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

