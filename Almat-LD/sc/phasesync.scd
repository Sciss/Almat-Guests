(

{
	Mix.fill(24, {

	})
}.play

)

s.prepareForRecord("/Users/poz/Desktop/phase.aiff", 12)

~incrs = Array.rand(6, 0.00, 0.00);


(
{
    var n = 6;
    var incr = ~incrs;//Rand(0.02,0.03!n); //[0.072,0.009];
	// var coupling = Rand(-0.8,0.8!n) * MouseX.kr(0,3).lag2(0.3);
	// var coupling = (0.08!n * MouseX.kr(0,3).lag2(0.3)).poll;
	var coupling = MouseX.kr(0.000001, 1);
    var initPhases =  Rand(0.0,pi*2!n); //[0.0, 2.72];
    var fb = LocalIn.ar(n, initPhases);
    var sumPh = fb;
    var diffs = sumPh.collect{ | thisPh, i |
        var diff = 0;
		diff = diff + (sumPh[(i-1)%sumPh.size] - thisPh).sin * coupling.neg;
		diff = diff + (sumPh[(i+1)%sumPh.size] - thisPh).sin * coupling;
		// sumPh.do{arg ph;
		// 	diff = diff + (ph - thisPh).sin;
		// };
		// diff / n;
		//sumPh.do{arg ph;
        //    diff = diff + (ph - thisPh).sin;
        //};

        diff / 2;
    };
	diffs.poll(1);
    sumPh = (sumPh + incr + diffs) % (2 * pi);
    //diffs.poll;
    LocalOut.ar(sumPh);
    Out.ar(0, sumPh.sin * 0.005);
}.play
)



//different couplings for each oscillator

~incrs = Array.rand(6, 0.01, 0.1);


(
{
    var n = 6;
    var incr = ~incrs;//Rand(0.02,0.03!n); //[0.072,0.009];
	// var coupling = Rand(-0.8,0.8!n) * MouseX.kr(0,3).lag2(0.3);
	// var coupling = (0.08!n * MouseX.kr(0,3).lag2(0.3)).poll;
	var coupling = Rand(0.00001, 0.1!n);
    var initPhases =  Rand(0.0,pi*2!n); //[0.0, 2.72];
    var fb = LocalIn.ar(n, initPhases);
    var sumPh = fb;ˇ
    var diffs = sumPh.collect{ | thisPh, i |
        var diff = 0;
		diff = diff + (sumPh[(i-1)%sumPh.size] - thisPh).sin * coupling[i].neg;
		diff = diff + (sumPh[(i+1)%sumPh.size] - thisPh).sin * coupling[i];
		// sumPh.do{arg ph;
		// 	diff = diff + (ph - thisPh).sin;
		// };
		// diff / n;
		//sumPh.do{arg ph;
        //    diff = diff + (ph - thisPh).sin;
        //};

        diff / 2;
    };
	diffs.poll(1);
    sumPh = (sumPh + incr + diffs) % (2 * pi);
    //diffs.poll;
    LocalOut.ar(sumPh);
    Out.ar(0, sumPh.sin * 0.005);
}.play
)



//phase difference sonification

~incrs = Array.rand(6, 0.05, 0.05);


(
{
    var n = 6;
    var incr = ~incrs;//Rand(0.02,0.03!n); //[0.072,0.009];
	// var coupling = Rand(-0.8,0.8!n) * MouseX.kr(0,3).lag2(0.3);
	// var coupling = (0.08!n * MouseX.kr(0,3).lag2(0.3)).poll;
	var coupling = Rand(0.00001, 0.0001!n) + MouseX.kr(0,0.05).lag2(0.3);
    var initPhases =  Rand(0.0,pi*2!n); //[0.0, 2.72];
    var fb = LocalIn.ar(n, initPhases);
    var sumPh = fb;
    var diffs = sumPh.collect{ | thisPh, i |
        var diff = 0;
		diff = diff - (sumPh[(i-1)%sumPh.size] - thisPh).sin.cubed;
		diff = diff + (sumPh[(i+1)%sumPh.size] - thisPh).sin.cubed;
		// sumPh.do{arg ph;
		// 	diff = diff + (ph - thisPh).sin;
		// };
		// diff / n;
		//sumPh.do{arg ph;
        //    diff = diff + (ph - thisPh).sin;
        //};

        diff / 2;
    };
	diffs.poll(1);
	Out.ar(0, diffs* 0.05);
	sumPh = sumPh.collect({arg item, i; (item + incr[i] + (diffs[i] * coupling[i]))%(2*pi)});
    //sumPh = (sumPh + incr + diffs) % (2 * pi);
    //diffs.poll;
    LocalOut.ar(sumPh);
    //Out.ar(0, sumPh.sin * 0.005);
}.play
)

