const int trigPin = 12; //setting var tipe const int dgn nama trigPin
const int echoPin = 11;
int outPin = 4;
 char val; // untuk meximpan data yg dtang dari komputer lewat usb serial
void setup() { 
  Serial.begin (9600); // perintah dlm arduino utk melakukan komunikasi serial dgn baudrate(kce kirim data 'bps') 
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(outPin, OUTPUT);
  }
void loop() {
  while (Serial.available()) { // untuk menuggu ada data yang akan di kirim or diterima
 val = Serial.read(); // data yg ada di serial di baca & disimpan di var val
 }
  
  long duration; //long int
  float distance; //tipe float(desimal) 
  digitalWrite(trigPin, LOW); //"low" kondisi 0 selama 2 microseconds untuk pengiriman data 
  delayMicroseconds(2); // low for 2 microseconds
  digitalWrite(trigPin, HIGH); //"high" kondisi 1 selama 10 microseconds
  delayMicroseconds(10); // high for 10 microseconds
  digitalWrite(trigPin, LOW);
  
  duration = pulseIn(echoPin, HIGH); // "pulseIn" sebagai stopwatch(timer)dari pengiriman data T ke R dan dipindahakn ke duration
  distance = (duration/2) / 29.1;  // rumus untuk konfersi dari data sensor ke cm

  if(val == '1'){ //yg di pakai untuk bisa membaca prosesing, untuk mengatur aktif tidaknya relay
   Serial.print(distance);
   Serial.print("\n");//untuk memisahkan antara data satu dan data yg lain
   digitalWrite(outPin, LOW);//outPin = Pin 4 Ar diperintahkan untuk berloika low"0"
   delay(500); }
  else{
   Serial.print(distance);
   Serial.print("\n");
   digitalWrite(outPin, HIGH);
   delay(500); 
  }  
}

