#include "SC_PlugIn.h"

// number of inputs before array of control signals
#define INPUTOFFSET 2

static InterfaceTable *ft;

struct Kuramoto : public Unit {
  double* phases_prev;
  double* phases_now;
  int n_oscs;
};

extern "C" {
  void load(InterfaceTable *inTable);

  void Kuramoto_Ctor(Kuramoto* unit);
  void Kuramoto_next_a(Kuramoto *unit, int inNumSamples);
  void Kuramoto_Dtor(Kuramoto *unit);

};


void Kuramoto_Ctor(Kuramoto* unit) {
  SETCALC(Kuramoto_next_a);

  int n = IN0(0);
  float** inputs = unit->mInBuf;  
  unit->n_oscs = n;

  // phases alloc and init
  unit->phases_prev = (double*)RTAlloc(unit->mWorld, n * sizeof(double));
  unit->phases_now = (double*)RTAlloc(unit->mWorld, n * sizeof(double));  
  for (int i = 0; i<n; i++) {
    unit->phases_prev[i] = inputs[INPUTOFFSET+i][0];
  }
  
  Kuramoto_next_a(unit, 1);
}


void Kuramoto_next_a(Kuramoto *unit, int inNumSamples) {
  
  int n = unit->n_oscs;
  double* phases_prev = unit->phases_prev;
  double* phases_now = unit->phases_now;

  
  
  // inputs contains: n (init), mode (audio), [n*initPhases (init)], [n*increments (audio)], [n*coupling_strengths (audio)]
  float* mode = IN(1); 
  float** inputs = unit->mInBuf;

  float* out = OUT(0);
  
  for (int i=0; i < inNumSamples; ++i) {
    int this_mode = sc_clip(mode[i], 0.f, 2.f);

    // if (i == 0) {
    //   Print("n:%d, mode:%d, modefl:%f\n", n, this_mode, mode[i]);
    // }
      
    for (int k=0; k < n; ++k) {
      //      float *out = OUT(k);
      double diff = 0.0;
      double this_phase = phases_prev[k];
      float increment = inputs[INPUTOFFSET+n+k][i];
      float coupling = inputs[INPUTOFFSET+(n*2)+k][i];

      
      switch (this_mode) {
	
      case 0:
	//	if (i == 0) {
      	//   Print("k:%d, this_phase:%f, increment:%f, coupling:%f\n", k, this_phase, increment, coupling);
      	// }
      	// all differences
      	for (int j=0; j < n; ++j) {
      	  diff += sin(phases_prev[j] - this_phase);
      	}
      	diff = diff / (double) n;
      	break;
	
      case 1:
      	// differences from neighbors
      	diff += sin(phases_prev[(k-1)%n] - this_phase);
      	diff += sin(phases_prev[(k+1)%n] - this_phase);
      	diff = diff / 2.f;
      	break;

      case 2:
      	// negative and positive difference
      	diff -= sin(phases_prev[(k-1)%n] - this_phase);
      	diff += sin(phases_prev[(k+1)%n] - this_phase);
      	diff = diff / 2.f;
      	break;

      }

      // TODO replace with different integrator
      phases_now[k] = fmod(this_phase + increment + (diff * coupling), twopi);
      
      (unit->mOutBuf[k])[i] = phases_now[k];
    }

    // swap the pointers, so phases_now becomes next phases_prev
    std::swap(phases_prev, phases_now);
    
  }

  unit->phases_prev = phases_prev;
  unit->phases_now = phases_now;

}

void Kuramoto_Dtor(Kuramoto *unit)
{

  RTFree(unit->mWorld, unit->phases_prev);
  RTFree(unit->mWorld, unit->phases_now);
  
}


PluginLoad(Kuramoto)
{
  ft = inTable;

  DefineDtorUnit(Kuramoto);
}


