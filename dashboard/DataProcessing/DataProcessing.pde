void serialEvent (Serial myPort) {
  
  //String containing last received line of data
  String dataString = myPort.readStringUntil('\n');

  if (dataString != null) {
    
    dataString = trim(dataString);
    float[] dataList = float(split(dataString, " "));
    
    println(dataString);
    
    // i = Graph Number; value = v
    for (int i=0; i < graphcount; i++){             //for each graph
      
      if (!Float.isNaN(dataList[i])) {
        
        for (int v=0; v<graphValues[i].length-1; v++) {      //for every value in the graphs' values subarray
            
            //every value in the list values[] (which contains the graph values) gets pushed 1 index forward
            graphValues[i][v] = graphValues[i][v+1];
            
        }
        //the last value gets updated to the newly read input
        graphValues[i][graphValues[i].length-1] = dataList[i];
        
     } 
       
    }
    
    
    
  }
}

String[] rowNames = {" GyroX", " GyroY", " GyroZ", " AccX", " AccY", " AccZ", " Pressure", " TempMS", " Height", " KalHeight"};


void readData(){

   for(String name : rowNames){
     row.getFloat(name));
   
   }

}
