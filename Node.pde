class Node
{
  PVector position;
  PVector velocity;
  PVector acceleration;
  private PVector target;
  int type;

  Node(float x, float y)
  {
    velocity = new PVector();
    target = new PVector(x, y);
    
    float angle = atan2(target.y - height/2, target.x - width/2);
    position = new PVector(width/2 + cos(angle) * Radius, height/2 + sin(angle) * Radius);
    
    float r = random(1);

    if (r < 0.6)
      type = 1;
    else if (r > 0.6 && r < 0.9)
      type = 0;
    else
      type = 2;
  }

  void update()
  {
    //movement
    PVector diff = PVector.sub(target, position);
    diff.mult(K);
    velocity.add(diff);
    velocity.mult(damping);
    velocity.add(new PVector(random(-randomness, randomness), random(-randomness, randomness)));
    position.add(velocity);

    noiseUpdate();

    float blink = random(1);
    if (blink < 0.9)
      render();
  }

  void noiseUpdate()
  {
    int t = millis();

    float timeScale = 0.0005f;

    float noise1 = noise(position.x / noiseScale, position.y / noiseScale);
    float noise2 = noise(position.x / noiseScale, position.y / noiseScale, (float)t * timeScale);

    colorMode(HSB, 360, 100, 100, 100);

    float hue = map(noise1, 0, 1, hue1, hue2);
    float saturation = constrainedMapping(noise2, saturation1, saturation2, 0, 100);

    color c = color(hue, saturation, 100, 100);
    tint(c);
  }

  void render()
  {
    switch(type)
    {
    case 0:
      stroke(255);
      strokeWeight(3);
      point(position.x, position.y);
      break;
    case 1:
      imageMode(CENTER);
      image(img, position.x, position.y, img.width/2, img.height/2);
      break;
    case 2:
      imageMode(CENTER);
      image(img, position.x, position.y);
      break;
    }
  }

  void setTarget(PVector t)
  {
    target = t;
  }

  void setNoTarget()
  {
    float angle = atan2(position.y - height/2, position.x - width/2);
    target = new PVector(width/2 + cos(angle) * Radius, height/2 + sin(angle) * Radius);
  }
  
  float constrainedMapping(float n, float sourceLow, float sourceHigh, float destLow, float destHigh)
  {
    n = constrain(n, sourceLow, sourceHigh);
    return map(n, sourceLow, sourceHigh, destLow, destHigh);
  }
}

