long He;
long Lox;
long CH4;
long Engine;
bool flipHe;
bool flipLox;
bool flipCH4;

void setup() {
  Serial.begin(9600);
  delay(1000);

  He = 1500;
  Lox = 300;
  CH4 = 300;
  Engine = 600;


}



void loop() {


  if(flipHe){
    He-=50;
  } else {He+=50;}
   switch(He){
    case 0:
    case 3000:
      flipHe = !flipHe;
   }

    if(flipLox){
    Lox-=20;
  } else {Lox+=20;}
   switch(Lox){
    case 0:
    case 600:
      flipLox = !flipLox;
   }

    if(flipCH4){
    CH4-=20;
  } else {CH4+=20;}
   switch(CH4){
    case 0:
    case 600:
      flipCH4 = !flipCH4;
   }



  String info = "-1,";
  info.concat(He);
  info.concat(",");
  //info.concat("Lox:");
  info.concat(Lox);
  info.concat(",");
  //info.concat("Ch4:");
  info.concat(CH4);
  info.concat(",");
  info.concat("-1");



Serial.println(info);
Serial.println(info);
Serial.println(info);
//delay(7);
                                
}