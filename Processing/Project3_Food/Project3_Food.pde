/* Project 3 Food
by Ashley Woon
  
  Made in connection with an Arduino sketch and hardware including:
  (1)Adafruit ESP32, (1)breadboard, (1)push button, (1)potentiometer, (1)LED, (1) RGB LED, (5)resistors
*/

// Importing the serial library to communicate with the Arduino 
import processing.serial.*;    

// Initializing a vairable named 'myPort' for serial communication
Serial myPort;      

// Data coming in from the data fields
// data[0] = "1" or "0"                  -- BUTTON
// data[1] = 0-4095, e.g "2049"          -- POT VALUE

String [] data;

int switchValue = 0;
int potValue = 0;

// Change to appropriate index in the serial list — YOURS MIGHT BE DIFFERENT
int serialIndex = 0;

void setup() 
{
  // List all the available serial ports
  printArray(Serial.list());
  
  // Set the com port and the baud rate according to the Arduino IDE
  //-- use your port name
  myPort  =  new Serial (this, "COM3",  115200); 
  
  size(1200, 800);
  imageMode(CENTER);
}

void draw() {
  checkSerial();
  drawDefaultBackground();
  
}

// We call this to get the data 
void checkSerial() 
{
  while (myPort.available() > 0) 
  {
    String inBuffer = myPort.readString();  
    
    print(inBuffer);
    
    // This removes the end-of-line from the string 
    inBuffer = (trim(inBuffer));
    
    // This function will make an array of TWO items, 1st item = switch value, 2nd item = potValue
    data = split(inBuffer, ',');
   
   // we have THREE items — ERROR-CHECK HERE
   if( data.length >= 2 ) {
      switchValue = int(data[0]);           // first index = switch value 
      potValue = int(data[1]);               // second index = pot value
      
      // change the display timer
      //timePerLine = map( potValue, minPotValue, maxPotValue, minTimePerLine, maxTimePerLine );
      //displayTimer.setTimer( int(timePerLine));
   }
  }
}

void drawDefaultBackground()
{
  background(#ffffba);
  //machine top and bottom
  fill(#CACAC7);
  rect(0,0, 1000,150);
  rect(0,650, 1000,800);
  //machine sides
  quad(0,0, 150,150, 150,650, 0,800);
  quad(1000,0, 850,150, 850,650, 1000,800);
  
  //control panel
  rect(1000,0, 1200,800);
  //meal selecting
  line(1050,150, 1050,450);
  fill(255,0,0);
  triangle(1050,150, 1050,200, 1100,175);
  //confirmation/open/close button
  rect(1050,650, 1100,650);
}

void drawChickenState()
{
  
}

void drawFishState()
{
  
}
