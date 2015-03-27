import processing.video.*;
import SimpleOpenNI.*;
import org.openkinect.*;
import org.openkinect.processing.*;
import controlP5.*;
import ddf.minim.*;
import ddf.minim.analysis.*;



//mode 0: cam
//mode 1: openni
//mode 2: openkinect
int mode = 2;

//lib
Capture cam;
SimpleOpenNI openni;
ControlP5 cp5;
Kinect kinect;

//minim
Minim minim;
AudioInput in;
BeatDetect beat;

boolean IsKick;
boolean IsSnare;
boolean IsHat;
int sensitivity = 400;

int POINT_SIZE = 12;

float kMinThrehold = 0.6f;
float kMaxThrehold = 1f;

float Radius;

int tileCountX;
int tileCountY;
//calculate tile size based on kinect size and tile count
int tileSizeX;
int tileSizeY;

int backgroundStarCount = 500;

PImage img;
PImage img1;
PImage bgImg;

void setup()
{
  //the screen ratio should always be 4:3, to fit kinect data source
  size(1280, 960, P3D);
  //  size(960, 720, P3D);
  background(0);
  frame.setResizable(true);
  Radius = width;

  frameRate(30);

  img = loadImage("star.png");
  img1 = loadImage("star1.png");
  bgImg = loadImage("bg.png");

  GUISetup();


  minim = new Minim(this);
  in = minim.getLineIn();
  beat = new BeatDetect();
  beat.detectMode(BeatDetect.FREQ_ENERGY);
  beat.setSensitivity (sensitivity);
  IsKick = false;
  IsSnare = false;
  IsHat = false;


  if (mode == 0)
    setupCam();
  else if (mode == 1)
    setupOpenni();
  else if (mode == 2)
    setupKinect();



  nodeHashMap = new HashMap<PVector, Node>();
  nodeRecycleList = new ArrayList<Node>();

  pData = new byte[tileCountX][tileCountY];
  for (int j = 0; j < tileCountY; j++)
  {
    for (int i = 0; i < tileCountX; i++)
    {
      pData[i][j] = 0;
    }
  }

  toBeAddedDataList = new ArrayList<PVector>();
  toBeRemovedDataList = new ArrayList<PVector>();
}

void draw()
{
  beat.detect(in.mix);
  IsKick = beat.isKick();
  IsSnare = beat.isSnare();
  IsHat = beat.isHat();

  imageMode(CORNER);
  colorMode(RGB, 255, 255, 255, 100);
  tint(255, 255, 255, 100);
  image(bgImg, 0, 0);

  randomSeed(0);
  for (int i = 0; i < backgroundStarCount; i++)
  {
    stroke(255, random(0, 50));
    strokeWeight(random(1, 3));
    point(random(width), random(height));
  }


  if (mode == 0)
    updateCam();
  else if (mode == 1)
    updateOpenni();
  else if (mode == 2)
    updateKinect();

  //this will fill the "to Be Added/Removed" data list
  PixelAnalysis();
  RemoveNode();
  AddNode();
  UpdateNodes();

  if (visualizePoint)
    VisualizePoint();

  if (showFPS)
    DisplayFPS();

  if (IsKick)
  {
    PVector p = new PVector(random(width), random(height));
    PVector p2 = new PVector(random(width), random(height));
    PVector p3 = new PVector(random(width), random(height));
    
    int shakeType = (int)random(3);
//    int shakeType = 0;
    
    for (Node node : nodeHashMap.values ()) {
      node.shake(p, shakeType);
      node.shake(p2, shakeType);
      node.shake(p3, shakeType);
    }
  }
}

