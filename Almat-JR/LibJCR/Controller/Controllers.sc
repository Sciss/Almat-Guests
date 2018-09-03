/*

Jonathan Reus-Brodsky
2015 Oct 10

Classes encapsulating various control interfaces.

*/

/*
Sensor Equipped Workout Gloves

*/
INQ_Gloves {

	var buttonstates;

	*new {
		^super.new.init;
	}

	init {
		buttonstates = [nil,nil,nil];
	}

	button {|but|
		^buttonstates[but];
	}

	// returns true if value has changed
	setButton {|but, val|
		var result = false, tmp;
		tmp = buttonstates[but];
		if(tmp.isNil || tmp != val) {
			result = true;
			buttonstates[but] = val;
		}
		^result;
	}




}