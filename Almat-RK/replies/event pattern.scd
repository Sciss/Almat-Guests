/*
Event Patterns

An "Event" is a dictionary whose keys specify an action to be taken.
An Event Stream is a stream that takes an Event as its parameter an alters its key
value pairs in order to generate the description of the action.

Pbind is the basic class for defining Event streams, it binds different event keys
to different patterns.
When the event stream it specifies is instantiated, an array of key/stream pairs is created
by sending each pattern an asStream message.
It then makes a copy of the event it received and iterates through the array, updating
keys in the copied event with the value returned by its associated stream.
If any substream returns nil, the event stream terminates and returns the unmodified event.

So an Event Stream can be thought of as an "event" filter that takes events and changes their
contents. The scheduling and performance of those events is is undertaken by an EventStreamPlayer object in conjunction with a clock

*/

Pbind : Pattern {
	var <>patternpairs;
	*new { arg ... pairs;
		if (pairs.size.odd, { Error("Pbind should have even number of args.\n").throw; });
		^super.newCopyArgs(pairs)
	}

	storeArgs { ^patternpairs }
	embedInStream { arg inevent;
		var event;
		var sawNil = false;
		var streampairs = patternpairs.copy;
		var endval = streampairs.size - 1;

		forBy (1, endval, 2) { arg i;
			streampairs.put(i, streampairs[i].asStream);
		};

		loop {
			if (inevent.isNil) { ^nil.yield };
			event = inevent.copy;
			forBy (0, endval, 2) { arg i;
				var name = streampairs[i];
				var stream = streampairs[i+1];
				var streamout = stream.next(event);
				if (streamout.isNil) { ^inevent };

				if (name.isSequenceableCollection) {
					if (name.size > streamout.size) {
						("the pattern is not providing enough values to assign to the key set:" + name).warn;
						^inevent
					};
					name.do { arg key, i;
						event.put(key, streamout[i].processRest(event));
					};
				}{
					event.put(name, streamout);
				};

			};
			inevent = event.yield;
		}
	}
}
