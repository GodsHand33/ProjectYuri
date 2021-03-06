float K = 0.1;
float damping = 0.9;
float randomness = 0.5;

float noiseScale = 100;
float noiseStrength = 10;
float step = 1;

float kMaxDist = 80;
float kMinDist = 50;

float kReachDistThrehold = 10;

float kShakeRange = 400;
float kShakeForce = 100;

float r = 400;

class Node
{
  PVector position;
  PVector velocity;
  PVector acceleration;
  private PVector target;
  int type;
  float size = 1f;
  boolean hasLines = false;

  Node(float x, float y)
  {
    velocity = new PVector();
    target = new PVector(x, y);

    float angle = atan2(target.y - height/2, target.x - width/2);
    position = new PVector(width/2 + cos(angle) * Radius, height/2 + sin(angle) * Radius);

    float r = random(1);

    if (r < 0.95)
    {
      type = 0;
      size = random(0.2f, 0.7f);
    }
    //    else if (r > 0.5 && r < 0.66)
    //      type = 1;
    //    else if (r > 0.66 && r < 0.9)
    //      type = 2;
    else
    {
      type = 3;
      hasLines = true;
    }
  }

  void update()
  {
    movement();

    if (!outOfBorder())
    {
      noiseUpdate();

      if (hasLines && hasReachedTheTarget())
        drawConnectionLines();

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

  public void shake(PVector origin, int shakeType)
  {
    switch(shakeType)
    {
    case 0:
      {
        PVector dir = PVector.sub(position, origin);
        float distance = dir.mag();
        float force = map(distance, 0, kShakeRange, kShakeForce, 0);
        force = constrain(force, 0, kShakeForce);
        dir.normalize();
        position = new PVector(position.x + dir.x * force, position.y + dir.y * force);
      }
      break;
    case 1:
      {
        float distance = abs(position.x - origin.x);
        float sign = (position.x > origin.x) ? 1 : -1;
        float force = map(distance, 0, kShakeRange, kShakeForce, 0);
        force = constrain(force, 0, kShakeForce);
        position = new PVector(position.x + sign * force, position.y);
      }
      break;
    case 2:
      {
        float distance = abs(position.y - origin.y);
        float sign = (position.y > origin.y) ? 1 : -1;
        float force = map(distance, 0, kShakeRange, kShakeForce, 0);
        force = constrain(force, 0, kShakeForce);
        position = new PVector(position.x, position.y + sign * force);
      }
      break;
    }
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

  boolean hasReachedTheTarget()
  {
    if (PVector.dist(position, target) < kReachDistThrehold)
      return true;
    return false;
  }

  void render()
  {
    float blink = random(1);
    if (blink < 0.1)
      return;

    switch(type)
    {
    case 0:

      //      imageMode(CENTER);
      //      image(img1, position.x, position.y, img1.width * size, img1.height * size);
      {
        pushMatrix();
        translate(width/2, height/2);
        PVector p = fishEye((int)position.x, (int)position.y, width, height);
        translate(p.x, p.y, p.z);
        imageMode(CENTER);
        image(img1, 0, 0, img1.width * size, img1.height * size);
        popMatrix();
      }
      break;
    case 1:
      imageMode(CENTER);
      image(img1, position.x, position.y, img1.width * 1, img1.height * 1);
      break;
    case 2:
      imageMode(CENTER);
      image(img, position.x, position.y, img.width * .7, img.height * .7);
      break;
    case 3:
      //      imageMode(CENTER);
      //      image(img, position.x, position.y);
      {
        pushMatrix();
        translate(width/2, height/2);
        PVector p = fishEye((int)position.x, (int)position.y, width, height);
        translate(p.x, p.y, p.z);
        imageMode(CENTER);
        image(img, 0, 0, img.width * size, img.height * size);
        popMatrix();
      }
      break;
    }
  }

  void drawConnectionLines()
  {
    for (Node n : nodeHashMap.values ()) {
      if (this != n && n.hasLines)
      {
        float distance = dist(position.x, position.y, n.position.x, n.position.y);
        if (distance > kMinDist && distance < kMaxDist)
        {
//          beginShape();
//          stroke(0, 0, 100, 0);
//          vertex(position.x, position.y);
//          stroke(0, 0, 100, 100);
//          vertex(0.5 * (position.x + n.position.x), 0.5 * (position.y + n.position.y));
//          stroke(0, 0, 100, 0);
//          vertex(n.position.x, n.position.y);
//          endShape();

          {
            pushMatrix();
            translate(width/2, height/2);
            beginShape();
            stroke(0, 0, 100, 0);
            PVector p = fishEye((int)position.x, (int)position.y, width, height);
            vertex(p.x, p.y, p.z);
            stroke(0, 0, 100, 100);
            p = fishEye((int)(0.5 * (position.x + n.position.x)), (int)(0.5 * (position.y + n.position.y)), width, height);
            vertex(p.x, p.y, p.z);
            stroke(0, 0, 100, 0);
            p = fishEye((int)n.position.x, (int)n.position.y, width, height);
            vertex(p.x, p.y, p.z);
            endShape();
            
            popMatrix();
          }
        }
      }
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

  PVector fishEye(int inX, int inY, int maxX, int maxY)
  {
    float phi = map(inX, 0, maxX, -PI, 0);
    float theta = map(inY, 0, maxY, PI, 0);

    float x = r * sin(theta) * cos(phi);
    float z = -r * sin(theta) * sin(phi);
    float y = r * cos(theta);

    return new PVector(x, y, z);
  }
}

