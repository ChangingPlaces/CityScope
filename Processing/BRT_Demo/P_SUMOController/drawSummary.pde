int columnCount;
int scenarioID = 2;
float offset;
float delta;
int column;
float x_;
float y_;

int smText;
int lgText;

boolean debug = false;

void setupSummary() {
  
  columnCount = summary.getColumnCount() - 1;
  //offset = 0.3*columnCount*(screenH/25);
  offset = 0.25/columnCount*height;
  
  baseChange = new int[columnCount];
  
  switch (demoMode) {
    case 1:
      smText = screenH/30;
      lgText = screenH/18;
      break;
    case 2:
      smText = screenH/25;
      lgText = screenH/14;
      break;
  }
    
}

void drawSummary() {
  
  // Refreshes (+/-) change flag on summary parameters
  // -1 is decresae from base; +1 is increase from base
  refreshChangeBools();
  
  fill(#FFFFFF);
  textSize(smText);
  textAlign(LEFT);
  
  if (debug) {
    
    for(int i=0; i<columnCount; i++) {
      
      if (i == 0) {
        fill(#FFF829);
      } else {
        fill(#FFFFFF);
      }
      
      if (i == 0 && invalid) {
        fill(#FF0000);
        text("INVALID", 0.01*width, float(i+1)/columnCount*height - offset);
        fill(#FFFFFF);
      } else {
        text(summary.getString(0, i+1), 0.01*width, float(i+1)/columnCount*height - offset);
      }
      
      text(summary.getString(scenarioID+1, i+1), 0.6*width, float(i+1)/columnCount*height - offset);
      if (i==0) {
        text("Change from Today", 0.75*width, float(i+1)/columnCount*height - offset);
      } else {
        
        delta = summary.getFloat(scenarioID+1, i+1) - summary.getFloat(0+1, i+1);
        
        fill(#333333);
        
        checkChange(i, 1);
        
        text(delta, 0.75*width, float(i+1)/columnCount*height - offset);
        fill(#FFFFFF);
      }
    }
    
    for(int i=0; i<summary.getRowCount(); i++) {
      //println(summary.getString(i, 0));
    }
  } else {
    
    // Sets Static Global Variables to a Demo of Choice
    switch (demoMode) {
      case 1:
        if (invalid == false) {
          drawStreetSummary();
        } else {
          image(streetScore_OFF, 0, 0, width, height);
        }
        break;
        
      case 2:
        if (invalid == false) {
          drawNeighborhoodSummary();
        } else {
          image(neighborhoodScore_OFF, 0, 0, width, height);
        }
        break;
    }
  }
}

void drawStreetSummary() {
  
  image(streetScore_template, 0, 0, width, height);
  
  textAlign(LEFT);
  fill(#FFFFFF);
  textSize(smText);
  
   x_ = 0.054;
   y_ = 0.475;
   
  if (scenarioID == 0) {
    text("Standard Bus Station", x_*width, y_*height);
  } else if (scenarioID == 1) {
    text("Upgraded Bus Station", x_*width, y_*height);
  } else if (scenarioID == 2) {
    text("Center-Median BRT Stop", x_*width, y_*height);
  } else if (scenarioID == 3) {
    text("Center-Median BRT Stop", x_*width, y_*height);
    text("with bike lane", x_*width, (y_+0.04)*height);
  }
    
  
  //Print Bus Time
  
      column = 3;
      x_ = -0.01;
      y_ = 0.01;
      
      // via Bus
      textAlign(RIGHT);
      fill(#FFFFFF);
      textSize(smText);
        //text("via Bus:", (0.79+x_)*width, (0.10+y_)*height);
      
      //Sets color to green or red
      checkChange(column-1, -1);
          
      // Change in Time
      textSize(smText);
      textAlign(RIGHT);
      if (baseChange[column-1] == -1) {
        text( "-" + ( abs(summary.getInt(scenarioID+1, column) - summary.getInt(0+1, column)) ) + " min", (0.74+x_)*width, (0.21+y_)*height);
      } else if (baseChange[column-1] == 1) {
        text( "+" + ( summary.getInt(scenarioID+1, column) - summary.getInt(0+1, column) ) + " min", (0.74+x_)*width, (0.21+y_)*height);
      }
      
      // Bus Time
      textAlign(RIGHT);
      textSize(lgText);
      fill(#FFFFFF);
        text(summary.getString(scenarioID+1, column), (0.79+x_)*width, (0.27+y_)*height);
      
      fill(#FFFFFF);
    
  //Print Driving Time
      column = 2;
      x_ = -0.01;
      y_ = 0.50;
      
//      // via Car
//      textAlign(RIGHT);
//      fill(#FFFFFF);
//      textSize(smText);
//        text("via Car:", (0.64+x_)*width, (0.22+y_)*height);
      
      //Sets color to green or red
      checkChange(column-1, -1);
          
      // Change in Time
      textSize(smText);
      textAlign(RIGHT);
      if (baseChange[column-1] == -1) {
        text( "-" + ( abs(summary.getInt(scenarioID+1, column) - summary.getInt(0+1, column)) ) + " min", (0.74+x_)*width, (0.21+y_)*height);
      } else if (baseChange[column-1] == 1) {
        text( "+" + ( summary.getInt(scenarioID+1, column) - summary.getInt(0+1, column) ) + " min", (0.74+x_)*width, (0.21+y_)*height);
      }
      
      // Car Time
      textAlign(RIGHT);
      textSize(lgText);
       fill(#FFFFFF);
        text(summary.getString(scenarioID+1, column), (0.79+x_)*width, (0.27+y_)*height);
      
      fill(#FFFFFF);
  
  //Print Bus Stop Waiting Time
      column = 4;
      x_ = -0.31;
      y_ = 0.13;
      
//      // via Bus
//      textAlign(RIGHT);
//      fill(#FFFFFF);
//      textSize(smText);
//        //text("via Bike:", (0.64+x_)*width, (0.22+y_)*height);
      
      //Sets color to green or red
      checkChange(column-1, -1);
          
      // Change in Wait Time
      textSize(smText);
      textAlign(RIGHT);
      if (baseChange[column-1] == -1) {
        text( "-" + ( abs(summary.getInt(scenarioID+1, column) - summary.getInt(0+1, column)) ) + " sec", (0.72+x_)*width, (0.21+y_)*height);
      } else if (baseChange[column-1] == 1) {
        text( "+" + ( summary.getInt(scenarioID+1, column) - summary.getInt(0+1, column) ) + " sec", (0.72+x_)*width, (0.21+y_)*height);
      }
      
      // Bus Wait Time
      textAlign(RIGHT);
      textSize(lgText);
      fill(#FFFFFF);
        text(summary.getString(scenarioID+1, column), (0.79+x_)*width, (0.27+y_)*height);
      
      fill(#FFFFFF);


  //Print Bike Trips
      column = 6;
      x_ = -0.50;
      y_ = 0.49;
      
//      // via Bus
//      textAlign(RIGHT);
//      fill(#FFFFFF);
//      textSize(smText);
//        text("via Bike:", (0.64+x_)*width, (0.22+y_)*height);
      
      //Sets color to green or red
      checkChange(column-1, 1);
          
      // Change in Bike Time
      textSize(smText);
      textAlign(RIGHT);
      if (baseChange[column-1] == -1) {
        text( "-" + ( abs(summary.getInt(scenarioID+1, column) - summary.getInt(0+1, column)) ) + " bikes", (0.82+x_)*width, (0.22+y_)*height);
      } else if (baseChange[column-1] == 1) {
        text( "+" + ( summary.getInt(scenarioID+1, column) - summary.getInt(0+1, column) ) + " bikes", (0.82+x_)*width, (0.22+y_)*height);
      }
      
      // Bike Time
      textAlign(LEFT);
      textSize(lgText);
      fill(#FFFFFF);
        text(summary.getString(scenarioID+1, column), (0.67+x_)*width, (0.27+y_)*height);
      
      fill(#FFFFFF);
      
  //Print Parking Spots
      column = 5;
      x_ = -0.64;
      y_ = -0.16;
      
//      // via Bus
//      textAlign(RIGHT);
//      fill(#FFFFFF);
//      textSize(smText);
//        //text("via Bike:", (0.64+x_)*width, (0.22+y_)*height);
      
      //Sets color to green or red
      checkChange(column-1, 1);
          
      // Change in Time
      textSize(smText);
      textAlign(RIGHT);
      if (baseChange[column-1] == -1) {
        text( "-" + ( abs(summary.getInt(scenarioID+1, column) - summary.getInt(0+1, column)) ) + " spaces", (0.77+x_)*width, (0.22+y_)*height);
      } else if (baseChange[column-1] == 1) {
        text( "+" + ( summary.getInt(scenarioID+1, column) - summary.getInt(0+1, column) ) + " spaces", (0.77+x_)*width, (0.22+y_)*height);
      }
      
      // Park Spots
      textAlign(RIGHT);
      textSize(lgText);
      fill(#FFFFFF);
        text(summary.getString(scenarioID+1, column), (0.78+x_)*width, (0.28+y_)*height);
      
      fill(#FFFFFF);
  
}

void drawNeighborhoodSummary() {
  
  image(neighborhoodScore_template, 0, 0, width, height);
  
  textAlign(CENTER);
  fill(0);
  textSize(smText);
  
  //translate(-0.3*width, 0);
  
  x_ = 0.0;
  y_ = 0.0;
  
  //Dedicated Lanes
  
      column = 6;
      x_ = 0.48;
      y_ = 0.63;
          
//      // Change in Lanes
//      textSize(smText);
//      textAlign(RIGHT);
//      if (baseChange[column-1] == -1) {
//        text( "-" + ( abs(summary.getFloat(scenarioID+1, column) - summary.getFloat(0+1, column)) ) + " mi", (0.22+x_)*width, (0.0+y_)*height);
//      } else if (baseChange[column-1] == 1) {
//        text( "+" + ( summary.getFloat(scenarioID+1, column) - summary.getFloat(0+1, column) ) + " mi", (0.22+x_)*width, (0.0+y_)*height);
//      }
      
      // # Lanes
      textAlign(RIGHT);
      textSize(lgText);
      //Sets color to green or red
      checkChange(column-1, 1);
        text(summary.getString(scenarioID+1, column), (0.04+x_)*width, (0.035+y_)*height);
      
  
  // Passengers 
      column = 7;
      x_ = 0.43+0.04;
      y_ = 0.885;
      
      //Sets color to green or red
      checkChange(column-1, 1);
          
      // Change in Lanes
//      textSize(smText);
//      fill(0);
//      textAlign(RIGHT);
//      if (baseChange[column-1] == -1) {
//        text( "-" + ( abs(summary.getFloat(scenarioID+1, column) - summary.getFloat(0+1, column)) ) + " ppl", (0.1+x_)*width, (0.0+y_)*height);
//      } else if (baseChange[column-1] == 1) {
//        text( "+" + ( summary.getFloat(scenarioID+1, column) - summary.getFloat(0+1, column) ) + " ppl", (0.1+x_)*width, (0.0+y_)*height);
//      }
      
      // # Lanes
      textAlign(RIGHT);
      textSize(lgText);
      checkChange(column-1, 1);
        text(summary.getInt(scenarioID+1, column)/1000 + "K", (0.00+x_)*width, (0.00+y_)*height);
      
      fill(0);
      
  // Cars Shifted
      column = 4;
      x_ = 0.20;
      y_ = 0.74;
      
      //Sets color to green or red
      checkChange(column-1, 1);
          
      // Change in Lanes
//      textSize(smText);
//      fill(0);
//      textAlign(RIGHT);
//      if (baseChange[column-1] == -1) {
//        text( "-" + ( abs(summary.getFloat(scenarioID+1, column) - summary.getFloat(0+1, column)) ) + " ppl", (0.1+x_)*width, (0.0+y_)*height);
//      } else if (baseChange[column-1] == 1) {
//        text( "+" + ( summary.getFloat(scenarioID+1, column) - summary.getFloat(0+1, column) ) + " ppl", (0.1+x_)*width, (0.0+y_)*height);
//      }
      
      // # Lanes
      textAlign(RIGHT);
      textSize(lgText);
      //checkChange(column-1, 1);
      fill(0);
        text(summary.getInt(scenarioID+1, column), (0.00+x_)*width, (0.00+y_)*height);
      
      fill(0);
  
  // Parking Spaces Removed
      column = 8;
      x_ = -0.18;
      y_ = .02;
      
//      // via Bus
//      textAlign(RIGHT);
//      fill(#FFFFFF);
//      textSize(smText);
//        //text("via Bike:", (0.64+x_)*width, (0.22+y_)*height);
      
//      //Sets color to green or red
//      checkChange(column-1, 1);
//          
//      // Change in Time
//      textSize(smText);
//      textAlign(RIGHT);
//      if (baseChange[column-1] == -1) {
//        text( "-" + ( abs(summary.getInt(scenarioID+1, column) - summary.getInt(0+1, column)) ) + " spaces", (0.77+x_)*width, (0.22+y_)*height);
//      } else if (baseChange[column-1] == 1) {
//        text( "+" + ( summary.getInt(scenarioID+1, column) - summary.getInt(0+1, column) ) + " spaces", (0.77+x_)*width, (0.22+y_)*height);
//      }
      
      // Park Spots
      textAlign(RIGHT);
      textSize(lgText);
      checkChange(column-1, -1);
        text(summary.getString(scenarioID+1, column), (0.78+x_)*width, (0.28+y_)*height);
      
      fill(0);
      
//  // Pollution (CO2)
//      column = 9;
//      x_ = -0.07;
//      y_ = .35;
//      
////      // via Bus
////      textAlign(RIGHT);
////      fill(#FFFFFF);
////      textSize(smText);
////        //text("via Bike:", (0.64+x_)*width, (0.22+y_)*height);
//      
//      //Sets color to green or red
//      checkChange(column-1, -1);
//          
//      // Change in Time
//      textSize(smText);
//      textAlign(RIGHT);
//      if (baseChange[column-1] == -1) {
//        text( "-" + ( abs(summary.getFloat(scenarioID+1, column) - summary.getFloat(0+1, column)) ) + " lbs", (0.7+x_)*width, (0.22+y_)*height);
//      } else if (baseChange[column-1] == 1) {
//        text( "+" + ( summary.getFloat(scenarioID+1, column) - summary.getFloat(0+1, column) ) + " lbs", (0.70+x_)*width, (0.22+y_)*height);
//      }
//      
//      // Park Spots
//      textAlign(RIGHT);
//      textSize(smText);
//      fill(0);
//        text(summary.getString(scenarioID+1, column), (0.61+x_)*width, (0.28+y_)*height);
//      
//      fill(0);
//      
//  // Pollution (Other)
//      column = 10;
//      x_ = -0.015;
//      y_ = 0.535;
//      
////      // via Bus
////      textAlign(RIGHT);
////      fill(#FFFFFF);
////      textSize(smText);
////        //text("via Bike:", (0.64+x_)*width, (0.22+y_)*height);
//      
//      //Sets color to green or red
//      checkChange(column-1, -1);
//          
//      // Change in Time
//      textSize(smText);
//      textAlign(RIGHT);
//      if (baseChange[column-1] == -1) {
//        text( "-" + ( abs(summary.getFloat(scenarioID+1, column) - summary.getFloat(0+1, column)) ) + " lbs", (0.63+x_)*width, (0.33+y_)*height);
//      } else if (baseChange[column-1] == 1) {
//        text( "+" + ( summary.getFloat(scenarioID+1, column) - summary.getFloat(0+1, column) ) + " lbs", (0.63+x_)*width, (0.33+y_)*height);
//      }
//      
//      // Park Spots
//      textAlign(RIGHT);
//      textSize(smText);
//      fill(0);
//        text(summary.getString(scenarioID+1, column), (0.55+x_)*width, (0.28+y_)*height);
//      
//      fill(0);
  
  // Average Speed (Bus)
      column = 3;
      x_ = .12;
      y_ = 0.03;
      
//      // via All Bus
//      textAlign(RIGHT);
//      fill(#FFFFFF);
//      textSize(smText);
//        //text("via Bike:", (0.64+x_)*width, (0.22+y_)*height);
      
      //Sets color to green or red
      checkChange(column-1, 1);
          
      // Change in Time
      textSize(smText);
      textAlign(RIGHT);
      
      if ( abs(summary.getFloat(scenarioID+1, column) - summary.getFloat(0+1, column)) > 0.1 ) {
        
        if (baseChange[column-1] == -1) {
          text( "-" + ( int(10*abs(summary.getFloat(scenarioID+1, column) - summary.getFloat(0+1, column)))/10.0 ), (0.65+x_)*width, (0.325+y_)*height);
        } else if (baseChange[column-1] == 1) {
          text( "+" + int( 10*( summary.getFloat(scenarioID+1, column) - summary.getFloat(0+1, column) ) )/10.0, (0.65+x_)*width, (0.325+y_)*height);
        }
        
      }
      
      // Park Spots
      textAlign(RIGHT);
      textSize(smText);
      fill(0);
        text(summary.getString(scenarioID+1, column), (0.67+x_)*width, (0.28+y_)*height);
      
      fill(0);
      
// Average Speed (BRT Bus)
      column = 12;
      x_ = .12;
      y_ = - 0.115;
      
//      // via Bus
//      textAlign(RIGHT);
//      fill(#FFFFFF);
//      textSize(smText);
//      //text("via Bike:", (0.64+x_)*width, (0.22+y_)*height);
      
      //Sets color to green or red
      checkChange(column-1, 1);
          
      // Change in Time
      textSize(smText);
      textAlign(RIGHT);
      
      if (IDArray[0] == -1 && IDArray[1] == -1 && IDArray[2] == -1 && IDArray[3] == -1) {

      } else {
                
        if ( abs(summary.getFloat(scenarioID+1, column) - summary.getFloat(0+1, column)) > 0.1 ) {
          
          if (baseChange[column-1] == -1) {
            text( "-" + ( int(10*abs(summary.getFloat(scenarioID+1, column) - summary.getFloat(0+1, column)))/10.0 ), (0.65+x_)*width, (0.325+y_)*height);
          } else if (baseChange[column-1] == 1) {
            text( "+" + int( 10*( summary.getFloat(scenarioID+1, column) - summary.getFloat(0+1, column) ) )/10.0, (0.65+x_)*width, (0.325+y_)*height);
          }
          
        }
        
        // Park Spots
        textAlign(RIGHT);
        textSize(smText);
        fill(0);
        text(summary.getString(scenarioID+1, column), (0.67+x_)*width, (0.28+y_)*height);
      }
      
      fill(0);
      
  // Average Speed (Car)
      column = 2;
      x_ = .12;
      y_ = 0.1625;
      
//      // via Bus
//      textAlign(RIGHT);
//      fill(#FFFFFF);
//      textSize(smText);
//      //text("via Bike:", (0.64+x_)*width, (0.22+y_)*height);
      
      //Sets color to green or red
      checkChange(column-1, 1);
          
      // Change in Time
      textSize(smText);
      textAlign(RIGHT);
      
      if ( abs(summary.getFloat(scenarioID+1, column) - summary.getFloat(0+1, column)) > 0.1 ) {
        
        if (baseChange[column-1] == -1) {
          text( "-" + ( int(10*abs(summary.getFloat(scenarioID+1, column) - summary.getFloat(0+1, column)))/10.0 ), (0.65+x_)*width, (0.325+y_)*height);
        } else if (baseChange[column-1] == 1) {
          text( "+" + int( 10*( summary.getFloat(scenarioID+1, column) - summary.getFloat(0+1, column) ) )/10.0, (0.65+x_)*width, (0.325+y_)*height);
        }
        
      }
      
      // Park Spots
      textAlign(RIGHT);
      textSize(smText);
      fill(0);
        text(summary.getString(scenarioID+1, column), (0.67+x_)*width, (0.28+y_)*height);
      
      fill(0);
  
  
  // Cost
      column = 11;
      x_ = .07;
      y_ = 0.565;
      
//      // via Bus
//      textAlign(RIGHT);
//      fill(#FFFFFF);
//      textSize(smText);
//        //text("via Bike:", (0.64+x_)*width, (0.22+y_)*height);
      
//      //Sets color to green or red
//      checkChange(column-1, 1);
//          
//      // Change in Time
//      textSize(smText);
//      textAlign(RIGHT);
//      if (baseChange[column-1] == -1) {
//        text( "-" + ( int(100*abs(summary.getFloat(scenarioID+1, column) - summary.getFloat(0+1, column)))/100.0 ) + " mph", (0.65+x_)*width, (0.33+y_)*height);
//      } else if (baseChange[column-1] == 1) {
//        text( "+" + int( 100*( summary.getFloat(scenarioID+1, column) - summary.getFloat(0+1, column) ) )/100.0 + " mph", (0.65+x_)*width, (0.33+y_)*height);
//      }
      
      // Park Spots
      textAlign(RIGHT);
      textSize(lgText);
      checkChange(column-1, -1);
        text(int(summary.getFloat(scenarioID+1, column)/1000000.0), (0.77+x_)*width, (0.25+y_)*height);
      
      fill(0);
      
      // Corridor State
      x_ = -0.02;
      y_ = 0.05;
      
      fill(#FFFFFF);
      textAlign(LEFT);
      textSize(smText/2);
      
      // A
      if (IDArray[0] > -1 && IDArray[1] == -1 && IDArray[2] == -1 && IDArray[3] == -1 ) {
        fill(#999999);
      } else {
        fill(#333333);
      }
      text("A: " + toggleNames[0], (0.05+x_)*width, (0.05+y_)*height);
      
      // B
      if (IDArray[1] > -1 && IDArray[0] == -1 && IDArray[2] == -1 && IDArray[3] == -1 ) {
        fill(#7dd5ed);
      } else {
        fill(#333333);
      }
      text("B: " + toggleNames[1], (0.05+x_)*width, (0.075+y_)*height);
      
      // C
      if (IDArray[2] > -1 && IDArray[1] == -1 && IDArray[0] == -1 && IDArray[3] == -1 ) {
        fill(#f3e05e);
      } else {
        fill(#333333);
      }
      text("C: " + toggleNames[2], (0.05+x_)*width, (0.10+y_)*height);
      
      // D
      if (IDArray[3] > -1 && IDArray[1] == -1 && IDArray[2] == -1 && IDArray[0] == -1 ) {
        fill(#e092df);
      } else {
        fill(#333333);
      }
      text("D: " + toggleNames[3], (0.05+x_)*width, (0.125+y_)*height);
      
      
      // BA
      if (IDArray[0] > -1 && IDArray[1] > -1 && IDArray[2] == -1 && IDArray[3] == -1 ) {
        fill(#7dd5ed);
      } else {
        fill(#333333);
      }
      text("BA: " + toggleNames[4], (0.05+x_)*width, (0.15+y_)*height);
      
      // BC
      if (IDArray[0] == -1 && IDArray[1] > -1 && IDArray[2] > -1 && IDArray[3] == -1 ) {
        fill(#7dd5ed);
      } else {
        fill(#333333);
      }
      text("BC: " + toggleNames[5], (0.05+x_)*width, (0.175+y_)*height);
      
      // BD
      if (IDArray[0] == -1 && IDArray[1] > -1 && IDArray[2] == -1 && IDArray[3] > -1 ) {
        fill(#7dd5ed);
      } else {
        fill(#333333);
      }
      text("BD: " + toggleNames[6], (0.05+x_)*width, (0.2+y_)*height);
      
}

void refreshChangeBools() {
  
  // Refreshes (+/-) change flag on summary parameters
  // -1 is decresae from base; +1 is increase from base
  for(int i=0; i<columnCount; i++) {
    baseChange[i] = 0;
    
    if ( summary.getFloat(scenarioID+1, i+1) > summary.getFloat(1, i+1) ) {
      baseChange[i] = 1;
    } else if ( summary.getFloat(scenarioID+1, i+1) < summary.getFloat(1, i+1) ) {
      baseChange[i] = -1;
    }
  }
  
}

void checkChange(int i, int flip) {
  switch (demoMode) {
    case 1:
    
      if (baseChange[i] == 1*flip) {
        //fill(#FFFFFF);
        fill(#00FF00);
      } else if (baseChange[i] == -1*flip) {
        //fill(#FFFFFF);
        fill(#FF0000);
      }
      break;
      
    case 2:
    
      if (baseChange[i] == 1*flip) {
        //fill(#FFFFFF);
        fill(#26A00B);
      } else if (baseChange[i] == -1*flip) {
        //fill(#FFFFFF);
        fill(#AF0003);
      }
      break;
  }     
}
