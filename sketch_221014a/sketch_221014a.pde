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

float LoxXPos = LoxX - 180;        // horizontal position of the graph
float LoxLastxPos = LoxX - 180;
float HeXPos = HeX - 180;
float HeLastxPos = HeX - 180;
float CH4XPos = CH4X - 180;
float CH4LastxPos = CH4X - 180;

void setup(){  

  port = new Serial(this, "COM7", 115200);  
  
  imageMode(CENTER);
  size(1920, 1080); 
  HeGauge = loadImage("3kgauge.png");      
  gaugeImg = loadImage("gauge600.png");
  logo = loadImage("LELogo.png");
  
  //surface.setResizable(true);      //making the screen window resizeable

}

void draw(){ 
  tint(255, 255);
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
  text("600", LoxX - 200, 3*height/4 - 120);              //for lox
  text("300", LoxX - 200, 3*height/4 - 120 + 350/2);
  text("0", LoxX - 200, 3*height/4 - 120 + 350);
  text("3000", HeX - 200, 3*height/4 - 120);              //for he
  text("1500", HeX - 200, 3*height/4 - 120 + 350/2);
  text("0", HeX - 200, 3*height/4 - 120 + 350);
  text("600", CH4X - 200, 3*height/4 - 120);              //for CH4
  text("300", CH4X - 200, 3*height/4 - 120 + 350/2);
  text("0", CH4X - 200, 3*height/4 - 120 + 350);
  
  if ( port.available() > 0) 
  {  // If data is available,
  data = port.readStringUntil('\n');         // read it and store it in data

  }
  
  //Serial data is in the form "He, Lox, CH4"
  //This condition makes sure the input was read correctly
  if(data != null && data.length() > 55 && data.length() < 70){ //for rocket, these numbers should be 69 and 95
    System.out.println(data);
    String arr[] = data.split(",", 5); //Split the input into array of strings
    for(int i = 0; i < 5; i++)println(arr[i]);
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
    
    strokeWeight(5);
    //lox valve indicator
    if(vLox) fill(0, 255,0);
    if(vLox != true) fill(255,0, 0);
    rect(LoxX-25, LoxY + 40, 50, 50);
    
    if(vCH4) fill(0, 255,0);
    if(vCH4 != true) fill(255,0, 0);
    rect(CH4X-25, CH4Y + 40, 50, 50);
    
    strokeWeight(10);
    //Drawing a line from Last inByte to the new one.
    stroke(4, 75, 127);     //stroke color
    line(LoxLastxPos, (float)lastheightLox+350, LoxXPos, 3*height/4 - 120 - mappedLox+350);  //line
    stroke(127, 34, 255);     //stroke color
    line(HeLastxPos, (float) lastheightHe+350, HeXPos, 3*height/4 - 120 - mappedHe+350);  //line
    stroke(146, 45, 80);     //stroke color
    line(CH4LastxPos, (float)lastheightCH4+350, CH4XPos, 3*height/4 - 120 - mappedCH4+350);  //line
    
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
    } else {
      LoxXPos+=0.5;                            //increment the horizontal position:
    }
    if (HeXPos >= HeX - 180 + 350) {        //Helium
      HeXPos = HeX - 180;
      HeLastxPos = HeX - 180;
    } else {
      HeXPos+= 0.5;                             //increment the horizontal position:
    }
    if (CH4XPos >= CH4X - 180 + 350) {      //CH4
      CH4XPos = CH4X - 180;
      CH4LastxPos = CH4X - 180;
    } else {
      CH4XPos+=0.5;                            //increment the horizontal position:
    }
    tint(255, 64);
    //image(logo, HeX, HeY+100);
  }
  else{
    stroke(0);
    strokeWeight(10);
    float HeAngle = (He / HE_MAX) * ((float)Math.PI * (-6.0/4.0)) + ((float)Math.PI * (7.0/4.0)); //This converts pressure reading into gauge angle 
    line(HeX, HeY,  HeX + sin(HeAngle) * HeRad,  HeY + cos(HeAngle) * HeRad); //line acts as gauge needle
    
    float LoxAngle = (Lox / LOX_MAX) * ((float)Math.PI * (-6.0/4.0)) + ((float)Math.PI * (7.0/4.0));  
    line(LoxX, LoxY,  LoxX + sin(LoxAngle) * LoxRad,  LoxY + cos(LoxAngle) * LoxRad); 
  
    float CH4Angle = (CH4 / CH4_MAX) * ((float)Math.PI * (-6.0/4.0)) + ((float)Math.PI * (7.0/4.0)); 
    line(CH4X, CH4Y,  CH4X + sin(CH4Angle) * CH4Rad,  CH4Y + cos(CH4Angle) * CH4Rad); 
    
    strokeWeight(5);
    //lox valve indicator
    if(vLox) fill(0, 255,0);
    if(vLox != true) fill(255,0, 0);
    rect(LoxX-25, LoxY + 40, 50, 50);
    
    if(vCH4) fill(0, 255,0);
    if(vCH4 != true) fill(255,0, 0);
    rect(CH4X-25, CH4Y + 40, 50, 50);
  
  }
  

  
  ////just to set the window to maximized
  //if (runOnce) {
  //  javax.swing.JFrame jframe = (javax.swing.JFrame)((processing.awt.PSurfaceAWT.SmoothCanvas)getSurface().getNative()).getFrame();
  //  runOnce = false;
  //  jframe.setLocation(0, 0);
  //  jframe.setExtendedState(jframe.getExtendedState() | jframe.MAXIMIZED_BOTH);
  //}
}
