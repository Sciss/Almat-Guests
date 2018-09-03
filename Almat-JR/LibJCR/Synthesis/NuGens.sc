/*
4 Nov 2015
Jonathan Reus

A collection of custom UGens.

Additional sources of inspiration...
"examples/pieces" folder
http://sccode.org
http://swiki.hfbk-hamburg.de:8888/MusicTechnology/524

*/


Stutter {
    *ar { |in, reset, length, rate = 1.0, maxdelay = 10|
        var phase, fragment, del;
        phase = Sweep.ar(reset);
        fragment = { |ph| (ph - Delay1.ar(ph)) < 0 + Impulse.ar(0) }.value(phase / length % 1);
        del = Latch.ar(phase, fragment) + ((length - Sweep.ar(fragment)) * (rate - 1));
        ^DelayC.ar(in, maxdelay, del);
    }
}


MaxSine : UGen {

	*ar {|freq=440,num=10,ratio=0.5,gain=0.9|
		var out;
		out = Mix.fill(num,{|i| SinOsc.ar(freq + (freq * (ratio * i)), mul: gain / num) });
		^out;
	}

}





/*

MySins

(
Ndef(\mysin,
	{
		var sig1, numsin=80;
		sig1 = Mix.fill(numsin, {|i| SinOsc.ar(MouseX.kr(0.5,5)*(i+1), mul: (LFTri.ar(MouseY.kr(100,500), phase: i * pi) + 1) * 1.0 / numsin)});
		sig1.dup;
	}
).play;
)

*/



