import processing.video.*;
import controlP5.*;

Capture VIDEO;
ControlP5 cp5;

HashMap<PVector, Node> nodeHashMap;
ArrayList<Node> nodeRecycleList;

// Data
byte[][] pData;
ArrayList<PVector> toBeAddedDataList;
ArrayList<PVector> toBeRemovedDataList;

int POINT_SIZE = 15;

//tunable parameters

float screenAlpha = 30;

float MIN_BRIGHTNESS = 0;
float MAX_BRIGHTNESS = 98;
float THREHOLD = 0.5;

float K = 0.001;
float damping = 0.9;
float randomness = 0.5;

float noiseScale = 100;
float noiseStrength = 10;
float step = 1;

float Radius;

int tileCountX;
int tileCountY;

PImage img;
PImage bgImg;

//color
float hue1 = 22;
float hue2 = 45;

float saturation1 = 0.5;
float saturation2 = 0.9;

float brightness1 = 0.3;
float brightness2 = 1.0;

float alpha1 = 0.2;
float alpha2 = 0.7;

//fps
int fcount, lastm;
float frate;
int fint = 1;

void setup()
{
  size(1280, 1024, P2D);
  background(0);
  frame.setResizable(true);
  Radius = width;

  //  frameRate(30);

  //  blendMode(ADD);

  img = loadImage("star.png");
  bgImg = loadImage("bg.png");


  GUISetup();

  VIDEO = new Capture(this, width, height);
  VIDEO.start();

  tileCountX = width / POINT_SIZE;
  tileCountY = height / POINT_SIZE;

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
  
  imageMode(CORNER);
  colorMode(RGB, 255, 255, 255, 100);
  tint(255, 255, 255, 100);
  image(bgImg, 0, 0);

  if (VIDEO.available()) {
    VIDEO.read();
    VIDEO.loadPixels();

    //this will fill the "to Be Added/Removed" data list
    PixelAnalysis();

    RemoveNode();

    AddNode();

    UpdateNodes();

    //    noLoop();
  }

  DisplayFPS();
}

void PixelAnalysis()
{
  toBeAddedDataList.clear();
  toBeRemovedDataList.clear();

  for (int j = 0; j < tileCountY; j++)
  {
    for (int i = 0; i < tileCountX; i++)
    {
      if ( (i % 2 == 0 && j % 2 == 1) || (i % 2 == 1 && j % 2 == 0))
      {
        int loc = j * POINT_SIZE * VIDEO.width + VIDEO.width - 1 - i * POINT_SIZE;
        color c = VIDEO.pixels[loc];
        float scale = map(brightness(c), MIN_BRIGHTNESS, MAX_BRIGHTNESS, 1, 0);

        if ( scale > THREHOLD ) //if new data is 1, then check pData
        {
          if (pData[i][j] == 0) //in this case, add a new node
          {
            //add a new node
            toBeAddedDataList.add(new PVector(i, j));
            //save the data to the matrix
            pData[i][j] = 1;
          }
        } else //if new data is 0, then check pData
        {
          if (pData[i][j] == 1) //in this case, remove the old node
          {
            //remove the old node
            toBeRemovedDataList.add(new PVector(i, j));
            //save the data to the matrix
            pData[i][j] = 0;
          }
        }
      }
    }
  }
  println("## PixelAnalysis");
  println("to be added: " + toBeAddedDataList.size());
  println("to be removed: " + toBeRemovedDataList.size());
  println("nodeHashMap: " + nodeHashMap.size());
}

void RemoveNode()
{
  println(nodeHashMap);
  println("#########");
  println(toBeRemovedDataList);

  for (int i = 0; i < toBeRemovedDataList.size (); i++)
  {
    if (nodeHashMap.containsKey(toBeRemovedDataList.get(i)))
    {
      //get the node whose target is this PVector
      Node node = nodeHashMap.get(toBeRemovedDataList.get(i));

      //set the node's target to bottom
      node.setNoTarget();

      //add the node to the nodeRecycleList
      nodeRecycleList.add(node);

      //remove the data from hashmap
      nodeHashMap.remove(toBeRemovedDataList.get(i));
    }
  }

  println("## RemoveNode");
  println("nodeRecycleList: " + nodeRecycleList.size());
  println("nodeHashMap: " + nodeHashMap.size());
}

void AddNode()
{
  for (int i = 0; i < toBeAddedDataList.size (); i++)
  {
    Node n;

    if (nodeRecycleList.size() != 0)
    {
      //reuse the node in the nodeRecycleList
      n = nodeRecycleList.get(0);
      //remove the reused node from nodeRecycleList
      nodeRecycleList.remove(0);
    } else
    {
      //generate a new node
      //        n = new Node(random(width), height);
      n = new Node(toBeAddedDataList.get(i).x * POINT_SIZE, toBeAddedDataList.get(i).y * POINT_SIZE);
    }

    PVector target = new PVector();
    target.set(toBeAddedDataList.get(i));
    target.mult(POINT_SIZE);
    //set the target
    n.setTarget(target);
    //put the data and node into the hashmap
    nodeHashMap.put(toBeAddedDataList.get(i), n);
  }

  println("## AddNode");
  println("nodeRecycleList: " + nodeRecycleList.size());
  println("nodeHashMap: " + nodeHashMap.size());
}

void UpdateNodes()
{
  for (Node node : nodeHashMap.values ()) {
    node.update();
  }

  for (int i = 0; i < nodeRecycleList.size (); i++)
  {
    nodeRecycleList.get(i).update();
  }

  println("\n\n");
}

void DisplayFPS()
{
  fcount += 1;
  int m = millis();
  if (m - lastm > 1000 * fint) {
    frate = float(fcount) / fint;
    fcount = 0;
    lastm = m;
    println("fps: " + frate);
  }
  fill(255);
  text("fps: " + frate, 0, height - 20);
}

void keyPressed()
{
  loop();
}

