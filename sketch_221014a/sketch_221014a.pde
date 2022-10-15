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

 String input = Serial.list()[2]; //change the 0 to a 1 or 2 etc. to match your port
 port = new Serial(this, input, 115200);
}



String input;
long He;
long Lox;
long CH4;

void draw(){
  
  if ( port.available() > 0) 
  {  // If data is available,
  input = port.readStringUntil('\n');         // read it and store it in input
  } 
  
 
//NULLPOINTEREXCEPTION AFTER RUNNING FOR A FEW SECONDS
  /*
if(input.substring(0,3).equals("He:")){
    
  He = Integer.parseInt(input.substring(
  3, 
  input.indexOf(", Lox:")
  ));
  }
*/
  
  println(input);
  //println(He);
  
  
  
  
  
  
  
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
