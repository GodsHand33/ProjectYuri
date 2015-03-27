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
    cp5.saveProperties(("hello.properties"));
  } else if (key=='2') {
    cp5.loadProperties(("hello.properties"));
  }
}

//void mouseClicked() {
//    for (Node node : nodeHashMap.values ()) {
//      node.shake(new PVector(mouseX, mouseY));
//    }
//}

