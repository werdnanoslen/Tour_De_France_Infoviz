int axesOffsetX = 50;
int axesOffsetY = 50;
int axesHeight = 500;
int axesWidth = 800;

int[] years;
float[] yearsMapped;
float[] distance;
float[] distanceMapped;
int numCases;

void setup()
{
  size(900, 600);
  background(255);
  
  String[] data = loadStrings("Tour_De_France_Data.csv");
  numCases = data.length-1; //doesn't count header row
  years = new int[data.length-1]; //col 0
  yearsMapped = new float[data.length-1];
  distance = new float[data.length-1]; //col 16
  distanceMapped = new float[data.length-1];
  
  for (int i=0; i<numCases; ++i)
  {
    String currentRow = data[i+1]; //+1 to skip title row
    String[] columns = split(currentRow, ",");
    years[i] = int(columns[0]);
    distance[i] = float(columns[16]);
  }
  for (int i=0; i<numCases; ++i)
  {
    yearsMapped[i] = map(i, 0, years.length, axesOffsetX+20, axesOffsetX+axesWidth); //evenly spaced
    distanceMapped[i] = map(distance[i], min(distance)-428, max(distance)+255, axesOffsetY+axesHeight, axesOffsetY);
  }
}

void plot()
{
  float prevYearsMapped = 0;
  float prevDistanceMapped = 0;
  for (int i=0; i<numCases; ++i)
  {
    stroke(#FABB00);
    fill(#FABB00);
    ellipse(yearsMapped[i], distanceMapped[i], 6, 6);
    if (i>0) line(prevYearsMapped, prevDistanceMapped, yearsMapped[i], distanceMapped[i]);
    prevYearsMapped = yearsMapped[i];
    prevDistanceMapped = distanceMapped[i];
  }
}

void drawAxes()
{
  fill(0);
  stroke(0);
  line(axesOffsetX, axesOffsetY, axesOffsetX, axesOffsetY+axesHeight); //vertical axis  
  line(axesOffsetX, axesOffsetY+axesHeight, axesOffsetX+axesWidth, axesOffsetY+axesHeight); //horizontal axis
  
  for (int i=0; i<12; ++i)
  {
    text(1900+i*10, map(i, 0, 11, axesOffsetX, axesOffsetX+axesWidth-30), axesOffsetX+axesHeight+15);
  }
  for (int i=0; i<5; ++i)
  {
    text(2000+i*1000, axesOffsetX-30, map(i, 0, 4, axesOffsetY+axesHeight, axesOffsetY));
  }
}

void draw()
{
  smooth();
  background(255);
  drawAxes();
  plot();
}

