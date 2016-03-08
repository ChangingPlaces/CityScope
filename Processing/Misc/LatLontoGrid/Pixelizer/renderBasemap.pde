PImage basemap;

void loadBasemap() {
  try {
    basemap = loadImage("data/" + fileName + "_" + int(gridSize*1000) + ".png");
  } catch(RuntimeException e) {
    println("No basemap available at this scale: " + gridSize + "km per pixel.");
  }
}

void renderBasemap() {
  try {
    image(basemap, 0, 0, width, height);
  } catch(RuntimeException e) {
    println("No basemap available at this scale: " + gridSize + "km per pixel.");
  }
}