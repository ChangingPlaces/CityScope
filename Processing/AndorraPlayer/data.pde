
boolean load_non_essential_data = true;

//Raster Graphics for basemaps of model

   // Base satelite image for model
   PImage topo;

// Objects for converting Latitude-Longitude to Canvas Coordinates
   
    // corner locations for topographic model (latitude and longitude)
    PVector UpperLeft = new PVector(42.505086, 1.509961);
    PVector UpperRight = new PVector(42.517066, 1.544024);
    PVector LowerRight = new PVector(42.508161, 1.549798);
    PVector LowerLeft = new PVector(42.496164, 1.515728);
    
    //Amount of degrees rectangular canvas is rotated from horizontal latitude axis
    float rotation = 25.5000; //degrees
    float lat1 = 42.517066; // Uppermost Latitude on canvas
    float lat2 = 42.496164; // Lowermost Latitude on canvas
    float lon1 = 1.509961; // Leftmost Longitude on canvas
    float lon2 = 1.549798; // Rightmost Longitude on canvas
     
    MercatorMap mercatorMap; // rectangular projection environment to convert latitude and longitude into pixel locations on the canvas

// Tables of CDR and other point-based data

  int dataMode = 2;
  // dataMode = 2 for Andorra CDR Network (circa Dec 2015)
  // dataMode = 1 for random network
  // dataMode = 0 for empty network and Pathfinder Test OD
  
  // Sample Geolocated Data
  Table tripAdvisor;
  Table frenchWifi;
  Table localTowers;
  Table restaurants;
  Table attractions;
  Table amenities; 
  Table wifi; 
  Table marc_rest;
  Table antenna; 
  Table yup;
  Table buildings;
  Table instagram;
  Table twitter;

  
  // OD Matrix Information
  Table network;
  Table OD;
  int dateIndex = 6; // Initial date index    
  String[] dates = { "20140602", 
                     "20140815",
                     "20141102",
                     "20141109",
                     "20141225",
                     "mtb",
                     "cirq",
                     "volta" };
  
  // for dataMode = 3:
  int hourIndex = 71;
  int maxHour = 23;
  int maxFlow = 0; // For a given date and hour, defines upper bound for flow between any two points based on data
  Table summary;
  String date = "no data";

// Names and locations of areas outside of table to be represented on margins
          
  // Names of 7 Hamlets in Andorra         
  String[] container_Names = {"Andorra La Vella",
                              "St. Julia",
                              "Massana",
                              "Ordino",
                              "Encamp",
                              "Canillo",
                              "El Pas de la Casa" };
  
  String[] correlating_dates = {"20140602", "20140815", "20141102", 
                                "20141109", "20141225", "20150823", 
                                "20150824", "20150825", "20150826",
                                "20150827", "20150828", 
                                "20150721", "20150722", "20150723", 
                                "20150724", "20150725","20150712"};    

  float offset = -.2; // Amount that Hamlets markers are offset from center of margin   
  PVector[] container_Locations = {new PVector(topoWidthPix+0.5*marginWidthPix, topoHeightPix+0.5*marginWidthPix), 
                                   new PVector((0.5-offset)*marginWidthPix, topoHeightPix + 0.5*marginWidthPix), 
                                   new PVector((1.5+offset)*marginWidthPix + topoWidthPix, 0.45*canvasHeight), 
                                   new PVector((1.5+offset)*marginWidthPix + topoWidthPix, 0.20*canvasHeight), 
                                   new PVector(0.80*canvasWidth, (1.5+offset)*marginWidthPix + topoHeightPix), 
                                   new PVector(0.65*canvasWidth, (1.5+offset)*marginWidthPix + topoHeightPix), 
                                   new PVector(0.50*canvasWidth, (1.5+offset)*marginWidthPix + topoHeightPix) };
  
