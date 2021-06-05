
/*   =================================================================================
   The Graph class contains functions and variables that have been created to draw
   graphs. Here is a quick list of functions within the graph class:

     Graph(int x, int y, int w, int h,color k)
     DrawAxis()
     Bar([])
     smoothLine([][])
     DotGraph([][])
     LineGraph([][])

   =================================================================================*/


class Graph
{

  boolean Dot=false;            // Draw dots at each data point if true
  boolean RightAxis;            // Draw the next graph using the right axis if true
  boolean ErrorFlag=false; // If the time array isn't in ascending order, make true

  boolean ShowMouseLines=true;  // Draw lines and give values of the mouse position

  int     xDiv=5,yDiv=5;            // Number of sub divisions
  float     xPos,yPos;            // location of the top left corner of the graph
  float     Width,Height;         // Width and height of the graph

  int     GraphIndex;

  color   GraphColor;
  color   BackgroundColor=color(50);
  color   StrokeColor=color(180);

  String  Title="Title";          // Default titles
  String  xLabel="x - Label";
  String  yLabel="y - Label";

  float   yMax=1024, yMin=0;      // Default axis dimensions
  float   xMax=10, xMin=0;
  float   yMaxRight=1024,yMinRight=0;

  PFont   Font;                   // Selected font used for text

//    int Peakcounter=0,nPeakcounter=0;

  Graph(float x, float y, float w, float h,color k, int index) {  // The main declaration function
    xPos = x;
    yPos = y;
    Width = w;
    Height = h;
    GraphColor = k;
    GraphIndex = index;
  }


  int mainColor = 255;

  void DrawAxis(){

    /*  =========================================================================================
    Main axes Lines, Graph Labels, Graph Background
   ==========================================================================================  */
    fill(BackgroundColor);
    color(mainColor);stroke(StrokeColor);strokeWeight(1);
    float t=width*0.035;

    rect(xPos-t*1.6,yPos-t,Width+t*2.5,Height+t*2, 15);            // outline

    //Title dimensions
    textAlign(CENTER);textSize(15); fill(mainColor);
    text(Title,xPos+Width/2, yPos-10);

    //X-Axis label
    textAlign(CENTER);textSize(14);
    text(xLabel,xPos+Width/2,yPos+Height+t/1.5);

    //Y-Axis label
    rotate(-PI/2);
    text(yLabel,-yPos-Height/2,xPos-t*1.6+30);
    rotate(PI/2);


    //Edges
    textSize(10); stroke(mainColor); smooth();strokeWeight(1);

    line(xPos-3,yPos+Height,xPos-3,yPos);                        // y-axis line
    line(xPos-3,yPos+Height,xPos+Width+5,yPos+Height);           // x-axis line
    stroke(mainColor);

    //Zero line (if y-min is below 0)
    if(yMin<0){
                line(xPos-7,
                     yPos+Height-(abs(yMin)/(yMax-yMin))*Height,
                     xPos+Width,
                     yPos+Height-(abs(yMin)/(yMax-yMin))*Height
                     );
    }

    if(RightAxis){                                       // Right-axis line
        stroke(mainColor);
        line(xPos+Width+3,yPos+Height,xPos+Width+3,yPos);
    }

       /*  =========================================================================================
            Sub-devisions for both axes, left and right
           ==========================================================================================  */

    stroke(mainColor);

    /*  =========================================================================================
          x-axis
        ==========================================================================================  */
    for(int x=0; x<=xDiv; x++){

        line(float(x)/xDiv*Width+xPos-3,yPos+Height,       //  x-axis Sub devisions
             float(x)/xDiv*Width+xPos-3,yPos+Height+5);

        textSize(10);                                      // x-axis Labels
        String xAxis=str(xMin+float(x)/xDiv*(xMax-xMin));  // the only way to get a specific number of decimals
        String[] xAxisMS=split(xAxis,'.');                 // is to split the float into strings
        text(xAxisMS[0]+"."+xAxisMS[1].charAt(0),          // ...
             float(x)/xDiv*Width+xPos-3,yPos+Height+15);   // x-axis Labels
    }

   /*  =========================================================================================
         (left) y-axis
       ==========================================================================================  */
    for(int y=0; y<=yDiv; y++){
      line(xPos-3,float(y)/yDiv*Height+yPos,                // ...
            xPos-7,float(y)/yDiv*Height+yPos);              // y-axis lines

      textAlign(RIGHT);fill(mainColor);

      String yAxis=str(yMin+float(y)/yDiv*(yMax-yMin));     // Make y Label a string
      String[] yAxisMS=split(yAxis,'.');                    // Split string

      text(yAxisMS[0]+"."+yAxisMS[1].charAt(0),             // ...
           xPos-15,float(yDiv-y)/yDiv*Height+yPos+3);       // y-axis Labels


      /*  =========================================================================================
           right y-axis
          ==========================================================================================  */

      if(RightAxis){

        color(mainColor); stroke(mainColor);fill(mainColor);

        line(xPos+Width+3,float(y)/yDiv*Height+yPos,             // ...
             xPos+Width+7,float(y)/yDiv*Height+yPos);            // Right Y axis sub devisions

        textAlign(LEFT);

        String yAxisRight=str(yMinRight+float(y)/                // ...
                          yDiv*(yMaxRight-yMinRight));           // convert axis values into string
        String[] yAxisRightMS=split(yAxisRight,'.');             //

         text(yAxisRightMS[0]+"."+yAxisRightMS[1].charAt(0),     // Right Y axis text
              xPos+Width+15,float(yDiv-y)/yDiv*Height+yPos+3);   // it's x,y location

      }stroke(mainColor);
    }
  }





