/* Project 3 Food
  by Ashley Woon
  
  This verion of Project 3 does not include use of potentiometer as the creator's potentiometer is not working
  Made in connection with an Arduino sketch and hardware including:
  (1)Adafruit ESP32, (1)breadboard, (1)push button, (1)LED, (1) RGB LED, (5)resistors
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
int lastSwitchValue;
int count = 0;

//int potValue = 0;

////mapping pot values
//float minPotValue = 0;
//float maxPotValue = 4095;
//float selector;

// Change to appropriate index in the serial list — YOURS MIGHT BE DIFFERENT
int serialIndex = 0;

PImage imgC, imgF, imgB;

//state machine
int state;
int defaultState = 0;
int chickenState = 1;
int fishState = 2;
int openState = 3;

PFont displayFont;

//Timers
Timer chickenTimer;
Timer fishTimer;
Timer cookingTimer;
int msTimer = 5000;
int second = 1000;

//Chicken variables
  boolean chicken = false;
  int cBodyX = 20;
  int cBodyY = 15;
  int cLegX = 15;
  int cLegY = 10;
  int cX = 510;
//Fish variables
  boolean fish = false;
  int fBodyX = 20;
  int fBodyY = 10;

void setup() 
{
  // List all the available serial ports
  printArray(Serial.list());
  
  // Set the com port and the baud rate according to the Arduino IDE
  //-- use your port name
  myPort  =  new Serial (this, "COM3",  115200); 
  
  size(1200, 800);
  imgC = loadImage("assets/chicken.JPG");
  imgF = loadImage("assets/fish.JPG");
  imgB = loadImage("assets/bowl.JPG");
  
  displayFont = createFont("Georgia", 32);
  
  //Setting timers
    chickenTimer = new Timer(msTimer);
    chickenTimer.start();
    fishTimer = new Timer(msTimer);
    fishTimer.start();
    cookingTimer = new Timer(second);
    cookingTimer.start();
    
    state =  defaultState;
}

void draw() {
  checkSerial();
  
  if(state == defaultState)
    drawDefaultBackground();
  else if(state == chickenState)
    drawChickenState();
  else if(state == fishState)
    drawFishState();
  else if(state == openState)
    drawOpenState();
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
      //potValue = int(data[1]);               // second index = pot value
      
      // get the potentiometer value
      //selector = map(potValue, minPotValue, maxPotValue, minPotValue, maxPotValue);
   }
  }
    //if(selector <= 1365)
    //  state = defaultState;
    //else if(selector > 1365 && selector <= 2730)
    //  state = chickenState;
    //else if(selector > 2730 && selector <=4095)
    //  state = fishState;
    if(keyPressed)
    {
      if(key == 'C' || key == 'c')
        chicken = true;
      else if(key == 'F' || key == 'f')
        fish = true;
      print("c");
    }
      
  if(switchValue != lastSwitchValue)
  {
    if(switchValue == 1) 
      count+=1;
  }
  lastSwitchValue = switchValue;
  
  if(count == 0)
  {
    state = defaultState;
    if(chicken == true)
      state = chickenState;
    else if(fish == true)
      state = fishState;
  }
  else if(count == 1)
    state = openState;
  else if(count == 2)
  {
    count = 0;
    state = defaultState;
    chicken = false;
    fish = false;
  }    
  
}

void drawDefaultBackground()
{
  background(#ffffba);
  //bowl  
    fill(#996515);
    arc(500, 575, 650, 275, 0, PI);
  //machine top and bottom
    fill(#CACAC7);
    rect(0,0, 1000,150);
    rect(0,650, 1000,800);
  //machine sides
    quad(0,0, 150,150, 150,650, 0,800);
    quad(1000,0, 850,150, 850,650, 1000,800);
  
  //control panel and image transparency
  drawControlPanel(); 
}

void drawBackground()
{
  //bowl  
    fill(#996515);
    arc(500, 575, 650, 275, 0, PI);
  //machine top and bottom
    fill(#CACAC7);
    rect(0,0, 1000,150);
    rect(0,650, 1000,800);
  //machine sides
    quad(0,0, 150,150, 150,650, 0,800);
    quad(1000,0, 850,150, 850,650, 1000,800);
  
  //control panel and image transparency
  drawControlPanel(); 
}

void drawControlPanel() {
  rect(1000,0, 1200,800);
  //meal selection indicator
  line(1050,150, 1050,475);
  
  fill(255,0,0);
  if(state == defaultState || state == openState) 
  {
    //no meal
    tint(255,255);
    image(imgB, 1100,140, 70,70);
    triangle(1050,150, 1050,200, 1100,175);
    
    //chicken
    tint(255, 127);
    image(imgC, 1100,290, 70,70);
    
    //fish
    tint(255,127);
    image(imgF, 1100,440, 70,70);
    
    //button
    rect(1025,650, 150,100);
    fill(0);
    textSize(20);
    text("Empty", 1050,700);
  }
  else if(state == chickenState)
  {
    //no meal
    tint(255,127);
    image(imgB, 1100,140, 70,70);
    
    //chicken
    tint(255, 255);
    image(imgC, 1100,290, 70,70);
    fill(0,255,0);
    triangle(1050,300, 1050,350, 1100,325);
    
    //fish
    tint(255,127);
    image(imgF, 1100,440, 70,70);
    
    fill(0,255,0);
    rect(1025,650, 150,100);
    fill(0);
    textSize(20);
    text("Chicken", 1050,700);
  }
  else if(state == fishState)
  {
    //no meal
    tint(255,127);
    image(imgB, 1100,140, 70,70);
    
    //chicken
    tint(255, 127);
    image(imgC, 1100,290, 70,70);
    
    //fish
    tint(255,255);
    image(imgF, 1100,440, 70,70);
    fill(0,0,255);
    triangle(1050,450, 1050,500, 1100,475);
    
    fill(0,0,255);
    rect(1025,650, 150,100);
    
    fill(255);
    textSize(20);
    text("Fish", 1060,710);
  }

}

void drawChickenState()
{  
    if(cookingTimer.expired() && chickenTimer.expired() == false)
    {
      fill(#FFC0CB);
      cBodyX+=2;
      cBodyY+=1;
    }
    else if(cookingTimer.expired() && chickenTimer.expired())
    {
      fill(#dc911e);
    }
  //body (500,640)
    ellipse(500,600, cBodyX,cBodyY); 
    
  drawBackground();
}

void drawFishState()
{
  if(cookingTimer.expired() && fishTimer.expired() == false)
  {
    fill(0,0,255);
    fBodyX+=2;
    fBodyY+=1;
  }
  else if(cookingTimer.expired() && fishTimer.expired())
  {
    fill(255);
  } 
   //body
     ellipse(500,600, fBodyX, fBodyY);
   //fin
   
   drawBackground();
}

void drawOpenState() 
{
    background(#ffffba);
    drawControlPanel();
}
