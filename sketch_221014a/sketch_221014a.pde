import processing.serial.*;
import controlP5.*;
import processing.serial.*;


ControlP5 cp5;
Serial port;


String data;
long He; 
long Lox;
long CH4;
final float HE_MAX = 3000;
final float LOX_MAX = 600;
final float CH4_MAX = 600;


PImage HeGauge; 
PImage gaugeImg;


//HE Gauge
int HeX = 960;     //X position
int HeY = 400;     //Y position
int HeRad = 130;   //Length of the needle
//Lox Gauge
int LoxX = 400;
int LoxY = 550;
int LoxRad = 130;
//CH4 Gauge
int CH4X = 1520;
int CH4Y = 550;
int CH4Rad = 130;
  



void setup(){
  
   port = new Serial(this, "COM7", 9600);  
  
  imageMode(CENTER);
  size(1920, 1080); 
  HeGauge = loadImage("gauge.png");      //*must make new gauges that cap out at 3000 and 600*
  gaugeImg = loadImage("gauge.png");


}





void draw(){
  
  
  
  background(248, 240, 227);
  
  fill(0, 0, 0);
  textSize(50);
  textAlign(CENTER);
  text("Lady Elizabeth", 960, 100);
  textSize(35);
  text("HE", HeX, HeY-225);
  image(HeGauge, HeX, HeY);
  text("LOX", LoxX, LoxY-225);
  image(gaugeImg, LoxX, LoxY);
  text("CH4", CH4X, CH4Y-225);
  image(gaugeImg, CH4X, CH4Y);
  
  
  
  
  
  if ( port.available() > 0) 
  {  // If data is available,
  data = port.readStringUntil('\n');         // read it and store it in data

  } 
  
 
//Serial data is in the form "He, Lox, CH4"
//This condition makes sure the input was read correctly
if(data != null && data.substring(0, 3).equals("-1,") && data.length() > 8 && data.length() < 21){

  
  
  
  
  String arr[] = data.split(",", 5); //Split the input into array of strings
  He = Integer.parseInt(arr[1]); //parse each element into an int
  Lox = Integer.parseInt(arr[2]);
  CH4 = Integer.parseInt(arr[3]);
  
  
  
  
  
  
  
  
  
  
  
  
  
  println("");
  println("New Iteration: ");
  print("Helium: ");
  println(He);
  print("Lox: ");
  println(Lox);
  print("CH4: ");
  println(CH4);
   
  


  
  
  

  
  
  
  stroke(0);
  strokeWeight(10);
  float HeAngle = (He / HE_MAX) * ((float)Math.PI * (-6.0/4.0)) + ((float)Math.PI * (7.0/4.0)); //This converts pressure reading into gauge angle 
  line(HeX, HeY,  HeX + sin(HeAngle) * HeRad,  HeY + cos(HeAngle) * HeRad); //line acts as gauge needle
  
  float LoxAngle = (Lox / LOX_MAX) * ((float)Math.PI * (-6.0/4.0)) + ((float)Math.PI * (7.0/4.0)); //This converts pressure reading into gauge angle 
  line(LoxX, LoxY,  LoxX + sin(LoxAngle) * LoxRad,  LoxY + cos(LoxAngle) * LoxRad); //line acts as gauge needle

  float CH4Angle = (CH4 / CH4_MAX) * ((float)Math.PI * (-6.0/4.0)) + ((float)Math.PI * (7.0/4.0)); //This converts pressure reading into gauge angle 
  line(CH4X, CH4Y,  CH4X + sin(CH4Angle) * CH4Rad,  CH4Y + cos(CH4Angle) * CH4Rad); //line acts as gauge needle
  
  }
}
