/* Legotizer By Ira Winder [jiw@mit.edu], CityScope Project, Changing Places Group, MIT Media Lab
 *
 * This code :
 *  (1) Draws a visualization of a digital, voxelized reconstruction of a physical Lego Model
 *  (2) Opens 1 or more Canvases to project a 3D plan onto a physical mode
 *  (3) Usually works in conjuntion with "Colortizer" and "CitySim" Algorithms that exist in the same Processing folder.
 * User should have knowledge of "CityScope" Color Scanning Technology, Colortizer, by Changing Places Group in MIT Media Lab
 * Script uses data recieved via UDP from a Lego color/pattern scanning algorithm such as "Colortizer" written by Ira Winder [jiw@mit.edu]
 *
 *
 * UPDATES (Since Riyadh Deployment):
 * 
 * v1.14: March 22, 2015 - Added realtime data buffer that detects whether changes have occurred.  Helps to reduce need for running computationally intensive simulations  
 * v1.15: March 23, 2015 - Added Nodes class for holding array of site-wide land use and activities.  Useful as input for simulation
 * v1.16: March 24, 2015 - Added Support for Flinders CityScope with additional set of pieces, and placeholders for Toronto and Kendall MarkI; 
 *                       - Added raster drawing/satellite images for Kendall and Flinders; Added options for toggling plexi grid gap and height in dynamic pieces
 * v1.17: March 26, 2015 - Added "Nodes" support for 1x1 structures (nodes can now be used in Flinders/CityScout demo!); 
 *                       - Specified path "../legotizer_data/" outside of Processing folder for files to import (buildings, structures, etc)
 *                       - Added function that saves current node status to JSON format in respective data folder
 * v1.18: March 28, 2015 - Added central "index.tsv" file in legotizer_data file to allow for easy referencing from multiple processing applications
 *                       - Added UI for loading screen, help screen, versioning, selecting lego_data folder
 *                       - Fixed Bug where projection mapping mode still showed 2D screen data
 *                       - Changed projector dimensions to read from a tsv file in the sketch folder
 * v1.19: March 28, 2015 - Restructured Tabs Quite a bit; fixed bug in plan renderings; placed keyCode methods into their own methods within relevant tab
 *                       - Added function for converting node heights between 3 a 1 Lego Units
 *                       - Fixed bug that caused Legotizer to sometimes crash when structureMode was changed
 * v1.20: March 29, 2015 - Fixed bug that exported nodes on non-overridden building sites
 *                       - Saves JSON file of nodes whenever a change is detected
 *                       - Changed JSON Node format to export distance and elevation in meters, as well as legotizer units
 *                       - Added "siteScale.tsv" file; allow export of Legotizer metadata to "metadata.json"
 *                       - Legotizer is finally ready to export enough information for a simulation?
 * v1.21: March 31, 2015 - Added handshake protocol between Legotizer and simulator so that JSON file updates don't overwhelm simulator
 *                       - Added functionality for Legotizer to display "solutionCloud" (i.e. Simulator outputs drawn from 'solutionNodes.json'
 *                       - Moved SDL data import functions to their own tab
 * v1.22: April 3, 2015  - Fixed bug that affected rendering of node-based heatmap
 *                       - Added dynNodeW to metadata for node width in meters
 *                       - Renames 'heatMapName' when data received from CitySim
 *                       - changing colorMode through 'o' key now aut0matically changes Node states
 * v1.23: April 5, 2015  - Added additional Metadata for Simulation Scripts
 *                       - Commented out redundant u_m, v_m, and z_m information exported to JSON, since this can be recreated in the simulation's client-side
 *                       - Runs simulation for 'simTime' iterations when change is detected instead of only once
 * v1.24: April 12, 2015 - Began Editing Plan visualization to show Nodes (still need to finish 4x4 Nodes)
 * v1.25: April 12, 2015 - Beta-Tested and tweaked so that feedback between colortizer, legotizer, and CitySim work
 *                       - Changed UDP to not print empty rows received to console
 *                       - Webcam detection now triggers simulation loop with CitySim
 *                       - Make Nodes Heatmaps differentiate parks with different shades of gray
 *                       - Fixed bug where live/work total values didn't update when nodeMode == 0
 * v1.25: April 13, 2015 - Fix occasional 'blip' when visualization is updated
 *                       - Finish 4x4 Nodes Plan Vizualization
 *                       - Added Status Update so that user knows the simulation is still updating
 * v1.26: April 13, 2015 - Reconsiled UMI and CitySim
 *                       - Converted all visualizations to nodes (non-nodes reserved for UMI)
 *                       - Rearranged 2D info
 *                       - simulation can export multiple layers and web output
 *                       - Added faux3D mode for 2D projection Map!!
 *                       - redefined layer modes defined by '0' key
 * v1.27: April 13, 2015 - Resized layer text
 *                       - fixed table row missing bug
 * v1.28: April 15, 2015 - Improved labels for information display
 * v1.29: August 6, 2015 -  (?) Patched Bug that crashes Legotizer when all pieces removed
 *                       - Allows automatic saving of projector location and control of projector height
 *                       - Added Barcelona Piece Types.
 *                       - Allows node-based rendering of triple-height Lego Units for 4x4 piece-types
 * v1.30: August 10, 2015- Allow 3 separate Heatmaps for Housing, Jobs, OpenSpace
 *                       - Display Assumptions, split working population from total residential population, highlight selected heatmap on score web
 * v1.31: August 27, 2015- Allow view of 3D model from 4 additional, orthogonal angles * v1.31: August 27, 2015- Allow view of 3D model from 4 additional, orthogonal angles
 * v1.32: Sep 6, 2015    - Added New Demomode for Hamburg (legotizer_library folders updated with basemaps!)
 * v1.33: Jan 16, 2016   - Update Hamburg visualization for 2 projectors, not 1.  Concatenate Multiple Tables
 * v1.34: Feb 1, 2016    - Added DemoMode for Tongzhou for iSoftStone & support or receiving multiple webcam inputs
 * 
 * TO DO: 
 * 0. Make Framerate a lot better
 * 0. Eliminate Library Dependencies (Keystone) to make export to executable possible
 * 0. Make Better UI, including continuous camera rotation, better lighting, etc
 * 0. Fix Table Row 1 error
 * 1. Uniquely color each Heatmap and/or change description to be more intuitive?
 */



