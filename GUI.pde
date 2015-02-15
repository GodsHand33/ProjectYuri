Range range;

//color
float hue1 = 22;
float hue2 = 45;

float saturation1 = 0.5;
float saturation2 = 0.9;

float brightness1 = 0.3;
float brightness2 = 1.0;

float alpha1 = 0.2;
float alpha2 = 0.7;

void GUISetup()
{
  cp5 = new ControlP5(this);

  range = cp5.addRange("rangeController")
    // disable broadcasting since setRange and setRangeValues will trigger an event
    .setBroadcast(false) 
      .setPosition(0, 10)
        .setSize(100, 10)
          .setHandleSize(10)
            .setRange(0, 1)
              // after the initialization we turn broadcast back on again
              .setBroadcast(true);

  cp5.addSlider("K")
    .setPosition(0, 20)
      .setRange(0, 0.01)
        ;

  cp5.addSlider("damping")
    .setPosition(0, 30)
      .setRange(0.8, 1)
        ;
  cp5.addSlider("randomness")
    .setPosition(0, 40)
      .setRange(0, 5)
        ;
}

void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isFrom("rangeController")) {
    // min and max values are stored in an array.
    // access this array with controller().arrayValue().
    // min is at index 0, max is at index 1.
    kMinThrehold = theControlEvent.getController().getArrayValue(0);
    kMaxThrehold = theControlEvent.getController().getArrayValue(1);
  }
}

