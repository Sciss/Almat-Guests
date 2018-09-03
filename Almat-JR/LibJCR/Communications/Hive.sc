/*

Jonathan Reus-Brodsky

Last updated:
2015 Apr 19
...this is old software, use MetaNet.sc instead!

Nice classes for working with minibees and Sense/Stage

// TODO: Would be nice to be able to autoconfigure the minibees.. Marije has implemented some of this.
// Check out the OSC-Pydon interface.

*/


Hive {
	var <comPydon,poster,listener;
	var dataHistory; // history of data sent for each minibee
	var r_callbacks;
	//var postdata;

	*new {|pydonip="127.0.0.1"|
		^super.new.init(pydonip,57600); // pydonhive listens to 57600

	}

	init {|pydonip,pydonport|
		r_callbacks = ();
		comPydon = NetAddr.new(pydonip,pydonport);
		dataHistory = Array.newClear(10);
	}

	// Run pydon gui
	launchPydon {
		// TODO: Check if pydongui is already running and give a warning.
		"Running pydongui.py ...".postln;
		"pydongui.py".runInTerminal;
	}

	// This only works with the custom flicker minibee firmware.
	// DO NOT SEND A MESSAGE THAT DOESN'T HAVE ALL FIVE LED VALUES OR ELSE IT WILL OVERFLOW THE ARRAY!
	// NTS: Add a check in the firmware to ignore messages that do not have film
	// NTS: Add calculation to convert input (as frequency) to appropriate half period duration.
	// NTS: Alter firmware to be higher resolution, and to allow envelope-driven fades. (i.e. lines)
	setLedFreq {|beeid=1, lf0=5000,lf1=5000,lf2=5000,lf3=5000,lf4=5000|
		var l00,l11,l22,l33,l44;
		l00=lf0.toBytes;
		l11=lf1.toBytes;
		l22=lf2.toBytes;
		l33=lf3.toBytes;
		l44=lf4.toBytes;

/*
/minibee/output - iii..i - id, and as many 8bit integers as outputs (first PWM's then digital)
/minibee/custom - iii..i - id, and as many 8bit integers as the custom message requires
NetAddr.localAddr.hostname
*/
		comPydon.sendMsg("/minibee/custom",beeid,
			l00[0],l00[1],
			l11[0],l11[1],
			l22[0],l22[1],
			l33[0],l33[1],
			l44[0],l44[1]
		);
	}



	// msg[0] = "/minibee/data"
	// msg[1] = 1 : this is the index of the minibee
	// msg[2] : this is the first sensor data stream
	// msg[3] : this is the second sensor data stream
	// Post incoming data from minibees
	postData_ {|posttrue=true|
		poster.free;
		if (posttrue) {
			poster = OSCdef(\minibeePost, {|msg|
					msg.postln;
			},"/minibee/data");
		};
	}

	// Send the data array to the minibee with the given id
	// nil values leave the last sent data unchanged
	// returns the values sent
	send {|beeid ... data_arr|
		var no_nil_arr;
		if(dataHistory[beeid].isNil) {
			dataHistory[beeid] = Array.fill(data_arr.size,{0});
		};

		// Go through data_arr, for nil values fill in the last value from history
		no_nil_arr = data_arr.collect({|item,idx|
			var result = item;
			if(item.isNil) {
				result = dataHistory[beeid][idx];
			};
			result;
		});


		// /minibee/output id 8bitint 8bitint 8bitint ... (PWMs first)
		comPydon.sendMsg("/minibee/output", beeid, *no_nil_arr);
		dataHistory[beeid] = no_nil_arr;
		^no_nil_arr;
	}


	// Listen to a specific minibee or 'all' or 'none'
	//  with the given callback, id is the bee id, data is an array with the data items
	listen {|beeid='all',callback=nil|
		if (beeid == 'all') {
			var allids = [1,2,3,4,5,6,7,8,9,10];
			// arbitrarily assume there are 10 minibees, ids 1-10.. for more minibees add more
			callback.notNil && {
				allids.do {|id|
					r_callbacks.put(id, callback);
				};
			};
		} {
			callback.notNil && beeid != 'none' && {
				r_callbacks.put(beeid,callback);
			};
		};

		listener.free;

		if (beeid != 'none') {
		listener = OSCdef(\hivelistener,{|msg|
			var b_id = msg[1].asInteger;
			var data;
			r_callbacks[b_id].notNil && {
				r_callbacks[b_id].value(b_id,msg.copyRange(2,msg.size));
			};
		},"/minibee/data");
		};
	}

	printOn {|stream|
		stream << "Hive with ids " << r_callbacks.getKeys;

	}
}


