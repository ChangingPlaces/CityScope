
/////////// Image Operations and distortions
/////////// code orignally by Mohammad K Hadhrawi
/////////// new and modified code by Carson Smuts
/////////// modified some more by Ira Winder
/////////// 2014

PImage  imgEOps, imgWOps;
PGraphics printerImageE, printerImageW, printerImageG;
int Y_AXIS = 1;
int X_AXIS = 2;
PGraphics outputE, outputW;

color b1, b2;

int imageCapture_width, imageCapture_height, piece_height; //Global variables used in "Image_Proj"

void setupOps() {
  
  printerImageW = createGraphics(width, height, P2D);
  printerImageE = createGraphics(width, height, P2D);

  outputE = createGraphics(width, height, P2D);
  outputW = createGraphics(width, height, P2D);
  
  imageCapture_width = width;
  imageCapture_height = height;
}


void imageOps() {

  //dimension ratio of each half to be projected (may be different than projector resolution)
  //0.5 is half and half no overlap, greater than 0.5 creates overlap
  float piece_ratio = 1150.0/2000; 
  float blend_ratio = (piece_ratio-0.5)/piece_ratio; //Fraction of projection halves to blend
  
  piece_height = floor(width*piece_ratio);
  int offset = width-piece_height;
  int blendDist = floor(blend_ratio*(width*piece_ratio));



  //uses PImage as sketch image .... "PImage screenCapture;"

  // Printer Image West
  printerImageW.beginDraw();
  printerImageW.background(0);
  printerImageW.blendMode(REPLACE);
  printerImageW.translate(0, printerImageW.height);
  printerImageW.rotate(radians(270));
  printerImageW.image(screenCapture, offset, 0);

  printerImageW.blendMode(MULTIPLY);
  setGradient(printerImageW, 0, 0, height, blendDist, b2, b1, Y_AXIS);
  printerImageW.blendMode(REPLACE);

  printerImageW.endDraw();
  imgWOps = printerImageW.get();


  // Printer Image East
  printerImageE.beginDraw();
  printerImageE.background(0);
  printerImageE.blendMode(REPLACE);
  printerImageE.translate(printerImageE.width, 0);
  printerImageE.rotate(radians(90));
  printerImageE.image(screenCapture, -offset, 0);
  
  printerImageE.blendMode(MULTIPLY);
  setGradient(printerImageE, 0, 0, width, blendDist, b2, b1, X_AXIS);
  printerImageE.blendMode(REPLACE);
  
  printerImageE.endDraw();
  imgEOps = printerImageE.get();
}





void setGradient(PGraphics printerImage, int x, int y, float w, float h, color c1, color c2, int axis ) {

  // printerImage.beginDraw();

  if (axis == Y_AXIS) {

    for (int i = y; i <= h; i++) {

      printerImage.beginShape();
      printerImage.noStroke();
      printerImage.fill(0, 0, 0, 250-i);
      printerImage.vertex(width-i, 0);
      printerImage.vertex(width-(i+1), 0);
      printerImage.vertex(width-(i+1), height);
      printerImage.vertex(width-i, height);

      printerImage.endShape();
    }
  }
  else {

    for (int i = y; i <= h; i++) {

      printerImage.beginShape();
      printerImage.noStroke();
      printerImage.fill(0, 0, 0, 250-i);
      printerImage.vertex(i, 0);
      printerImage.vertex((i+1), 0);
      printerImage.vertex((i+1), width);
      printerImage.vertex(i, width);
      printerImage.endShape();
    }
  }
  
}

