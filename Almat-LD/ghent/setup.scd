s.reboot;

s.options.numOutputBusChannels = 24;
s.options.numInputBusChannels = 16;

// speakers
// 0 - rechts oben
// 1 - links oben
// 2 - rechts unten
// 3 - links unten
// 4 - mitte tür
// 5 - mitte wand


// mics
// 0 - links tür
// 1 - wand mitte
// 2 - rechts tür
// 3 - wand rechts
// 4 - links wand
// 5 - tür mitte

{ Out.ar(3, Impulse.ar(30) * 0.001) }.play

s.meter