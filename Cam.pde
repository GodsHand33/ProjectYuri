PImage depthImage = new PImage(480, 320);
float kAngle = 15;

void setupCam()
{
  //cam setup
  cam = new Capture(this, width, height);
  cam.start();
}

void setupOpenni()
{
  //openni setup
  openni = new SimpleOpenNI(this);

  if (openni.isInit() == false)
  {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
  } else
  {
    openni.setMirror(true);
    openni.enableDepth();
    getTileSize();
  }
}

void setupKinect()
{
  kinect = new Kinect(this);
  kinect.start();
  kinect.enableDepth(true);
  kinect.tilt(kAngle);
  getTileSize();
}

void getTileSize()
{
  tileCountX = width / POINT_SIZE;
  tileCountY = height / POINT_SIZE;

  tileSizeX = depthImage.width / tileCountX;
  tileSizeY = depthImage.height / tileCountY;
}

void updateCam()
{
  //cam update
  if (cam.available()) {
    cam.read();
    cam.loadPixels();
  }
}

void updateOpenni()
{
  //openni update
  openni.update();
  depthImage = openni.depthImage();
}

void updateKinect()
{
  depthImage = kinect.getDepthImage();
}

void stop() {
  if (mode == 2)
    kinect.quit();

  super.stop();
}

