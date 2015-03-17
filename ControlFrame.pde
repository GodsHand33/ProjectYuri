public class ControlFrame extends PApplet {

  ControlP5 cp5;
  Object parent;
  int w;
  int h;

  public ControlFrame(Object theParent, int theWidth, int theHeight) {
    parent = theParent;
    w = theWidth;
    h = theHeight;
  }

  public void setup() {
    size(w, h);
    frameRate(25);
    GUISetup();
  }

  public void draw() {
    background(0);
  }

  void GUISetup()
  {
    cp5 = new ControlP5(this);

    Group g1 = cp5.addGroup("Menu")
      .setPosition(0, 0)
        .setBackgroundHeight(50)
          .setBackgroundColor(color(255, 50))
            ;

    range = cp5.addRange("rangeController")
      //    .plugTo(parent,"rangeController")
      // disable broadcasting since setRange and setRangeValues will trigger an event
      .setBroadcast(false) 
        .setPosition(0, 0)
          .setSize(100, 10)
            .setGroup(g1)
              .setHandleSize(10)
                .setRange(0, 1)
                  // after the initialization we turn broadcast back on again
                  .setBroadcast(true);

    cp5.addSlider("kMaxDist")
      .plugTo(parent, "kMaxDist")
        .setPosition(0, 10)
          .setGroup(g1)
            .setRange(0, 300)
              ;

    cp5.addSlider("kMinDist")
      .plugTo(parent, "kMinDist")
        .setPosition(0, 20)
          .setGroup(g1)
            .setRange(0, 100)
              ;

    cp5.addSlider("K")
      .plugTo(parent, "K")
        .setPosition(0, 30)
          .setGroup(g1)
            .setRange(0, 0.1)
              ;

    cp5.addSlider("kReachDistThrehold")
      .plugTo(parent, "kReachDistThrehold")
        .setPosition(0, 40)
          .setGroup(g1)
            .setRange(1, 100)
              ;

    cp5.addSlider("kShakeRange")
      .plugTo(parent, "kShakeRange")
        .setPosition(0, 50)
          .setGroup(g1)
            .setRange(0, 1000)
              ;
    cp5.addSlider("kShakeForce")
      .plugTo(parent, "kShakeForce")
        .setPosition(0, 60)
          .setGroup(g1)
            .setRange(0, 1000)
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

  void keyPressed()
  {
    if (key == CODED) {
      if (keyCode == UP) {
        kAngle++;
      } else if (keyCode == DOWN) {
        kAngle--;
      }
      kAngle = constrain(kAngle, 0, 30);
      kinect.tilt(kAngle);
    } else if (key == 'p')
    {
      visualizePoint = !visualizePoint;
    } else if (key == 'f')
    {
      showFPS = !showFPS;
    } else if (key=='1') {
      cp5.saveProperties(("yuri.properties"));
    } else if (key=='2') {
      cp5.loadProperties(("yuri.properties"));
    }
  }
}

ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
  Frame f = new Frame(theName);
  ControlFrame p = new ControlFrame(this, theWidth, theHeight);
  f.add(p);
  p.init();
  f.setTitle(theName);
  f.setSize(p.w, p.h);
  f.setLocation(100, 100);
  f.setResizable(false);
  f.setVisible(true);
  return p;
}

