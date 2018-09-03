/*
IMPORTANT! all classes have to be saved in a SuperCollider class
library folder.

User/Library/Application Support/SuperCollider/
*/

Sonology {

	classvar <>numberOfInstitutes;
	var <>courses, <>concerts;

	*new { arg concerts;
		^super.new.init(concerts)
	}

	init { arg newConcerts;
		concerts = newConcerts ? 6;
		courses = 15;
	}

	print {
		("Currently there used to be" + courses + "courses and" + concerts + "concerts").postln;
	}
}

OddNumbers {

	var numbers;

	*new { arg numbers;
		^super.new.init(numbers)
	}

	init { arg list;
		numbers = list;
	}

	get {
		^numbers.select({ arg item; item.odd });
	}
}


Speaker {

	speak {arg text;
		text.speak;
	}

	improvise {arg input, times=10;
		var text = "";

		times.do{
			text = text + input.scramble;
		}

		^this.speak(text);
	}
}

Methods {
    *classMethod {
		"This is a class method".postln;
    }

    instanceMethod { arg argument;
		"This is an instance method";
    }

	returnMethod {
		^"returned text";
	}
}

EmptyConstructor {
    *new {
        ^super.new
    }
}

InitConstructor {

	var first, second;

    *new { arg a, b;
        ^super.new.init(a, b)
    }

    init { arg a, b;
		first = a;
		second = b;
    }

	display {
		^first + second;
	}
}

CopyArgsConstructor {

	var first, second;

    *new { arg a, b;
        ^super.newCopyArgs(a,b)
    }

	display {
		^first + second;
	}
}


MySynth {

	play {
		{ SinOsc.ar(500) }.play
	}
}

MyPattern {

	play {
		Pbind().play;
	}
}


Point3D : Point {

	var z;

	 *new { arg posX, posY, posZ;
		^super.new(posX, posY).init(posZ)
    }

    init { arg posZ;
		z = posZ;
    }
}