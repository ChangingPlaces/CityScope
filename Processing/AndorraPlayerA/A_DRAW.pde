boolean showData = false;
boolean showTopo = true;
boolean showPaths = false;
boolean showGrid = false;
boolean showPathInfo = true;
boolean showSource = true;
boolean showEdges = false;
boolean showSwarm = true;
boolean showInfo = false;
boolean showTraces = false;
boolean hotelprice = false;
boolean hotelstars = false;
int d = 0; 

// Makes darker colors more visible when projecting
int masterAlpha = 15;
float schemeScaler = 0.5;
int background = 0;
int textColor = 255;
int grayColor = int(abs(background - (255.0/2)*schemeScaler));

// temp variable that holds coordinate location for a point to render
PVector coord;

// temp variable that holds coordinate locations for a line to render
PVector[] line = new PVector[2];

color french = #2D34EA;
color spanish = #E5953F;
color other = #666666;
//colors for the travelocity data 
color best = #00ff00;
color good = #ffff00; 
color medium = #ffcc00;
color poor = #ff751a;
color bad = #ff0000;


void drawTableCanvas(PGraphics p) {
  
  p.beginDraw();
  
      // Instead of solid background draws a translucent overlay every frame.
      // Provides the effect of giving animated elements "tails"
      p.noStroke();
      p.fill(background, 75);
      p.rect(0,0,canvasWidth,canvasHeight);
      
      // Draw Margin Information
      if (load_non_essential_data) {
        drawMargin(p);
      }
      
      // Allows dragging of Table Area Info
      p.translate(scrollX, scrollY);
      
      // Offsets from margin in upper-left corner 
      // Points geolocated with MercatorMap class should be rendered within this section
      p.translate(marginWidthPix, marginWidthPix);
            
            // Draw raster image of topography
            if (showTopo) {
              drawTopo(p);
            }
            
            // Draw Sample Geographic data (debugging purposes)
            if (load_non_essential_data) {
            if (dataMode == 4) { 
                drawHotelStars(p);
                drawHotelSelector(p);
              }
            if (hotelprice == true) { 
                drawHotelPrice(p);
                drawHotelSelector(p);
              }
            }
            
      
      // Reverses margin offset
      p.translate(-marginWidthPix, -marginWidthPix);

      // Displays Heatmap
      if(showTraces) {
        traces.display();
      }
  
      // Displays ObstacleCourses
      if (showObstacles) {
        
        if (finderMode == 1) { 
          // Obstacles for gridded Pathfinder Network
          grid.display(p, textColor, 100);
        } else if (finderMode == 2) { 
          // Obstacles for custom Pathfinder Network
          boundaries.display(p, textColor, 100);
        }
        
        //topoBoundary.display(p, textColor, 100);
      }
      
      // Draws pathfinding nodes onto Canvas
      if (showGrid) {
        p.image(pFinderGrid, 0, 0);
      }
      
      // Draws shortest paths for OD nodes
      if (showPaths) {
        p.image(pFinderPaths, 0, 0);
      }
      
      // Show Markers for Sources and Sinks of Angents
      if (showSource) {
        p.image(sources_Viz, 0, 0);
      }
      
      // Show OD Network for Agents
      if (showEdges) {
        p.image(edges_Viz, 0, 0);
      }
      
      // Renders Agent 'dots' and corresponding obstacles and heatmaps
      drawSwarms(p);
     
      // Revereses dragging of Table Area Info
      p.translate(-scrollX, -scrollY); 
  
  p.endDraw();
}