float version = 1.34;

// For any given setup, please update these dimensions, in pixels
//
// Example TSV Format:
//
//  width   height
//  1280    800

String canvasPath = "canvas.tsv";
Table canvas;
// Initial dimensions of canvas when application is run, in pixels
int canvasWidth, canvasHeight;

// Set to true to automatically open in present mode
boolean sketchFullScreen() {
  return true;
}

// Visualization is usually customized to a particular demo configuration.
// Configurations are named accordingly, given 'index.txt' as of v1.18:
//
// 0 = Kendall Square Playground
// 1 = Riyadh
// 2 = Flinders
// 3 = Kendall Square Real-time Data Visualization
// 4 = Toronto

// Sets default visualization Mode
int vizMode = 0;
boolean vizChange = false;
boolean firstFrame = true;

// Runs once before any draw function is called
void setup() {
  initializeCanvas();
  size(canvasWidth, canvasHeight, P3D);         // Canvas Size
  frame.setResizable(true);
  
  selectFolder("Please select the 'legotizer_data' folder and click 'Open'", "folderSelected");
  
  // Loads Fonts
  loadFonts();                 
  
  //Displays Loading Text
  loading("Legotizer | Version " + version);
  
  /*
  * initiates connection to ddp client (01/12/16 YS)
  * DDP doesn't want to be in the first frame of draw :(
  */
  //ddp = new DDPClient(this,"localhost",3000);
  ddp= new DDPClient(this,DDPAddress,80);
  ddp.setProcessing_delay(100);
}

