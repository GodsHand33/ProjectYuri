Range range;

void GUISetup()
{
  cp5 = new ControlP5(this);

  cp5.addSlider("THREHOLD")
    .setPosition(0, 0)
      .setRange(0, 1)
        ;

  range = cp5.addRange("rangeController")
    // disable broadcasting since setRange and setRangeValues will trigger an event
    .setBroadcast(false) 
      .setPosition(0, 10)
        .setSize(100, 10)
          .setHandleSize(10)
            .setRange(0, 255)
              //              .setRangeValues(128, 255)
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

  cp5.addSlider("screenAlpha")
    .setPosition(0, 50)
      .setRange(0, 64)
        ;
}

void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isFrom("rangeController")) {
    // min and max values are stored in an array.
    // access this array with controller().arrayValue().
    // min is at index 0, max is at index 1.
    MIN_BRIGHTNESS = int(theControlEvent.getController().getArrayValue(0));
    MAX_BRIGHTNESS = int(theControlEvent.getController().getArrayValue(1));
  }
}

