import processing.serial.*;
import controlP5.*;
import processing.serial.*;

ControlP5 cp5;
Serial port;


PImage HeGauge; 

//HE Gauge
int HeX = 500;  
int HeY = 500;
int HeRad= 120;

  



void setup(){
 size(1920, 1080); 
 HeGauge = loadImage("gauge.png");

 port = new Serial(this, "COM7", 9600);
}



String data;
long He;
long Lox;
long CH4;

void draw(){
  
  if ( port.available() > 0) 
  {  // If data is available,
  data = port.readStringUntil('\n');         // read it and store it in data
  } 
  
 
//Serial data is in the form "He, Lox, CH4"
  println(data);
if(data != null){
  
  //TODO:
  // take input1, take input2
  //compare them-> if same, we know we got good input
  //we can then split it into values.
  //if not same, input messed up, try again
  
  
  
  
  String arr[] = data.split(",", 4);
  He = Integer.parseInt(arr[0]);
  Lox = Integer.parseInt(arr[1]);
  CH4 = Integer.parseInt(arr[2]);
  
  /*
  //print("Helium: ");
  println(He);
  //print("Lox: ");
  println(Lox);
  println(CH4);
   */ 
  }

  //println("Helium Pressure: " + He);

  
  
  
  
  imageMode(CENTER);
  
  background(248, 240, 227);
  
  fill(0, 0, 0);
  textSize(50);
  text("Lady Elizabeth", 950, 100);
  
  image(HeGauge, HeX, HeY);
  
  stroke(0);
  strokeWeight(10);
  float rand = random(300);
  line(HeX, HeY,  HeX + cos(rand) * HeRad,  HeY + sin(rand) * HeRad);

  

}
