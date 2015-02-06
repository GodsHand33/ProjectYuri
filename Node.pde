class Node
{
  PVector position;
  PVector velocity;
  PVector acceleration;

  float K = 0.001;
  float damping = 0.9;
  float randomness = 0.5;

  private PVector target;

  int type;

  Node(float x, float y)
  {
    position = new PVector(x, y);
    velocity = new PVector();
    target = new PVector(x, y);

    float r = random(1);
    if (r < 0.9)
      type = 0;
    else
      type = 1;
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

    render();
  }

  void render()
  {
    switch(type)
    {
    case 0:
      stroke(255);
      strokeWeight(5);
      point(position.x, position.y);
      break;
    case 1:
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
}

