import processing.serial.*;
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
  
   port = new Serial(this, "COM6", 115200);  
  
  imageMode(CENTER);
  size(1920, 1080); 
  HeGauge = loadImage("gauge.png");      //*must make new gauges that cap out at 3000 and 600*
  gaugeImg = loadImage("gauge.png");
  logo = loadImage("LELogo.png");

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
  
  image(logo, 960, 800);
  
  
  if ( port.available() > 0) 
  {  // If data is available,
  data = port.readStringUntil('\n');         // read it and store it in data

  } 
  
     
  //Serial data is in the form "He, Lox, CH4"
  //This condition makes sure the input was read correctly
  if(data != null && data.length() > 69 && data.length() < 95){
  
         println(data);
    String arr[] = data.split(",", 5); //Split the input into array of strings
    He = Integer.parseInt(arr[2].substring(arr[2].indexOf(":")+1, arr[2].indexOf("."))); //parse each element into an int
    Lox = Integer.parseInt(arr[3].substring(arr[3].indexOf(":")+1, arr[3].indexOf(".")));
    CH4 = Integer.parseInt(arr[4].substring(arr[4].indexOf(":")+1, arr[4].indexOf(".")));
    
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
    
  }
}
