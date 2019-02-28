extern crate cfg_if;
extern crate wasm_bindgen;

mod utils;

use cfg_if::cfg_if;
use wasm_bindgen::prelude::*;
use std::f64;

cfg_if! {
    // When the `wee_alloc` feature is enabled, use `wee_alloc` as the global
    // allocator.
    if #[cfg(feature = "wee_alloc")] {
        extern crate wee_alloc;
        #[global_allocator]
        static ALLOC: wee_alloc::WeeAlloc = wee_alloc::WeeAlloc::INIT;
    }
}

#[wasm_bindgen]
extern {
    fn alert(s: &str);
}

#[wasm_bindgen]
pub fn greet(name: &str) {
    alert(&format!("Hello, {}!", name));
}


static TWOPI:f64 = f64::consts::PI * 2f64;

/// Unwrap phase to be within 0 and 2pi
fn unwrap_phase(phase: f64) -> f64 {
    if phase < 0f64 {
        unwrap_phase(phase + TWOPI)
    } else if phase > TWOPI {
        unwrap_phase(phase - TWOPI)
    } else {
        phase
    }
}

/// An oscillator type that can be coupled
#[wasm_bindgen]
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Osc {
    phase : f64, // between 0 and 2pi
    incr : f64, 
    coupling : f64
}

#[wasm_bindgen]
impl Osc {

    pub fn new(phase: f64, incr: f64, coupling: f64) -> Osc {
        Osc { phase : phase, incr : incr, coupling : coupling}
    }
    
    /// Update the oscilaltors phase given a sum of differences.
    /// to other oscillators' phases.
    /// This should probably only be called via the collection update method.
    /// Therefore not public.
    fn update(&mut self, diff: f64) {
        self.phase += unwrap_phase(self.incr + diff * self.coupling);
    }


}

// fn create_osc(incr: f64, coupling: f64) -> Osc {
//     Osc {phase : 0f64, incr : incr, coupling : coupling} 
// }

/// This type cotains a collection of coupled oscillators
#[wasm_bindgen]
pub struct OscCollection {
    oscs : Vec<Osc>
}


#[wasm_bindgen]
impl OscCollection {

    /// Create an empty oscillator collection
    pub fn new() -> OscCollection {
        OscCollection { oscs : Vec::new() }
    }
    
    /// Add an oscillator to the collection
    pub fn add(&mut self, osc: Osc) {
        self.oscs.push(osc);
    }

    /// Update all oscillators in the connection
    pub fn update(&mut self) {

        let mut diff_sum = 0f64;
        let length = self.oscs.len();

        // would be more nicely expressed as a fold
        for i in 0..length {
            // we also diff from self but is 0, so no effect
            for k in 0..length { 
                diff_sum += (self.oscs[k].phase - self.oscs[i].phase).sin();
            }            
            self.oscs[i].update(diff_sum);
        }
    }

    /// Return the length of the collection
    pub fn len(&self) -> usize {
        self.oscs.len()
    }

    /// Access the phase value of a particular oscillator
    pub fn phase(&self, i: usize) -> f64 {
        self.oscs[i].phase
    }
}