s.scope;



//phase difference sonification with harmonics

~incrs = Array.rand(6, 0.05, 0.05);
s.reboot

(
{
    var n = 6;
    var incr = ~incrs;//Rand(0.02,0.03!n); //[0.072,0.009];
	// var coupling = Rand(-0.8,0.8!n) * MouseX.kr(0,3).lag2(0.3);
	// var coupling = (0.08!n * MouseX.kr(0,3).lag2(0.3)).poll;
	var coupling = Rand(0.00001, 0.0001!n) + MouseX.kr(0,0.05).lag2(0.3);
	var harm = MouseY.kr(1,10).round.poll;
    var initPhases =  Rand(0.0,pi*2!n); //[0.0, 2.72];
    var fb = LocalIn.ar(n, initPhases);
    var sumPh = fb;
    var diffs = sumPh.collect{ | thisPh, i |
        var diff = 0;
		diff = diff - (sumPh[(i-1)%sumPh.size] - thisPh).sin.cubed;
		diff = diff + (sumPh[(i+1)%sumPh.size] - thisPh).sin.cubed;
		diff = diff - ( (sumPh[(i-1)%sumPh.size] - thisPh) * harm).sin.cubed;
		diff = diff + ( (sumPh[(i+1)%sumPh.size] - thisPh) * harm).sin.cubed;

        diff / 4;
    };
	diffs.poll(1);
	Out.ar(0, diffs* 0.03);
	sumPh = sumPh.collect({arg item, i; (item + incr[i] + (diffs[i] * coupling[i]))%(2*pi)});
    //sumPh = (sumPh + incr + diffs) % (2 * pi);
    //diffs.poll;
    LocalOut.ar(sumPh);
    //Out.ar(0, sumPh.sin * 0.005);
}.play
)






//phase difference from mic input

~incrs = Array.rand(6, 0.05, 0.05);

(
{
    var n = 6;
//	var mic = Normalizer.ar(SoundIn.ar(0),1,0.3).clip(-1,1);
	var mic = (SoundIn.ar(0) * ((1 / (PeakFollower.ar(SoundIn.ar(0)) + 0.000001)) * 0.8)).poll.softclip(-1,1);
    var incr = ~incrs;//Rand(0.02,0.03!n); //[0.072,0.009];
	// var coupling = Rand(-0.8,0.8!n) * MouseX.kr(0,3).lag2(0.3);
	// var coupling = (0.08!n * MouseX.kr(0,3).lag2(0.3)).poll;
	var coupling = Rand(0.00001, 0.0001!n) + MouseX.kr(0,0.1).lag2(0.3);
    var initPhases =  Rand(0.0,pi*2!n); //[0.0, 2.72];
    var fb = LocalIn.ar(n, initPhases);
    var sumPh = fb;
    var diffs = sumPh.collect{ | thisPh, i |
        var diff = 0;
		diff = diff - (sumPh[(i-1)%sumPh.size] - thisPh).sin;
		diff = diff + (sumPh[(i+1)%sumPh.size] - thisPh).sin;
		diff = diff + (mic.asin - thisPh).sin;


        diff / 3;
    };
	//diffs.poll(1);
	//Out.ar(0, diffs* 0.02);
	sumPh = sumPh.collect({arg item, i; (item + incr[i] + (diffs[i] * coupling[i]))%(2*pi)});
    //sumPh = (sumPh + incr + diffs) % (2 * pi);
    //diffs.poll;
    LocalOut.ar(sumPh);
    Out.ar(0, sumPh.sin * 0.005);
}.play
)



s.reboot;

//phase difference from multiple mic inputs

~incrs = Array.rand(6, 0.0, 0.0);

