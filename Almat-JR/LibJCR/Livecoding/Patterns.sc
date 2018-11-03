/******************************************

Additional Pattern utlities for livecoding and other things.

2018 Jonathan Reus
jonathanreus.com
info@jonathanreus.com

*******************************************/

/*

Generates a node proxy representing an envelope, whose bus can be mapped to a parameter.
The existance of the pattern value is duration-based. And will hold the final value.

Uses control rate.

*/


Penv2 {
	*new { arg levels, times, curves, levelScale=1, levelBias=0, timeScale=1;
		var env = Env(levels, times, curves);
		var proxy = NodeProxy.new;
		proxy.source = {
			EnvGen.kr(env, 1, levelScale, levelBias, timeScale, doneAction: 2);
		};
		^proxy;
	}

}