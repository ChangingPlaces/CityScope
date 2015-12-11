int background = 0;
int textColor = 255;
int grayColor = int(255.0/2);

void drawAgents() {
  tableCanvas.beginDraw();
  
  tableCanvas.translate(scrollX, scrollY);
  
  if(showTraces) {
    traces.display();
  }
  
  if (showObstacles) {
    for (Obstacle o : testWall) {
      o.display(#0000FF, 100, false);
    }
    boundaries.display(#00FF00, 100);
  }
  
  numAgents = 0;
  
  for (Swarm s : swarms) {
    s.update();
    numAgents += s.swarm.size();
  }
  

  
  numAgents = 0;
  
  for (Swarm s : swarms) {
    s.update();
    numAgents += s.swarm.size();
  }
  
  for (Swarm s : swarms) {
    if (showSource) {
      s.displaySource();
    }
    
    if (showEdges) {
      s.displayEdges();
    }
      
    if (showTraces) {
      traces.update(s);
      s.display("grayscale");
    } else {
      s.display("color");
    }
    
    
  }
  
  traces.decay();
  
  for(int i=0; i<swarms.length; i++) {
    swarmSize[i] = swarms[i].swarm.size();
  }
  
//  if (frameRate < 45) {
//    maxAgents --;
//  } else if (frameRate > 50) {
//    maxAgents ++;
//  }
  
  if (numAgents > maxAgents) {
    int rand;
    int counter;
    while(numAgents > maxAgents) {
      
      // Picks a random agent from one of the swarms.  Larger swarms are more likely to be selected
      rand = int(random(0, numAgents));
      counter = 0;
      for (int i=0; i<swarms.length; i++) {
        counter += swarmSize[i];
        if (rand < counter) {
          rand = i;
          //println("random: " + rand);
          break;
        }
      }
      
      //kills a random agent in the selected swarm
      if (swarms[rand].swarm.size() > 0) {
        swarms[rand].swarm.get(int(random(swarms[rand].swarm.size()))).finished = true;
        numAgents--;
        //text("TWEAK", 20,20);
        
      }
    }
    adjust /= 0.9;
  } else {
    adjust *= 0.99;
  }
  //println("Adjust: " + adjust);
  
  tableCanvas.fill(textColor);
  //tableCanvas.text("Total Agents: " + numAgents,20,50);
  
  tableCanvas.fill(textColor);
  tableCanvas.textSize(24*(projectorWidth/1920.0));
  tableCanvas.text("Tourists:", marginWidthPix, tableCanvas.height-7*marginWidthPix/12);
  tableCanvas.text(dates[dateIndex] + ", " + "Hour: " + hourIndex + ":00 - " + (hourIndex+1) + ":00", 7*marginWidthPix, tableCanvas.height-7*marginWidthPix/12);
  
  tableCanvas.fill(#7883F7);
  tableCanvas.text("Spanish", 2.5*marginWidthPix, tableCanvas.height-7*marginWidthPix/12);
  
  tableCanvas.fill(#ADAF67);
  tableCanvas.text("French", 2.5*marginWidthPix, tableCanvas.height-2*marginWidthPix/12);
  
  textSize = 8;
  
  if (showInfo) {
    tableCanvas.pushMatrix();
    tableCanvas.translate(2*textSize, 2*textSize + scroll);
    
    // Background rectangle
    tableCanvas.fill(#555555, 50);
    tableCanvas.noStroke();
    tableCanvas.rect(0, 0, 32*textSize, (swarms.length+4)*1.5*textSize, textSize, textSize, textSize, textSize);
    
    // Text
    tableCanvas.translate(2*textSize, 2*textSize);
    for (int i=0; i<swarms.length; i++) {
      tableCanvas.fill(swarms[i].fill);
      tableCanvas.textSize(textSize);
      tableCanvas.text("Swarm[" + i + "]: ", 0,0);
      tableCanvas.text("Weight: " + int(1000.0/swarms[i].agentDelay) + "/sec", 10*textSize,0);
      tableCanvas.text("Size: " + swarms[i].swarm.size() + " agents", 20*textSize,0);
      tableCanvas.translate(0, 1.5*textSize);
    }
    tableCanvas.translate(0, 1.5*textSize);
    tableCanvas.text("Total Swarms: " + swarms.length,0,0);
    tableCanvas.translate(0, 1.5*textSize);
    tableCanvas.text("Total Agents: " + numAgents,0,0);
    tableCanvas.popMatrix();
  }
  
  tableCanvas.endDraw();
  
  time_0 = millis();
}
  
