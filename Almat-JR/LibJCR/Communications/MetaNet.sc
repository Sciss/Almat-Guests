/*
Classes for working with SenseStage minibees and interconnecting sensor data between networks.
An update to the old Hive class. Useful for Sense/Stage and also for connecting various
sensor networks to each other (we probably rewrote the SenseStage Data Network..!)

Created by JC Reus, 2015 - Taiwan Metacologies Workshop

Last updated:
16 March, 2016 - Renamed methods to be more self-explanatory.

TODO:

1. Create a GUI for exploring the data being sent on the network.

2. Create an easy patching system for getting data by node/subnet.

3. Create an easy system for sending your own data out.

Add data smoothing functionality to make continuous skippy sensor data -> for smoothing out incoming data streams.

Ignore one's own broadcast. Or be able to listen to only one subnet/node.

*/


/*
USAGE:

1. Once the MetaNet object begins listening, start registering subnets & nodes as they are discovered.
2. The MetaNet object ignores its own subnet.

API
m = MetaNet.new(2); // Create a new MetaNet instance. It will automatically create a subnet with ID 2 and begin listening for metanet broadcasts from other subnets.
m.launchHive; // Launch the Sense/Stage Hive software for communicating with minibees on the local subnet.

// Set a callback function to respond to incoming data from sensor node 1 on the local subnet
m.local_responder(1, {|beeid, data| data.postln; });

// You can use local_responder combined with global_send to send data from a sensor node to the wider metanet.
m.local_responder(1, {|beeid, data|
  m.global_send(beeid, data[1], data[2]);
});

// Set a callback function to respond to incoming data from a specific virtual node on a specific subnet
// on the Metanet
m.global_responder(1, 2, {|subnet, node, data|
  data.postln;
});

// Send data out as a specific virtual node to the Metanet
m.global_send(3, 1.0, 0.3, 5, 18); // virtual node 3, sending two floats and two ints

// Send a data to a specific sensor node on the local subnet
m.local_send(beeid, val1, val2 ...)



// METANET OSC PROTOCOL: subnet, node, num_datapoints, type0, value0, type1, value1, ...
~net.sendMsg("/metacology/broadcast",1,1,2,'D',0,'A',1.0);

m.cleanup;

*/



