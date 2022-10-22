import processing.serial.*;

Serial port;

String data;
boolean vLox = false;
boolean vCH4 = false;
long He; 
long Lox;
long CH4;
final float HE_MAX = 3000;
final float LOX_MAX = 600;
final float CH4_MAX = 600;

PImage HeGauge; 
PImage gaugeImg;
PImage logo;

boolean runOnce = true;

//HE Gauge
int HeX = 960;     //X position
int HeY = 400;     //Y position
int HeRad = 130;   //Length of the needle
//Lox Gauge
int LoxX = 400;
int LoxY = 400;
int LoxRad = 130;
//CH4 Gauge
int CH4X = 1520;
int CH4Y = 400;
int CH4Rad = 130;

float mappedHe;            //mapped versions of the map
float mappedLox;
float mappedCH4;

int lastheightHe = 0;      //height of the graph
int lastheightLox = 0;
int lastheightCH4 = 0;

int LoxXPos = LoxX - 180;        // horizontal position of the graph
int LoxLastxPos = LoxX - 180;
int HeXPos = HeX - 180;
int HeLastxPos = HeX - 180;
int CH4XPos = HeX - 180;
int CH4LastxPos = HeX - 180;

void setup(){  
  String portName = Serial.list()[4]; //change the 0 to a 1 or 2 etc. to match your port
  port = new Serial(this, portName, 115200);  
  
  imageMode(CENTER);
  size(1376, 774); 
  HeGauge = loadImage("gauge.png");      //*must make new gauges that cap out at 3000 and 600*
  gaugeImg = loadImage("gauge.png");
  logo = loadImage("LELogo.png");
  
  surface.setResizable(true);      //making the screen window resizeable

}

