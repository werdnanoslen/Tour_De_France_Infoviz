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
String[] winner;
String[] country;
String[] runnerup;

ControlP5 controlP5;
Toggle speedToggle;
Toggle distanceToggle;
boolean drawDistance;
boolean drawSpeed;
DropdownList yearList;
int filterYear;
String details;

void setup()
{
    size(900, 630);
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
    drawDistance = true;
    speed = new float[data.length-1];
    speedMapped = new float[data.length-1];
    drawSpeed = true;
    winner = new String[data.length-1];
    country = new String[data.length-1];
    runnerup = new String[data.length-1];
    for (int i=0; i<numCases; ++i)
    {
        String currentRow = data[i+1]; //+1 to skip title row
        String[] columns = split(currentRow, ",");
        years[i] = int(columns[0]);
        distance[i] = float(columns[16]);
        speed[i] = float(columns[17]);
        winner[i] = columns[1];
        country[i] = columns[3];
        runnerup[i] = columns[5];
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
    distanceToggle = controlP5.addToggle("drawDistance")
            .setCaptionLabel("Distance")
            .setPosition(axesOffsetX, axesOffsetY-100)
            .setSize(10, 10)
            .setColorForeground(black)
            .setColorBackground(grey)
            .setColorActive(black)
            .setColorLabel(black)
            .setValue(true);
    speedToggle = controlP5.addToggle("drawSpeed")
            .setCaptionLabel("Average Speed")
            .setPosition(axesOffsetX+50, axesOffsetY-100)
            .setSize(10, 10)
            .setColorForeground(yellow)
            .setColorBackground(grey)
            .setColorActive(yellow)
            .setColorLabel(darkYellow)
            .setValue(true);
    yearList = controlP5.addDropdownList("filterYear",axesOffsetX,axesOffsetY-60,90,120);
        yearList.captionLabel().set("Show all years");
        yearList.captionLabel().style().marginTop = 1;
        yearList.setBarHeight(11);
        yearList.addItem("Show all years", 0);
        for (int i=0; i<years.length; ++i)
        {
            if (32 <= i && i <= 38) continue;
            yearList.addItem(str(years[i]), i+1);
        }
    filterYear = 0;
}

void controlEvent(ControlEvent theEvent)
{
    if(theEvent.isFrom(yearList))
    {
        filterYear = (int)yearList.value();
    }
}

void detailsOnDemand()
{
    if (drawDistance)
    {
        for (int i=0; i<numCases; ++i)
        {
            if
            (
                yearsMapped[i]-3 <= mouseX && mouseX <= yearsMapped[i]+3 && 
                distanceMapped[i]-3 <= mouseY && mouseY <= distanceMapped[i]+3
            )
            {
                showDetails(i);
            }
        }
    }
    if (drawSpeed)
    {
        for (int i=0; i<numCases; ++i)
        {
            if
            (
                yearsMapped[i]-3 <= mouseX && mouseX <= yearsMapped[i]+3 && 
                speedMapped[i]-3 <= mouseY && mouseY <= speedMapped[i]+3
            )
            {
                showDetails(i);
            }
        }
    }
}

void showDetails(int i)
{
    if (filterYear != 0 & filterYear != i) return;
    
    int boxWidth = 350;
    int leftShift = (i<floor(numCases/2)) ? 0 : boxWidth;
    
    fill(yellow);
    stroke(black);
    rect(mouseX-leftShift+5, mouseY+5, boxWidth, 110);
    fill(black);
    details = "Year:  "+years[i]+"\n"
        +"Tour distance:  "+distance[i]+" km\n"
        +"Winner's speed:  "+speed[i]+" km/h\n"
        +"Winning rider:  "+winner[i]+" ("+country[i]+")"+"\n"
        +"Runner up:  "+runnerup[i];
    text
    (
        details, 
        mouseX-leftShift+30, 
        mouseY+30
    );
}

    
void plot()
{
    float prevYearsMapped = 0;
    float prevDistanceMapped = 0;
    float prevSpeedMapped = 0;
    
    if (drawDistance)
    {
        if (0 != filterYear)
        {
            stroke(black);
            fill(black);
            ellipse(yearsMapped[filterYear], distanceMapped[filterYear], 6, 6);
        }
        else
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
    }
    
    if (drawSpeed)
    {
        prevYearsMapped = 0;
        if (0 != filterYear)
        {
            stroke(yellow);
            fill(yellow);
            ellipse(yearsMapped[filterYear], speedMapped[filterYear], 6, 6);
        }
        else
        {
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
    
    if (drawDistance)
    {
        line(axesOffsetX, axesOffsetY, axesOffsetX, axesOffsetY+axesHeight);
        for (int i=0; i<=4; ++i)
        {
            text(2000+i*1000, axesOffsetX-32, map(i, 0, 4, axesOffsetY+axesHeight, axesOffsetY));
        }
    }
    
    if (drawSpeed)
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
    fill(bg);
    stroke(black);
    rect(axesOffsetX-10, axesOffsetY-130, 135, 80, 15, 15, 15, 15);
    //reset, arrggh why can't colors be set per function? T_T
    fill(black);
    
    textSize(12);
    text("CONTROL PANEL", axesOffsetX-2, axesOffsetY-110);
    
    textSize(40);
    textAlign(RIGHT);
    text("Tour De France", axesOffsetX+axesWidth, axesOffsetY-100);
    
    textSize(20);
    text("Distance and average speed (1903-2010)", axesOffsetX+axesWidth, axesOffsetY-70);
    
    //reset
    textSize(11);
    textAlign(LEFT);
    
    if (drawDistance)
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
    
    if (drawSpeed)
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
    detailsOnDemand();
}

