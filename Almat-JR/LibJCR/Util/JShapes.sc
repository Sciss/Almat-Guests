/*
Envelopes, Scales, Gestures, Waveshaping Functions and other Shaping Utilities
*/

+ Env {

	*halfSine {arg start=0, end=1, curve=4;
		var mid = (start-end) / 2;
		mid = end + mid;
		^Env([start,mid,end],[0.5,0.5],[curve,-1 * curve]);
	}
}

+ Scale {
	*loadCustom {
		this.all.put(\depth, Scale([0, 0.01, 0.02, 11.2, 36, 45], 6, Tuning([400,5000,6000,200,300,560]/400), "Depth"));
	}
}




