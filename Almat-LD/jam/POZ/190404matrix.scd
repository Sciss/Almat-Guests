"osc.scd".loadRelative;
"190404network.scd".loadRelative;
//blocksize 4
//button 6/7


//button 7
s.plotMyTree(0.5, 200, 600, 1100, 210);//optional

(
m.setKnobs(
	nil, nil, nil, nil, 0, 20, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
	nil, nil, 0, 12.5, 0, 10, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
	4, 40, 0, 1, 0.01, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
);

n.buttFunc={n.router.set(\amp, m.faders.subBus(0).asMap)};
o.buttFunc={o.router.set(\amp, m.faders.subBus(1).asMap)};
p.buttFunc={p.router.set(\amp, m.faders.subBus(2).asMap)};

m.buttonsOn[15]= {
	a= Synth(\001578, [\out, 100, \period, 0, \sign, 1,
		\zeroscale, m.knobs.subBus(19).asMap,
		\freq, m.knobs.subBus(20).asMap, //0.05
		\rrate, m.knobs.subBus(21).asMap,
		\zc, m.knobs.subBus(24).asMap
	]);
};
m.buttonsOff[15]= {a.free};

//stay safe if going too loud
MIDIdef.cc(\mm_thresholddd, {arg val, num, chan;
	defer{r.threshold.valueAction= ((val+0.00001)/127)}//sens
}, 9).permanent_(true);
)

//0.13793103448276
//0.12068965517241

//-53.442018828579

//45.51724137931