void draw(){ 
  
  background(248, 240, 227);
  fill(0, 0, 0);
  textSize(50);
  textAlign(CENTER);
  text("Lady Elizabeth", 960, 100);
  
  textSize(35);
  text("HE", HeX, HeY-225);       //He gauge
  image(HeGauge, HeX, HeY);
  
  text("LOX", LoxX, LoxY-225);    //LOX gauge
  image(gaugeImg, LoxX, LoxY);
  
  text("CH4", CH4X, CH4Y-225);    //CH4 gauge
  image(gaugeImg, CH4X, CH4Y);
  
  image(logo, 130, 130);
  
  //draw the graph lines
  fill(248, 240, 227);
  stroke(0, 0, 0);
  strokeWeight(4);        //stroke bigger
  rect(LoxX - 180, 3*height/4 - 120, 350, 350);                                                  //drawing the three rectangles
  rect(HeX - 180, 3*height/4 - 120, 350, 350);
  rect(CH4X - 180, 3*height/4 - 120, 350, 350);
  strokeWeight(1);        //stroke smaller
  line(LoxX - 180, 3*height/4 - 120 + 350/2, LoxX - 180 + 350, 3*height/4 - 120 + 350/2);        //drawing halfwaypoint lines
  line(HeX - 180, 3*height/4 - 120 + 350/2, HeX - 180 + 350, 3*height/4 - 120 + 350/2);
  line(CH4X - 180, 3*height/4 - 120 + 350/2, CH4X - 180 + 350, 3*height/4 - 120 + 350/2);
  
  //draw graph numbers
  fill(0, 0, 0);
  textSize(25);
  textAlign(RIGHT);
  text("600", LoxX - 180, 3*height/4 - 120);              //for lox
  text("300", LoxX - 180, 3*height/4 - 120 + 350/2);
  text("0", LoxX - 180, 3*height/4 - 120 + 350);
  text("3000", HeX - 180, 3*height/4 - 120);              //for he
  text("1500", HeX - 180, 3*height/4 - 120 + 350/2);
  text("0", HeX - 180, 3*height/4 - 120 + 350);
  text("600", CH4X - 180, 3*height/4 - 120);              //for CH4
  text("300", CH4X - 180, 3*height/4 - 120 + 350/2);
  text("0", CH4X - 180, 3*height/4 - 120 + 350);
  
  if ( port.available() > 0) 
  {  // If data is available,
  data = port.readStringUntil('\n');         // read it and store it in data

  }
  
  //Serial data is in the form "He, Lox, CH4"
  //This condition makes sure the input was read correctly
  if(data != null && data.length() > 69 && data.length() < 95){
    System.out.println(data);
    String arr[] = data.split(",", 5); //Split the input into array of strings
    He = Integer.parseInt(arr[2].substring(arr[2].indexOf(":")+1, arr[2].indexOf("."))); //parse each element into an int
    Lox = Integer.parseInt(arr[3].substring(arr[3].indexOf(":")+1, arr[3].indexOf(".")));
    CH4 = Integer.parseInt(arr[4].substring(arr[4].indexOf(":")+1, arr[4].indexOf(".")));
    
    mappedLox = map(Lox, 0, 600, 0, 350);    //map he, lox, and ch4 to the graph height.
    mappedHe = map(He, 0, 3000, 0, 350);
    mappedCH4 = map(CH4, 0, 600, 0, 350);
 
    //Lox valve check
    if(arr[0].substring(arr[0].indexOf(":") + 1, arr[0].length()).equals("Closed")){
      vLox = false;
    }else{
      vLox = true;
    }
    
    //Methane valve check
    if(arr[1].substring(arr[1].indexOf(":") + 1, arr[1].length()).equals("Closed")){
      vCH4 = false;
    }else{
      vCH4 = true;
    }
    
    println(vLox);
    
    System.out.println("");
    System.out.println("New Iteration: ");
    System.out.print("Helium: ");
    System.out.println(He);
    System.out.print("Lox: ");
    System.out.println(Lox);
    System.out.print("CH4: ");
    System.out.println(CH4);
    
    stroke(0);
    strokeWeight(10);
    float HeAngle = (He / HE_MAX) * ((float)Math.PI * (-6.0/4.0)) + ((float)Math.PI * (7.0/4.0)); //This converts pressure reading into gauge angle 
    line(HeX, HeY,  HeX + sin(HeAngle) * HeRad,  HeY + cos(HeAngle) * HeRad); //line acts as gauge needle
    
    float LoxAngle = (Lox / LOX_MAX) * ((float)Math.PI * (-6.0/4.0)) + ((float)Math.PI * (7.0/4.0));  
    line(LoxX, LoxY,  LoxX + sin(LoxAngle) * LoxRad,  LoxY + cos(LoxAngle) * LoxRad); 
  
    float CH4Angle = (CH4 / CH4_MAX) * ((float)Math.PI * (-6.0/4.0)) + ((float)Math.PI * (7.0/4.0)); 
    line(CH4X, CH4Y,  CH4X + sin(CH4Angle) * CH4Rad,  CH4Y + cos(CH4Angle) * CH4Rad); 
    
    //lox valve indicator
    if(vLox) fill(0, 255,0);
    if(vLox != true) fill(255,0, 0);
    rect(LoxX - 50, LoxY + 250, 100, 100);
    
    if(vCH4) fill(0, 255,0);
    if(vCH4 != true) fill(255,0, 0);
    rect(CH4X - 50, CH4Y + 250, 100, 100);
    
    //Drawing a line from Last inByte to the new one.
    stroke(4, 75, 127);     //stroke color
    line(LoxLastxPos, lastheightLox, LoxXPos, 3*height/4 - 120 - mappedLox);  //line
    stroke(127, 34, 255);     //stroke color
    line(HeLastxPos, lastheightHe, HeXPos, 3*height/4 - 120 - mappedHe);  //line
    stroke(146, 45, 80);     //stroke color
    line(CH4LastxPos, lastheightCH4, CH4XPos, 3*height/4 - 120 - mappedCH4);  //line
    
    //resetting stuff
    LoxLastxPos = LoxXPos;
    HeLastxPos = HeXPos;
    CH4LastxPos = CH4XPos;
    lastheightLox = int(3*height/4 - 120 - mappedLox);
    lastheightHe = int(3*height/4 - 120 - mappedHe);
    lastheightCH4 = int(3*height/4 - 120 - mappedCH4);
    
    // at the edge of the window, go back to the beginning:
    if (LoxXPos >= LoxX - 180 + 350) {      //Lox
      LoxXPos = LoxX - 180;
      LoxLastxPos = LoxX - 180;
      background(0);                        //Clear the screen.
    } else {
      LoxXPos++;                            //increment the horizontal position:
    }
    if (HeXPos >= HeX - 180 + 350) {        //Hellium
      HeXPos = HeX - 180;
      HeLastxPos = HeX - 180;
      background(0);                        //Clear the screen.
    } else {
      HeXPos++;                             //increment the horizontal position:
    }
    if (CH4XPos >= CH4X - 180 + 350) {      //CH4
      CH4XPos = CH4X - 180;
      CH4LastxPos = CH4X - 180;
      background(0);                        //Clear the screen.
    } else {
      CH4XPos++;                            //increment the horizontal position:
    }
    
  }
  
  //just to set the window to maximized
  if (runOnce) {
    javax.swing.JFrame jframe = (javax.swing.JFrame)((processing.awt.PSurfaceAWT.SmoothCanvas)getSurface().getNative()).getFrame();
    runOnce = false;
    jframe.setLocation(0, 0);
    jframe.setExtendedState(jframe.getExtendedState() | jframe.MAXIMIZED_BOTH);
  }
}
