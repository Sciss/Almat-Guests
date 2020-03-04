import { Osc, OscCollection } from "wasm-sync";

const collection = OscCollection.new();

collection.add(Osc.new(0, 0.001, 0.005));
collection.add(Osc.new(0.5, 0.001, 0.005));

for (let iter = 0; iter < 500; iter++) {
    // print phases and indices of oscillators
    for (let i = 0; i < collection.len(); i++) { 
	let phase_i = collection.phase(i);
	console.log("idx: ", i, "phase: ", phase_i);
    }
    // update
    collection.update();
}

