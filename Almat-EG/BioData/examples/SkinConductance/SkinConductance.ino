/******************************************************
copyright Erin Gee 2017

Authors Erin Gee // Martin Peach // Thomas Ouellet-Fredericks

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License version 3 as published by
the Free Software Foundation.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    For more details: <http://www.gnu.org/licenses/>.

******************************************************/
#include <SkinConductance.h>

// Create instance for sensor on analog input pin.
SkinConductance sc(A0);

void setup() {
  Serial.begin(9600);

  // Initialize sensor.
  sc.reset();
}

void loop() {
  // Update sensor.
  sc.update();

  // Print-out SCR and SCL values.
  Serial.print(sc.getSCR());
  Serial.print(" ");
  Serial.print(sc.getSCL());
  Serial.println();
}
