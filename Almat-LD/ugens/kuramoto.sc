Kuramoto : MultiOutUGen {
	*ar {
		arg n, mode, initPhases, increments, couplings;
		^this.multiNewList(['audio', n, mode] ++ initPhases ++ increments ++ couplings)
	}

	init {arg ... theInputs;
		inputs = theInputs;
		^this.initOutputs(inputs[0], 'audio');
	}
	
}