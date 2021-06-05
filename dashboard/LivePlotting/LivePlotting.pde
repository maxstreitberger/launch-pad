// import libraries
import java.awt.Frame;
import java.awt.BorderLayout;
import java.lang.Float;
import controlP5.*; // http://www.sojamo.de/libraries/controlP5/
import processing.serial.*;

Serial serialPort; String serialPortName = "/dev/ttyACM0"; // Serial port object and its name


float[] lineGraphSampleNumbers = new float[100]; // -> No clue what this is for


int graphcount = 12; //amount of plots to draw
int valuesPerGraph = 100; // amount of values to store and draw per graph
float[][] graphValues = new float[graphcount][valuesPerGraph]; //array containing the graph-respective values -> values[graph][value]
Graph[] graphs = new Graph[graphcount]; 


float graphHeight, graphWidth;
color graphColor;


//Graph TempGraph = new Graph(225, 50, 600, 200, color(20, 20, 200), 0); //plot
//Graph HeightGraph = new Graph(225, 350, 600, 200, color(20, 20, 200), 1);


void setup() {
  //size(890, 620);
  fullScreen(); 
  frame.setTitle("Realtime plotter");
  
  initializeGraphs();
  

 
  setChartSettings();
  
  serialPort = new Serial(this, serialPortName , 9600);
  serialPort.bufferUntil('\n');  //-> buffers until the given character and then calls serialEvent()
 
  for (int k=0; k<lineGraphSampleNumbers.length; k++) {
    lineGraphSampleNumbers[k] = k;
  } // same as above, no clue what it is for
}



void draw() {
  background(255); 
  /*graphs[0].DrawAxis();
  graphs[0].smoothLine(lineGraphSampleNumbers, graphValues[graphs[0].getIndex()]);
  graphs[1].DrawAxis();
  graphs[1].smoothLine(lineGraphSampleNumbers, graphValues[graphs[1].getIndex()]);*/
  drawGraphs();
}


void initializeGraphs(){

  
   //rect(xPos-t*1.6,yPos-t,Width+t*2.5,Height+t*2);    t=60
   
   // actual size of the graph (or its window at least);
  
  
  rectSettings();
  //for(int i=0; i<graphcount; i++){
  //  graphs[i] = new Graph(225, 50 + i * 300, graphWidth, graphHeight, color(20, 20, 200), i);
   
  //}
  
  for (int i=0; i<4; i++){
    float x = (width *i * 0.25) + (width*0.06);
    float y = (height*0.72)+60; //horizontal bottom
    graphs[i+4] = new Graph(x, y, graphWidth, graphHeight, graphColor, i+4);
    
    y = (height * 0) +60; //horizontal top
    graphs[i] = new Graph(x, y, graphWidth, graphHeight, graphColor, i); //
    
  }

  //vertical boxes
   
  for (int i=1; i<3; i++){
    
    float y = (height * 0.25 * i) + width*0.035;
    graphs[i+7] = new Graph(0 + width*0.06 , y, graphWidth, graphHeight, graphColor, i+7); //vertical left
    graphs[i+9] = new Graph((width * 0.75)+width*0.06, y, graphWidth, graphHeight,graphColor, i+9); //vertical right
  }
  
}


void drawGraphs(){
  for (int i=0; i<graphcount; i++){

    graphs[i].DrawAxis();
    graphs[i].smoothLine(lineGraphSampleNumbers, graphValues[graphs[i].getIndex()]);
  
  }

  

}


void rectSettings(){
  graphHeight = height * 0.10;
  graphWidth = width * 0.15;
  graphColor = color(0);
}

void setChartSettings() {
  graphs[0].setSettings("Chart 0 ", "", "", 20, 50, 0, 25, 10);
  graphs[1].setSettings("Chart 1 ", "", "", 20, 50, 0, 25, 10);
 
  graphs[2].setSettings("Chart 2 ", "", "", 20, 50, 0, 25, 10);
  graphs[3].setSettings("Chart 3 ", "", "", 20, 50, 0, 25, 10);
  graphs[4].setSettings("Chart 4", "", "", 20, 50, 0, 25, 10);
  graphs[5].setSettings("Chart 5", "", "", 20, 50, 0, 25, 10);
  graphs[6].setSettings("Chart 6", "", "", 20, 50, 0, 25, 10);
  graphs[7].setSettings("Chart 7", "", "", 20, 50, 0, 25, 10);
  graphs[8].setSettings("Chart 8 ", "", "", 20, 50, 0, 25, 10);
  graphs[9].setSettings("Chart 9 ", "", "", 20, 50, 0, 25, 10);
  graphs[10].setSettings("Chart 10 ", "", "", 20, 50, 0, 25, 10);
  graphs[11].setSettings("Chart 11 ", "", "", 20, 50, 0, 25, 10);
}