(
//ææææææææææææææææææææ[1]æææææææææææææææææææææ//
m.buttonsOn[0]= {
	m.buttonsOn[8]= {
		defer{n.load(
			1,0,1,1,1,0,0,1,0,0,
			1,0,0,0,0,0,0,0,1,1,
			1,0,0,0,0,0,0,1,0,0,
			0,0,0,0,0,0,0,0,0,0,
		)};
	};

	m.buttonsOn[9]= {
		defer{o.load(
			1,0,0,0,0,0,0,0,0,0,
			1,0,0,0,1,1,0,0,1,0,
			1,0,1,0,0,0,0,0,0,1,
			0,0,0,0,0,0,0,0,0,0,
		)};
	};

	m.buttonsOn[10]= {
		defer{p.load(
			1,0,1,0,1,1,0,1,0,0,
			1,0,1,0,0,1,0,0,0,0,
			0,0,0,1,1,1,0,1,0,0,
			0,0,0,0,0,1,0,0,0,0,
		)};
	};

	m.buttonsOff[8]= {defer{n.clear}};
	m.buttonsOff[9]= {defer{o.clear}};
	m.buttonsOff[10]= {defer{p.clear}};
	m.buttonsOff[15]= {a.free};

	m.setKnobs(
		nil, nil, nil, nil, 0, 20, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
		nil, nil, 0, 12.5, 0, 10, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
		4, 40, 0, 1, 0, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	);

	m.buttonsOn[15]= {
		a= Synth(\001578, [\out, 100, \period, 0, \sign, 1,
			\zeroscale, m.knobs.subBus(16).asMap,
			\freq, m.knobs.subBus(17).asMap, //0.05
			\rrate, m.knobsSum.subBus(2).asMap,
			\zc, m.knobs.subBus(23).asMap
		]);
	};


	m.load(
		0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,
		0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,0.0,0.0,0.0,
		1.0,1.0,1.0,0.0,0.0,0.0,0.0,0.0,0.84,
	);
};


m.buttonsOn[1]= {
	m.buttonsOn[8]= {
		defer{n.load(
			1,0,1,1,1,0,0,0,0,0,
			1,0,1,1,1,0,0,0,1,1,
			1,0,1,1,1,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,
		)};
	};

	m.buttonsOn[9]= {
		defer{o.load(
			1,0,1,1,1,1,0,0,0,0,
			1,0,1,1,1,1,0,0,1,0,
			1,0,1,0,0,0,0,0,0,1,
			0,0,0,0,0,0,0,0,0,0,
		)};
	};

	m.buttonsOn[10]= {
		defer{p.load(
			1,0,1,0,1,1,0,0,0,0,
			1,0,1,0,0,1,0,0,0,0,
			0,0,0,1,1,1,0,0,0,0,
			0,0,0,0,0,0,0,1,0,0,
		)};
	};

	m.buttonsOff[8]= {defer{n.clear}};
	m.buttonsOff[9]= {defer{o.clear}};
	m.buttonsOff[10]= {defer{p.clear}};
	m.buttonsOff[15]= {a.free};

	m.setKnobs(
		nil, nil, nil, nil, 0, 150000, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
		nil, nil, 0, 12.5, 0, 10, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
		1, 40, 0, 1, 0, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	);

	m.buttonsOn[15]= {
		a= Synth(\001578, [\out, 100, \period, 0, \sign, 1,
			\zeroscale, m.knobs.subBus(16).asMap,
			\freq, m.knobs.subBus(17).asMap, //0.05
			\rrate, m.knobsSum.subBus(2).asMap,
			\zc, m.knobs.subBus(23).asMap
		]);
	};


	m.load(
		0.0,0.0,1.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.03,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,
		0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,0.0,0.0,0.0,
		1.0,1.0,0.0,0.63,0.0,0.0,0.0,0.55,0.0,


	);
};

m.buttonsOn[2]= {
	m.buttonsOn[8]= {
		defer{n.load(
			1,0,1,1,1,0,0,1,0,0,
			1,0,0,0,0,0,0,0,1,1,
			1,0,0,0,0,0,0,1,0,0,
			0,0,0,0,0,0,0,0,0,0,
		)};
	};

	m.buttonsOn[9]= {
		defer{o.load(
			0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,1,0,
			0,0,0,0,0,0,0,0,0,1,
			0,0,0,0,0,0,0,0,0,0,
		)};
	};

	m.buttonsOn[10]= {
		defer{p.load(
			1,0,1,0,1,1,0,1,0,0,
			1,0,1,0,0,1,0,0,0,0,
			0,0,0,1,1,1,0,1,0,0,
			0,0,0,0,0,1,0,0,0,0,
		)};
	};

	m.buttonsOff[8]= {defer{n.clear}};
	m.buttonsOff[9]= {defer{o.clear}};
	m.buttonsOff[10]= {defer{p.clear}};
	m.buttonsOff[15]= {a.free};

	m.buttonsOn[15]= {
		a= Synth(\001578, [\out, 100, \period, 0, \sign, 1,
			\zeroscale, m.knobs.subBus(16).asMap,
			\freq, m.knobs.subBus(17).asMap, //0.05
			\rrate, m.knobsSum.subBus(2).asMap,
			\zc, m.knobs.subBus(23).asMap
		]);
	};

	m.setKnobs(
		nil, nil, nil, nil, 0, 20, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
		nil, nil, 0, 12.5, 0, 10, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
		4, 40, 0, 1, 0.0, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	);


	m.load(
		0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.56,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,
		0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,0.0,0.0,1.0,
		1.0,0.14,1.0,0.0,0.0,0.0,0.0,0.0,0.84,

	);
};

m.buttonsOn[3]= {
	m.buttonsOn[8]= {
		defer{n.load(
			1,0,1,1,1,0,0,1,0,0,
			1,0,0,0,0,0,0,0,1,1,
			1,0,0,0,0,0,0,1,0,0,
			0,0,0,0,0,0,0,0,0,0,
		)};
	};

	m.buttonsOn[9]= {
		defer{o.load(
			0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,1,0,
			0,0,0,0,0,0,0,0,0,1,
			0,0,0,0,0,0,0,0,0,0,
		)};
	};

	m.buttonsOn[10]= {
		defer{p.load(
			1,0,1,0,1,1,0,1,0,0,
			1,0,1,0,0,1,0,0,0,0,
			0,0,0,1,1,1,0,1,0,0,
			0,0,0,0,0,1,0,0,0,0,
		)};
	};

	m.buttonsOff[8]= {defer{n.clear}};
	m.buttonsOff[9]= {defer{o.clear}};
	m.buttonsOff[10]= {defer{p.clear}};
	m.buttonsOff[15]= {a.free};

	m.buttonsOn[15]= {
		a= Synth(\001578, [\out, 100, \period, 0, \sign, 1,
			\zeroscale, m.knobs.subBus(16).asMap,
			\freq, m.knobs.subBus(17).asMap, //0.05
			\rrate, m.knobsSum.subBus(2).asMap,
			\zc, m.knobs.subBus(23).asMap
		]);
	};

	m.setKnobs(
		nil, nil, nil, nil, 0, 20, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
		nil, nil, 0, 12.5, 0, 10, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
		4, 40, 0, 1, 0.0, 1, nil, nil, nil, nil, nil, nil, nil, nil, 0, 1
	);


	m.load(
		0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1,
		0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,0.0,0.0,1.0,
		1.0,0.13,1.0,0.0,0.0,0.0,0.0,0.0,0.84,

	);
};


m.buttonsOn[7]= {
	m.buttonsOn[8]= {
		defer{n.load(
			1,0,1,1,1,0,0,0,0,0,
			1,0,1,1,1,0,0,0,1,1,
			1,0,1,1,1,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,
		)};
	};

	m.buttonsOn[9]= {
		defer{o.load(
			1,0,1,1,1,1,0,0,0,0,
			1,0,1,1,1,1,0,0,1,0,
			1,0,1,0,0,0,0,0,0,1,
			0,0,0,0,0,0,0,0,0,0,
		)};
	};

	m.buttonsOn[10]= {
		defer{p.load(
			1,0,1,0,1,1,0,0,0,0,
			1,0,1,0,0,1,0,0,0,0,
			0,0,0,1,1,1,0,0,0,0,
			0,0,0,0,0,0,0,1,0,0,
		)};
	};

	m.buttonsOff[8]= {defer{n.clear}};
	m.buttonsOff[9]= {defer{o.clear}};
	m.buttonsOff[10]= {defer{p.clear}};
	m.buttonsOff[15]= {a.free};

	m.setKnobs(
		nil, nil, nil, nil, 0, 20, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
		nil, nil, 0, 12.5, 0, 10, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
		1, 40, 0, 1, 0, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	);

	m.buttonsOn[15]= {
		a= Synth(\001578, [\out, 100, \period, 0, \sign, 1,
			\zeroscale, m.knobs.subBus(16).asMap,
			\freq, m.knobs.subBus(17).asMap, //0.05
			\rrate, m.knobsSum.subBus(2).asMap,
			\zc, m.knobs.subBus(23).asMap
		]);
	};


	m.load(
		0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.15,0.0,0.0,0.0,0.0,0.0,0.0,1.0,
		0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,0.0,0.0,0.0,
		1.0,0.0,0.26,0.63,0.0,0.0,0.0,0.58,1.0,
	);
};

m.buttonsOn[5]= {
	m.buttonsOn[8]= {
		defer{n.load(
			1,0,1,1,1,0,0,0,0,0,
			1,0,1,1,1,0,0,0,1,1,
			1,0,1,1,1,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,
		)};
	};

	m.buttonsOn[9]= {
		defer{o.load(
			1,0,1,1,1,1,0,0,0,0,
			1,0,1,1,1,1,0,0,1,0,
			1,0,1,0,0,0,0,0,0,1,
			0,0,0,0,0,0,0,0,0,0,
		)};
	};

	m.buttonsOn[10]= {
		defer{p.load(
			1,0,1,0,1,1,0,0,0,0,
			1,0,1,0,0,1,0,0,0,0,
			0,0,0,1,1,1,0,0,0,0,
			0,0,0,0,0,0,0,1,0,0,
		)};
	};

	m.buttonsOff[8]= {defer{n.clear}};
	m.buttonsOff[9]= {defer{o.clear}};
	m.buttonsOff[10]= {defer{p.clear}};
	m.buttonsOff[15]= {a.free};

	m.setKnobs(
		nil, nil, nil, nil, 0, 20, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
		nil, nil, 0, 12.5, 0, 10, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
		1, 40, 0, 1, 0, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	);

	m.buttonsOn[15]= {
		a= Synth(\001578, [\out, 100, \period, 0, \sign, 1,
			\zeroscale, m.knobs.subBus(16).asMap,
			\freq, m.knobs.subBus(17).asMap, //0.05
			\rrate, m.knobsSum.subBus(2).asMap,
			\zc, m.knobs.subBus(23).asMap
		]);
	};


	//MOUSE ALL ON THE RIGHT
	m.load(
		0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.52,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,
		0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,0.0,0.0,0.0,
		1.0,1.0,0.22,0.0,0.0,0.0,0.71,0.08,0.0,
	);
};

m.buttonsOn[6]= {

	m.load(
		0.0,0.0,0.0,0.07,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.06,0.0,0.0,0.0,0.0,0.0,0.0,1.0,
		0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,0.0,0.0,0.0,
		0.78,1.0,0.42,0.05,0.0,0.0,0.71,0.1,0.5,
	);
};


/*
m.buttonsOn[4]= {
m.buttonsOn[8]= {
defer{n.load(
1,0,1,1,1,0,0,0,0,0,
1,0,1,1,1,0,0,0,1,1,
1,0,1,1,1,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,
)};
};

m.buttonsOn[9]= {
defer{o.load(
1,0,1,1,1,1,0,0,0,0,
1,0,1,1,1,1,0,0,1,0,
1,0,1,0,0,0,0,0,0,1,
0,0,0,0,0,0,0,0,0,0,
)};
};

m.buttonsOn[10]= {
defer{p.load(
1,0,1,0,1,1,0,0,0,0,
1,0,1,0,0,1,0,0,0,0,
0,0,0,1,1,1,0,0,0,0,
0,0,0,0,0,0,0,1,0,0,
)};
};

m.buttonsOff[8]= {defer{n.clear}};
m.buttonsOff[9]= {defer{o.clear}};
m.buttonsOff[10]= {defer{p.clear}};
m.buttonsOff[15]= {a.free};

m.setKnobs(
nil, nil, nil, nil, 0, 20, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
nil, nil, 0, 12.5, 0, 10, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
1, 40, 0, 1, 0, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
);

m.buttonsOn[15]= {
a= Synth(\001578, [\out, 100, \period, 0, \sign, 1,
\zeroscale, m.knobs.subBus(16).asMap,
\freq, m.knobs.subBus(17).asMap, //0.05
\rrate, m.knobsSum.subBus(2).asMap,
\zc, m.knobs.subBus(23).asMap
]);
};


m.load(
0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.09,0.0,0.0,0.0,0.0,0.0,0.0,1.0,
0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,0.0,0.0,0.0,
0.59,0.09,0.97,0.0,0.0,0.02,0.71,0.08,0.11,
);
};
*/
)

0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.52,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,
0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,0.0,0.0,0.0,0.0,0.0,
1.0,1.0,0.22,0.0,0.0,0.0,0.71,0.08,0.0,


//4hth button first row