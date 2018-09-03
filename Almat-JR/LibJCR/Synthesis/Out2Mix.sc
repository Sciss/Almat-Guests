/*
Some nice sources of inspiration
"examples/pieces" folder
http://sccode.org
http://swiki.hfbk-hamburg.de:8888/MusicTechnology/524

*/

/*
Some handy UGens for Mixing
*/

// A single mono mixing/filter/panning channel
MixCh : UGen {

	*ar {|insig, pregain=1.0, postgain=1.0, pan=0, verbmix=0.5, cutoff=440, rq=1|
		var out;
		out = insig * pregain;
		out = BLowPass4.ar(out, cutoff, rq);
		out = FreeVerb.ar(out, verbmix);
		out = Pan2.ar(out, pan);
		^(out * postgain);
	}
}


// Send a signal out to a mix channel
Out2Mix : UGen {

	classvar <>mixbus = 50;

	*ar { |ch=0, channelsArray|
		^Out.ar(mixbus + ch, channelsArray);
	}
}





