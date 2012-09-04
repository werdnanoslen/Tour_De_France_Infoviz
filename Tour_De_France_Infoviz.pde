int axesOffsetX = 50;
int axesOffsetY = 50;
int axesHeight = 500;
int axesWidth = 800;

int numCases;
int[] years;
float[] yearsMapped;
float[] distance;
float[] distanceMapped;
float[] speed;
float[] speedMapped;

void setup()
{
  size(900, 600);
  background(255);
  
  String[] data = loadStrings("Tour_De_France_Data.csv");
  numCases = data.length-1; //doesn't count header row
  years = new int[data.length-1];
  yearsMapped = new float[data.length-1];
  distance = new float[data.length-1];
  distanceMapped = new float[data.length-1];
  speed = new float[data.length-1];
  speedMapped = new float[data.length-1];
  
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
}

void plot()
{
  float prevYearsMapped = 0;
  float prevDistanceMapped = 0;
  float prevSpeedMapped = 0;
  for (int i=0; i<numCases; ++i)
  {
    stroke(#332626); //official tour color
    fill(#332626);
    ellipse(yearsMapped[i], distanceMapped[i], 6, 6);
    if (i>0) line(prevYearsMapped, prevDistanceMapped, yearsMapped[i], distanceMapped[i]);
    prevDistanceMapped = distanceMapped[i];
    
    stroke(#FABB00); //official tour color
    fill(#FABB00);
    ellipse(yearsMapped[i], speedMapped[i], 6, 6);
    if (i>0) line(prevYearsMapped, prevSpeedMapped, yearsMapped[i], speedMapped[i]);
    prevSpeedMapped = speedMapped[i];
    
    prevYearsMapped = yearsMapped[i];
  }
}

void drawAxes()
{
  fill(0);
  stroke(0);
  
  //years
  line(axesOffsetX, axesOffsetY+axesHeight, axesOffsetX+axesWidth, axesOffsetY+axesHeight);
  for (int i=0; i<12; ++i)
  {
    text(1900+i*10, map(i, 0, 11, axesOffsetX, axesOffsetX+axesWidth-30), axesOffsetX+axesHeight+15);
  }
  
  //distance
  line(axesOffsetX, axesOffsetY, axesOffsetX, axesOffsetY+axesHeight);
  for (int i=0; i<=4; ++i)
  {
    text(2000+i*1000, axesOffsetX-32, map(i, 0, 4, axesOffsetY+axesHeight, axesOffsetY));
  }
  
  stroke(#CC9500);
  fill(#CC9500);
  //speed
  line(axesOffsetX+axesWidth, axesOffsetY, axesOffsetX+axesWidth, axesOffsetY+axesHeight);
  for (int i=0; i<=6; ++i)
  {
    text(20+i*5, axesOffsetX+axesWidth+6, map(i, 0, 6, axesOffsetY+axesHeight, axesOffsetY));
  }
}

void draw()
{
  smooth(); //nothing's changing much, so might as well...
  background(255); //clears screen
  drawAxes();
  plot();
}