void initData() {
  
  println("Loading Data ...");
  
  if (dataMode == 2) {
    load_non_essential_data = true;
    showTopo = true;
  } else {
    load_non_essential_data = false;
    showTopo = false;
  }
  println("Load Non-Essential Data = " + load_non_essential_data);
  
  // Creates projection environment to convert latitude and longitude into pixel locations on the canvas
  mercatorMap = new MercatorMap(topoWidthPix, topoHeightPix, lat1, lat2, lon1, lon2, rotation);
  
  //datasets 
  localTowers = loadTable("data/cell.csv", "header");
  frenchWifi = loadTable("data/network_edges_french.csv", "header");
  antenna = loadTable("data/antenna.csv", "header");
  buildings = loadTable("data/buildings.csv", "header");
  
  
  // loads baseimage for topographic model
  topo = loadImage("crop.png");
  
  if (load_non_essential_data) {
    
    network = loadTable("data/CDR_OD/" + dates[dateIndex] + "_network.tsv", "header");
    OD =      loadTable("data/CDR_OD/" + dates[dateIndex] + "_OD.tsv", "header");
    
    wifi = loadTable("data/wifi_user.csv");
    
    localTowers = loadTable("data/cell.csv", "header");
    amenities = loadTable("data/attractions.csv", "header");
    buildings = loadTable("data/buildings.csv", "header");

   Table courseBuild = new Table();
    courseBuild.addColumn("obstacle");
    courseBuild.addColumn("vertX");
    courseBuild.addColumn("vertY");
    
  Table BuildObs = new Table();
    BuildObs.addColumn("obstacle");
    BuildObs.addColumn("vertX");
    BuildObs.addColumn("vertY");

    for (int i=buildings.getRowCount() - 1; i >= 0; i--) {
     if (buildings.getFloat(i, "Lat") < lat2 || buildings.getFloat(i, "Lat") > lat1 ||
          buildings.getFloat(i, "Lon") < lon1 || buildings.getFloat(i, "Lon") > lon2) {
        buildings.removeRow(i);
      }
           TableRow newRow = courseBuild.addRow();
            newRow.setInt("obstacle", buildings.getInt(i, "shapeid"));
            newRow.setFloat("vertX", buildings.getFloat(i, "Lat"));
            newRow.setFloat("vertY", buildings.getFloat(i, "Lon"));
    }
   saveTable(courseBuild, "data/courseBuild.csv");  
    
    
    for(int i = 0; i<courseBuild.getRowCount(); i++){
    coord = mercatorMap.getScreenLocation(new PVector(courseBuild.getFloat(i, "vertX"), courseBuild.getFloat(i,"vertY")));
        TableRow newRow = BuildObs.addRow();
        newRow.setInt("obstacle", courseBuild.getInt(i, "obstacle"));
        newRow.setFloat("vertX", coord.x);
        newRow.setFloat("vertY", coord.y);
    }
    
    saveTable(BuildObs, "data/BuildObs.csv"); 

    for (int i=amenities.getRowCount() - 1; i >= 0; i--) {
     if (amenities.getFloat(i, "Lat") < lat2 || amenities.getFloat(i, "Lat") > lat1 ||
          amenities.getFloat(i, "Long") < lon1 || amenities.getFloat(i, "Long") > lon2) {
        amenities.removeRow(i);
      }
    }
    
    yup = loadTable("data/amens.csv", "header");
    for (int i=yup.getRowCount() - 1; i >= 0; i--) {
     if (yup.getFloat(i, "Lat") < lat2 || yup.getFloat(i, "Lat") > lat1 ||
          yup.getFloat(i, "Lon") < lon1 || yup.getFloat(i, "Lon") > lon2) {
        yup.removeRow(i);
      }
    }
    
  marc_rest = loadTable("data/restaurants.tsv", "header");
  for (int i=marc_rest.getRowCount() - 1; i >= 0; i--) {
     if (marc_rest.getFloat(i, "LAT") < lat2 || marc_rest.getFloat(i, "LAT") > lat1 ||
          marc_rest.getFloat(i, "LNG") < lon1 || marc_rest.getFloat(i, "LNG") > lon2) {
        marc_rest.removeRow(i);
      }
    }
    
  antenna = loadTable("data/antenna.csv", "header");
  for (int i=antenna.getRowCount() - 1; i >= 0; i--) {
     if (antenna.getFloat(i, "Latitude") < lat2 || antenna.getFloat(i, "Latitude") > lat1 ||
          antenna.getFloat(i, "Longitude") < lon1 || antenna.getFloat(i, "Longitude") > lon2) {
        antenna.removeRow(i);
      }
    }
  

   restaurants = loadTable("data/restaurants.csv", "header");
   for (int i=restaurants.getRowCount() - 1; i >= 0; i--) {
     if (restaurants.getFloat(i, "Lat") < lat2 || restaurants.getFloat(i, "Lat") > lat1 ||
          restaurants.getFloat(i, "Long") < lon1 || restaurants.getFloat(i, "Long") > lon2) {
        restaurants.removeRow(i);
      }
    }
    
   attractions = loadTable("data/attractions.csv", "header");
   for (int i=attractions.getRowCount() - 1; i >= 0; i--) {
     if (attractions.getFloat(i, "Lat") < lat2 || attractions.getFloat(i, "Lat") > lat1 ||
          attractions.getFloat(i, "Long") < lon1 || attractions.getFloat(i, "Long") > lon2) {
        attractions.removeRow(i);
      }
    }
    
    tripAdvisor = loadTable("data/Tripadvisor_andorra_la_vella.csv", "header");
    for (int i=tripAdvisor.getRowCount()-1; i >= 0; i--) {
      if (tripAdvisor.getFloat(i, "Lat") < lat2 || tripAdvisor.getFloat(i, "Lat") > lat1 ||
          tripAdvisor.getFloat(i, "Long") < lon1 || tripAdvisor.getFloat(i, "Long") > lon2) {
        tripAdvisor.removeRow(i);
      }
    }
    
   String[] list;
   ArrayList<String> correlates;
   int[] correlating_indices;
   
   Table cleaninsta = new Table(); 
   cleaninsta.addColumn("Date");
   cleaninsta.addColumn("Hour");
   cleaninsta.addColumn("Lat");
   cleaninsta.addColumn("Lon");
   cleaninsta.addColumn("Language");
        
   instagram = loadTable("data/instagram.csv", "header");
         for(int i = 0; i<instagram.getRowCount(); i++){
                String timestamp = instagram.getString(i, "andorra_time");
                list = split(timestamp, '-');
                
                String date = list[0] + list[1] + list[2].charAt(0) + list[2].charAt(1); 
                
                for(int j = 0; j<correlating_dates.length; j++){
                  if(date.equals(correlating_dates[j])){
                     TableRow newRow = cleaninsta.addRow();
                        newRow.setString("Date", list[0] + list[1] + list[2].charAt(0) + list[2].charAt(1));
                        newRow.setFloat("Lat", instagram.getFloat(i, "location.latitude"));
                        newRow.setFloat("Lon", instagram.getFloat(i, "location.longitude"));
                        newRow.setString("Language", instagram.getString(i, "lang"));
                        newRow.setString("Hour",  str(list[2].charAt(3)) + str(list[2].charAt(4)));
              
                  }
                    
                }
               
                    }
    saveTable(cleaninsta, "data/cleaninsta.csv");            
    twitter = loadTable("data/twitter.csv", "header");

   } 

   else { // Initializes empty objects to prevent null pointer error
    network = new Table();
    OD = new Table();
    wifi = new Table();
    tripAdvisor = new Table();
    restaurants = new Table();
    attractions = new Table();
    amenities = new Table();
    marc_rest = new Table();
    antenna = new Table();
    instagram = new Table();
    twitter = new Table();
  }
  
  println("Data loaded.");
}
  
