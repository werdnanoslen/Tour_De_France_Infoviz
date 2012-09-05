import controlP5.*;

color bg = #f4f4f4;
color black = #332626;
color grey = #cccccc;
color yellow = #fabb00;
color darkYellow = #E88F0C;
color red = #ff0000;

int axesOffsetX;
int axesOffsetY;
int axesHeight;
int axesWidth;

int numCases;

int[] years;
float[] yearsMapped;
float[] distance;
float[] distanceMapped;
float[] speed;
float[] speedMapped;

ControlP5 controlP5;
Toggle toggle;
boolean distanceToggle;
boolean speedToggle;

void setup()
{
  size(900, 600);
  background(bg);
  
  axesOffsetX = 100;
  axesOffsetY = 150;
  axesHeight = 400;
  axesWidth = width-2*axesOffsetX;
  
  String[] data = loadStrings("Tour_De_France_Data.csv");
  numCases = data.length-1; //doesn't count header row
  years = new int[data.length-1];
  yearsMapped = new float[data.length-1];
  distance = new float[data.length-1];
  distanceMapped = new float[data.length-1];
  distanceToggle = true;
  speed = new float[data.length-1];
  speedMapped = new float[data.length-1];
  speedToggle = true;
  for (int i=0; i<numCases; ++i)
  {
    String currentRow = data[i+1]; //+1 to skip title row
    String[] columns = split(currentRow, ",");
    years[i] = int(columns[0]);
    distance[i] = float(columns[16]);
    speed[i] = float(columns[17]);
  }
  for (int i=0; i<numCases; ++i)
  {
    yearsMapped[i] = map
    (
      i, 
      0, 
      years.length, 
      axesOffsetX+20, 
      axesOffsetX+axesWidth
    );
    
    distanceMapped[i] = map
    (
      distance[i], 
      2000, 
      6000, 
      axesOffsetY+axesHeight, 
      axesOffsetY
    );
    
    speedMapped[i] = map
    (
      speed[i],
      20,
      50,
      axesOffsetY+axesHeight,
      axesOffsetY
    );
  }
  
  controlP5 = new ControlP5(this);
  controlP5.addToggle("distanceToggle")
    .setCaptionLabel("Distance")
    .setPosition(axesOffsetX, axesOffsetY-100)
    .setSize(10, 10)
    .setColorForeground(black)
    .setColorBackground(grey)
    .setColorActive(black)
    .setColorLabel(black)
    .setValue(true);
  controlP5.addToggle("speedToggle")
    .setCaptionLabel("Average Speed")
    .setPosition(axesOffsetX+50, axesOffsetY-100)
    .setSize(10, 10)
    .setColorForeground(yellow)
    .setColorBackground(grey)
    .setColorActive(yellow)
    .setColorLabel(darkYellow)
    .setValue(true);
}

void plot()
{
  float prevYearsMapped = 0;
  float prevDistanceMapped = 0;
  float prevSpeedMapped = 0;
  
  if (distanceToggle)
  {
    for (int i=0; i<numCases; ++i)
    {
      stroke(black); //official tour color
      fill(black);
      ellipse(yearsMapped[i], distanceMapped[i], 6, 6);
      if (i>0) line(prevYearsMapped, prevDistanceMapped, yearsMapped[i], distanceMapped[i]);
      prevDistanceMapped = distanceMapped[i];
      prevYearsMapped = yearsMapped[i];
    }
  }
  
  if (speedToggle)
  {
    prevYearsMapped = 0;
    for (int i=0; i<numCases; ++i)
    {
      stroke(yellow); //official tour color
      fill(yellow);
      ellipse(yearsMapped[i], speedMapped[i], 6, 6);
      if (i>0) line(prevYearsMapped, prevSpeedMapped, yearsMapped[i], speedMapped[i]);
      prevSpeedMapped = speedMapped[i];
      prevYearsMapped = yearsMapped[i];
    }
  }
}

void drawAxes()
{
  fill(black);
  stroke(black);
  
  //years
  line(axesOffsetX, axesOffsetY+axesHeight, axesOffsetX+axesWidth, axesOffsetY+axesHeight);
  for (int i=0; i<12; ++i)
  {
    text(1900+i*10, map(i, 0, 11, axesOffsetX, axesOffsetX+axesWidth-30), axesOffsetY+axesHeight+15);
  }
  
  if (distanceToggle)
  {
    line(axesOffsetX, axesOffsetY, axesOffsetX, axesOffsetY+axesHeight);
    for (int i=0; i<=4; ++i)
    {
      text(2000+i*1000, axesOffsetX-32, map(i, 0, 4, axesOffsetY+axesHeight, axesOffsetY));
    }
  }
  
  if (speedToggle)
  {
    stroke(darkYellow);
    fill(darkYellow);
    //speed
    line(axesOffsetX+axesWidth, axesOffsetY, axesOffsetX+axesWidth, axesOffsetY+axesHeight);
    for (int i=0; i<=6; ++i)
    {
      text(20+i*5, axesOffsetX+axesWidth+6, map(i, 0, 6, axesOffsetY+axesHeight, axesOffsetY));
    }
  }
}

void drawMissingVals()
{
  fill(grey);
  stroke(bg);
  rect(yearsMapped[33], axesOffsetY+axesHeight, yearsMapped[39]-yearsMapped[33], -axesHeight);
  
  fill(black);
  textSize(18);
  textAlign(CENTER);
  translate(yearsMapped[37], axesOffsetY+axesHeight/2);
  rotate(-PI/2);
  text("No races during World War II", 0, 0);

  rotate(PI/2);
  translate(-yearsMapped[37], -(axesOffsetY+axesHeight/2));
  textAlign(LEFT);
  textSize(11);
}

void drawLabels()
{
  textSize(40);
  textAlign(RIGHT);
  text("Tour De France", axesOffsetX+axesWidth, axesOffsetY-100);
  textSize(20);
  text("Distance and average speed (1903-2010)", axesOffsetX+axesWidth, axesOffsetY-70);
  textSize(11);
  textAlign(LEFT);
  
  if (distanceToggle)
  {
    fill(black);
    textSize(18);
    textAlign(CENTER);
    translate(axesOffsetX/2, axesOffsetY+axesHeight/2);
    rotate(-PI/2);
    text("Distance (km)", 0, 0);
    //reset
    rotate(PI/2);
    translate(-(axesOffsetX/2), -(axesOffsetY+axesHeight/2));
    textAlign(LEFT);
    textSize(11);
  }
  
  if (speedToggle)
  {
    fill(darkYellow);
    textSize(18);
    textAlign(CENTER);
    translate(width-axesOffsetX/2, axesOffsetY+axesHeight/2);
    rotate(PI/2);
    text("Average Speed (km/h)", 0, 0);
    //reset
    rotate(-PI/2);
    translate(-(width-axesOffsetX/2), -(axesOffsetY+axesHeight/2));
    textAlign(LEFT);
    textSize(11);
  }
}

void draw()
{
  smooth(); //nothing's changing much, so might as well...
  background(bg); //clears screen
  drawAxes();
  plot();
  drawMissingVals();
  drawLabels();
}

