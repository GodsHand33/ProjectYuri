HashMap<PVector, Node> nodeHashMap;
ArrayList<Node> nodeRecycleList;
byte[][] pData;
ArrayList<PVector> toBeAddedDataList;
ArrayList<PVector> toBeRemovedDataList;

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

        color c = color(0);
        float brightness = 0;

        if (mode == 0)
        {
          int loc = j * POINT_SIZE * cam.width + cam.width - 1 - i * POINT_SIZE;
          c = cam.pixels[loc];
        } else if (mode == 1 || mode == 2)
        {
          int loc = j * tileSizeY * depthImage.width + i * tileSizeX;
          c = depthImage.pixels[loc];
        }


        brightness = brightness(c);

        if ( brightness > 255 * kMinThrehold && brightness < 255 * kMaxThrehold ) //if new data is 1, then check pData
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
  //  println("## PixelAnalysis");
  //  println("to be added: " + toBeAddedDataList.size());
  //  println("to be removed: " + toBeRemovedDataList.size());
  //  println("nodeHashMap: " + nodeHashMap.size());
}

void RemoveNode()
{
  //  println(nodeHashMap);
  //  println("#########");
  //  println(toBeRemovedDataList);

  for (int i = 0; i < toBeRemovedDataList.size (); i++)
  {
    if (nodeHashMap.containsKey(toBeRemovedDataList.get(i)))
    {
      //get the node whose target is this PVector
      Node node = nodeHashMap.get(toBeRemovedDataList.get(i));

      //set the node's target to bottom
      node.setNoTarget();

      //add the node to the nodeRecycleList
      nodeRecycleList.add(0, node);

      //remove the data from hashmap
      nodeHashMap.remove(toBeRemovedDataList.get(i));
    }
  }

  //  println("## RemoveNode");
  //  println("nodeRecycleList: " + nodeRecycleList.size());
  //  println("nodeHashMap: " + nodeHashMap.size());
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

  //  println("## AddNode");
  //  println("nodeRecycleList: " + nodeRecycleList.size());
  //  println("nodeHashMap: " + nodeHashMap.size());
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
}

