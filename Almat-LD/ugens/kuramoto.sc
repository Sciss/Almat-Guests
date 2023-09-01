Kuramoto : MultiOutUGen {
	*ar {
		arg n, mode, initPhases, increments, externalPhases, couplingsInternal, couplingsExternal;
		^this.multiNewList(['audio', n, mode] ++ initPhases ++ increments ++ externalPhases ++ couplingsInternal ++ couplingsExternal)
	}

	init {arg ... theInputs;
		inputs = theInputs;
		^this.initOutputs(inputs[0], 'audio');
	}
	
}


Hopf : MultiOutUGen {

	*ar { arg force, coupling, radius;
		^this.multiNew('audio', force, coupling, radius)
	}


	init { arg ... theInputs;
		inputs = theInputs;
		^this.initOutputs(4, 'audio');
	}
	
}