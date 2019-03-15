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


Hopf : UGen {

	*ar { arg force, coupling;
		^this.multiNew('audio', force, coupling)
	}

}