void drawMargin(PGraphics p) {
  
  // sets colors and weight
  p.fill(background);
  p.noStroke();
  
  // Top
  p.rect(0, 0, canvasWidth, marginWidthPix); 
  // Bottom
  p.rect(0, marginWidthPix + topoHeightPix, canvasWidth, marginWidthPix); 
  // Left
  p.rect(0, marginWidthPix, marginWidthPix, canvasHeight); 
  // Right
  p.rect(marginWidthPix + topoWidthPix, marginWidthPix, marginWidthPix, canvasHeight); 
  
  int[][] lineMatrix = { {2, 3},
                         {4, 5},
                         {5, 6} };
  
  p.stroke(grayColor);
  p.strokeWeight(marginWidthPix/4);
  p.fill(grayColor);
  
  for (int i=0; i<lineMatrix.length; i++) {
    p.line(container_Locations[lineMatrix[i][0]].x, container_Locations[lineMatrix[i][0]].y, container_Locations[lineMatrix[i][1]].x, container_Locations[lineMatrix[i][1]].y);
  }
  
  
  p.strokeJoin(ROUND);
  p.noFill();
  
  // St. Julia
  p.beginShape();
  p.vertex(container_Locations[1].x, container_Locations[1].y);
  p.vertex(container_Locations[1].x, marginWidthPix + 0.5*topoHeightPix);
  p.vertex(marginWidthPix, marginWidthPix + 0.5*topoHeightPix);
  p.endShape();
  
  // La Massana
  p.beginShape();
  p.vertex(container_Locations[2].x, container_Locations[2].y);
  p.vertex(container_Locations[2].x, marginWidthPix + 0.75*topoHeightPix);
  p.vertex(1.0*marginWidthPix + topoWidthPix, marginWidthPix + 0.75*topoHeightPix);
  p.endShape();
  
  // Encamp
  p.beginShape();
  p.vertex(container_Locations[4].x, container_Locations[4].y);
  p.vertex(1.0*marginWidthPix + 0.96*topoWidthPix, container_Locations[4].y);
  p.vertex(1.0*marginWidthPix + 0.96*topoWidthPix, 1.0*marginWidthPix + topoHeightPix);
  p.endShape();
  
  p.endDraw();
  p.beginDraw();
  
  p.stroke(background, 255);
  p.strokeWeight(marginWidthPix/8);
  p.fill(grayColor);
  
  for (int i=1; i<container_Locations.length; i++) {
    p.ellipse(container_Locations[i].x, container_Locations[i].y, 0.5*marginWidthPix, 0.5*marginWidthPix);
  }
  
  p.textSize(24*(projectorWidth/1920.0));
  
  p.translate(container_Locations[1].x, container_Locations[1].y);
  p.rotate(PI/2);
  p.textAlign(CENTER);
  p.text(container_Names[1], 0, marginWidthPix/2);
  p.textAlign(LEFT);
  p.rotate(-PI/2);
  p.translate(-container_Locations[1].x, -container_Locations[1].y);
  
  for (int i=2; i<4; i++) {
    p.translate(container_Locations[i].x, container_Locations[i].y);
    p.rotate(-PI/2);
    p.textAlign(CENTER);
    p.text(container_Names[i], 0, marginWidthPix/2);
    p.textAlign(LEFT);
    p.rotate(PI/2);
    p.translate(-container_Locations[i].x, -container_Locations[i].y);
  }
  
  for (int i=4; i<7; i++) {
    p.translate(container_Locations[i].x, container_Locations[i].y);
    //p.rotate(-PI/2);
    p.textAlign(CENTER);
    p.text(container_Names[i], 0, marginWidthPix/2);
    p.textAlign(LEFT);
    //p.rotate(PI/2);
    p.translate(-container_Locations[i].x, -container_Locations[i].y);
  }
  
  p.textSize(36*(projectorWidth/1920.0));
  p.text(container_Names[0], marginWidthPix, p.height-7*marginWidthPix/12);
  
  p.textSize(24*(projectorWidth/1920.0));
  p.text("Tourists |", marginWidthPix, p.height-2*marginWidthPix/12);
  
  p.fill(#00FF00);
  p.text(dates[dateIndex] + ", " + "Hour: " + hourIndex%24 + ":00 - " + (hourIndex+1)%24 + ":00", 
                   5*marginWidthPix, p.height-7*marginWidthPix/12);
  
  p.fill(spanish);
  p.text("Spanish", 4.5*marginWidthPix, p.height-2*marginWidthPix/12);
  
  p.fill(french);
  p.text("French", 3.0*marginWidthPix, p.height-2*marginWidthPix/12);
  
  p.fill(other);
  p.text("Other", 6.0*marginWidthPix, p.height-2*marginWidthPix/12);
  
  p.endDraw();
  p.beginDraw();

}



void drawTopo(PGraphics p) {
 
  // Draws Satellite images
  p.tint(255, masterAlpha);
  //p.filter(GRAY);
  p.image(topo, 0, 0, topoWidthPix, topoHeightPix);
  p.tint(255, 255);
  
}

//draws the stagnant hotel data color coded by amount of stars 
void drawHotelStars(PGraphics p) { 
  p.noStroke();
  int j = 0; 
  for (int i=0; i<tripAdvisor.getRowCount (); i++) {
    // turns latitude and longitude of a point into canvas location within PGraphic topo
    coord = mercatorMap.getScreenLocation(new PVector(tripAdvisor.getFloat(i, "Lat"), tripAdvisor.getFloat(i, "Long")));
    j+=1;
    {
    if ((tripAdvisor.getFloat(i, "Stars") == 5)) {
      tableCanvas.fill(best);
    }
    if ((tripAdvisor.getFloat(i, "Stars") == 4)) {
      tableCanvas.fill(good);
    }
    if ((tripAdvisor.getFloat(i, "Stars") == 3)) {
      tableCanvas.fill(medium);
    }
    if ((tripAdvisor.getFloat(i, "Stars") == 2)) {
      tableCanvas.fill(poor);
    }
    if ((tripAdvisor.getFloat(i, "Stars") == 1)) {
      tableCanvas.fill(bad);
    }
    if ((tripAdvisor.getFloat(i, "Stars") == 5) && (tripAdvisor.getFloat(i, "Price") == 1)){
      tableCanvas.fill(#ffffff);
    }
    }
    // Draw a circle 7 pixels in diameter at geolocation
    p.ellipse(coord.x, coord.y, 7, 7);

  PVector geo;
  geo = mercatorMap.getGeo(new PVector( mouseX-marginWidthPix, mouseY-marginWidthPix));
  //println(geo.x + ", " + geo.y);
  coord = mercatorMap.getScreenLocation(geo);
  p.fill(#00FF00);
  p.noStroke();
  p.ellipse(coord.x, coord.y, 10, 10);
  }
  
}

//draws stagnant hotel data color coded by price 
void drawHotelPrice(PGraphics p) { 
  p.noStroke();
  p.fill(#ff0000, 150);
  for (int i=0; i<tripAdvisor.getRowCount (); i++) {
    // turns latitude and longitude of a point into canvas location within PGraphic topo
    coord = mercatorMap.getScreenLocation(new PVector(tripAdvisor.getFloat(i, "Lat"), tripAdvisor.getFloat(i, "Long")));
    {
    if ((tripAdvisor.getFloat(i, "Price") == 1)) {
      tableCanvas.fill(best);
    }
    if ((tripAdvisor.getFloat(i, "Price") == 2)) {
      tableCanvas.fill(good);
    }
    if ((tripAdvisor.getFloat(i, "Price") == 3)) {
      tableCanvas.fill(medium);
    }
    if ((tripAdvisor.getFloat(i, "Price") == 4)) {
      tableCanvas.fill(poor);
    }
    if ((tripAdvisor.getFloat(i, "Price") == 5)) {
      tableCanvas.fill(bad);
    }
     if ((tripAdvisor.getFloat(i, "Stars") == 5) && (tripAdvisor.getFloat(i, "Price") == 1)){
      tableCanvas.fill(#ffffff);
    }
    }
    // Draw a circle 7 pixels in diameter at geolocation
    p.ellipse(coord.x, coord.y, 7, 7);
    int j = i;    
  PVector geo;
  geo = mercatorMap.getGeo(new PVector( mouseX-marginWidthPix, mouseY-marginWidthPix));
  //println(geo.x + ", " + geo.y);
  coord = mercatorMap.getScreenLocation(geo);
  p.fill(#00FF00);
  p.noStroke();
  p.ellipse(coord.x, coord.y, 10, 10);
  }
  
}

//draws a selector circle to show what hotel you're on (displaying info below) and initiates j and d to go through hotels (still a little buggy) 
int j = 0; 

void drawHotelSelector(PGraphics p) { 
  p.noStroke();
  p.fill(#ffffff, 70);
  for (j = d; j<tripAdvisor.getRowCount (); j++) {
    // turns latitude and longitude of a point into canvas location within PGraphic topo
    coord = mercatorMap.getScreenLocation(new PVector(tripAdvisor.getFloat(d, "Lat"), tripAdvisor.getFloat(d, "Long")));
    }
// Draw a circle 30 pixels in diameter at geolocation 
    p.ellipse(coord.x, coord.y, 50, 50);
    fill(255);
  }
  

void drawData(PGraphics p) {
  
  // Currently renders 3 sets of sample data (Local Cell Towers, Wifi, and TripAdvisor)
  // CDR Data:
  // Sets fill color to blue
  p.noStroke();
  p.fill(#0000FF, 150);
  for (int i=0; i<localTowers.getRowCount(); i+=2) { // iterates through each row
      
    // turns latitude and longitude of a point into canvas location within PGraphic topo
    coord = mercatorMap.getScreenLocation(new PVector(localTowers.getFloat(i, "Lat"), localTowers.getFloat(i, "Lon")));
    
    // Draw a circle 30 pixels in diameter at geolocation
    p.ellipse(coord.x, coord.y, 30, 30);
    
  }
  // TripAdvisor Data:
  // Sets fill color to red
  p.noStroke();
  p.fill(#FF0000, 150);
  for (int i=0; i<tripAdvisor.getRowCount(); i++) {
    // turns latitude and longitude of a point into canvas location within PGraphic topo
    coord = mercatorMap.getScreenLocation(new PVector(tripAdvisor.getFloat(i, "Lat"), tripAdvisor.getFloat(i, "Long")));
    
    // Draw a circle 30 pixels in diameter at geolocation
    p.ellipse(coord.x, coord.y, 30, 30);
  }
  
  
  // WiFi Data:
  // Sets fill color to green
  p.noStroke();
  p.fill(#00FF00, 150);
  for (int i=0; i<frenchWifi.getRowCount(); i+=2) {
    // turns latitude and longitude of a point into canvas location within PGraphic topo
    coord = mercatorMap.getScreenLocation(new PVector(frenchWifi.getFloat(i, "Source_lat"), frenchWifi.getFloat(i, "Source_long")));
    
    // Draw a circle 30 pixels in diameter at geolocation
    p.ellipse(coord.x, coord.y, 30, 30);
  }
  
  
  // Boundary Data:
  if (debug) {
    // Draws a boarder around the site using latitude and longitude of corner locations
    // Should line up with edge of topo canvas
    
    p.fill(0, 0);
    p.strokeWeight(20);
    
    //Top (White)
    p.stroke(#FFFFFF); //White
    line[0] = mercatorMap.getScreenLocation(UpperLeft);
    line[1] = mercatorMap.getScreenLocation(UpperRight);
    p.line(line[0].x, line[0].y, line[1].x, line[1].y);
    //Right (Red)
    p.stroke(#FF0000); //Red
    line[0] = mercatorMap.getScreenLocation(UpperRight);
    line[1] = mercatorMap.getScreenLocation(LowerRight);
    p.line(line[0].x, line[0].y, line[1].x, line[1].y);
    //Bottom (Green)
    p.stroke(#00FF00); //Green
    line[0] = mercatorMap.getScreenLocation(LowerRight);
    line[1] = mercatorMap.getScreenLocation(LowerLeft);
    p.line(line[0].x, line[0].y, line[1].x, line[1].y);
    //Left (Blue)
    p.stroke(#0000FF); //Blue
    line[0] = mercatorMap.getScreenLocation(UpperLeft);
    line[1] = mercatorMap.getScreenLocation(LowerLeft);
    p.line(line[0].x, line[0].y, line[1].x, line[1].y);
  
    p.strokeWeight(1);
  }
  
  // Test that Mouse location is filtered through geo-locator correctly
  PVector geo;
  geo = mercatorMap.getGeo(new PVector( mouseX-marginWidthPix, mouseY-marginWidthPix));
  //println(geo.x + ", " + geo.y);
  coord = mercatorMap.getScreenLocation(geo);
  p.fill(#00FF00);
  p.noStroke();
  p.ellipse(coord.x, coord.y, 10, 10);
  
}




void drawLineGraph() {
  
  fill(#FFFFFF);
  translate(float(1)/(maxHour+6)*width, 1.45*canvasHeight);
  text("Hr", 0, textSize);
  
  int graphHeight = 2*marginWidthPix;

  textAlign(CENTER);
  for (int i=0; i<=maxHour; i+=3) {
    float hor = float(i+2)/(maxHour+6)*width;
    text(i%24, hor, textSize);
  }
  
  noStroke();
  fill(french, 200);
  beginShape();
  vertex(float(0+2)/(maxHour+6)*width, 0 - 2*textSize);
  for (int i=0; i<=maxHour; i++) {
    float hor = float(i+2)/(maxHour+6)*width;
    vertex(hor, -graphHeight*summary.getFloat(i, "TOTAL")/maxFlow - 2*textSize);
  }
  vertex(float(maxHour+2)/(maxHour+6)*width, 0 - 2*textSize);
  endShape();
  
  noStroke();
  fill(spanish, 200);
  beginShape();
  vertex(float(0+2)/(maxHour+6)*width, 0 - 2*textSize);
  for (int i=0; i<=maxHour; i++) {
    float hor = float(i+2)/(maxHour+6)*width;
    vertex(hor, -graphHeight*(summary.getFloat(i, "TOTAL")-summary.getFloat(i, "FRENCH"))/maxFlow - 2*textSize);
  }
  vertex(float(maxHour+2)/(maxHour+6)*width, 0 - 2*textSize);
  endShape();
  
  noStroke();
  fill(other, 200);
  beginShape();
  vertex(float(0+2)/(maxHour+6)*width, 0 - 2*textSize);
  for (int i=0; i<=maxHour; i++) {
    float hor = float(i+2)/(maxHour+6)*width;
    vertex(hor, -graphHeight*(summary.getFloat(i, "TOTAL")-summary.getFloat(i, "FRENCH")-summary.getFloat(i, "SPANISH"))/maxFlow - 2*textSize);
  }
  vertex(float(maxHour+2)/(maxHour+6)*width, 0 - 2*textSize);
  endShape();
  
  textAlign(LEFT);
  textSize(18*(projectorWidth/1920.0));
  
  float hor = float(hourIndex+2)/(maxHour+6)*width;
  stroke(#00FF00, 150);
  fill(#00FF00);
  strokeWeight(2);
  line(hor, -graphHeight - 4*textSize, hor, -1.75*textSize);
  text(hourIndex%24 + ":00 - " + (hourIndex%24+1) + ":00", 
                   hor + 0.5*textSize, -graphHeight - 3*textSize);
  text(date, 
                   hor + 0.5*textSize, -graphHeight - 3*textSize + 2.5*textSize);
  
//  fill(french);
//  text(int(100*summary.getFloat(hourIndex, "FRENCH") / summary.getFloat(hourIndex, "TOTAL")) + "%", 
//                   hor + 0.5*textSize, -graphHeight - 3*textSize);
//  fill(spanish);
//  text(int(100*summary.getFloat(hourIndex, "SPANISH") / summary.getFloat(hourIndex, "TOTAL")) + "%", 
//                   hor + 0.5*textSize, -graphHeight - 3*textSize + 2*textSize);
//  fill(other);
//  text(int(100*summary.getFloat(hourIndex, "OTHER") / summary.getFloat(hourIndex, "TOTAL")) + "%", 
//                   hor + 0.5*textSize, -graphHeight - 3*textSize + 4*textSize);
  
  
  noStroke();
  

  translate(float(0+2)/(maxHour+6)*width, -1.5*graphHeight);
  
  fill(#FFFFFF);
  textSize(24*(projectorWidth/1920.0));
  textAlign(LEFT);
  //gives info for the hotels
  if(hotelstars == true){ 
  text("Hotels by Star Rating (1-5)", 0, -65);
  fill(best);
  text("5", 1.0*marginWidthPix, -40);
  fill(good);
  text("4", 2.0*marginWidthPix, -40);
  fill(medium);
  text("3", 3.0*marginWidthPix, -40);
  fill(poor);
  text("2", 4.0*marginWidthPix, -40);
  fill(bad);
  text("1", 5.0*marginWidthPix, -40);
  fill(#ffffff);
  text("Current Selection: " + tripAdvisor.getString(d, "Hotel"), 6.0*marginWidthPix, -40);
  text(tripAdvisor.getFloat(d, "Stars") + " Stars", 13.5*marginWidthPix, -40);
  text(tripAdvisor.getFloat(d, "USD") + " USD", 15.5*marginWidthPix, -40);
  text(tripAdvisor.getInt(d, "Review") + " Reviews", 17.5*marginWidthPix, -40);
  }
  if(hotelprice == true){ 
  text("Hotels by Price (1-5), 5 being the most", 0, -65);
  fill(bad);
  text("5", 1.0*marginWidthPix, -40);
  fill(poor);
  text("4", 2.0*marginWidthPix, -40);
  fill(medium);
  text("3", 3.0*marginWidthPix, -40);
  fill(good);
  text("2", 4.0*marginWidthPix, -40);
  fill(best);
  text("1", 5.0*marginWidthPix, -40);
  fill(#ffffff);
  text("Current Selection: " + tripAdvisor.getString(d, "Hotel"), 7.0*marginWidthPix, -40);
  text(tripAdvisor.getFloat(d, "Stars") + " Stars", 13.5*marginWidthPix, -40);
  text(tripAdvisor.getFloat(d, "USD") + " USD", 15.5*marginWidthPix, -40);
  text(tripAdvisor.getInt(d, "Review") + " Reviews", 17.5*marginWidthPix, -40);
  }
  
  fill(#ffffff);
  text("Tourists |", 0, 0);
  
  fill(spanish);
  text("Spanish", 3.5*marginWidthPix, 0);
  
  fill(french);
  text("French", 2.0*marginWidthPix, 0);
  
  fill(other);
  text("Other", 5.0*marginWidthPix, 0);
}



void drawTestFinder(PGraphics p, Pathfinder f, ArrayList<PVector> path, ArrayList<PVector> visited) {
  
  // Draw Base Network
  f.display(p);
  
  // Draw Nodes Visited in order to find path solution
  p.strokeWeight(1);
  int base = 255;
  p.stroke(abs( background - base*schemeScaler));
  for (int i=0; i<visited.size(); i++) {
    p.ellipse(visited.get(i).x, visited.get(i).y, f.getResolution(), f.getResolution());
  }
  
  // Draws Edges that Connect Nodes Visited to Parent Nodes
  int neighbor;
  for (int i=0; i<f.allVisited.size(); i++) {
    for (int j=0; j<f.network.nodes.get(f.allVisited.get(i)).neighbors.size(); j++) {
      neighbor = f.network.nodes.get(f.allVisited.get(i)).neighbors.get(j);
      //println(neighbor);
      p.line(f.network.nodes.get(f.allVisited.get(i)).node.x, f.network.nodes.get(f.allVisited.get(i)).node.y, f.network.nodes.get(neighbor).node.x, f.network.nodes.get(neighbor).node.y);
    }
  }
  
  // Draw Path Edges
  p.strokeWeight(2);
  if (drawMode == 0) {
    p.stroke(#007D00);
  } else {
    p.stroke(#00FF00);
  }
  for (int i=0; i<path.size()-1; i++) {
    p.line(path.get(i).x, path.get(i).y, path.get(i+1).x, path.get(i+1).y);
  }
  
  p.endDraw();
  p.beginDraw();
  
  //Draw Origin
  p.strokeWeight(2);
  p.stroke(#FF0000);
  p.noFill();
  p.ellipse(A.x, A.y, f.getResolution(), f.getResolution());
  
  p.fill(textColor);
  p.text("origin", A.x + f.getResolution(), A.y);
  
  //Draw Destination
  p.strokeWeight(2);
  p.stroke(#0000FF);
  p.noFill();
  p.ellipse(B.x, B.y, f.getResolution(), f.getResolution());
  
//  p.fill(textColor);
//  p.text("destination", B.x +finderTest f.getResolution(), B.y);
  
  //Draw Path not Found Message
  if (path.size() < 2) {
    p.textAlign(CENTER);
    p.fill(textColor);
    p.text("Path not found. Try a new origin and destination", p.width/2, p.height/2);
    p.textAlign(LEFT);
  }
  
  if (showPathInfo) {
    
    p.pushMatrix();
    p.translate(0, 10);
    
    //Draw Background Rectangle
    p.fill(abs(textColor-25), 200);
    p.noStroke();
    p.rect(10, 4, 0.4*p.width, 10*20+10 , 12, 12, 12, 12);
    
    //Draw Directions
    p.fill(abs(textColor-225), 255);
    p.text("Explanation:", 20, 20);
    p.text("A network, origin, and destination has been randomly generated.", 20, 40);
    p.text("A green line represents the shortest path.", 20, 60);
    p.text("Nodes are highlighted when visited by the pathfinding algorithm.", 20, 80);
    
    p.text("Directions:", 20, 120);
    p.text("Press 'X' to generate a new origin-destination pair", 20, 140);
    p.text("Press 'n' to generate a new network", 20, 160);
    p.text("Press 'b' to invert colors", 20, 180);
    p.text("Press 'h' to hide these directions", 20, 200);
    
    p.popMatrix();
  }
  
  p.fill(textColor);
  p.text("Pathfinder v1.0", 20, p.height - 40);
  p.text("Ira Winder, MIT Media Lab 2015", 20, p.height - 20);
  
  p.endDraw();
  p.beginDraw();
}

void drawSwarms(PGraphics p) {
  
  numAgents = 0;
  
  for (Swarm s : swarms) {
    s.update();
    numAgents += s.swarm.size();
  }
  
  for (Swarm s : swarms) {
      
    if (showTraces) {
      traces.update(s);
      if (showSwarm) {
        s.display(p, "grayscale");
      }
    } else {
      if (showSwarm) {
        s.display(p, "color");
      }
    }
  }
  
  if (showTraces) {
    traces.decay();
  }
  
  for(int i=0; i<swarms.length; i++) {
    swarmSize[i] = swarms[i].swarm.size();
  }
  
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
  
  // Ensures that hourIndex doesn't null point
  if (hourIndex > summary.getRowCount()) {
     hourIndex = summary.getRowCount()-1;
  }
  
  p.fill(textColor);
  p.textSize(1.5*textSize);
  if (dataMode == 2 || dataMode == 3 || dataMode == 4 || dataMode ==5) {
    p.text("Total Agents Rendered: " + numAgents, marginWidthPix, 0.4*marginWidthPix);
    //p.text("Adjust: " + int(adjust), marginWidthPix, 0.7*marginWidthPix);
    //p.text("Total Agents in OD: " + summary.getInt(hourIndex, "TOTAL"), 7*marginWidthPix, 0.4*marginWidthPix);
  }
  
  textSize = 8;
  
  if (showInfo) {
    p.pushMatrix();
    p.translate(2*textSize, 2*textSize + scroll);
    
    // Background rectangle
    p.fill(#555555, 50);
    p.noStroke();
    p.rect(0, 0, 32*textSize, (swarms.length+4)*1.5*textSize, textSize, textSize, textSize, textSize);
    
    // Text
    p.translate(2*textSize, 2*textSize);
    for (int i=0; i<swarms.length; i++) {
      p.fill(swarms[i].fill);
      p.textSize(textSize);
      p.text("Swarm[" + i + "]: ", 0,0);
      p.text("Weight: " + int(1000.0/swarms[i].agentDelay) + "/sec", 10*textSize,0);
      p.text("Size: " + swarms[i].swarm.size() + " agents", 20*textSize,0);
      p.translate(0, 1.5*textSize);
    }
    p.translate(0, 1.5*textSize);
    p.text("Total Swarms: " + swarms.length,0,0);
    p.translate(0, 1.5*textSize);
    p.text("Total Agents: " + numAgents,0,0);
    p.popMatrix();
  }
  
  time_0 = millis();
}



void loading(PGraphics p, String item) {
  
  p.beginDraw();
  
  int w, h;
  boolean showName;
  
  // Draw Background Rectangle
  p.fill(abs(textColor-25), 200);
  p.stroke(textColor);
  p.strokeWeight(2);
  
  int x, y;
  
  if (numProjectors == 4 && drawMode == 1) {
    x = p.width/4;
    y = 3*p.height/4;
  } else {
    x = p.width/2;
    y = p.height/2;
  }
  
  if (!initialized) {
    p.background(0);
    w = 400;
    h = 50;
    showName = true;
    p.rect(x - w/2 , y - h/2 + 12/2 , w, h , 12, 12, 12, 12);
  } else {
    w = 400;
    h = 25;
    showName = false;
    p.rect(x - w/2 , y - h + 3*12/4 , w, h , 12, 12, 12, 12);
  }
  p.noStroke();
  
  // Text
  p.textAlign(CENTER);
  p.fill(abs(textColor-225), 255);
  p.textSize(12);
  p.text("Loading " + item + "...", x, y);
  if (showName) {
    p.text("Ira Winder, MIT Media Lab", x, y + 20);
  }
  
  p.endDraw();
}

void setScheme(int dMode) {
  // Adjusts Colors and Transparency depending on whether visualization is on screen or projected
  switch (dMode) {
    case 0: // On-Screen Rendering
      masterAlpha = 25;
      schemeScaler = 0.4;
      break;
    case 1: // Projection-Mapping Rendering
      masterAlpha = 100;
      schemeScaler = 1.0;
      break;
  }
  
  grayColor = int(abs(background - (255.0/2)*schemeScaler));
}

// Reinitialize any PGraphics that use masterAlpha and schemaScaler
void refreshGraphicScheme(PGraphics p) {
  pFinderGrid_Viz(p);
}

void adjustAlpha(int a) {
   masterAlpha += a;
      if (a > 0) {
     schemeScaler += 0.05;
   } else {
     schemeScaler -= 0.05;
   }
   
   if (masterAlpha < 0) {
     masterAlpha = 0;
   }
   if (masterAlpha > 255) {
     masterAlpha = 255;
   }
   if (schemeScaler < 0) {
     schemeScaler = 0;
   }
   if (schemeScaler > 1) {
     schemeScaler = 1;
   }
}