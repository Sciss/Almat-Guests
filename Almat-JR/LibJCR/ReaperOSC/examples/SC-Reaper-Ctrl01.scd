/******
Examples of controlling Reaper via OSC

******/

~rea = NetAddr("localhost", 8000);
NetAddr.localAddr; // this process
OSCFunc.trace(true);
OSCFunc.trace(false);


~rea.sendMsg('/SC/hello', 1, 2, 3, 4.0);

// Set track volume
~rea.sendMsg('/track/0/volume', 0.8); // master track
~rea.sendMsg('/track/1/volume', 0.5);

~rea.sendMsg('/track/2/select',1); // select given track
~rea.sendMsg('/track/2/select',0); // unselect given track

~rea.sendMsg('/track/2/mute', 1); // mute track
~rea.sendMsg('/track/2/mute', 0); // unmute track

~rea.sendMsg('/track/1,2/mute', 1,1); // mute multiple tracks


~rea.sendMsg('/tempo/raw', 120); // set tempo

// Set FX parameters, usually as normalized floats.. 0.0-1.0
~rea.sendMsg('/track/2/fx/1/fxparam/1/value', 0.0); // set first param of first fx unit to 0.0
~rea.sendMsg('/track/2/fx/1/fxparam/1,3/value', 0.5, 0.7); // set first & third param of first fx unit to 0.5 and 0.7

// What the param numbers are is anybody's guess...
~rea.sendMsg('/track/2/fx/1/fxparam/7,8,9,10/value', 0.5, 0.3, 0.4, 1.0);


~rea.sendMsg('/reaper/track/follows', "DEVICE");
~rea.sendMsg('/device/track/count', 6);




~rea.sendMsg('/scrub', 1); // scrub forward
~rea.sendMsg('/scrub', -1); // scrub in reverse

~rea.sendMsg('/rewind', 1); // start rewinding
~rea.sendMsg('/rewind', 0); // stop rewinding

~rea.sendMsg('/play', 1); // toggle playback
~rea.sendMsg('/pause');   // also toggles playback

// Arbitrary action
~rea.sendMsg('/action', 40044); // play/stop
// Full Action list is here: http://mespotine.de/Ultraschall/Reaper_Action_Commands.html



// A lot can be done with the default OSC commands, but for really fancy stuff you need to access action IDs

// More sophisticated actions...

// Add a Track
~rea.sendMsg('/action', 40001); // insert new track (add multiple)
~rea.sendMsg('/action/40001'); // insert new track (add multiple)
~rea.sendMsg('/track/6,7/select', 1,1);
~rea.sendMsg('/action', 40005); // remove tracks


~rea.sendMsg('/action', 40001); // insert new track

~rea.sendMsg('/track/5/select', 1);

// TODO: Renaming tracks doesn't seem to work.. is this a bug?
// Can I rename from other apps?
~rea.sendMsg('/track/name', "Alibalar");
~rea.sendMsg('/track/1/name', "Alibalar");


~rea.sendMsg('/action/40018', "Alibalar"); // insert media files...

// add FX to selected track
~rea.sendMsg('/action/40271', "Alibalar"); // show FX browser window...

~rea.sendMsg('/action/40142', "Alibalar"); // insert empty item

// Right-click and enter add keyboard shortcut. Then send the OSC message.
// This now will add that fx VST to the currently selected track
~rea.sendMsg('/makefx'); // automagical learning new commands!


// Scroll/Zoom around the track area in the x and y directions
~rea.sendMsg('/scroll/x', 1);
~rea.sendMsg('/scroll/x', -1);
~rea.sendMsg('/zoom/x', 1);
~rea.sendMsg('/zoom/x', -1);

~rea.sendMsg('/time', 3.0); // in seconds
~rea.sendMsg('/time/str', "1.0"); // in seconds

~rea.sendMsg('/track/2/fx/1/openui', 1); // open a specific FX ui
~rea.sendMsg('/track/2/fx/1/openui', 0); // close a specific FX ui

// FX bypass
~rea.sendMsg('/track/1/fx/1/bypass', 1); // activate a specific fx unit
~rea.sendMsg('/track/1/fx/1/bypass', 0); // bypass a specific fx unit

// bypass on the master track
~rea.sendMsg('/fx/bypass', 1);
~rea.sendMsg('/fx/bypass', 0);



(
OSCdef('trackdata', {arg msg;
	msg.postln;
}, '/track/1/hello');
);

OSCFunc.newMatching({arg msg; \matching.postln; }, '/track/');

~sc = NetAddr("localhost", 57120);
~sc.sendMsg('/track/hula',1,2);


// How to get a full report of the track setup in Reaper?
~rea.sendMsg('/device/track/count', 4);

~rea.sendMsg('/device/track/count', 4);

// To do top-level patch matching you need to implement your own top level listener..
String

"/track/[0-9a-z]*".matchRegexp("/track/1/hula");

"/track/([0-9])/[a-z]*".matchRegexp("/track/2/hula");

"/track/1/hello/2".findRegexp("(/track/([0-9][0-9]?))[/]?([A-Za-z0-9]*)");

"/track/3/hula".findRegexp("/track/([0-9])/[a-z]+");

"/track/1/hula".findRegexp("([0-9])", 7);

"foobar".findRegexp("(o*)(bar)");

(
thisProcess.removeOSCRecvFunc(f); // remove the special function...
f = {arg msg, time, addr;
	var result;

	msg.postln;
	if("/track/1/[0-9a-zA-Z/]*".matchRegexp(msg[0].asString)) {
		//"Track1".postln;
		//msg[0].postln;
	};
};
thisProcess.addOSCRecvFunc(f);
);

~sc.sendMsg('/track/1/hula',1,2);


// When reaper starts up, or you add a new controller, Reaper will send
// a ton of information to SC with all the track information.

// New tracks and info will also be added as you go..

// Q: Can you ping Reaper for this info?

// Get info about a specific track (unless it's already selected on the device)

~rea.sendMsg('/device/track/select/0'); // you could scan all tracks if necessary... but you don't get messages with the track number embedded :-/

~rea.sendMsg('/device/track/select', 1);

~rea.sendMsg('/device/track/select', 0); // select MASTER track...

~rea.sendMsg('/device/track/bank/select/0');

~rea.sendMsg('/device/fx/select', 0);

// Configure the SC / Reaper Connection

// Let's give SC




// Using Reaper class....

r = Reaper.new();

r.reaperAddr
r.tracksById
r.tracksByName

r.tracksById[3].params
r.tracksByName['Test 3'].params
r.tracksByName['Jay'].params

z = Dictionary.new;

// sets the volume in reaper
r.tracksById[3].volume_(0.7);
r.tracksByName['Test 2'].volume_(0.2);















