/**
 * An application with a basic interactive map. You can zoom and pan the map.
 */

PImage get;
PGraphics g, crop;

float counter;

float C = 2*PI*6372798.2; // Circumference of Earth

float scale; // distance represented by one pixel

int modelW_Pix;
int modelH_Pix;

public void setupU_Crop() {
  g = createGraphics(width, height);
  
  setScale();
}

public void setupM_Crop() {
  crop = createGraphics(width, height);
}

public void setScale() {
  zoom = bm.currentMap.getZoomLevel();
  
  // Scale Equation:
  // http://wiki.openstreetmap.org/wiki/Zoom_levels
  scale = C*cos( (lat/360.0)*(2*PI) )/ pow(2, zoom+8);
  println("scale: " + scale);
  
  modelW_Pix = int(modelWidth/scale);
  modelH_Pix = int(modelHeight/scale);
  
  crop = createGraphics(modelW_Pix, modelH_Pix);
}

public void U_Crop() {
  
  //background(0);
  
  g.beginDraw();
  g.background(0);
  g.translate(width/2, height/2);
  g.rotate(modelRotation);
  g.translate(-width/2, -height/2);
  g.image(get(), 0, 0);
  g.endDraw();
  
  crop.beginDraw();
  crop.background(0);
  crop.translate(-(g.width-crop.width)/2, -(g.height-crop.height)/2);
  crop.image(g,0,0);
  crop.translate((g.width-crop.width)/2, (g.height-crop.height)/2);
  crop.endDraw();
  
  image(crop,0,0);
}

public void M_Crop() {
  
  crop.beginDraw();
  crop.background(0);
  crop.image(get(), 0, 0);
  crop.endDraw();
  
  image(crop,0,0);
}