  /*  =========================================================================================
         smoothLine
      ==========================================================================================  */

  void smoothLine(float[] x ,float[] y) {

    float tempyMax=yMax, tempyMin=yMin;

    if(RightAxis){yMax=yMaxRight;yMin=yMinRight;}

    int counter=0;
    float xlocation=0,ylocation=0;

    //         if(!ErrorFlag |true ){    // sort out later!

      beginShape(); strokeWeight(1);stroke(57,255,20);noFill(); smooth();

        for (int i=0; i<x.length; i++){

       /* ===========================================================================
           Check for errors-> Make sure time array doesn't decrease (go back in time)
          ===========================================================================*/
          if(i<x.length-1){
            if(x[i]>x[i+1]){

              ErrorFlag=true;

            }
          }

     /* =================================================================================
         First and last bits can't be part of the curve, no points before first bit,
         none after last bit. So a streight line is drawn instead
        ================================================================================= */

          if(i==0 || i==x.length-2)line(xPos+(x[i]-x[0])/(x[x.length-1]-x[0])*Width,
                                        yPos+Height-(y[i]/(yMax-yMin)*Height)+(yMin)/(yMax-yMin)*Height,
                                        xPos+(x[i+1]-x[0])/(x[x.length-1]-x[0])*Width,
                                        yPos+Height-(y[i+1]/(yMax-yMin)*Height)+(yMin)/(yMax-yMin)*Height);

      /* =================================================================================
          For the rest of the array a curve (spline curve) can be created making the graph
          smooth.
         ================================================================================= */

          curveVertex( xPos+(x[i]-x[0])/(x[x.length-1]-x[0])*Width,
                       yPos+Height-(y[i]/(yMax-yMin)*Height)+(yMin)/(yMax-yMin)*Height);

       /* =================================================================================
          If the Dot option is true, Place a dot at each data point.
         ================================================================================= */

         if(Dot)ellipse(
                         xPos+(x[i]-x[0])/(x[x.length-1]-x[0])*Width,
                         yPos+Height-(y[i]/(yMax-yMin)*Height)+(yMin)/(yMax-yMin)*Height,
                         2,2
                         );

     /* =================================================================================
         Highlights points closest to Mouse X position
        =================================================================================*/

          if( abs(mouseX-(xPos+(x[i]-x[0])/(x[x.length-1]-x[0])*Width))<5 ){


              float yLinePosition = yPos+Height-(y[i]/(yMax-yMin)*Height)+(yMin)/(yMax-yMin)*Height;
              float xLinePosition = xPos+(x[i]-x[0])/(x[x.length-1]-x[0])*Width;
              strokeWeight(0.7);stroke(mainColor);
             // line(xPos,yLinePosition,xPos+Width,yLinePosition);
              strokeWeight(1);stroke(57,255,20);

              ellipse(xLinePosition,yLinePosition,4,4);
          }



        }

      endShape();
      yMax=tempyMax; yMin=tempyMin;
            float xAxisTitleWidth=textWidth(str(map(xlocation,xPos,xPos+Width,x[0],x[x.length-1])));


   if((mouseX>xPos&mouseX<(xPos+Width))&(mouseY>yPos&mouseY<(yPos+Height))){
    if(ShowMouseLines){
          // if(mouseX<xPos)xlocation=xPos;
        if(mouseX>xPos+Width)xlocation=xPos+Width;
        else xlocation=mouseX;
        stroke(200); strokeWeight(0.5);fill(255);color(50);
        // Rectangle and x position
        line(xlocation,yPos,xlocation,yPos+Height);
        rect(xlocation-xAxisTitleWidth/2-10,yPos+Height-16,xAxisTitleWidth+20,12);

        textAlign(CENTER); fill(160);
        text(map(xlocation,xPos,xPos+Width,x[0],x[x.length-1]),xlocation,yPos+Height-6);

       // if(mouseY<yPos)ylocation=yPos;
         if(mouseY>yPos+Height)ylocation=yPos+Height;
        else ylocation=mouseY;

       // Rectangle and y position
        stroke(200); strokeWeight(0.5);fill(255);color(50);

        line(xPos,ylocation,xPos+Width,ylocation);
         int yAxisTitleWidth=int(textWidth(str(map(ylocation,yPos,yPos+Height,y[0],y[y.length-1]))) );
        rect(xPos-15+3,ylocation-6, -60 ,12);

        textAlign(RIGHT); fill(GraphColor);//StrokeColor
      //    text(map(ylocation,yPos+Height,yPos,yMin,yMax),xPos+Width+3,yPos+Height+4);
        text(map(ylocation,yPos+Height,yPos,yMin,yMax),xPos -15,ylocation+4);
       if(RightAxis){

                       stroke(200); strokeWeight(0.5);fill(255);color(50);

                       rect(xPos+Width+15-3,ylocation-6, 60 ,12);
                        textAlign(LEFT); fill(160);
                       text(map(ylocation,yPos+Height,yPos,yMinRight,yMaxRight),xPos+Width+15,ylocation+4);
       }
        noStroke();noFill();
     }
   }


  }


