double He;
double Lox;
double CH4;
double Engine;
bool flipHe;
bool flipLox;
bool flipCH4;

void setup() {
  Serial.begin(115200);
  delay(1000);

  He = 1500;
  Lox = 300;
  CH4 = 300;
  Engine = 600;


}



void loop() {


  if(flipHe){
    He-=50;
  } else {He+=10;}
   switch((int)He){
    case 0:
    case 3000:
      flipHe = !flipHe;
   }

    if(flipLox){
    Lox-=50;
  } else {Lox+=6;}
   switch((int)Lox){
    case 0:
    case 600:
      flipLox = !flipLox;
   }

    if(flipCH4){
    CH4-=50;
  } else {CH4+=1;}
   switch((int)CH4){
    case 0:
    case 600:
      flipCH4 = !flipCH4;
   }


   String clopen = "Closed";
   if((int)random(100)> 95){
     if(clopen.equals("Closed")) {
      clopen = "Open";
     }else{
       clopen = "Closed";
     } 
   }



  String info = "hall1:";
  info.concat(clopen);
  info.concat(",");
  info.concat("hall2:");
  info.concat(clopen);
  info.concat(",");
  info.concat("Helium:");
  info.concat(He);
  info.concat(",");
  info.concat("Lox:");
  info.concat(Lox);
  info.concat(",");
  info.concat("Ch4:");
  info.concat(CH4);
  info.concat(",");




Serial.println(info);

//delay(7);
                                
}
