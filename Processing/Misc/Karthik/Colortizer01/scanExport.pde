/*
 * Incoming Port: 6669
 * Ougoing Port:  6152
 *
 * REPORT ALL CHANGES WITH DATE AND USER IN THIS AREA:
 * - Updated to include location array "locArray" that passes x, y, width, and height values for scanGrids
 * -
 * -
 * -
 */

boolean busyImporting = false;
boolean viaUDP = true;

// import UDP library
import hypermedia.net.*;
UDP udp;  // define the UDP object

void startUDP(){
  
  if (decode == false) {
    viaUDP = false;
  }
  
  if (viaUDP) {
    udp = new UDP( this, 6001 );
    //udp.log( true );     // <-- printout the connection activity
    udp.listen( true );
  }
  
}

void sendData() {
  
  if (viaUDP && updateReceived) {
    String dataToSend = "";
    
    for (int u=0; u<tagDecoder[0].U; u++) {
      for (int v=0; v<tagDecoder[0].V; v++) {
        
        // Object ID
        dataToSend += tagDecoder[0].id[u][v] ;
        dataToSend += "\t" ;
        
        // U Position
        dataToSend += tagDecoder[0].U-u-1;
        dataToSend += "\t" ;
        
        // V Position
        dataToSend += v;
        
        ////// BEGIN Added March 3, 2015 by Ira Winder ///////
        
        dataToSend += "\t" ;
        
        // Rotation
        dataToSend += tagDecoder[0].rotation[u][v];
        
        ////// END Added March 3, 2015 by Ira Winder ///////
        
        //if (u != tagDecoder[0].U-1 || v != tagDecoder[0].V-1) {
          dataToSend += "\n" ;
        //}
        
      }
    } 
    
    // UMax and VMax Values
    dataToSend += tagDecoder[0].U;
    dataToSend += "\t" ;
    dataToSend += tagDecoder[0].V;
    dataToSend += "\n" ;
    
    /*
    // Slider and Toggle Values
    for (int i=0; i<sliderDecoder.length; i++) {
      dataToSend += sliderDecoder[i].code;
      if (i != sliderDecoder.length-1) {
        dataToSend += "\t";
      } else {
        dataToSend += "\n";
      }
    }
    
    
    // Slider and Toggle Locations
    for (int i=0; i<numGridAreas[0]; i++) {
      dataToSend += gridLocations.getInt(0, 0 + i*4); 
      dataToSend += "\t" ;
      dataToSend += gridLocations.getInt(0, 1 + i*4);
      dataToSend += "\t" ;
      dataToSend += gridLocations.getInt(0, 2 + i*4); 
      dataToSend += "\t" ;
      dataToSend += gridLocations.getInt(0, 3 + i*4);
      dataToSend += "\n";
    }
    
    
    // Slider and Toggle Canvas Dimensions
    dataToSend += vizRatio; 
    dataToSend += "\t" ;
    dataToSend += vizWidth;
    dataToSend += "\n" ;
    */
    
    saveStrings("data.txt", split(dataToSend, "\n"));
    //udp.send( dataToSend, "18.85.55.241", 6666 );
    udp.send( dataToSend, "localhost", 6666 );
    
    //println("update received");
    
  } else {
    //println("no update received");
  }
}

void ImportData(String inputStr[]) {
  
  for (int i=0 ; i<inputStr.length;i++) {

    String tempS = inputStr[i];
    String[] split = split(tempS, "\t");
    
    // Sends commands to Rhino Server to run UMI functions
    if (split.length == 1) { 
      
      switch(int(split[0])) {
        case 1:
          if (writer != null) { writer.println("resimulate"); }
          break;
        case 2:
          if (writer != null) { writer.println("save"); }
          break;
        case 3:
          if (writer != null) { writer.println("displaymode energy"); }
          break;
        case 4:
          if (writer != null) { writer.println("displaymode walkability"); }
          break;
        case 5:
          if (writer != null) { writer.println("displaymode daylighting"); }
          break;
        case 6:
          if(useUMI) {
            initServer();
          }
          break;
      }
      println(split[0]);
    } 
  }
  
  busyImporting = false;
}

void receive( byte[] data, String ip, int port ) {  // <-- extended handler
  
  // get the "real" message =
  String message = new String( data ); 
  //println(message);
  saveStrings("data.txt", split(message, "\n"));
  String[] split = split(message, "\n");

  if (!busyImporting) {
    busyImporting = true;
    ImportData(split);
  }
}

