// import libraries
import java.awt.Frame;
import java.awt.BorderLayout;
import java.lang.Float;
import controlP5.*; // http://www.sojamo.de/libraries/controlP5/
import processing.serial.*;

//Data read live via Serial(true) or from CSV (false)
Boolean serialRead = true;

Serial serialPort; String serialPortName = "/dev/ttyACM0"; // Serial port object and its name

//CSV tables can be stored in this Table
Table table;
//Indicator of the number of the row that was looped through
int rowCount = 0;

String[] valueNames = {" GyroX", " GyroY", " GyroZ", " AccX", " AccY", " AccZ", " Pressure", " TempMS", " Height", " KalHeight"};

int graphcount = valueNames.length;

//Arrays containing the graphvalues and an exemplatory lineGraph to smooth out the graph
float[] lineGraphSampleNumbers;
float[][] graphValues;

int valuesPerGraph;

//Graphs
Graph heightGr, accX, accY, accZ, gyroX, gyroY, gyroZ, pressure;




void setup() {
  fullScreen();
  surface.setTitle("Live-Data Dashboard");

  if(serialRead){
    serialPort = new Serial(this, serialPortName , 9600);
    serialPort.bufferUntil('\n');  //-> buffers until the given character and then calls serialEvent()
    valuesPerGraph = 500;
  }
  else{
    table = loadTable("9-DATA.CSV", "header");
    valuesPerGraph = table.getRowCount();
  }

  graphValues = new float[graphcount][valuesPerGraph];
  lineGraphSampleNumbers = new float[valuesPerGraph];


  initializeGraphs();

  //Basic linear Graph, used to smooth out the graph lines
  for (int k=0; k<lineGraphSampleNumbers.length; k++) {
    lineGraphSampleNumbers[k] = k;
  }

}

void draw() {
  background(0);


  float[] newTableValues;
  String[] newValuePair;
  if(serialRead){
    newValuePair = serialEvent(serialPort)
    updateSerialRowValues(newValuePair)
  }
  else{
    if(rowCount < table.getRowCount()-1){
      rowCount++;
    }
    TableRow row = table.getRow(rowCount);
    newValues = readCSVRow(row);
    updateRowValues(newValues);
  }


  drawGraphs(255);
  delay(70);
}
void initializeGraphs() {
  float smallGraphW =  width * 0.10;
  float smallGraphH = height*0.09;
  heightGr = new Graph(width*0.07, height*0.07, width * 0.25, height *0.40, color(0), 0);
  heightGr.setSettings("Height", "Time(sec)", "Meters", 5, 0, -10, 200, 0);

  accX = new Graph(width*0.45, height*0.82, smallGraphW, smallGraphH, color(0), 0);
  accX.setSettings("Acc X", "Time(sec)", "Acc X", 5, 0, -10, 3, -3);

  accY = new Graph(width*0.65, height*0.82, smallGraphW, smallGraphH, color(0), 0);
  accY.setSettings("Acc Y", "Time(sec)", "", 5, 0, -10, 3, -3);

  accZ = new Graph(width*0.85, height*0.82, smallGraphW, smallGraphH, color(0), 0);
  accZ.setSettings("Acc Z", "Time(sec)", "", 5, 0, -10, 3, -3);

  gyroX = new Graph(width*0.45, height*0.60, smallGraphW, smallGraphH, color(0), 0);
  gyroX.setSettings("Gyro X", "Time(sec)", "", 7, 0, -10, 600, -600);

  gyroY = new Graph(width*0.65, height*0.60, smallGraphW, smallGraphH, color(0), 0);
  gyroY.setSettings("Gyro Y", "Time(sec)", "", 7, 0, -10, 600, -600);

  gyroZ = new Graph(width*0.85, height*0.60, smallGraphW, smallGraphH, color(0), 0);
  gyroZ.setSettings("Gyro Z", "Time(sec)", "", 7, 0, -10, 600, -600);

  pressure = new Graph(width*0.07, height*0.82, smallGraphW*2.8, smallGraphH, color(0), 0);
  pressure.setSettings("Time(sec)", "", "Pressure", 7, 0, -10, 1050, 950 );


}

void drawGraphs(float h){

  float smallGraphW =  width * 0.10;
  float smallGraphH = height*0.09;

  heightGr.DrawAxis();
  heightGr.smoothLine(lineGraphSampleNumbers, graphValues[8]);
  accX.DrawAxis();
  accX.smoothLine(lineGraphSampleNumbers, graphValues[3]);
  accY.DrawAxis();
  accY.smoothLine(lineGraphSampleNumbers, graphValues[4]);
  accZ.DrawAxis();
  accZ.smoothLine(lineGraphSampleNumbers, graphValues[5]);

  gyroX.DrawAxis();
  gyroX.smoothLine(lineGraphSampleNumbers, graphValues[0]);
  gyroY.DrawAxis();
  gyroY.smoothLine(lineGraphSampleNumbers, graphValues[1]);
  gyroZ.DrawAxis();
  gyroZ.smoothLine(lineGraphSampleNumbers, graphValues[2]);

  pressure.DrawAxis();
  pressure.smoothLine(lineGraphSampleNumbers, graphValues[6]);

  fill(50);
  color(255);stroke(255);strokeWeight(1);
  float t=width*0.035;

  float xPos = width*0.07-t*1.6;
  float yPos = height*0.60-t;
  float Width = smallGraphW+t*2.5;
  rect(xPos,yPos, smallGraphW+t*2.5, smallGraphH+t*2, 15);

  textAlign(CENTER);textSize(40); fill(255);
  text(int(h) + "m",xPos+Width/2, yPos*1.22);


}
