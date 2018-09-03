/*****************************************

BelaServer

Jonathan Reus-Brodsky

Simple ssh control of scsynth on the Bela.

This is a stopgap to just get working with the Bela.
// Connecting to Bela remotely
// CODEBASE SUGGESTION:: A subclass of Server, BelaServer, which adds additional Bela-Specific server options,
// and automatically recognizes the platform its on (working remotely or on the board) so as to simplify
// the workflow of moving from remote experimentation to running on the board.

NTS:: Update to use Giulio's dev scripts.

Also:
there are some issues where connecting to the server does not show the server status in the IDE.
notifications are also a bit wonky (how to know when the server has finished booting on the board?)

Updated Aug 11, 2016 - created


****************************************/



// NTS:: Extend Server instead
BelaServer {
	var <options;
	var <serv;
	var <>scriptDir;

	*new {|blocksize=16, analog_ins=2, analog_outs=2, digital_IOs=0, audio_ins=2, audio_outs=2|
		^super.new.initme();
	}

	initme {
		options = BelaServerOptions.new;
		serv = nil;
		scriptDir="/Volumes/Store/Box/_Projects/Bela/Bela/scripts/";
	}

	boot {
		serv = Server("belaServer", NetAddr("192.168.7.2", 57110));
		Server.default = serv;
		{
			var startcmd, pidstart, args;
			args = "-u 57110 -z 16 -J 2 -K 2 -G 0 -i 0 -o 2";
			// NTS:: see ServerOptions.asOptionsString for construction option strings
			startcmd = "ssh root@192.168.7.2 \"screen -d -m -S mysynth scsynth"+args+"\"";
			// Use Guilio's scripts instead
			startcmd = scriptDir +/+ "scsynth.sh start -c"+args;


			pidstart = startcmd.unixCmd({}, true);
			startcmd.postln;
			5.0.wait;
			// These commands are necessary to connect the running sclang to the server
			// These are not done when you boot from the command line
			serv.initTree;
			serv.startAliveThread;
			serv.sync;
			// ^^^^^
			// ISSUE TRACKER:: Not getting server feedback in the IDE?
			// Lots of goofiness here in terms of server feedback
			"Bela Server Booting ... at some point you should get a response..".postln;
		}.fork;

		^serv;
	}

	stat {
		"ssh root@192.168.7.2 cat /proc/xenomai/stat".unixCmd;
	}

	status {
		^(serv.status);
	}

	isRunning {
		^(serv.serverRunning);
	}

	quit {
		{
			var killcmd;
			//NetAddr("192.168.7.2", 57110).sendMsg(\quit);
			serv = serv ? Server.default;
			serv.quit;
			2.0.wait;
			// Brutal.
			killcmd = "ssh root@192.168.7.2 pkill scsynth";
			// Use Guilio's script instead
			killcmd = scriptDir +/+ "scsynth.sh stop";
			killcmd.unixCmd({}, true);
			"Done...".postln;
		}.fork;
	}
}

// NTS:: Extend ServerOptions instead
BelaServerOptions {
	var <>blockSize = 16;
	var <>numAnalogInChannels = 8;
	var <>numAnalogOutChannels = 8;
	var <>numDigitalChannels = 16;
	var <>numInputBusChannels = 2;
	var <>numOutputBusChannels = 2;

	*new {|blocksize=16, analog_ins=2, analog_outs=2, digital_IOs=0, audio_ins=2, audio_outs=2|
		^super.new.initme(blocksize, analog_ins, analog_outs, digital_IOs, audio_ins, audio_outs);
	}

	initme {|blocksize, analog_ins, analog_outs, digital_IOs, audio_ins, audio_outs|
		blockSize = blocksize;
		numAnalogInChannels = analog_ins;
		numAnalogOutChannels = analog_outs;
		numDigitalChannels = digital_IOs;
		numInputBusChannels = audio_ins;
		numOutputBusChannels = audio_outs;
	}

}

