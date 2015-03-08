//fps
int fcount, lastm;
float frate;
int fint = 1;

//visualization
boolean visualizePoint = false;
boolean showFPS = false;

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
  fill(0, 0, 100, 100);
  text("fps: " + frate + " node count: " + nodeHashMap.size() + " " + nodeRecycleList.size(), 100, 40);
  //  fill(255);
  //  text("fps: " + frate + " node count: " + nodeHashMap.size() + " " + nodeRecycleList.size(), 1, 101);
}

void VisualizePoint()
{
  for (int j = 0; j < tileCountY; j++)
  {
    for (int i = 0; i < tileCountX; i++)
    {
      if (pData[i][j] == 1)
      {
        fill(255);
        ellipse(i * POINT_SIZE, j * POINT_SIZE, POINT_SIZE, POINT_SIZE);
      }
    }
  }
}