  void smoothLine(float[] x ,float[] y, float[] z, float[] a ) {
       GraphColor=color(188,53,53);
        smoothLine(x ,y);
       GraphColor=color(193-100,216-100,16);
       smoothLine(z ,a);

   }

   /*  =========================================================================================
      Straight line graph
      ==========================================================================================  */

     void LineGraph(float[] x ,float[] y) {

        for (int i=0; i<(x.length-1); i++){
                   strokeWeight(2);stroke(GraphColor);noFill();smooth();
          line(xPos+(x[i]-x[0])/(x[x.length-1]-x[0])*Width,
                                           yPos+Height-(y[i]/(yMax-yMin)*Height)+(yMin)/(yMax-yMin)*Height,
                                           xPos+(x[i+1]-x[0])/(x[x.length-1]-x[0])*Width,
                                           yPos+Height-(y[i+1]/(yMax-yMin)*Height)+(yMin)/(yMax-yMin)*Height);
        }
     }


   void setSettings(String title, String xLabel, String yLabel, int xDiv, int xMax, int xMin, int yMax, int yMin){
      this.Title= title;
      this.xLabel=xLabel;
      this.yLabel=yLabel;
      this.xDiv=xDiv;
      this.xMax=xMax;
      this.xMin=xMin;
      this.yMax=yMax;
      this.yMin=yMin;
   }


   int getIndex(){
     return GraphIndex;
   }
   float getXPos(){
     return xPos;
   }
   float getYPos(){
     return yPos;
   }


}
