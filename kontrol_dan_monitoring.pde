import static javax.swing.JOptionPane.*; //buat import library dialog text
import processing.serial.*;                               //panggil atau gunakan library serial (koneksi dgn arduinoxs)
TombolB reset_button;                                     //tombol reset dikonfigurasi di tombolB
int clk = 1;                                              //banyaknya tombol di klik
Serial myPort;                                            //membuat object dari klas Serial
String val="";
String status,tpas;                                        //variabel buat nyimpen data dari serial port
int posisi;                                               //variabel buat nyimpen data jarum penunjuk bar
float sen=0; //sensor dri string ke float
float tpa=0;

String ttab = showInputDialog("Masukan Tinggi Tabbung (Cm)");
float tab = parseInt(ttab == null? "" : ttab, MIN_INT); //nilai yg dimasukkan di simpan di var "teb"

String lim = showInputDialog("Masukan Maximal Tinggi Air (Cm)");
float limit = parseInt(lim == null? "" : lim, MIN_INT);


void setup() {
  size (400, 350);                                        //buat layar pada saat program berjlan(x,y)
  printArray(Serial.list());                              //buat konfig data serial
  myPort = new Serial(this,Serial.list()[0], 9600);       //konfig baudrate dan port yang dipakai pada komputer
  myPort.bufferUntil('\n');                               //jangan cetak data kalo belum ada "\n" ...\n = newline = garis baru
  reset_button = new TombolB("Reset", 20, 180, 100, 50);   //membuat objek tombol reset dan konfigurasi dan tulisan reset(x,y,besar button)
}

void draw() {
 
  if (limit > tab){
  showMessageDialog(null, "Limit air melebihi tinggi tabung ", "Peringatan", ERROR_MESSAGE);}
  else{
  
  background(0);                                          //konfig warna background (R,G,B) atau (0)=hitam dan (225)=putih                                         
  rect (320,20,22,300);                                   //konfig letak x dan y bar sekaligus lebar dan panjangnya
  
  fill(225,225,225);                                      //konfig warna tulisan
   textAlign(RIGHT);                                      //konfig align yang kaya di ms word..susah jelasinnya
   text(ttab + " CM", 310, 29);                                //konfig letak tulisan 50cm agar ada di samping atas bar
   text("0 CM", 310, 321);                                //konfig letak tulisan 0cm agar ada di samping baawah bar
  
  textSize(14);                                           //konfig ukuran huruf
   fill(255, 255, 255, 255);                              //konfig warna tulisan
   textAlign(LEFT);                                       //konfig align tulisan kaya di ms.office left , right atau center
   text("Tinggi Tabung = "+ tab + " Cm", 20, 20); 
  
  textSize(14);                                           //konfig ukuran huruf
   fill(255, 255, 255, 255);                              //konfig warna tulisan
   textAlign(LEFT);                                       //konfig align tulisan kaya di ms.office left , right atau center
   text("Limit Tinggi Air = "+ limit + " Cm", 20, 50);          //untuk mengatur koordinat text(x,y) sekaligus menulis pada layar komputer
   
  textSize(14);
   fill(225);
   text("Tinggi Permukaan Air = "+ tpas + " Cm", 20, 80); 
     
  textSize(14);
   fill(225);
   text("Status Pompa Air = "+ status, 20, 140);  
  
  fill(225,225,225); 
   textAlign(LEFT);
   text("Ruang Yang Belum Terisi : "+str(int(val)) + " CM", 20, 110);
  
   tpas=String.format("%.2f",tpa); //perintah library processing buat keluaran angka dijid di belkng koma
   
   if(sen <= tab){ // sensor <= tinggi tbung
   tpa=(tab - sen);} // tinggi tbung - jark sensor ke prmukaan air
   else if (sen > tab){
   tpa=0;} //pengukuran full tinggi tbung dgn snsor
   
   sen = float(val);                                         //konversi data dari String ke integer 
   
   posisi = int(300 -((byte(tpa)*6)));                   //konnfig jarum pointar pada bar di monitor 
   if( tpa == limit){                                       // membandingkan nilai LIM dangan 50      
     triangle(345, 20, 355, 15, 355, 25);                 //jika nilai Lim >= 50 maka jarum berhnti/mentok d atas bar  (jrum) 
   }
   
   else if(sen > tab){
     triangle(345, 319, 355, 314, 355, 324);             // jika Lim < 50 maka jarum akan berada pada nilai yg terbaca dari posisi 
   }

   else{ 
     triangle(345, posisi + 20, 355, posisi + 15, 355, posisi + 25); // jika Lim < 50 maka jarum akan berada pada nilai yg terbaca dari posisi 
   }
   
   if( tpa >= limit){                                       // membandingkan nilai LIM dangan 50
     
     myPort.write('1');   //"1" dikirim ke arduino melalui port serial buat mnnukan pompa on or off
     status="OFF";
   }
   else if(tpa < limit){
     
     myPort.write('0');
     status="ON";
   }
         
                                             // jika pointer mouse berada pada tombol
  if (reset_button.MouseIsOver()){
   rect(20, 180, 100, 50);                   
   }
   else{                                   //jika pointer mos berada d luar tombol Reset maka tidak ada kerangka yg digambar
   }
                      
  reset_button.Draw();                     //untuk menampilkan tombol reset
  }
}
  void serialEvent (Serial myPort){        //konfigurasi serial
   val = myPort.readStringUntil('\n');     //membaca data serial dan menyimpannya ke variable "val"
    if(val != null){                       //jika val TIDAK sama dengan null(kosong)
    val=trim(val);                         //simpan data serial yang baru di variable val dan hapus data lama yang ada d variabel val
      }
    }
 
  //perintah if untuk mengecek apakah tombol di tekan atau tidak 
  void mousePressed(){
   if (reset_button.MouseIsOver()) {                                               
   lim="";
   limit=0;
   tab=0;  
   ttab="";
     ttab = showInputDialog("Masukan Tinggi Tabbung (Cm)");
     tab = parseInt(ttab == null? "" : ttab, MIN_INT);

    lim = showInputDialog("Masukan Maximal Tinggi Air (Cm)");
    limit = parseInt(lim == null? "" : lim, MIN_INT);

    }
   }

  
  class TombolB {
    String tulisan; // label tombol
    float x;      // variable untuk kordinat x tombol reset
    float y;      // variable untuk kordinat y tombol reset
    float w;      // variable untuk lebar tobol reset
    float h;      // variable untuk tinggi tombol reset
  
  
  TombolB(String tulisB, float xpos, float ypos, float lebarB, float tinggiB) {
    tulisan = tulisB;
    x = xpos;      //variabel x diisi dengan nilai variabel xpos
    y = ypos;      //variabel y diisi dengan nilai variabel ypos
    w = lebarB;    //variabel w diisi dengan nilai variabel lebarB
    h = tinggiB;   //variabel h diisi dengan nilai variabel tinggib
  }
    
  void Draw() {
    fill(225);                             //konnfigurasi warna tombol reset
    stroke(141);                           //warna bayangan
    rect(x, y, w, h, 10);                  //konfigurasi rangka kordinat x dan y ... w=lebar dan h=tinggi
    textAlign(CENTER, CENTER);             //konfigursi letak pd tombl reset
    fill(0);                               //konfigurasi warna tulisan pd tmbl reset
    text(tulisan, x + (w / 2), y + (h / 2)); //konfigurasi tulisan pada tombol reset
   }
  
  boolean MouseIsOver() {
    if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) {
     return true;
     }
     return false;
   }
}