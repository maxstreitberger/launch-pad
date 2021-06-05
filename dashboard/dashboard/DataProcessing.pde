String[] serialEvent (Serial myPort) {

  //String containing last received line of data
  String dataString = myPort.readStringUntil('\n');
  if (dataString != null) {
    dataString = trim(dataString);
    String[] valuePair = String(split(dataString, " "));
    return valuePair;

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


void updateSerialRowValues(String[] newData){

  int nValue;
  switch(newData[0]){
    case 'gyro_x':
      nValue = 0;
      break;
    case 'gyro_y':
      nValue = 1;
      break;
    case 'gyro_z':
      nValue = 2;
      break;
    case 'acc_x':
      nValue = 3;
      break;
    case 'acc_y':
      nValue = 4;
      break;
    case 'acc_z':
      nValue = 5;
      break;
    case 'pressure':
      nValue = 6;
      break;
    case 'temperature':
      nValue = 7;
      break;
    case 'height':
      nValue = 8;
      break;
    default 'ERROR':
      break;
  }

  for (int v=0; v<graphValues[nValue].length-1; v++) {      //for every value in the respective column
        //every value in the column gets pushed 1 index forward
        graphValues[nValue][v] = graphValues[nValue][v+1];
  }
  //the last value gets updated to the newly read input
  graphValues[nValue][graphValues[nValue].length-1] = float(newData[1]);

}
