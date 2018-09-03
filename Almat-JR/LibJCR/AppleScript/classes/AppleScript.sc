/*******
Some helpful AppleScripting utilities.
Uses osascript and unixCmd under the hood.

Jonathan Reus-Brodsky

AppleScript Command Reference
https://developer.apple.com/library/mac/documentation/AppleScript/Conceptual/AppleScriptLangGuide/reference/ASLR_cmds.html#//apple_ref/doc/uid/TP40000983-CH216-SW59
http://www.mactech.com/articles/mactech/Vol.21/21.07/WorkingWithText/index.html

Using System Events
https://en.wikibooks.org/wiki/AppleScript_Programming/System_Events


USAGE:

AppleScript.eval("
  beep
  beep
  beep
  beep
");

AppleScript.eval("
tell application \"System Events\"
  repeat 6 times
    beep
    key code 103
    delay 0.3
    key code 103
    delay 0.3
  end repeat
end tell
");


// One command after another.

AppleScript.eval("
say \"Revolutionary!\"
say \"Reeeeeevolutionary!\"
say \"Revoooooolutionary!\""
);

// Or all at the same time
(
AppleScript.eval("say \"Revolutionary!\"");
AppleScript.eval("say \"Reeeeeevolutionary!\"");
AppleScript.eval("say \"Revooooluuutionary!\"");
);

// Change background image
AppleScript.eval("
set theFolder to \"/Library/Desktop Pictures/\"
set theFiles to (list folder (theFolder) without invisibles)

tell application \"Finder\"
	repeat with theFile in theFiles
		set theFile to (theFolder & theFile)
		set desktop picture to POSIX file theFile
		delay 0.05
	end repeat
end tell
");

*******/



AppleScript {

	/********
	Evaluates a string containing AppleScript code, where commands are separated by newlines.

	post - optionally post the result code & pid of the osascript process
	returnFunc - optional function to be called after the osascript process finishes, takes result & pid as arguments
	*******/
	*eval {|string, post=false, returnFunc=nil|
		var cmd, lines;
		// strip whitespace
		string = AppleScript.stripLeadingSpace(string);
		string = AppleScript.stripLeadingSpace(string.reverse).reverse;
		lines = string.split($\n);
		cmd = "osascript";
		lines.do {|line|
			if(line.notNil && line != "") {
				line = line.findRegexp("^[\\s]*(.+)$")[1][1]; // strip leading whitespace
				cmd = cmd + "-e '" ++ line ++ "'";
			}
		};
		returnFunc = returnFunc ? {|result, pid| if(post) { [result, pid].postln; } };
		cmd.unixCmd(returnFunc);
		^cmd;
	}

	*listKeycodes {
		^Keyboard.listKeycodes;
	}

	// Strip leading whitespace
	*stripLeadingSpace{|thestring|
		var nonspacefound = false;
		var result = "";
		thestring.do {|char, idx|
			if(nonspacefound) {
				result = result ++ char;
			} {
				if(char.isSpace.not) {
					nonspacefound = true;
					result = result ++ char;
				};
			};
		};	
		^result;
	}


}