MetaNet {
	var <subnet_id, <ip_mask, netaddr_broadcast;  // metanet local subnet id & broadcast
	var netaddr_hive;   // netaddr for the hive running the local subnet, for local minibee communications
	var cb_nodes, cb_minibees; // callback functions by subnet/node and by minibee id
	var oscdef_metanet, oscdef_hive; // OSC listeners for metanet & hive
	var metanet_broadcast_history, minibee_send_history; // histories of data transmissions
	var metanet_received_history; // history of received metanet messages
	var postlocal; // OSC listener for posting all incoming local sensor node data

	/********************************
	* new
	*   ClassMethod: construct a new instance of MetaNet
	******************/
	*new {|subid, ipmask="255.255.255.255", broadcast_port=57121, local_addr="127.0.0.1", local_port=57600|
		^super.new.init(subid, ipmask, broadcast_port, local_addr, local_port);
	}

	/********************************
	* init
	*   Initialize a new instance of MetaNet
	******************/
	init {|subid, ipmask, broadcast_port, local_addr, local_port|
		// Setup Hive
		netaddr_hive = NetAddr(local_addr, local_port);

		// Setup Broadcasting
		subnet_id = subid;
		ip_mask = ipmask;
		cb_nodes = Array.fill(10, {|i| nil!10}); // init cb_nodes with 10 arrays of 10 nil entries
		cb_minibees = nil!10;  // init cb_minibees to 10 nil values

		NetAddr.broadcastFlag = true;   // enable broadcasting
		netaddr_broadcast = NetAddr(ip_mask , broadcast_port);
		// ^^^ send to the whole internet TODO: this can be done more intelligently

		// Create the MetaNet OSC listener
		// Callbacks are registered in cb_nodes, indexed by [subnet id][node id]
		oscdef_metanet = OSCdef(\metanet_listener,{|msg|
			var subid, nodeid, data;
			subid = msg[1].asInteger;
			if(subnet_id != subid) { // Only process the message if it comes from an external subnet.
				nodeid = msg[2].asInteger;
				if (cb_nodes[subid][nodeid].notNil) {
					data = msg.copyRange(3, msg.size);
					// TODO: Decode the incoming data here.
					cb_nodes[subid][nodeid].value(subid, nodeid, data);
				};
			};
		},"/metacology/broadcast");


		// Create the Sense/Stage Hive Listener.
		// Callbacks are registered in cb_minibees, indexed by [bee id]
		oscdef_hive = OSCdef(\hive_listener,{|msg|
			var beeid, data;
			beeid = msg[1].asInteger;
			if(cb_minibees[beeid].notNil) {
				data = msg.copyRange(2, msg.size);
				cb_minibees[beeid].value(beeid, data);
			};
		},"/minibee/data");

	}

	cleanup {
		oscdef_metanet.free;
		oscdef_hive.free;
		netaddr_broadcast.disconnect;
		NetAddr.broadcastFlag = false;
	}

	/********************************
	* launchHive
	*   Open a terminal window and run the pydon hive.
	******************/
	launchHive {
		// TODO: Check if pydongui is already running and give a warning.
		"Opening terminal window... ".postln;
		"pydongui.py".runInTerminal;
		"Running pydongui.py... ".postln;
	}

	/********************************
	* local_send
	*   Send some data to one of the sensor nodes on the local subnet.
	*   beeid - the minibee id on the local subnet
	*   data_arr - arguments to send to the local node
	******************/
	local_send {|beeid ... data_arr|
		netaddr_hive.sendMsg("/minibee/output", beeid, *data_arr);
	}


	/********************************
	* local_responder
	*   Register a callback function which responds to a specific sensor node on the local subnet.
	*   Note: the OSC listener for incoming Hive messages is defined in the init method as oscdef_hive
	*
	*   beeid - The id of the minibee
	*   callback - The callback function with two arguments, (beeid, data)
	*              data is the unmodified array of data values coming from the minibee
	*              If callback is omitted or is nil the callback function for beeid
	*              is disabled.
	******************/
	local_responder {|beeid, callback=nil|
		cb_minibees[beeid] = callback;
	}

	/********************************
	* global_responder
	*   Register a callback function which responds to a specific subnet and node on MetaNet.
	*   Note: the OSC listener for incoming MetaNet messages is defined in the init method as oscdef_metanet
	*
	*   subid - The subnet id of the node
	*   nodeid - The node id
	*   callback - The callback function with three arguments, (subnet, node, data)
	*              data is the unmodified array of data values coming from the node on MetaNet
	*              If callback is omitted or is nil the callback function for the combination of
	*              subnet and node is disabled.
	*        TODO: Integrate some data parsing of the incoming MetaNet data if needed.
	******************/
	global_responder {|subid, nodeid, callback=nil|
		cb_nodes[subid][nodeid] = callback;
	}

	/********************************
	* postlocal
	*   Print incoming data from all local sensor nodes to the post window
	*
	*   posttrue - If false, stop posting, if true or omitted start posting.
	******************/
	postlocal_ {|posttrue=true|
		postlocal.free;
		if (posttrue) {
			postlocal = OSCdef(\minibeePost, {|msg|
				Post << "Bee: " << msg[1] << " Data: " << msg.copyRange(2, msg.size) << Char.nl;
			},"/minibee/data");
		};
	}

/*********************************
	* global_send
	*
	* Send a message to the MetaNet with a specific node id. The nodeid is a virtual placeholder for
	* data, it can correspond directly to one of the sensor nodes on the local subnet or can be some
	* other aggregation of data operating as a virtual sensor node (maybe you want to do some processing
	* on the data before sending it out).
	*
	* nodeid - the virtual node identifier
	* data_arr - the data arguments (nil values resend the last data value unchanged)
	*
	* Returns the values that were sent.
	*
	* EX:
	* m.global_send(3, 1.0, 0.3, 5, 18); // virtual node 3, sending two floats and two ints
	*********************************/
	global_send {|nodeid ... data_arr|
		var no_nil_arr;

		// If an entry in broadcast history for this nodeid doesn't exist, create one.
		if(metanet_broadcast_history[nodeid].isNil) {
			metanet_broadcast_history[nodeid] = 0.dup(data_arr.size);
		};

			/*******************
			   NOTE TO SELF:: TODO! Left off, 8 Dec, 2015 @ 3:29 Taipei time
			*******************/
		// Go through data_arr, for nil values fill in the last value from history
		no_nil_arr = data_arr.collect({|item,idx|
			var result = item;
			if(item.isNil) {
				result = metanet_broadcast_history[nodeid][idx];
			};
			result;
		});

		// Send /metacology/broadcast message
		// OSC PROTOCOL: subnet, node, num_datapoints, type0, value0, type1, value1, ...
		no_nil_arr = encode_datavals(no_nil_arr);
		netaddr_broadcast.sendMsg("/metacology/broadcast", subnet_id, nodeid, *no_nil_arr);
		metanet_broadcast_history[nodeid] = no_nil_arr;
		^no_nil_arr;
	}


	/*********************************
	* encode_datavals
	*
	* A convenience class method encodes a list of data values as metacology/broadcast
	* arguments in the format:
	* [num_datapoints, type0, val0, type1, val1, ...]
	*
	*  Where type 'D' is digital, type 'A' is analog (scaled 0.0-1.0)
	************************/
	*encode_datavals {|datavals|
		var result = [];
		result.add(datavals.size);
		datavals.do {|item, idx|
			var type;
				if(item.isFloat) {
					type = "A";
				} {
					type = "D";
				};
			result.add(type);
			result.add(item);
		};
	}

}