(
{
    var n = 6;
//	var mic = Normalizer.ar(SoundIn.ar(0),1,0.3).clip(-1,1);
//	var mic = (SoundIn.ar(0) * ((1 / (PeakFollower.ar(SoundIn.ar(0)) + 0.000001)) * 0.8)).poll.softclip(-1,1);
//	var mics = (SoundIn.ar((1..6)) * 8).softclip(-1,1).poll;
	var mics = Normalizer.ar(SoundIn.ar((1..6))).softclip(-1,1).poll;
    var incr = ~incrs;//Rand(0.02,0.03!n); //[0.072,0.009];
	// var coupling = Rand(-0.8,0.8!n) * MouseX.kr(0,3).lag2(0.3);
	// var coupling = (0.08!n * MouseX.kr(0,3).lag2(0.3)).poll;
	// var coupling = Rand(0.00001, 0.0001!n) + MouseX.kr(0,0.8).lag2(0.3);
	var coupling = 0.0001!n + MouseX.kr(0,0.8).lag2(0.3);
    var initPhases =  Rand(0.0,pi*2!n); //[0.0, 2.72];
    var fb = LocalIn.ar(n, initPhases);
    var sumPh = fb;
    var diffs = sumPh.collect{ | thisPh, i |
        var diff = 0;
	//	diff = diff + (sumPh[(i-1)%sumPh.size] - thisPh).sin;
		//diff = diff + (sumPh[(i+1)%sumPh.size] - thisPh).sin;
		diff = diff + (mics[i].asin - thisPh).sin.cubed;


        diff;
    };
	//diffs.poll(1);
	//Out.ar(0, diffs* 0.02);
	sumPh = sumPh.collect({arg item, i; (item + incr[i] + (diffs[i] * coupling[i]))%(2*pi)});
    //sumPh = (sumPh + incr + diffs) % (2 * pi);
    //diffs.poll;
    LocalOut.ar(sumPh);
    Out.ar(0, sumPh.sin * 0.03);
}.play
)

0.atan2(-1)


s.options.blockSize = 1;
s.reboot;

//phase difference from multiple mic inputs (hilbert phase version)

~incrs = Array.rand(6, 0.0, 0.0);



(
{
    var n = 6;
//	var mic = Normalizer.ar(SoundIn.ar(0),1,0.3).clip(-1,1);
//	var mic = (SoundIn.ar(0) * ((1 / (PeakFollower.ar(SoundIn.ar(0)) + 0.000001)) * 0.8)).poll.softclip(-1,1);
//	var mics = (SoundIn.ar((1..6)) * 8).softclip(-1,1).poll;
	var mics = HPF.ar(SoundIn.ar((0..5)),600);
	//	var mics = BLowShelf.ar(SoundIn.ar((0..5)),140,1,-60);
	var hilbert = Hilbert.ar(mics);
    var incr = ~incrs;//Rand(0.02,0.03!n); //[0.072,0.009];
	// var coupling = Rand(-0.8,0.8!n) * MouseX.kr(0,3).lag2(0.3);
	// var coupling = (0.08!n * MouseX.kr(0,3).lag2(0.3)).poll;
	// var coupling = Rand(0.00001, 0.0001!n) + MouseX.kr(0,0.8).lag2(0.3);
	var coupling = 0.00001!n + MouseX.kr(0.0,0.8).lag2(0.3); //MouseX.kr(0.00001!n,0.8,1).lag2(0.3);
    var initPhases =  Rand(0.0,pi*2!n); //[0.0, 2.72];
    var fb = LocalIn.ar(n, initPhases);
    var sumPh = fb;
    var diffs = sumPh.collect{ | thisPh, i |
        var diff = 0;
		//	diff = diff + (sumPh[(i-1)%sumPh.size] - thisPh).sin;
		//	diff = diff + (sumPh[(i+1)%sumPh.size] - thisPh).sin;
		diff = diff + (hilbert[i][1].atan2(hilbert[i][0]) - thisPh).sin.cubed;

        diff;
    };
	//diffs.poll(1);
	//Out.ar(0, diffs* 0.02);
	sumPh = sumPh.collect({arg item, i; (item + incr[i] + (diffs[i] * coupling[i]))%(2*pi)});
	//	sumPh.poll;
    //sumPh = (sumPh + incr + diffs) % (2 * pi);
	//    diffs.poll;
    LocalOut.ar(sumPh);
    Out.ar(0, sumPh.sin * 0.02);
}.play
)