// Infinite draw loop
void draw() {
  
  // These are essentially Setup functions, but they are run in the first draw frame to allow for the folder selection option
  if (dataSelected && !dataLoaded) {
    
    initializePaths();           // defines filepaths for data from "index.txt"
    initializeProjection2D();    // Loads projector dimensions and horizontal location from "projector.tsv"
      
    initUDP();                   // Protocol for recieving data from "Colortizer" Script, run separately
    initCam();                   // Initializes Camera Parameters
    
    loadMode();                  // Checks which demo is default
    initializeNodes();           // Sets up cloud of nodes for visualization and simulation 
    initializeNodesJSON();       // Sets up JSON File structure
    initializeGrid();            // Sets up Static Framework for displaying Dynamic Pieces
    initializePieces();          // Loads Libraries of Piece Typologies
    
    initializePlan();            // Initializes PGraphic that holds plan Information
    initializePerspective();     // Initializes PGraphic that holds perspective Information
    initializeHeatMap();         // Initializes Array that holds heatmap values
    initializeScoreWeb();        // Initialized PGraphics for Score Web Vizualization
    
    dataLoaded = true;
    
    setMode();                  // Sets First Visualization to Default Demo
    
    loadSolutionJSON(solutionJSON, "testSolutionNodes.json", "scoreNames.tsv", vizMode);
    loadSummary();
    loadAssumptions();
    
    //Opens Projection-Mapping Canvas
    toggle2DProjection();
    
    // Ensures that plan and perspective is rendered even before any change detected
    renderPerspective();
    renderPlan();
  }
  
  //-------- Draw functions enabled -------------- //
  
  if (dataLoaded) {
    
    if (nextDataMode) {
      toggleColorMode();
      nextDataMode = false;
    }
    
    // Loads Last Colortizer Data submitted to the cloud
    if (pingCloud && millis() % 1000 <= 150 ) {
    //if (pingCloud) {
      pingCloud("/n", "104.131.179.31", 6666);
    }
    
    //-------- ReLoad Simulation .tsv's ------------ //
    
    // Loads Solution from SIM if recieved
    if (readSolution) {
      loadSolutionJSON(solutionJSON, "solutionNodes.json", "scoreNames.tsv", vizMode);
      loadSummary();
      loadAssumptions();
      readSolution = false;
    }
    
    // Sends Input to SIM if Sim is ready and Change has been detected
    checkSendNodesJSON("scan");
    
    // Reloads textfiles of SDL outputs  
    if (vizMode == 1 && !drawNodes) { //Riyadh Demo Mode
      
      loadSDLSummary();
      loadSDLData();
    }
    
    // Checks if there's been a request to change the visualization
    if (vizChange) {
      setMode();
      resetProjection2D();
      vizChange = false;
    }
    
    drawScreen();
    
  }
}

void initializeCanvas() {
  canvas = loadTable(canvasPath, "header");
  canvasWidth  = canvas.getInt(0, "width");   // Projector Width in Pixels
  canvasHeight = canvas.getInt(0, "height");  // Projector Height in Pixels
  println("Canvas Info: " + canvasWidth + ", " + canvasHeight);
}

boolean drawPerspective = true;
boolean renderPlan = true;
boolean renderPerspective = true;
boolean drawInfo = true;

void drawScreen() {
  
  // Visualization Graphics
  if (displayHelp) {
    drawHelp();
  } else { // Puts most typical draw functions here
    
    
    //---------- Begin rendering Graphics --------------//
    
    if (changeDetected || firstFrame) {
      
      // Renders Axes, Grids, Static Models and/or Dynamic Models (Very Heavy)
      if (renderPerspective) {
        renderPerspective();   
      }
      
      // Renders Plan to Projection Canvas (Very Heavy)
      if (renderPlan) {
        renderPlan();
      }
      
      if (firstFrame) {
        firstFrame = false;
      }
    }
    
      
    //---------- Draw PGraphics onto main Canvas ------------//
    
    // Sets Camera View to 2D, reset fill and alpha values
    cam2D();
    background(0);
    fill(#FFFFFF, 255);
    
    if (drawPerspective) {
      drawPerspective(0, 0, width, height);
    }
    
    // Draws small Plan in upper corner 
    if (drawPlan) {
      drawPlan(10, 10, int(0.3*height), int(0.3*height));
    }
    
    // Draws Web Representing Scores
    if (displayScoreWeb) {
      drawScoreWeb(int(0.8*width), int(height - 0.3*width), int(0.2*width), int(0.2*width));
    }
    
    // Draws information about current view
    if (drawInfo) {
      drawInfo();
    }
  }
}
