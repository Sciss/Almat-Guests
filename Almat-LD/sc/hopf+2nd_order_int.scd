

s.options.blockSize = 1;
s.options.numOutputBusChannels = 24;
s.options.numInputBusChannels = 16;

s.reboot;

s.meter;

{ Out.ar(1, SinOsc.ar(240) * 0.1) }.play // test


// just a reformulation of the simple model of next neighbor interaction in terms of the second order integrator

~incrs = Array.rand(6, 0.0, 0.0);
(
{
    var n = 6;
    var incr = ~incrs;
	var coupling = 0.001;
    var initPhases =  Rand(0.0,pi*2!n);
    var fb = LocalIn.ar(n, initPhases);
    var sumPh = fb;

    sumPh.do{ | thisPh, i |
        var diff = 0;
		diff = diff + (sumPh[(i-1)%sumPh.size] - thisPh).sin * coupling.neg;
		diff = diff + (sumPh[(i+1)%sumPh.size] - thisPh).sin * coupling;
        diff / 2;
		sumPh[i] = (sumPh[i] + ((incr[i] + diff) * 0.5)) % (2 * pi);
    };

    sumPh.reverse.do{ | thisPh, i |
        var diff = 0;
		diff = diff + (sumPh[(i-1)%sumPh.size] - thisPh).sin * coupling.neg;
		diff = diff + (sumPh[(i+1)%sumPh.size] - thisPh).sin * coupling;
        diff / 2;
		sumPh[i] = (sumPh[i] + ((incr[i] + diff) * 0.5)) % (2 * pi);
    };

    //diffs.poll;
    LocalOut.ar(sumPh);
    Out.ar(0, sumPh.sin * 0.005);
}.play
)

// simple oscillator (cartesian coordinates i.e. two-dimensional differential equation system)
// with second order integrator

(
{
	var omega = 0.1; // frequency : this works
	// var omega = 0.01 + MouseX.kr(0.01,0.2).lag; // frequency : why does this not work?
    var initState =  [0.1, 0.0]; // initial conditions, disnatce from [0.0, 0.0] determines amplitude
    var fb = LocalIn.ar(2, initState);
    var state = fb;
	var dd; // change : set for each variable

	dd = omega.neg * state[1];
	state[0] = state[0] + (dd * 0.5);

	dd = omega * state[0];
	state[1] = state[1] + dd;

	dd = omega.neg * state[1];
	state[0] = state[0] + (dd * 0.5);

	state.poll(1);
    LocalOut.ar(state);
    Out.ar(0, state);
}.play
)

// limit cycle with second order integrator

(
{
	var omega = 0.05; // frequency : this works
	// var omega = 0.01 + MouseX.kr(0.01,0.2).lag; // frequency : why does this not work?
	var radius = 0.0002; // radius : this determines the amplitude, no matter which the starting conditions are
	// ATTENTION : higher values of rstrength make the system unstable
    var initState =  [0.1, 0.0]; // initial conditions

    var fb = LocalIn.ar(2, initState);
    var state = fb;
	var dd; // change : set for each variable

	// state.squared.sum.poll;

	dd = (omega.neg * state[1]) + ((radius - state.squared.sum) * state[0]);
	state[0] = state[0] + (dd * 0.5);

	dd = (omega * state[0]) + ((radius - state.squared.sum) * state[1]);
	state[1] = state[1] + (dd * 0.5);
	dd = (omega * state[0]) + ((radius - state.squared.sum) * state[1]);
	state[1] = state[1] + (dd * 0.5);
	// these previous two steps can be simplified safely into one, without loosing stability in integration.
	// I kept them written out for reference.

	dd = (omega.neg * state[1]) + ((radius - state.squared.sum) * state[0]);
	state[0] = state[0] + (dd * 0.5);

	// state.poll(1);
    LocalOut.ar(state);
    Out.ar(0, state);
}.play
)


// hopf osciallator with second order integrator
// it's a three dimensional differential equation system
// we have the 2 cartesian coordiantes as before, forming an limit cycle
// plus the variational equation for the frequency (omega)
// passing from coupling 0.0 to > 0.0 and then to zero again the oscillator will
// have a frequency equal to that of the driving force (or to some harmonic of it)

(
{
	var omega = 100; // frequency : ATTENTION FREQUENCY OF FORCE!!!
	// var omega = 0.01 + MouseX.kr(0.01,0.2).lag; // frequency : why does this not work?
	var radius = 0.001; // radius : this determines the amplitude, no matter which the starting conditions are
	// ATTENTION : higher values of rstrength make the system unstable
	var coupling = 0.0; // coupling to external force, to external oscillator
    var initState =  [0.1, 0.0, 0.1]; // initial conditions, third value is intial condition for frequency

    var fb = LocalIn.ar(3, initState);
    var state = fb;
	var force = SinOsc.ar(omega, 0.5);
	// var force = Saw.ar(omega, 0.5); // force can be any periodic function
	// var force = LFPulse.ar(omega, 0.5); // force can be any periodic function
	var dd; // change : set for each variable

	coupling = MouseX.kr(0.0, 0.005).lag; // coupling should be quite small...:
	// different coupling strengths are needed for different periodic function
	// it is possible that the oscillator locks into the frequency of an harmonic of the driving force.

	// state.squared.sum.poll;

	dd = coupling.neg * force * state[1] / (state.keep(2).squared.sum.sqrt);
	state[2] = state[2] + (dd * 0.5);

	dd = (state[2].neg * state[1]) + ((radius - state.keep(2).squared.sum) * state[0]) + (coupling * force);
	state[0] = state[0] + (dd * 0.5);

	dd = (state[2] * state[0]) + ((radius - state.keep(2).squared.sum) * state[1]);
	state[1] = state[1] + (dd * 0.5);
	dd = (state[2] * state[0]) + ((radius - state.keep(2).squared.sum) * state[1]);
	state[1] = state[1] + (dd * 0.5);

	dd = (state[2].neg * state[1]) + ((radius - state.keep(2).squared.sum) * state[0]) + (coupling * force);
	state[0] = state[0] + (dd * 0.5);

	dd = coupling.neg * force * state[1] / (state.keep(2).squared.sum.sqrt);
	state[2] = state[2] + (dd * 0.5);

	state.poll(1);
    LocalOut.ar(state);
    Out.ar(0, state);
    // Out.ar(1, force * coupling);
}.play
)


