long He;
long Lox;
long CH4;
long Engine;



void setup() {
  Serial.begin(115200);
  



}



void loop() {
  He = random(3000);
  Lox = random(600);
  CH4 = random(600);
  Engine = random(600);

  String info = "He:";
  info.concat(He);
  info.concat(", ");
  info.concat("Lox:");
  info.concat(Lox);
  info.concat(", ");
  info.concat("Ch4:");
  info.concat(CH4);


Serial.println(info);
delay(200);
                                
}