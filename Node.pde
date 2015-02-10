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

    if (r < 0.33)
      type = 0;
    else if (r > 0.33 && r < 0.66)
      type = 1;
    else if (r > 0.66 && r < 0.99)
      type = 2;
    else
      type = 3;
  }

  void update()
  {
    movement();
    if (!outOfBorder())
    {
      noiseUpdate();
      render();
    }
  }

  void movement()
  {
    PVector diff = PVector.sub(target, position);
    diff.mult(K);
    diff.add(new PVector(random(-randomness, randomness), random(-randomness, randomness)));
    velocity.add(diff);
    velocity.mult(damping);
    position.add(velocity);
  }

  boolean outOfBorder()
  {
    if (position.x < 0)
      return true;
    if (position.x > width)
      return true;
    if (position.y < 0)
      return true;
    if (position.y > height)
      return true;

    return false;
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
    float blink = random(1);
    if (blink < 0.1)
      return;

    switch(type)
    {
    case 0:
      stroke(255);
      strokeWeight(3);
      point(position.x, position.y);
      break;
    case 1:
      imageMode(CENTER);
      image(img1, position.x, position.y, img1.width * .8, img1.height * .8);
      //      image(img1, position.x, position.y);
      break;
    case 2:
      imageMode(CENTER);
      image(img, position.x, position.y, img.width * .5, img.height * .5);
      break;
    case 3:
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

