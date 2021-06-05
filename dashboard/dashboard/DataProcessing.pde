float[] serialEvent (Serial myPort) {

  //String containing last received line of data
  String dataString = myPort.readStringUntil('\n');

  if (dataString) {
    dataString = trim(dataString);

    float[] newData = float(split(dataString, " "));
    return newData;

  }
}


/**
  Takes in a TableRow and returns an Array of its values.
**/
float[] readCSVRow(TableRow row){

  //initalize an array for all the newly read values
  float newData[] = new float[valueNames.length];

  //go through all columns of the new row and add them to the newData array
  for(int i=0; i<valueNames.length-1; i++){
    float readVar = row.getFloat(valueNames[i]);
    newData[i] = readVar;
  }

  return newData;
}


/**
  Adds a row of newly read values to the graphvalues table and moves all
  already existing rows one row forward. First row is consequently overwritten.
**/
void updateRowValues(float[] newData){

  // i = column/graph number; value = v
  for (int i=0; i < graphcount; i++){             //for each column ( & graph)
    if (!Float.isNaN(newData[i])) {
      for (int v=0; v<graphValues[i].length-1; v++) {      //for every value in the respective column
            //every value in the column gets pushed 1 index forward
            graphValues[i][v] = graphValues[i][v+1];
      }
      //the last value gets updated to the newly read input
      graphValues[i][graphValues[i].length-1] = newData[i];
    }
  }
}
