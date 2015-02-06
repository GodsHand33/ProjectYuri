class Node
{
  PVector position;
  PVector velocity;
  PVector acceleration;

  float K = 0.005;
  float damping = 0.9;
  float randomness = 0.1;

  private PVector target;
//  private boolean hasTarget;

  Node(float x, float y)
  {
    position = new PVector(x, y);
    velocity = new PVector();
    target = new PVector(x, y);
    
//    target.set(position);
//    hasTarget = false;
  }

  void update()
  {
//    if (!hasTarget)
//    {
//      target = new PVector(position.x, height);
//    }


    //movement
    PVector diff = PVector.sub(target, position);
    diff.mult(K);
    velocity.add(diff);
    velocity.mult(damping);
    velocity.add(new PVector(random(-randomness, randomness), random(-randomness, randomness)));
    position.add(velocity);

    //rendering
//    ellipse(position.x, position.y, 10, 10);
    stroke(255);
    strokeWeight(5);
    point(position.x, position.y);

//    hasTarget = false;
  }

  void setTarget(PVector t)
  {
    target = t;
//    hasTarget = true;
  }
}

